local PLUGIN = PLUGIN
local PANEL = {}

local levelTitles = {
    [0] = "Ambience",
    [1] = "Passive",
    [2] = "Combat",
    [3] = "Death",
}

function PANEL:Init()
    if IsValid(nut.gui.nowPlaying) then
        nut.gui.nowPlaying:Remove()
    end

    nut.gui.nowPlaying = self

    --self:SetParent(nut.gui.quick)
    local maxWide = 0
    if not table.IsEmpty(PLUGIN.nowPlaying) then
        self.title = self:Add("DLabel")
        self.title:Dock(TOP)
        self.title:SetFont("nutBigFont")
        self.title:SetText("Now Playing")
        self.title:SizeToContents()
        local titleWide = self.title:GetWide()
        maxWide = (maxWide > titleWide) and maxWide or titleWide

    end


    for level, stations in SortedPairs(PLUGIN.nowPlaying) do
        if not table.IsEmpty(stations) then
            self["title"..level] = self:Add("DLabel")
            self["title"..level]:Dock(TOP)
            self["title"..level]:SetFont("nutMediumFont")
            self["title"..level]:SetText(levelTitles[level])
            self["title"..level]:SizeToContents()

            local titleWide = self["title"..level]:GetWide()
            maxWide = (maxWide > titleWide) and maxWide or titleWide

            for uniqueID, stationData in SortedPairsByMemberValue(stations, title) do
                self["station"..uniqueID] = self:Add("DLabel")
                self["station"..uniqueID]:Dock(TOP)
                self["station"..uniqueID]:SetFont("nutMediumLightFont")
                self["station"..uniqueID]:SetText(stationData.title)
                self["station"..uniqueID]:SizeToContents()

                local songWide = self["station"..uniqueID]:GetWide()
                maxWide = (maxWide > songWide) and maxWide or songWide
            end
        end
    end
    self:InvalidateLayout(true)
    self:SizeToChildren(true, true)
    self:SetY(30)
    self:SetWide(maxWide + 50)
end

function PANEL:Think()
    if not IsValid(nut.gui.quick) then return end
    self:MoveLeftOf(nut.gui.quick)
end

vgui.Register("nutMusicNowPlaying", PANEL, "DPanel")

function PLUGIN:OnContextMenuOpen()
    timer.Simple(0, function()
        vgui.Create("nutMusicNowPlaying")
    end)
end

function PLUGIN:OnContextMenuClose()
    if IsValid(nut.gui.nowPlaying) then
        nut.gui.nowPlaying:Remove()
    end
end