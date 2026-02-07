local PLUGIN = PLUGIN
nut.music = nut.music or {}
PLUGIN.nowPlaying = PLUGIN.nowPlaying or {
    [MUSIC_LEVEL_AMB] = {},
    [MUSIC_LEVEL_PAS] = {},
    [MUSIC_LEVEL_COM] = {},
    [MUSIC_LEVEL_DEA] = {}
}

CVAR_nut_music_volume = CreateClientConVar("nut_music_volume", 20, true, true, "Set Event Audio Volume")
CVAR_nut_auto_combat_music = CreateClientConVar("nut_auto_combat_music", 0, true, true, "Enable automatic combat music", 0, 1)
CVAR_nut_auto_passive_music = CreateClientConVar("nut_auto_passive_music", 0, true, true, "Enable automatic passive music", 0, 1)
CVAR_nut_auto_death_music = CreateClientConVar("nut_auto_death_music", 1, true, true, "Enable automatic death music", 0, 1)

local autoEnabledChecks = {
    [MUSIC_LEVEL_PAS] = CVAR_nut_auto_passive_music,
    [MUSIC_LEVEL_COM] = CVAR_nut_auto_combat_music,
    [MUSIC_LEVEL_DEA] = CVAR_nut_auto_death_music
}

local settingsTable = {
	{CVAR_nut_auto_combat_music, "nut_auto_combat_music", CVAR_nut_auto_combat_music:GetHelpText()},
	{CVAR_nut_auto_passive_music, "nut_auto_passive_music", CVAR_nut_auto_passive_music:GetHelpText()},
	{CVAR_nut_auto_death_music, "nut_auto_death_music", CVAR_nut_auto_death_music:GetHelpText()},
}

function PLUGIN:SetupQuickMenu(menu) -- adds a new option in the C quickmenu (the same one where to toggle thirdperson)
    menu:addButton("Set Music Volume", function()
        vgui.Create("nutMusicVolume")
    end)

    for _, v in ipairs(settingsTable) do
        menu:addCheck(v[3], function(panel, state)
            if (state) then
                RunConsoleCommand(v[2], "1")
            else
                RunConsoleCommand(v[2], "0")
            end
        end, v[1]:GetBool())
    end
	menu:addSpacer()
end

local function checkAutoMusicEnabled(level)
    return autoEnabledChecks[level]:GetBool() or false
end

local selectFunctions = {
    [MUSIC_SELECT_NONE] = function(newLevel, stationLevel, stationID, fade, remove)
        local shouldBeMuted
        if newLevel == MUSIC_LEVEL_COM then
            if stationLevel == MUSIC_LEVEL_PAS then
                nut.music.stopMusic(stationLevel, stationID, fade, remove)
            end
        elseif newLevel == MUSIC_LEVEL_PAS then
            if stationLevel == MUSIC_LEVEL_COM then shouldBeMuted = true end
        end

        return shouldBeMuted
    end,
    [MUSIC_SELECT_CURLEVEL] = function(newLevel, stationLevel, stationID, fade, remove)
        local shouldBeMuted
        if newLevel == MUSIC_LEVEL_COM then
            if stationLevel ~= MUSIC_LEVEL_AMB then
                nut.music.stopMusic(stationLevel, stationID, fade, remove)
            end
        elseif newLevel == MUSIC_LEVEL_PAS then
            if stationLevel == MUSIC_LEVEL_PAS then
                nut.music.stopMusic(stationLevel, stationID, fade, remove)
            elseif stationLevel == MUSIC_LEVEL_COM then
                shouldBeMuted = true
            end
        elseif newLevel == MUSIC_LEVEL_AMB and stationLevel == MUSIC_LEVEL_AMB then
            nut.music.stopMusic(stationLevel, stationID, fade, remove)
        end

        return shouldBeMuted
    end,
    [MUSIC_SELECT_OTHERLEVEL] = function(newLevel, stationLevel, stationID, fade, remove)
        if newLevel ~= MUSIC_LEVEL_AMB and newLevel ~= stationLevel or stationLevel ~= MUSIC_LEVEL_AMB then
            nut.music.stopMusic(stationLevel, stationID, fade, remove)
        end
    end,
    [MUSIC_SELECT_ALL] = function(newLevel, stationLevel, stationID, fade, remove)
         if newLevel == MUSIC_LEVEL_AMB or stationLevel ~= MUSIC_LEVEL_AMB then
            nut.music.stopMusic(stationLevel, stationID, fade, remove)
        end
    end,
}

nut.music.playMusic = function(data)
    --[[CHECKS IF THE MUSIC SHOULD EVEN PLAY]]
    --don't run music code if music is incomplete data
    if not (data and istable(data) and data.path) then return end
    -- dont play automusic if that toggle is off
    if data.isAuto and not checkAutoMusicEnabled(data.level) then return end
    -- dont play automusic if music in the level is already playing
    if data.isAuto and not table.IsEmpty(PLUGIN.nowPlaying[data.level]) then return end
    if data.isAuto and data.level ~= MUSIC_LEVEL_DEA then
        for level, stations in pairs(PLUGIN.nowPlaying) do
            -- ignore the ambience level if the requested level isnt ambience
            if level == MUSIC_LEVEL_AMB and data.level ~= MUSIC_LEVEL_AMB then continue end

            if not table.IsEmpty(stations) -- if the list of stations ain't empty
            and (data.level == MUSIC_LEVEL_COM and level == MUSIC_LEVEL_COM) -- if requested is combat and current station is combat
            or data.level == MUSIC_LEVEL_PAS then -- or if requested is passive
                for _, stationData in pairs(stations) do
                    if not stationData.isAuto then -- if existing song aint auto
                        return -- dont do shit
                    end
                end
            end
        end
    end

    --[[PLAY THE MUSIC]]
    local playMusic
    if string.StartWith(data.path, "http") then
        playMusic = sound.PlayURL
    else
        if not string.StartWith(data.path, "sound/") then
            data.path = "sound/" .. data.path
        end
        playMusic = sound.PlayFile
    end
    playMusic(data.path, "noplay noblock mono", function(station, errorID, errorName)
        local shouldBeMuted = false

        if station and IsValid(station) then
            data.station = station
            PLUGIN.nowPlaying[data.level][data.uniqueID] = data

            for level, stations in pairs(PLUGIN.nowPlaying) do
                for uniqueID, stationData in pairs(stations) do
                    shouldBeMuted = selectFunctions[data.select](data.level, level, uniqueID, data.fade, data.remove) or shouldBeMuted
                end
            end
            if (not data.global) and LocalPlayer():GetPos():DistToSqr(data.pos) > (data.range * data.range) then
                shouldBeMuted = true
            end
            if shouldBeMuted then
                station:SetVolume(0)
            elseif data.fade then
                nut.music.fadeMusic(data.level, data.uniqueID, 3)
            else
                station:SetVolume(CVAR_nut_music_volume:GetInt()/100)
            end
            station:EnableLooping(data.loop)
            station:Play()
        else
            MsgC(Color(255, 0, 0), "Failed to play music. ErrorID = "..errorID..", errorName = "..errorName)
        end
    end)
end

nut.music.fadeMusic = function(level, musicID, time, disengage, remove)
    if not (level and musicID) then return end

    local station = PLUGIN.nowPlaying[level][musicID].station

    if not (station and IsValid(station)) then return end

    local start, finish = RealTime(), RealTime() + (time or 3)
    local target = disengage and 0 or (CVAR_nut_music_volume:GetInt()/100)

    if not disengage then station:SetVolume(0) end -- weird bug where the first 0.1 seconds is superloud. this fixes it

    timer.Create("musicFade"..musicID, 0.1, 0, function()
        if not IsValid(station) then
            timer.Remove("musicFade"..musicID)
            PLUGIN.nowPlaying[level][musicID] = nil
            return
        end
        local fraction = math.Clamp(math.TimeFraction(start, finish, RealTime()), 0, 1)
        if not disengage then
            station:SetVolume((CVAR_nut_music_volume:GetInt()/100) * fraction)
        else
            station:SetVolume((CVAR_nut_music_volume:GetInt()/100) * (1-fraction))
        end
        if math.Round(station:GetVolume(), 2) == target then
            timer.Remove("musicFade"..musicID)
            if disengage and (remove or PLUGIN.nowPlaying[level][musicID].isAuto) then
                station:Stop()
                PLUGIN.nowPlaying[level][musicID] = nil

                for _, stations in pairs(PLUGIN.nowPlaying) do
                    for _, stationData in pairs(stations) do
                        if stationData.station and IsValid(stationData.station) and stationData.station:GetVolume() > 0.1 then
                            return
                        end
                    end
                end
                for nlevel = MUSIC_LEVEL_COM, MUSIC_LEVEL_PAS, -1 do
                    for uniqueID in SortedPairsByMemberValue(PLUGIN.nowPlaying[nlevel], "uniqueID", true) do
                        nut.music.fadeMusic(nlevel, uniqueID, 2)
                        return
                    end
                end
            end
        end
    end)
end

nut.music.stopMusic = function(stationLevel, stationID, fade, remove)
    if not (stationLevel and stationID) then return end

    local station = PLUGIN.nowPlaying[stationLevel][stationID].station
    if not (station and IsValid(station)) then return end
    if fade then
        nut.music.fadeMusic(stationLevel, stationID, 3, true, remove)
    elseif not remove then
        station:SetVolume(0)
    elseif remove then
        station:Stop()
        PLUGIN.nowPlaying[stationLevel][stationID] = nil
    end

    if not fade and remove then
        for _, stations in pairs(PLUGIN.nowPlaying) do
            for _, stationData in pairs(stations) do
                if stationData.station and IsValid(stationData.station) and stationData.station:GetVolume() > 0 then
                    return
                end
            end
        end
        for level = MUSIC_LEVEL_COM, MUSIC_LEVEL_PAS, -1 do
            for uniqueID in SortedPairsByMemberValue(PLUGIN.nowPlaying[level], "uniqueID", true) do
                nut.music.fadeMusic(level, uniqueID, 2)
                return
            end
        end
    end
end

--[[ENDED SONGS CLEARING]]
function PLUGIN:InitPostEntity()
    timer.Create("flushCompleteMusic", 3, 0, function()
        for level, stations in pairs(self.nowPlaying) do
            for uniqueID, stationData in pairs(stations) do
                if not (stationData.station and IsValid(stationData.station)) or
                stationData.station:GetLength() > 0 and
                stationData.station:GetLength() <= stationData.station:GetTime() or
                stationData.time == stationData.station:GetTime() then -- stopsound freezes stations apparently but they don't get flushed, this should help
                    nut.music.stopMusic(level, uniqueID, false, true)
                else
                    stationData.time = stationData.station:GetTime()
                end
            end
        end
    end)
end

--[[RANGE CHECKS FOR NON GLOBAL SONGS]]

function PLUGIN:Think()
    local clientPos = LocalPlayer():GetPos()
    for level, stations in pairs(PLUGIN.nowPlaying) do
        for uniqueID, stationData in pairs(stations) do
            if not stationData.global then
                if clientPos:DistToSqr(stationData.pos) > (stationData.range * stationData.range) then
                    if not stationData.fadeOut then
                        nut.music.fadeMusic(level, uniqueID, 2, true)
                        stationData.fadeOut = true
                    end
                else
                    if stationData.fadeOut then
                        nut.music.fadeMusic(level, uniqueID, 2, false)
                        stationData.fadeOut = false
                    end
                end
            end
        end
    end
end

--[[NETWORKING]]

net.Receive("nutPlayMusic", function()
    local data = {}
    data.path = net.ReadString() --path/url of music
    data.title = net.ReadString() -- title of music
    data.uniqueID = net.ReadUInt(16) -- current song's id
    data.level = net.ReadUInt(2) -- level of music
    data.select = net.ReadUInt(2) -- type of overriding
    data.global = net.ReadBool() -- is the song global or localized
    data.pos = net.ReadVector()
    data.range = net.ReadUInt(15) -- range of song to be heard
    data.remove = net.ReadBool() -- should overrides be removed or muted
    data.fade = net.ReadBool() -- fade in or start at full vol
    data.loop = net.ReadBool()
    data.isAuto = net.ReadBool() -- was manually requested or playing automatically
    nut.music.playMusic(data)
end)

net.Receive("nutStopMusic", function()
    local stationLevel = net.ReadUInt(2)-- song's level
    local stationID = net.ReadUInt(16) -- song's id
    local fade = net.ReadBool()
    local remove = net.ReadBool()

    if not (stationLevel and PLUGIN.nowPlaying[stationLevel] and stationID and isnumber(stationID) and
    fade ~= nil and isbool(fade) and remove ~= nil and isbool(remove)) then return end

    nut.music.stopMusic(stationLevel, stationID, fade, remove)
end)

net.Receive("nutUnmuteMusic", function()
    local level = net.ReadUInt(2)
    local uniqueID = net.ReadUInt(16)
    local instant = net.ReadBool()

    if instant then
        PLUGIN.nowPlaying[level][uniqueID].station:SetVolume(CVAR_nut_music_volume:GetInt()/100)
    else
        nut.music.fadeMusic(level, uniqueID, 3)
    end
end)

net.Receive("nutStopAutoMusic", function()
    local level = net.ReadUInt(2)

    for uniqueID, stationData in pairs(PLUGIN.nowPlaying[level]) do
        if stationData.isAuto then
            nut.music.stopMusic(level, uniqueID, true, true)
        end
    end
end)