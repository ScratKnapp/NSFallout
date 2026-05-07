local PLUGIN = PLUGIN
PLUGIN.curMusicID = PLUGIN.curMusicID or 0 -- used to index new songs for reference
PLUGIN.nowFighting = PLUGIN.nowFighting or {}
nut.music = nut.music or {}
util.AddNetworkString("nutPlayMusic")
util.AddNetworkString("nutStopMusic")
util.AddNetworkString("nutUnmuteMusic")
util.AddNetworkString("nutStopAutoMusic")
--[[MUSIC PLAYING FUNCTION
    client = who called the function. If nil, then should be server/console/automatic
    target = either player or table of players, can be player.GetAll()
    data = table of music data, check the net part to see what data is needed
]]
nut.music.playMusic = function(client, target, data)
    --If incomplete data is received, don't run the code
    if not (target and data and istable(data) and data.path) then return end
    --if not (isstring(data.path) and (string.EndsWith(data.path, ".mp3") or string.EndsWith(data.path, ".wav"))) then return end
    --if the command was run by a non-admin player, inform him that he aint shit and dont run the code
    if client and not client:IsAdmin() then
        client:notify("You are not allowed to do this")
        return
    end

    data.uniqueID = PLUGIN.curMusicID -- assign the song data a uniqueID
    PLUGIN.curMusicID = PLUGIN.curMusicID + 1 -- increment the ID by 1
    net.Start("nutPlayMusic")
    net.WriteString(data.path) --path/url of music
    net.WriteString(data.title or data.path) -- title of music
    net.WriteUInt(data.uniqueID, 16) -- current song's id
    net.WriteUInt(data.level or MUSIC_LEVEL_PAS, 2) -- level of music
    net.WriteUInt(data.select or MUSIC_SELECT_NONE, 2) -- type of overriding
    net.WriteBool(data.global) -- song is global?
    net.WriteVector(data.pos or Vector(0, 0, 0)) -- position of the music caster
    net.WriteUInt(data.range or 32767, 15) -- the range of the song to be heard (32767 HU is the max length of a max apparently)
    net.WriteBool(data.remove) -- should overrides be removed or muted
    net.WriteBool(data.fade) -- fade in or start at full vol
    net.WriteBool(data.loop) -- should the music loop or not
    net.WriteBool(data.isAuto) -- was manually requested or playing automatically
    net.Send(target)
end

--[[MUSIC STOP FUNCTION
    client = who called the function. If nil, then should be server/console/automatic
    target = either player or table of players, can be player.GetAll()
    data = table of music data, check the net part to see what data is needed
]]
nut.music.stopMusic = function(client, target, data)
    --don't run code if there's no song to stop
    if not data then return end
    --if the command was run by a non-admin player, inform him that he aint shit and dont run the code
    if client and not client:IsAdmin() then
        client:notify("You are not allowed to do this")
        return
    end

    if not (target and (istable(target) or target:IsPlayer())) then return end
    if data.uniqueID then
        net.Start("nutStopMusic")
        net.WriteUInt(data.level or MUSIC_LEVEL_PAS, 2) -- song's level
        net.WriteUInt(data.uniqueID, 16) -- song's id
        net.WriteBool(data.fade)
        net.WriteBool(data.remove)
        net.Send(target)
    elseif data.isAuto then
        net.Start("nutStopAutoMusic")
        net.WriteUInt(data.level or MUSIC_LEVEL_COM, 2)
        net.Send(target)
    end
end

--[[Auto-Music]]
function PLUGIN:customAutoMusicTrigger(client, finish)
    if finish then
        nut.music.stopMusic(nil, client, {
            level = MUSIC_LEVEL_COM,
            isAuto = true
        })

        self.nowFighting[client] = nil
        return
    end

    local time = SysTime()
    if self.nowFighting[client] and client:Health() > 0 then
        self.nowFighting[client] = time
        return
    end

    local data = table.Random(self.autoMusicList[MUSIC_LEVEL_COM])
    if not data then return end
    data.isAuto = true
    data.level = MUSIC_LEVEL_COM
    data.select = MUSIC_SELECT_NONE
    data.fade = true
    data.remove = false
    data.loop = true
    data.global = true
    if not self.nowFighting[client] and client:Health() > 0 then nut.music.playMusic(nil, client, data) end
    self.nowFighting[client] = time
end

function PLUGIN:PostEntityTakeDamage(ent, dmginfo)
    --[[  local time = SysTime()
        local attacker = dmginfo:GetAttacker()
        if not (ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot()) then return end
        if not (attacker:IsPlayer() or attacker:IsNPC() or attacker:IsNextBot()) then return end
        local data = table.Random(self.autoMusicList[MUSIC_LEVEL_COM])
        if not data then return end
        data.isAuto = true
        data.level = MUSIC_LEVEL_COM
        data.select = MUSIC_SELECT_NONE
        data.fade = true
        data.remove = false
        data.loop = true
        data.global = true

        if ent:IsPlayer() then
            if not self.nowFighting[ent] and ent:Health() > 0 then
                nut.music.playMusic(nil, ent, data)
            end
            self.nowFighting[ent] = time
        end
        if attacker:IsPlayer() then
            if not self.nowFighting[attacker] then
                nut.music.playMusic(nil, attacker, data)
            end
            self.nowFighting[attacker] = time
        end ]]
end

local nextNPCCheck = 0
function PLUGIN:Think()
    --[[ local time = SysTime()
        if nextNPCCheck <= time then
            local npcTable = ents.FindByClass("npc*") -- get all npcs
            table.Add(npcTable, ents.FindByClass("nz*")) -- get all npcs that start with nz
            for _, npc in pairs(npcTable) do
                if IsValid(npc) and npc.GetEnemy and IsValid(npc:GetEnemy()) and npc:GetEnemy():IsPlayer() then -- if the NPC is hostile and actively targetting a player
                    if not self.nowFighting[npc:GetEnemy()] then
                        local data = table.Random(self.autoMusicList[MUSIC_LEVEL_COM])
                        if not data then return end
                        data.isAuto = true
                        data.level = MUSIC_LEVEL_COM
                        data.select = MUSIC_SELECT_NONE
                        data.fade = true
                        data.remove = false
                        data.loop = true
                        data.global = true
                        nut.music.playMusic(nil, npc:GetEnemy(), data)
                    end

                    self.nowFighting[npc:GetEnemy()] = time
                end
            end

            nextNPCCheck = time + 5
        end ]]
end

local function triggerPassiveMusic()
    timer.Create("nutAutoPassiveMusicTimer", math.random(nut.config.get("passMusicMin"), nut.config.get("passMusicMax")), 1, function()
        local data = table.Random(PLUGIN.autoMusicList[MUSIC_LEVEL_PAS])
        if not data then return end
        data.isAuto = true
        data.level = MUSIC_LEVEL_PAS
        data.select = MUSIC_SELECT_NONE
        data.fade = true
        data.remove = false
        data.loop = false
        data.global = true
        for _, client in pairs(player.GetHumans()) do
            nut.music.playMusic(nil, client, data)
        end

        triggerPassiveMusic()
    end)
end

function PLUGIN:InitializedPlugins()
    timer.Create("nutAutoCombatMusicTimer", 1, 0, function()
        local time = SysTime()
        local dur = nut.config.get("autoCombatDur", 15)
        for client, started in pairs(self.nowFighting) do
            if started + dur <= time then
                nut.music.stopMusic(nil, client, {
                    level = MUSIC_LEVEL_COM,
                    isAuto = true
                })

                self.nowFighting[client] = nil
            end
        end
    end)

    triggerPassiveMusic() -- starts the autoPassive Music timer
end

--[[Death music triggers]]
function PLUGIN:PostPlayerDeath(client)
    timer.Simple(0.1, function()
        if not client:getChar() then return end
        if client:Alive() then return end
        local data = table.Random(PLUGIN.autoMusicList[MUSIC_LEVEL_DEA])
        if not data then return end
        data.isAuto = true
        data.level = MUSIC_LEVEL_DEA
        data.select = MUSIC_SELECT_ALL
        data.fade = true
        data.remove = false
        data.loop = true
        data.global = true
        nut.music.playMusic(nil, client, data)
    end)
end

function PLUGIN:PlayerSpawn(client)
    timer.Simple(2, function()
        nut.music.stopMusic(nil, client, {
            level = MUSIC_LEVEL_DEA,
            isAuto = true
        })
    end)
end

--[[Networking]]
net.Receive("nutPlayMusic", function(_, client)
    if not client:IsAdmin() then return end
    local data = {
        path = net.ReadString(),
        title = net.ReadString(),
        level = net.ReadUInt(2),
        select = net.ReadUInt(2),
        global = net.ReadBool(),
        pos = net.ReadVector(),
        range = net.ReadUInt(15),
        remove = net.ReadBool(),
        fade = net.ReadBool(),
        loop = net.ReadBool(),
        isAuto = false,
    }

    nut.music.playMusic(client, player.GetHumans(), data)
end)

net.Receive("nutStopMusic", function(_, client)
    if not client:IsAdmin() then return end
    local data = {
        level = net.ReadUInt(2),
        uniqueID = net.ReadUInt(16),
        fade = net.ReadBool(),
        remove = net.ReadBool()
    }

    nut.music.stopMusic(client, player.GetHumans(), data)
end)

net.Receive("nutUnmuteMusic", function(_, client)
    if not client:IsAdmin() then return end
    local level = net.ReadUInt(2)
    local uniqueID = net.ReadUInt(16)
    local instant = net.ReadBool()
    net.Start("nutUnmuteMusic")
    net.WriteUInt(level, 2)
    net.WriteUInt(uniqueID, 16)
    net.WriteBool(instant)
    net.Broadcast()
end)
--[[
            IF ISAUTO AND NOT NONE MODE THEN FAIL AND RETURN!!!
        SELECT MODE:
            none:
                if active requested
                    if music exists
                        if is auto
                            if active exists, return
                        if passive exists
                            mute/remove all passive
                        play
                if passive requested
                    if active exists, start muted
                    if isauto and music exists, return
                    play
                if ambience requested, play ambience
            curLevel:
                if active requested
                    mute/remove all active
                    if passive exists
                        mute/remove all passive
                    play
                if passive requested
                    mute/remove all passive
                    if active exists
                        start muted
                    play
                if ambience requested
                    mute/remove all ambience, play
            otherLevel:
                if active requested
                    mute/remove all passive
                play
                if passive requested
                    mute/remove all active
                play
                if ambience requested
                    mute/remove all passive + active
                play
            all:
                mute/remove all passive + active
                play
    ]]