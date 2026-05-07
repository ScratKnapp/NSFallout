local PLUGIN = PLUGIN
local PANEL = {}
local ScrW, ScrH = ScrW(), ScrH()

function PANEL:Init()
    if nut.gui.musicVolumeSlider then
        nut.gui.musicVolumeSlider:Remove()
    end
    nut.gui.musicVolumeSlider = self

	self:SetTitle("Set Event Audio Volume")
	self:SetSize(ScrW * 0.25, ScrH * 0.1)
	self:Center()
	self:MakePopup()

	local audioSlider = self:Add("DNumSlider")
	audioSlider:Dock(TOP)
	audioSlider:SetText("Threshold") -- Set the text above the slider
	audioSlider:SetMin(0)				 -- Set the minimum number you can slide to
	audioSlider:SetMax(100)				-- Set the maximum number you can slide to
	audioSlider:SetDecimals(0)			 -- Decimal places - zero for whole number
	audioSlider:SetConVar("nut_music_volume") -- Changes the ConVar when you slide
	audioSlider:DockMargin(10, 0, 0, 5)
    function audioSlider:OnValueChanged(val)
        for _, stations in pairs(PLUGIN.nowPlaying) do
			for _, stationData in pairs(stations) do
				stationData.station:SetVolume(val/100)
			end
		end
    end
end

vgui.Register("nutMusicVolume", PANEL, "DFrame")