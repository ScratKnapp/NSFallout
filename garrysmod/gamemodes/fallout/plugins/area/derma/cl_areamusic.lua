local PLUGIN = PLUGIN
local PANEL = {}

function PANEL:Init()
	self:SetTitle("Area Music")
	self:SetSize(500, 400)
	self:Center()
	self:MakePopup()

	self.list = self:Add("DListView")
	self.list:Dock(FILL)
	self.list:DockMargin(0, 5, 0, 0)
	--self.list:EnableVerticalScrollbar()

	self.list:AddColumn("Song (File Path)", 1)
	self.list:AddColumn("Volume (0-1)", 2)

	timer.Simple(0, function()
		self:loadMusic()
	end)
end

function PANEL:loadMusic()
	if(!self.areaData.music) then
		self.areaData.music = {
			test = {
				path = "rightclick",
				volume = 1,
			},
		}
	end

	for k, song in pairs(self.areaData.music) do
		local line = self.list:AddLine(song.path or "", song.volume or 1)
		line.path = song.path
		line.volume = tonumber(song.volume)
		line.id = k
		
		--options here, like add a new line or something
		line.OnRightClick = function(panel)
			-- Just make sure this is defined
			self.areaData.music[panel.id] = self.areaData.music[panel.id] or {}
		
			local menu = DermaMenu()
			menu:AddOption("Edit Song", function()
				Derma_StringRequest("Edit Song", "Input Sound Path", panel.path, function(text)
					panel:SetValue(1, text or panel.path)
					panel.path = text
					
					self.areaData.music[panel.id].path = text
					
					self:saveMusicData()
				end)
			end):SetImage("icon16/textfield_add.png")
			menu:AddOption("Edit Volume", function()
				Derma_StringRequest("Edit Volume", "Input Volume", panel.volume, function(text)
					panel:SetValue(2, text or panel.volume)
					panel.volume = math.Clamp(tonumber(text), 0, 1)
					
					self.areaData.music[panel.id].volume = math.Clamp(tonumber(text), 0, 1)
					
					self:saveMusicData()
				end)
			end):SetImage("icon16/textfield_add.png")
			menu:AddOption("Remove Entry", function()
				self.areaData.music[panel.id] = nil
				self:saveMusicData(k, self.areaData.music)
				
				panel:Remove()
			end):SetImage("icon16/textfield_delete.png")
			menu:AddOption( "Add Line", function()	
				local newLine = self.list:AddLine("newsong", "1")
				newLine.id = newLine:GetID()
				newLine.OnRightClick = panel.OnRightClick
			end):SetImage("icon16/textfield_add.png")
			
			menu:Open()
		end
	end
end

function PANEL:saveMusicData()
	PLUGIN.areaTable[self.areaID] = self.areaData

	netstream.Start("areaUpdateMusic", self.areaID, self.areaData)
end
vgui.Register("nutAreaMusic", PANEL, "DFrame")

netstream.Hook("nutAreaMusic", function(areaData)
	areaManager = vgui.Create("nutAreaMusic")
	areaManager.areaData = areaData
end)
