local PLUGIN = PLUGIN
local PANEL = {}
local ScrW, ScrH = ScrW(), ScrH()
local function colorBrighten(color, value)
    local r, g, b, a = color:Unpack()
    return Color(r * value, g * value, b * value, a)
end

local function colorInvert(color)
    local r, g, b, a = color:Unpack()
    return Color(255 - r, 255 - g, 255 - b, a)
end

local levelNames = {
    [0] = "Ambience",
    [1] = "Passive",
    [2] = "Combat",
    [3] = "Death",
}

local levelIcons = {
    [0] = "icon16/world.png",
    [1] = "icon16/cup.png",
    [2] = "icon16/bomb.png",
    [3] = "icon16/status_offline.png",
}

local menuFunctions = {
    [1] = function(self)
        local textEntryTall = ScrH * 0.03
        if not self.menuButtons then return end
        if self.mainPanel then self.mainPanel:Remove() end
        self.mainPanel = self:Add("DPanel")
        self.mainPanel:Dock(FILL)
        self.mainPanel.Paint = function(this, w, h) end
        self.mainPanel.OnRemove = function(this) hook.Remove("PostDrawTranslucentRenderables", "nutMusicMenuRangeSphere") end
        self.mainPanel.data = {}
        local playFromListPanel = self.mainPanel:Add("DPanel")
        playFromListPanel:Dock(TOP)
        playFromListPanel:DockMargin(0, ScrH * 0.01, 0, 0)
        playFromListPanel:SetTall(ScrH * 0.05)
        playFromListPanel.Paint = function() end
        playFromListPanel.label = playFromListPanel:Add("DLabel")
        playFromListPanel.label:SetText("Play Music From List")
        playFromListPanel.label:SetFont("nutBigFont")
        playFromListPanel.label:Dock(LEFT)
        playFromListPanel.label:SizeToContents()
        playFromListPanel.label:SetWide(self:GetWide() * 0.3)
        playFromListPanel.label:SetContentAlignment(5)
        playFromListPanel.combo = playFromListPanel:Add("DComboBox")
        playFromListPanel.combo:SetSortItems(false)
        playFromListPanel.combo:Dock(RIGHT)
        playFromListPanel.combo:SetWide(self:GetWide() * 0.7)
        playFromListPanel.combo:SetFont("ScoreboardDefault")
        playFromListPanel.combo:SetContentAlignment(4)
        playFromListPanel.combo.UpdateColours = function(this, skin)
            if not this:IsEnabled() then return this:SetTextStyleColor(self.nutColor) end
            if this:IsDown() or this.m_bSelected then return this:SetTextStyleColor(colorBrighten(self.nutColor, 0.8)) end
            if this.Hovered then return this:SetTextStyleColor(colorInvert(self.nutColor)) end
            return this:SetTextStyleColor(self.nutColor)
        end

        for level, data in pairs(PLUGIN.menuMusicList) do
            if table.IsEmpty(data) then continue end
            playFromListPanel.combo:AddChoice(levelNames[level] .. " (Click to select random song from this category)", level, false, levelIcons[level])
            for _, musicData in pairs(data) do
                playFromListPanel.combo:AddChoice(musicData.title, musicData)
            end

            playFromListPanel.combo:AddSpacer()
        end

        playFromListPanel.combo:SetValue("Click to select a song from a predefined list")
        local pathLabel = self.mainPanel:Add("DLabel")
        pathLabel:SetText("Music URL")
        pathLabel:SetFont("nutBigFont")
        pathLabel:SizeToContents()
        pathLabel:SetContentAlignment(5)
        pathLabel:Dock(TOP)
        local pathEntry = self.mainPanel:Add("DTextEntry")
        pathEntry:SetFont("ScoreboardDefault")
        pathEntry:Dock(TOP)
        pathEntry:SetUpdateOnType(true)
        pathEntry:SetTooltip("Mandatory. May be an online url or a local game sound path. Must end in either .mp3 or .wav")
        pathEntry.OnValueChange = function(this, value) self.mainPanel.data.path = value end
        pathEntry:SetTall(textEntryTall)
        local titleLabel = self.mainPanel:Add("DLabel")
        titleLabel:SetText("Music Title")
        titleLabel:SetFont("nutBigFont")
        titleLabel:SizeToContents()
        titleLabel:SetContentAlignment(5)
        titleLabel:Dock(TOP)
        local titleEntry = self.mainPanel:Add("DTextEntry")
        titleEntry:SetFont("ScoreboardDefault")
        titleEntry:Dock(TOP)
        titleEntry:SetUpdateOnType(true)
        titleEntry:SetTooltip("If no title is entered, will be set to the url above")
        titleEntry.OnValueChange = function(this, value) self.mainPanel.data.title = value end
        titleEntry:SetTall(textEntryTall)
        local levelPanel = self.mainPanel:Add("DPanel")
        levelPanel:Dock(TOP)
        levelPanel:DockMargin(0, ScrH * 0.01, 0, 0)
        levelPanel:SetTall(ScrH * 0.05)
        levelPanel.Paint = function() end
        levelPanel.label = levelPanel:Add("DLabel")
        levelPanel.label:SetText("Set Level")
        levelPanel.label:SetFont("nutBigFont")
        levelPanel.label:Dock(LEFT)
        levelPanel.label:SizeToContents()
        levelPanel.label:SetWide(self:GetWide() * 0.3)
        levelPanel.label:SetContentAlignment(5)
        levelPanel.combo = levelPanel:Add("DComboBox")
        levelPanel.combo:AddChoice("Ambience. For non-musical soundscapes. Will not be muted/removed by other levels", MUSIC_LEVEL_AMB, false, "icon16/world.png")
        levelPanel.combo:AddChoice("Passive. For non-combat music. Will be muted/removed by combat music", MUSIC_LEVEL_PAS, true, "icon16/cup.png")
        levelPanel.combo:AddChoice("Combat. Will mute/remove passive music", MUSIC_LEVEL_COM, false, "icon16/bomb.png")
        levelPanel.combo:SetSortItems(false)
        levelPanel.combo:Dock(RIGHT)
        levelPanel.combo:SetWide(self:GetWide() * 0.7)
        levelPanel.combo:SetFont("ScoreboardDefault")
        levelPanel.combo:SetContentAlignment(4)
        levelPanel.combo.UpdateColours = function(this, skin)
            if not this:IsEnabled() then return this:SetTextStyleColor(self.nutColor) end
            if this:IsDown() or this.m_bSelected then return this:SetTextStyleColor(colorBrighten(self.nutColor, 0.8)) end
            if this.Hovered then return this:SetTextStyleColor(colorInvert(self.nutColor)) end
            return this:SetTextStyleColor(self.nutColor)
        end

        local rangePanel = self.mainPanel:Add("DPanel")
        rangePanel:Dock(TOP)
        rangePanel:DockMargin(0, ScrH * 0.01, 0, 0)
        rangePanel:SetTall(ScrH * 0.05)
        rangePanel.Paint = function() end
        rangePanel.label = rangePanel:Add("DLabel")
        rangePanel.label:SetText("Set Range")
        rangePanel.label:SetFont("nutBigFont")
        rangePanel.label:Dock(LEFT)
        rangePanel.label:SizeToContents()
        rangePanel.label:SetWide(self:GetWide() * 0.3)
        rangePanel.label:SetContentAlignment(5)
        rangePanel.combo = rangePanel:Add("DComboBox")
        rangePanel.combo:AddChoice("Global. Music will be heard by everyone regardless of location", true, true, "icon16/world.png")
        rangePanel.combo:AddChoice("Range: 0. Click to set custom range. Music will be heard by players inside the defined range", false, false, "icon16/shape_group.png")
        rangePanel.combo:SetSortItems(false)
        rangePanel.combo:Dock(RIGHT)
        rangePanel.combo:SetWide(self:GetWide() * 0.7)
        rangePanel.combo:SetFont("ScoreboardDefault")
        rangePanel.combo:SetContentAlignment(4)
        rangePanel.combo.UpdateColours = function(this, skin)
            if not this:IsEnabled() then return this:SetTextStyleColor(self.nutColor) end
            if this:IsDown() or this.m_bSelected then return this:SetTextStyleColor(colorBrighten(self.nutColor, 0.8)) end
            if this.Hovered then return this:SetTextStyleColor(colorInvert(self.nutColor)) end
            return this:SetTextStyleColor(self.nutColor)
        end

        rangePanel.combo.OnSelect = function(this, index, text, data)
            if data then
                hook.Remove("PostDrawTranslucentRenderables", "nutMusicMenuRangeSphere")
            else
                self:Hide()
                local setRangePanel = vgui.Create("DFrame")
                setRangePanel:SetSize(ScrW * 0.4, ScrH * 0.1)
                setRangePanel:SetPos(ScrW * 0.3, ScrH * 0.9)
                setRangePanel:MakePopup()
                local rangeSlider = setRangePanel:Add("DNumSlider")
                rangeSlider:Center()
                rangeSlider:Dock(FILL)
                rangeSlider:SetText("Set Range")
                rangeSlider:SetMin(5)
                rangeSlider:SetMax(32767)
                rangeSlider:SetDefaultValue(self.mainPanel.data.range or 500)
                rangeSlider:SetValue(self.mainPanel.data.range or 500)
                rangeSlider:SetDecimals(0)
                self.mainPanel.data.range = self.mainPanel.data.range or 500
                hook.Add("PostDrawTranslucentRenderables", "nutMusicMenuRangeSphere", function(_, skybox)
                    if skybox then return end
                    render.DrawWireframeSphere(LocalPlayer():GetPos(), self.mainPanel.data.range, 75, 75, self.nutColor, true)
                end)

                rangeSlider.OnValueChanged = function(that, value)
                    value = math.Round(value)
                    self.mainPanel.data.range = value
                    hook.Add("PostDrawTranslucentRenderables", "nutMusicMenuRangeSphere", function(_, skybox)
                        if skybox then return end
                        render.DrawWireframeSphere(LocalPlayer():GetPos(), value, 75, 75, self.nutColor, true)
                    end)
                end

                setRangePanel.OnRemove = function(that)
                    this.Choices[index] = "Range: " .. self.mainPanel.data.range .. ". Click to set custom range. Music will be heard by players inside the defined range"
                    this:SetText(this.Choices[index])
                    self:Show()
                end
            end
        end

        local selectPanel = self.mainPanel:Add("DPanel")
        selectPanel:Dock(TOP)
        selectPanel:DockMargin(0, ScrH * 0.01, 0, 0)
        selectPanel:SetTall(ScrH * 0.05)
        selectPanel.Paint = function() end
        selectPanel.label = selectPanel:Add("DLabel")
        selectPanel.label:SetText("Set Select Mode")
        selectPanel.label:SetFont("nutBigFont")
        selectPanel.label:Dock(LEFT)
        selectPanel.label:SizeToContents()
        selectPanel.label:SetWide(self:GetWide() * 0.3)
        selectPanel.label:SetContentAlignment(5)
        selectPanel.combo = selectPanel:Add("DComboBox")
        selectPanel.combo:AddChoice("None. No other current songs will be muted/removed", MUSIC_SELECT_NONE, true, "icon16/bullet_green.png")
        selectPanel.combo:AddChoice("Current Level. All music in the current level will be muted/removed", MUSIC_SELECT_CURLEVEL, false, "icon16/arrow_in.png")
        selectPanel.combo:AddChoice("Other Level. All music in the other level will be muted/removed", MUSIC_SELECT_OTHERLEVEL, false, "icon16/arrow_switch.png")
        selectPanel.combo:AddChoice("All. All music will be muted/removed", MUSIC_SELECT_ALL, false, "icon16/arrow_out.png")
        selectPanel.combo:SetSortItems(false)
        selectPanel.combo:Dock(RIGHT)
        selectPanel.combo:SetWide(self:GetWide() * 0.7)
        selectPanel.combo:SetFont("ScoreboardDefault")
        selectPanel.combo:SetContentAlignment(4)
        selectPanel.combo.UpdateColours = function(this, skin)
            if not this:IsEnabled() then return this:SetTextStyleColor(self.nutColor) end
            if this:IsDown() or this.m_bSelected then return this:SetTextStyleColor(colorBrighten(self.nutColor, 0.8)) end
            if this.Hovered then return this:SetTextStyleColor(colorInvert(self.nutColor)) end
            return this:SetTextStyleColor(self.nutColor)
        end

        local fadePanel = self.mainPanel:Add("DPanel")
        fadePanel:Dock(TOP)
        fadePanel:DockMargin(0, ScrH * 0.01, 0, 0)
        fadePanel:SetTall(ScrH * 0.05)
        fadePanel.Paint = function() end
        fadePanel.label = fadePanel:Add("DLabel")
        fadePanel.label:SetText("Set Fading")
        fadePanel.label:SetFont("nutBigFont")
        fadePanel.label:Dock(LEFT)
        fadePanel.label:SizeToContents()
        fadePanel.label:SetWide(self:GetWide() * 0.3)
        fadePanel.label:SetContentAlignment(5)
        fadePanel.combo = fadePanel:Add("DComboBox")
        fadePanel.combo:AddChoice("Enabled. Music will fade in and selected existing songs will fade out", true, true, "icon16/accept.png")
        fadePanel.combo:AddChoice("Disabled. Music will start at full volume and selected existing songs will immediately stop", false, false, "icon16/cross.png")
        fadePanel.combo:SetSortItems(false)
        fadePanel.combo:Dock(RIGHT)
        fadePanel.combo:SetWide(self:GetWide() * 0.7)
        fadePanel.combo:SetFont("ScoreboardDefault")
        fadePanel.combo:SetContentAlignment(4)
        fadePanel.combo.UpdateColours = function(this, skin)
            if not this:IsEnabled() then return this:SetTextStyleColor(self.nutColor) end
            if this:IsDown() or this.m_bSelected then return this:SetTextStyleColor(colorBrighten(self.nutColor, 0.8)) end
            if this.Hovered then return this:SetTextStyleColor(colorInvert(self.nutColor)) end
            return this:SetTextStyleColor(self.nutColor)
        end

        local mutePanel = self.mainPanel:Add("DPanel")
        mutePanel:Dock(TOP)
        mutePanel:DockMargin(0, ScrH * 0.01, 0, 0)
        mutePanel:SetTall(ScrH * 0.05)
        mutePanel.Paint = function() end
        mutePanel.label = mutePanel:Add("DLabel")
        mutePanel.label:SetText("Set Mute/Remove")
        mutePanel.label:SetFont("nutBigFont")
        mutePanel.label:Dock(LEFT)
        mutePanel.label:SizeToContents()
        mutePanel.label:SetWide(self:GetWide() * 0.3)
        mutePanel.label:SetContentAlignment(5)
        mutePanel.combo = mutePanel:Add("DComboBox")
        mutePanel.combo:AddChoice("Mute. Selected songs will be muted, will keep playing and may be unmuted when this song ends", false, true, "icon16/sound_none.png")
        mutePanel.combo:AddChoice("Remove. Selected songs will be removed and cannot be continued", true, false, "icon16/sound_mute.png")
        mutePanel.combo:SetSortItems(false)
        mutePanel.combo:Dock(RIGHT)
        mutePanel.combo:SetWide(self:GetWide() * 0.7)
        mutePanel.combo:SetFont("ScoreboardDefault")
        mutePanel.combo:SetContentAlignment(4)
        mutePanel.combo.UpdateColours = function(this, skin)
            if not this:IsEnabled() then return this:SetTextStyleColor(self.nutColor) end
            if this:IsDown() or this.m_bSelected then return this:SetTextStyleColor(colorBrighten(self.nutColor, 0.8)) end
            if this.Hovered then return this:SetTextStyleColor(colorInvert(self.nutColor)) end
            return this:SetTextStyleColor(self.nutColor)
        end

        local loopPanel = self.mainPanel:Add("DPanel")
        loopPanel:Dock(TOP)
        loopPanel:DockMargin(0, ScrH * 0.01, 0, 0)
        loopPanel:SetTall(ScrH * 0.05)
        loopPanel.Paint = function() end
        loopPanel.label = loopPanel:Add("DLabel")
        loopPanel.label:SetText("Set Looping")
        loopPanel.label:SetFont("nutBigFont")
        loopPanel.label:Dock(LEFT)
        loopPanel.label:SizeToContents()
        loopPanel.label:SetWide(self:GetWide() * 0.3)
        loopPanel.label:SetContentAlignment(5)
        loopPanel.combo = loopPanel:Add("DComboBox")
        loopPanel.combo:AddChoice("Enabled. Music will loop until manually stopped/overriden", true, false, "icon16/arrow_refresh.png")
        loopPanel.combo:AddChoice("Disabled. Music will play only once", false, true, "icon16/cross.png")
        loopPanel.combo:SetSortItems(false)
        loopPanel.combo:Dock(RIGHT)
        loopPanel.combo:SetWide(self:GetWide() * 0.7)
        loopPanel.combo:SetFont("ScoreboardDefault")
        loopPanel.combo:SetContentAlignment(4)
        loopPanel.combo.UpdateColours = function(this, skin)
            if not this:IsEnabled() then return this:SetTextStyleColor(self.nutColor) end
            if this:IsDown() or this.m_bSelected then return this:SetTextStyleColor(colorBrighten(self.nutColor, 0.8)) end
            if this.Hovered then return this:SetTextStyleColor(colorInvert(self.nutColor)) end
            return this:SetTextStyleColor(self.nutColor)
        end

        playFromListPanel.combo.OnSelect = function(panel, index, value, data)
            if istable(data) then
                pathEntry:SetValue(data.path)
                titleEntry:SetValue(data.title)
            elseif isnumber(data) then
                local randomEntry = table.Random(PLUGIN.menuMusicList[data])
                pathEntry:SetValue(randomEntry.path)
                titleEntry:SetValue(randomEntry.title)
            end
        end

        local postButton = self.mainPanel:Add("DButton")
        postButton:Dock(BOTTOM)
        postButton:DockMargin(0, 5, 0, 0)
        postButton:SetText("PLAY")
        postButton:SetFont("nutBigFont")
        postButton:SetTall(ScrH * 0.05)
        postButton.Paint = function(this, w, h)
            surface.SetDrawColor(self.nutColor:Unpack())
            surface.DrawRect(0, 0, w, h)
        end

        postButton.UpdateColours = function(this, skin)
            if this:IsDown() or this.m_bSelected or this.Hovered then return this:SetTextStyleColor(color_white) end
            return this:SetTextStyleColor(colorInvert(self.nutColor))
        end

        postButton.DoClick = function()
            if not self.mainPanel.data.path then
                nut.util.notify("URL is missing, please add a valid URL/path to the song")
                return
            end

            if string.find(self.mainPanel.data.path, "https://drive.google.com/file/d/") then
                local tempPath = self.mainPanel.data.path
                tempPath = tempPath:gsub("https://drive.google.com/file/d/", "http://docs.google.com/uc?export=open&id=")
                tempPath = tempPath:gsub("/view%?usp=drive_link", "")
                tempPath = tempPath:gsub("/view%?usp=sharing", "")
                self.mainPanel.data.path = tempPath
            end

            if not (string.EndsWith(self.mainPanel.data.path, ".mp3") or string.EndsWith(self.mainPanel.data.path, ".wav") or string.find(self.mainPanel.data.path, "http://docs.google.com/uc?export=open&id=", 1, true)) then
                nut.util.notify("URL is invalid, URL must end in .mp3, .wav, or be google drive upload")
                return
            end

            if not self.mainPanel.data.title or self.mainPanel.data.title == "" then
                self.mainPanel.data.title = self.mainPanel.data.path:gsub(".*%/", ""):gsub("%%20", " ") -- . = all characters, * = followed until the last / (%/), then replace all %20 with a space
            end

            net.Start("nutPlayMusic")
            net.WriteString(self.mainPanel.data.path)
            net.WriteString(self.mainPanel.data.title)
            local _, data = levelPanel.combo:GetSelected()
            net.WriteUInt(data, 2)
            _, data = selectPanel.combo:GetSelected()
            net.WriteUInt(data, 2)
            _, data = rangePanel.combo:GetSelected()
            net.WriteBool(data)
            net.WriteVector(LocalPlayer():GetPos())
            net.WriteUInt(self.mainPanel.data.range or 32767, 15)
            _, data = mutePanel.combo:GetSelected()
            net.WriteBool(data)
            _, data = fadePanel.combo:GetSelected()
            net.WriteBool(data)
            _, data = loopPanel.combo:GetSelected()
            net.WriteBool(data)
            net.SendToServer()
            nut.util.notify("Music with title " .. self.mainPanel.data.title .. " sent")
            self:menuButtonFocus(1)
        end
    end,
    [2] = function(self)
        if not self.menuButtons then return end
        if self.mainPanel then self.mainPanel:Remove() end
        self.mainPanel = self:Add("DCategoryList")
        self.mainPanel:Dock(FILL)
        self.mainPanel.Paint = function(this, w, h) end
        for level = MUSIC_LEVEL_AMB, MUSIC_LEVEL_COM do
            if not table.IsEmpty(PLUGIN.nowPlaying[level]) then
                self.mainPanel[level] = self.mainPanel:Add(levelNames[level])
                for uniqueID, stationData in pairs(PLUGIN.nowPlaying[level]) do
                    --if stationData.isAuto then continue end
                    local length = math.Round(stationData.station:GetLength())
                    local text = stationData.title or stationData.path
                    if stationData.isAuto then text = text .. "(Auto-Music)" end
                    text = text .. "          Status: " .. (stationData.station:GetVolume() > 0 and "Playing" or "Muted")
                    text = text .. "          Time: " .. math.Round(stationData.station:GetTime()) .. "/" .. length
                    self.mainPanel[level][uniqueID] = self.mainPanel[level]:Add(text)
                    self.mainPanel[level][uniqueID]:SetFont("nutMediumFont")
                    self.mainPanel[level][uniqueID]:SizeToContents()
                    self.mainPanel[level][uniqueID].Think = function(this)
                        if not PLUGIN.nowPlaying[level][uniqueID] then
                            this:Remove()
                            return
                        end

                        local time = math.Round(stationData.station:GetTime())
                        if length - time <= 0 then this:Remove() end
                        local newText = this:GetText()
                        newText = newText:gsub("Status: %a+", "Status: " .. (stationData.station:GetVolume() > 0 and "Playing" or "Muted"))
                        this:SetText(newText:gsub("%d*/%d*", time .. "/" .. length))
                    end

                    self.mainPanel[level][uniqueID].DoClick = function(this)
                        local menu = DermaMenu()
                        local stopMenu = menu:AddOption("Stop")
                        stopMenu:SetIcon("icon16/cross.png")
                        local stopSubMenu = stopMenu:AddSubMenu("Stop Type")
                        stopSubMenu:AddOption("Stop Instant", function()
                            net.Start("nutStopMusic")
                            net.WriteUInt(level, 2)
                            net.WriteUInt(uniqueID, 16)
                            net.WriteBool(false) -- fade
                            net.WriteBool(true) -- remove
                            net.SendToServer()
                        end)

                        stopSubMenu:AddOption("Stop with Fade", function()
                            net.Start("nutStopMusic")
                            net.WriteUInt(level, 2)
                            net.WriteUInt(uniqueID, 16)
                            net.WriteBool(true) -- fade
                            net.WriteBool(true) -- remove
                            net.SendToServer()
                        end)

                        menu:AddSpacer()
                        local muteMenu = menu:AddOption("Mute")
                        muteMenu:SetIcon("icon16/sound_none.png")
                        local muteSubMenu = muteMenu:AddSubMenu("Mute Type")
                        muteSubMenu:AddOption("Mute Instant", function()
                            net.Start("nutStopMusic")
                            net.WriteUInt(level, 2)
                            net.WriteUInt(uniqueID, 16)
                            net.WriteBool(false) -- fade
                            net.WriteBool(false) -- remove
                            net.SendToServer()
                        end)

                        muteSubMenu:AddOption("Mute with Fade", function()
                            net.Start("nutStopMusic")
                            net.WriteUInt(level, 2)
                            net.WriteUInt(uniqueID, 16)
                            net.WriteBool(true) -- fade
                            net.WriteBool(false) -- remove
                            net.SendToServer()
                        end)

                        menu:AddSpacer()
                        local unmuteMenu = menu:AddOption("Unmute")
                        unmuteMenu:SetIcon("icon16/sound_add.png")
                        local unmuteSubMenu = unmuteMenu:AddSubMenu("Unmute Type")
                        unmuteSubMenu:AddOption("Unmute Instant", function()
                            net.Start("nutUnmuteMusic")
                            net.WriteUInt(level, 2)
                            net.WriteUInt(uniqueID, 16)
                            net.WriteBool(true) -- instant
                            net.SendToServer()
                        end)

                        unmuteSubMenu:AddOption("Unmute with Fade", function()
                            net.Start("nutUnmuteMusic")
                            net.WriteUInt(level, 2)
                            net.WriteUInt(uniqueID, 16)
                            net.WriteBool(false) -- instant
                            net.SendToServer()
                        end)

                        menu:AddSpacer()
                        menu:SetPos(input.GetCursorPos())
                        menu:Open()
                    end
                end
            end
        end
    end,
}

function PANEL:Init()
    if not LocalPlayer():IsAdmin() then return end
    if nut.gui.musicPanel then nut.gui.musicPanel:Remove() end
    nut.gui.musicPanel = self
    self:SetSize(ScrW * 0.4, ScrH * 0.7)
    self:Center()
    self:MakePopup()
    self:SetTitle("")
    self.nutColor = nut.config.get("color")
    self.menuButtons = self:Add("DPanel")
    self.menuButtons:Dock(TOP)
    self.menuButtons:SetSize(self:GetWide(), self:GetTall() * 0.1)
    for i = 1, 2 do
        self.menuButtons[i] = self.menuButtons:Add("DButton")
        self.menuButtons[i].id = i
        self.menuButtons[i].colMult = 0.8
        self.menuButtons[i].menuFunction = menuFunctions[i]
        self.menuButtons[i]:Dock(i + 1) --1+1 = 2 (LEFT) 2+1 = 3 (RIGHT)
        self.menuButtons[i]:SetSize(self.menuButtons:GetWide() * 0.5, self.menuButtons:GetTall())
        self.menuButtons[i]:SetFont("nutMediumFont")
        self.menuButtons[i]:SetTextColor(colorInvert(self.nutColor))
        self.menuButtons[i]:SetText(i == 1 and "Play New Music" or "Browse Current Music")
        self.menuButtons[i]:SetContentAlignment(5)
        self.menuButtons[i].Paint = function(this, w, h)
            surface.SetDrawColor(self.nutColor.r * this.colMult, self.nutColor.g * this.colMult, self.nutColor.b * this.colMult)
            surface.DrawRect(0, 0, w, h)
        end

        self.menuButtons[i].DoClick = function() self:menuButtonFocus(i) end
    end

    self:menuButtonFocus(1)
end

function PANEL:menuButtonFocus(id)
    for _, v in pairs(self.menuButtons:GetChildren()) do
        v.selected = v.id == id and true or false
        local anim = v:NewAnimation(0.5, 0, 2, function() v:SetCursor(v.selected and "arrow" or "hand") end)
        local oldmult = v.colMult
        local newmult = v.selected and 1.15 or 0.8
        anim.Think = function(anim, panel, fraction) panel.colMult = Lerp(fraction, oldmult, newmult) end
        if v.id == id then v.menuFunction(self) end
    end
end

vgui.Register("nutMusicMenu", PANEL, "DFrame")
list.Set("DesktopWindows", "nutMusicMenu", {
    title = "NS Music Menu",
    icon = "icon16/sound.png",
    init = function(icon, window)
        if not LocalPlayer():IsAdmin() then return end
        vgui.Create("nutMusicMenu")
    end,
    width = 960,
    height = 700,
    onewindow = true,
})

CreateContextMenu() -- (Re?)Create the context menu so that the new music button appears as intended