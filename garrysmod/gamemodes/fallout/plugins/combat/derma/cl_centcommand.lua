local PLUGIN = PLUGIN

local PANEL = {}
	function PANEL:Init()
		local client = LocalPlayer()
	
		if (IsValid(nut.gui.command)) then
			nut.gui.command:Remove()
		end
		
		nut.gui.command = self
		self:SetSize(ScrW() * 0.3, ScrH() * 0.6)
		self:Center()
		self:SetTitle("")
		self:MakePopup()
		self:ShowCloseButton(true)
		
		self.Paint = function(panel, w, h)
			--background image
			surface.SetDrawColor(Color(40, 40, 40, 255))
			surface.DrawRect(0, 0, w, h)
		end
		
		self.buttons = {}
		self.categories = {}
		self.labels = {}
		
		local inner = vgui.Create("DScrollPanel", self)
		inner:Dock(FILL)
		self.inner = inner
		
		--inner:SetVerticalScrollbarEnabled(false)
		local vBar = inner:GetVBar()
		function vBar:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
		end
		function vBar.btnUp:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
		end
		function vBar.btnDown:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
		end
		function vBar.btnGrip:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
		end
		
		local searchEntry = vgui.Create("DTextEntry", self)
		searchEntry:Dock(TOP)
		searchEntry:DockMargin(0,0,0,8)
		searchEntry:SetText("")
		searchEntry:SetTall(28)
		searchEntry:SetTextColor(Color(0,0,0))
		searchEntry.OnValueChange = function(this, text)
			local search
		
			if(text == "" or text == " ") then
				search = nil
			else
				search = string.lower(text)
			end
			
			self:Search(search)
		end
		
		local saveButton = vgui.Create("DButton", self)
		saveButton:Dock(BOTTOM)
		saveButton:SetTextColor(Color(255,255,255))
		saveButton:SetText("SAVE")
		saveButton.Paint = function(panel, w, h)
			surface.SetDrawColor(255,255,255)
			
			surface.DrawOutlinedRect(0,0,w,h,1)
		end
		saveButton.DoClick = function()
			self:SaveCEnt()
			self:Close()
		end
	end
	
	--panel for selected entity
	function PANEL:CEntConfig(entity, weapon, dataFields, search)
		local client = LocalPlayer()
		
		self.entity = entity
		self.weapon = weapon
		self.fields = {}
		
		local fields = entity:getDataFields()

		local inner = self.inner
		
		self.categories = {}

		for _, data in pairs(fields) do
			local catPanel = vgui.Create("DPanel", inner)
			catPanel:Dock(TOP)
			catPanel:DockMargin(0,0,0,8)
			catPanel.Paint = function(this, w, h)
				surface.SetDrawColor(40,40,40)
				surface.DrawRect(0,0,w,h)
			end
			
			local catButton = catPanel:Add("DButton")
			catButton:Dock(TOP)
			catButton:DockMargin(0,0,0,4)
			catButton:SetSize(0, ScreenScaleH(18))
			catButton:SetText("")
			
			catButton.DoClick = function(this)
				if(catPanel.minimized) then
					catPanel.minimized = false
					
					for k, v in pairs(catPanel:GetChildren()) do
						if(IsValid(v) and v != this) then
							v:SetVisible(true)
						end
					end
				else
					catPanel.minimized = true
					
					for k, v in pairs(catPanel:GetChildren()) do
						if(IsValid(v) and v != this) then
							v:SetVisible(false)
						end
					end
				end
				
				catPanel:InvalidateLayout(true)
				catPanel:SizeToChildren(false, true)
			end
			
			catButton.Paint = function(this, w, h)
				surface.SetDrawColor(40,40,40)
				surface.DrawRect(0,0,w,h)
				
				local sizeX, sizeY
				surface.SetFont("nutMenuButtonLightFont")
				
				if(catPanel.minimized) then
					surface.SetTextColor(128, 128, 128)
				
					sizeX, sizeY = surface.GetTextSize(">")
				
					surface.SetTextPos(sizeX*0.5, h*0.5-sizeY*0.5)
					surface.DrawText(">")
				else
					surface.SetTextColor(255, 255, 255)
				
					surface.SetDrawColor(128,128,128)
					surface.DrawLine(0,0,0,h)
				end
				
				local name = catPanel.name or "Unnamed Category"
				
				sizeX, sizeY = surface.GetTextSize(name)
				
				surface.SetTextPos(w*0.5-sizeX*0.5, 0)
				surface.DrawText(name)
				
				surface.SetDrawColor(128,128,128)
				surface.DrawLine(w*0.25,h-1,w*0.75,h-1)
			end
			
			for k, v in SortedPairsByMemberValue(data, "weight") do
				if(v.category and !catPanel.name) then catPanel.name = v.category end
			
				self:CreateField(k, v, catPanel)
			end
			
			catPanel:InvalidateLayout(true)
			catPanel:SizeToChildren(false, true)
			
			self.categories[_] = catPanel
		end
	end
	
	function PANEL:Search(search)
		local innerChildren = self.inner:GetChildren()
		
		for uid, panel in pairs(self.fields) do
			if(istable(panel)) then
				for k, subPanel in pairs(panel) do
					local label = subPanel.label
					local box = subPanel.box
				
					if(!search) then
						box:SetVisible(true)
						continue
					end

					if(label) then
						local name = label:GetText() or ""
						name = string.lower(name)
						
						if(string.find(name, search)) then
							box:SetVisible(true)
						else
							box:SetVisible(false)
						end
					end
				end
			else
				local label = panel.label
				local box = panel.box
				
				if(label) then
					if(!search) then
						box:SetVisible(true)
						continue
					end
				
					local name = label:GetText() or ""
					name = string.lower(name)
					
					if(string.find(name, search)) then
						box:SetVisible(true)
					else
						box:SetVisible(false)
					end
				end
			end

			for k, category in pairs(self.categories) do
				category:InvalidateLayout(true)
				category:SizeToChildren(false, true)
			end
		end
	end
	
	PANEL.FieldFormat = {
		["DLabel"] = function(id, data, parent, fields)
			if(data.extra) then
				fields[id] = {}
			
				for k, v in SortedPairs(data.extra) do
					local box = vgui.Create("DPanel", parent)
					box:Dock(TOP)
				
					local label = vgui.Create("DLabel", box)
					label:SetText(v.name)
					label:SetFont("nutSmallFont")
					label:SetWide(ScreenScale(40))
					label:Dock(LEFT)

					local entry = vgui.Create("DTextEntry", box)
					entry:SetText((data.value and data.value[k]) or "")
					entry:SetFont("nutSmallFont")
					entry:SetWide(ScreenScale(140))
					entry:Dock(LEFT)
					entry:SetTextColor(Color(200,200,200))
					entry:SetCursorColor(Color(255,255,255))
					entry:SetPaintBackground(false)
					entry.label = label
					entry.box = box
					
					if(data.numeric) then
						entry:SetNumeric(true)
					end
					
					fields[id][k] = entry
				end
			else
				local box = vgui.Create("DPanel", parent)
				box:Dock(TOP)
			
				local label = vgui.Create("DLabel", box)
				label:SetText(data.name)
				label:SetFont("nutSmallFont")
				label:SetWide(ScreenScale(40))
				label:Dock(LEFT)

				local entry = vgui.Create("DTextEntry", box)
				entry:SetText(data.value or "")
				entry:SetFont("nutSmallFont")
				entry:SetWide(ScreenScale(140))
				entry:Dock(LEFT)
				entry:SetTextColor(Color(200,200,200))
				entry:SetCursorColor(Color(255,255,255))
				entry:SetPaintBackground(false)
				entry.label = label
				entry.box = box
				
				if(data.numeric) then
					entry:SetNumeric(true)
				end
				
				fields[id] = entry
			end
		end,
		["DColorMixer"] = function(id, data, parent, fields)
			local box = vgui.Create("DPanel", parent)
			box:Dock(TOP)
			box:SetTall(ScreenScaleH(100))
		
			local label = vgui.Create("DLabel", box)
			label:SetText(data.name)
			label:SetFont("nutSmallFont")
			label:SetWide(ScreenScale(40))
			label:Dock(LEFT)

			local entry = vgui.Create("DColorMixer", box)
			entry:Dock(LEFT)
			entry:SetColor(data.value or Color(255,255,255))
			
			entry.GetFunc = entry.GetColor
			
			entry.box = box
			entry.label = label
			
			fields[id] = entry
		end,
		["DComboBox"] = function(id, data, parent, fields)
			local box = vgui.Create("DPanel", parent)
			box:Dock(TOP)

			local label = vgui.Create("DLabel", box)
			label:SetText(data.name)
			label:SetFont("nutSmallFont")
			label:SetWide(ScreenScale(40))
			label:Dock(LEFT)

			local entry = vgui.Create("DComboBox", box)

			if(data.panelFunc) then
				for choice, v in pairs(data.extra) do
					entry:AddChoice(v)
				end
			else
				for choice, _ in pairs(data.extra) do
					entry:AddChoice(choice)
				end
			end
			
			if(data.value and isstring(data.value)) then
				entry:SetValue(data.value)
			end
			
			entry:Dock(LEFT)
			
			entry.box = box
			entry.label = label

			fields[id] = entry
		end,
	}
	
	function PANEL:CreateField(id, data, parent, search)
		local panelType = data.panelType
		if(!panelType) then 
			panelType = "DLabel"
		end
		
		if(self.FieldFormat[panelType]) then
			if(search and data.extra) then
				for name, v in pairs(data.extra) do
					if(string.find(string.lower(name), string.lower(search))) then
						self.FieldFormat[panelType](id, data, parent, self.fields)
					end
				end
			else
				self.FieldFormat[panelType](id, data, parent, self.fields)
			end
		end
	end
	
	function PANEL:SaveCEnt()
		local entity = self.entity
		local data = {}
		
		for id, panel in pairs(self.fields) do
			if(istable(panel)) then
				data[id] = {}
				
				for k, v in pairs(panel) do
					if(v.GetFunc) then
						data[id][k] = v:GetFunc()
					elseif(v.GetValue and v:GetValue() != "") then 
						data[id][k] = v:GetValue()
					elseif(v.GetText and v:GetText() != "") then
						data[id][k] = v:GetText()
					end
				end
			else
				if(panel.GetFunc) then
					data[id] = panel:GetFunc()
				elseif(panel.GetValue and panel:GetValue() != "") then 
					data[id] = panel:GetValue()
				elseif(panel.GetText and panel:GetText() != "") then
					data[id] = panel:GetText()
				end
			end
		end

		netstream.Start("nut_CEntUpdateData", entity, data)
	end
vgui.Register("nutCombatCommand", PANEL, "DFrame")