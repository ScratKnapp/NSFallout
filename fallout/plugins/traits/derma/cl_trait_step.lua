local PANEL = {}

function PANEL:Init()
	self.title = self:addLabel("PERKS")
	
	self.traits = self:Add("DScrollPanel")
	self.traits:Dock(FILL)

	self.leftLabel = self:addLabel("points left")
	self.leftLabel:SetFont("nutCharSubTitleFont")
	
	self.traits:SetDrawBackground(false)
	
	local maximum = nut.config.get("maxTraits", 2) or hook.Run("GetStartTraitPoints", LocalPlayer(), panel.payload)
	
	--self:setContext("ptPerk", maximum)
end

function PANEL:updatePointsLeft()
	self.leftLabel:SetText(L("points left"):upper()..": "..self.left)
end

function PANEL:onDisplay()
	if(!TRAITS or !TRAITS.traits) then return end

	local oldChildren = self.traits:GetChildren()
	
	local total = total or 0
	local maximum = nut.config.get("maxTraits", 2) or hook.Run("GetStartTraitPoints", LocalPlayer(), panel.payload)
	local traits = self:getContext("traits", {})
	
	local sum = table.Count(traits)
	self.left = math.max(maximum - sum, 0)	
	self:updatePointsLeft()
	
	if(self.bars) then
		for k, v in pairs(self.bars) do
			v:Remove()
		end
	end
	
	self.bars = {}
	
	local sizeX, sizeY = self:GetSize()

	sizeY = 60
	
	for k, v in SortedPairsByMemberValue(TRAITS.traits, "category") do
		if(v.hidden) then continue end
	
		local name = v.name
		local desc = v.desc

		local perkPanel = self:Add("DButton")
		perkPanel:SetSize(sizeX, sizeY)
		perkPanel:SetText("")
		perkPanel:SetTooltip()
		perkPanel:Dock(TOP)
		perkPanel:DockMargin(2,2,2,2)
		perkPanel.Paint = function(self, w, h)
			surface.SetFont("nutMediumFont")
		
			if(perkPanel.selected) then
				surface.SetDrawColor(0, 47, 0, 200)
				surface.DrawRect(0, 0, w, h)
			else
				surface.SetDrawColor(0, 0, 0, 200)
				surface.DrawRect(0, 0, w, h)
			end

			surface.SetDrawColor(50, 255, 50)
			surface.DrawOutlinedRect(0, 0, w, h, 2)
			
			local textSizeX, textSizeY = surface.GetTextSize(name)
			surface.SetTextColor(50, 255, 50)
			surface.SetTextPos(w*0.5-textSizeX*0.5, h*0.5-textSizeY*0.5) 
			surface.DrawText(name)
			
			if(v.icon) then
				if(!v.iconCache) then
					v.iconCache = Material(v.icon)
				end
			
				local ratio = h/160
			
				surface.SetMaterial(v.iconCache or "")
				surface.SetDrawColor(50, 255, 50)
				surface.DrawTexturedRect(0, 0, 145*ratio, 160*ratio)
			end
		end
		perkPanel.OnCursorEntered = function(button)
			local popup = self:PerkPopup(v, button)
			
			popup:MoveRightOf(perkPanel, -ScrW()*0.25)
		end
		perkPanel.OnCursorExited = function(button)
			if(IsValid(self.perkPopup)) then
				self.perkPopup:Remove()
			end
		end
		perkPanel.DoClick = function(button)
			if(!perkPanel.selected) then
				if((total + 1) > maximum) then
					return false
				end

				total = total + 1
				
				if(traits[k]) then
					traits[k] = nil
				else
					traits[k] = 1
				end
				
				sum = table.Count(traits)
				self.left = math.max(maximum - sum, 0)
				self:updatePointsLeft()			
				
				self:setContext("traits", traits)
				self:setContext("ptPerk", self.left)
			
				perkPanel.selected = true
			else
				total = total - 1
				
				if(traits[k]) then
					traits[k] = nil
				else
					traits[k] = 1
				end
				
				sum = table.Count(traits)
				self.left = math.max(maximum - sum, 0)
				self:updatePointsLeft()			
				
				self:setContext("traits", traits)
				self:setContext("ptPerk", self.left)
			
				perkPanel.selected = false
			end
		end
	end
	
	self:setContext("ptPerk", self.left)
end


function PANEL:PerkPopup(perkData, button)
	if(IsValid(self.perkPopup)) then self.perkPopup:Remove() end
	
	local name = perkData.name
	local desc = perkData.desc

	local perkPopup = vgui.Create("DPanel")
	perkPopup:SetSize(ScrW()*0.3, ScrH()*0.3)
	--perkPopup:SetPos(button:GetPos())
	perkPopup:Center()
	perkPopup:MakePopup()
	perkPopup.OnKeyCodePressed = function(this, key)
		if (key == KEY_F1) then
			self:Remove()
			
			if (IsValid(nut.gui.menu)) then
				nut.gui.menu:remove()
			end
		end
	end

	perkPopup.Paint = function(panel, w, h)
		surface.SetDrawColor(0,0,0)
		surface.DrawRect(0,0,w,h)
		
		surface.SetDrawColor(50,125,50)
		surface.DrawOutlinedRect(0,0,w,h,2)
		
		surface.SetFont("nutMediumFont")
		
		--name
		local nameSizeX, nameSizeY = surface.GetTextSize(name)
		
		surface.SetTextColor(50, 255, 50)
		surface.SetTextPos(w*0.5-nameSizeX*0.5, nameSizeY*0.5) 
		surface.DrawText(name)
		
		surface.SetDrawColor(50,125,50)
		surface.DrawOutlinedRect(0,nameSizeY+16,w,2,2)
		
		--description
		local descSizeY, descSizeY = surface.GetTextSize(desc)
		
		local descLines = nut.util.wrapText(
			desc,
			w-32,
			"nutMediumFont"
		)

		local offsetY = 0
		for k, v in pairs(descLines) do
			surface.SetTextColor(50, 255, 50)
			surface.SetTextPos(8, nameSizeY+descSizeY*0.5+16+offsetY) 
			surface.DrawText(v)
			
			offsetY = offsetY + nameSizeY+descSizeY*0.5+8
		end
	end
	
	
	self.perkPopup = perkPopup
	
	return perkPopup
end

function PANEL:PerkChoose(button)
	if(IsValid(self.perkChoose)) then self.perkChoose:Remove() end
	
	local client = LocalPlayer()
	
	--so we can exclude them
	local clientPerks = client:getTraitsData()

	local perkChoose = vgui.Create("DFrame")
	perkChoose:SetSize(ScrW()*0.3, ScrH()*0.3)
	perkChoose:Center()
	perkChoose:SetX(ScrW()*0.5)
	perkChoose:SetTitle("")
	--perkPopup:SetPos(button:GetPos())
	perkChoose.Paint = function(self, w, h)
		surface.SetDrawColor(0,0,0)
		surface.DrawRect(0,0,w,h)
	end
	
	perkChoose:MakePopup()
	perkChoose.OnKeyCodePressed = function(this, key)
		if (key == KEY_F1) then
			self:Remove()
			
			if (IsValid(nut.gui.menu)) then
				nut.gui.menu:remove()
			end
		end
	end
	
	local perkScroll = perkChoose:Add("DScrollPanel")
	perkScroll:Dock(FILL)
	perkScroll:DockMargin(0,0,0,0)
	
	local sizeX, sizeY = perkChoose:GetSize()

	local perks = TRAITS.traits
	
	for k, v in pairs(perks) do
		local name = v.name
		local desc = v.desc
	
		local perkPanel = perkScroll:Add("DButton")
		perkPanel:SetSize(sizeX*0.33, sizeY*0.1)
		perkPanel:SetText("")
		perkPanel:SetTooltip("")
		perkPanel:Dock(TOP)
		perkPanel:DockMargin(2,2,2,2)
		perkPanel.Paint = function(self, w, h)
			surface.SetFont("nutMediumFont")
		
			if(perkPanel.selected) then
				surface.SetDrawColor(0, 238, 0, 200)
				surface.DrawRect(0, 0, w, h)
			else
				surface.SetDrawColor(0, 0, 0, 200)
				surface.DrawRect(0, 0, w, h)
			end
			
			surface.SetDrawColor(50, 255, 50)
			surface.DrawOutlinedRect(0, 0, w, h, 2)
			
			local textSizeX, textSizeY = surface.GetTextSize(name)
			
			surface.SetTextColor(50, 255, 50)
			surface.SetTextPos(w*0.5-textSizeX*0.5, h*0.5-textSizeY*0.5) 
			surface.DrawText(name)

			if(v.icon) then
				if(!v.iconCache) then
					v.iconCache = Material(v.icon)
				end
			
				local ratio = h/160
			
				surface.SetMaterial(v.iconCache or "")
				surface.SetDrawColor(50, 255, 50)
				surface.DrawTexturedRect(0, 0, 145*ratio, 160*ratio)
			end
		end
		perkPanel.OnCursorEntered = function(button)
			local popup = self:PerkPopup(v, button)
			
			popup:MoveRightOf(button, -ScrW()*0.4)
		end
		perkPanel.OnCursorExited = function(button)
			if(IsValid(self.perkPopup)) then
				self.perkPopup:Remove()
			end
		end
		perkPanel.DoClick = function(button)
			perkPanel.selected = true
		
			--[[
			Derma_Query("Choose " ..v.name.. "?", "Confirmation", "Yes", function()
				if(IsValid(self.newPerk)) then
					self.newPerk:Remove()
				end				
				
				if(IsValid(perkChoose)) then
					perkChoose:Remove()
				end
			
				netstream.Start("perkAdd", v.uid)
			end, "No", function()
			
			end)
			--]]
		end
	end
	
	self.perkChoose = perkChoose
end

function PANEL:OnRemove()
	if(IsValid(self.perkPopup)) then
		self.perkPopup:Remove()
	end
end

vgui.Register("nutCharTraits", PANEL, "nutCharacterCreateStep")