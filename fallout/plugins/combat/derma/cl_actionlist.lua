local PLUGIN = PLUGIN
NUT_SWEP_COMBAT_PLUGIN = PLUGIN
local PANEL = {}
	function PANEL:Init()
		local client = LocalPlayer()
		local char = client:getChar()
	
		if (IsValid(nut.gui.actionL)) then
			nut.gui.actionL:Remove()
		end
		
		nut.gui.actionL = self
		
		self:SetSize(ScrW() * 0.3, ScrH() * 0.6)
		self:Center()
		self:SetTitle("")
		self:MakePopup()
		self:ShowCloseButton(false)
		
		local inner = vgui.Create("DScrollPanel", self)
		inner:Dock(FILL)
		self.inner = inner
		
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
		
		local closeButton = vgui.Create("DButton", self)
		closeButton:SetPos(ScrW()*0.285, 0)
		closeButton:SetSize(20, 20)
		closeButton:SetTextColor(Color(255,255,255))
		closeButton:SetText("X")
		closeButton.Paint = function(panel, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
		end
		closeButton.DoClick = function()
			self:Close()
		end
		
		--drop down menu for parts targetting
		local partTarget = vgui.Create("DComboBox")
		partTarget:SetPos(self:GetPos())
		partTarget:SetSize(ScrW()*0.1, ScrH()*0.05)
		partTarget:MoveRightOf(self, 8)
		
		partTarget:SetFont("nutSmallFont")
		partTarget:SetToolTip("This affects accuracy and damage output.")
		
		partTarget:SetText("Body")
			
		local parts = PLUGIN:getPartsModifiers()
			
		for k, v in pairs(parts) do
			partTarget:AddChoice(k)
		end
		
		partTarget.OnSelect = function(panel, index, value)
			self:selectPart(value)
		end
		
		self.partTarget = partTarget
		
		--[[
		--drop down menu for weapon selecting
		local weaponSelect = vgui.Create("DComboBox")
		weaponSelect:SetPos(self:GetPos())
		weaponSelect:SetSize(ScrW()*0.1, ScrH()*0.05)
		weaponSelect:MoveRightOf(self, 8)
		weaponSelect:MoveBelow(partTarget, 8)

		weaponSelect:SetFont("nutSmallFont")
		weaponSelect:SetToolTip("What weapon to use for your attacks.")

		local equipment = {}
		for k, itemID in pairs(client:getEquip()) do
			local item = nut.item.instances[itemID]
			
			if(item) then
				equipment[#equipment+1] = item
			end
		end
		for k, item in pairs(char:getInv():getItems()) do
			if(item:getData("equip")) then
				equipment[#equipment+1] = item
			end
		end

		for k, item in pairs(equipment) do
			local dmg = item:getData("dmg", item.dmg)
			
			if(dmg) then
				weaponSelect:AddChoice(item:getName(), item)
			end
		end
		
		weaponSelect.OnSelect = function(panel, index, value, data)
			self:selectWeapon(data)
		end
		
		self.weaponSelect = weaponSelect
		--]]

		self:loadActions()
	end
	
	function PANEL:actionPress(button)
		for k, v in pairs(self.buttons) do
			v.active = false
			v:SetTextColor(Color(255,255,255,255))
		end
		
		button:SetTextColor(Color(100,100,200,255))
		button.active = true
		
		if(self.actions and self.swep) then
			self.swep:selectAction(button.action)
		--[[
		elseif(self.entity) then
			for k, v in pairs(self.entity.actions) do
				if(v.name == button:GetText()) then
					self.entity.casting = true --might be temporary
					
					self.entity.actCur = k
					netstream.Start("ccActionSelect", self.entity, k)
				end
			end
		--]]
		end
	end
	
	function PANEL:selectPart(partTarget)
		if(self.swep) then
			self.swep:selectPart(partTarget)
		end
	end
	
	--[[
	function PANEL:selectWeapon(item)
		if(self.swep) then
			self.swep:selectWeapon(item)
		end
	end
	--]]
	
	--loads all the actions and category headers
	function PANEL:loadActions()
		--clears existing actions (so we can reload them)
		self.categories = {}
		self.buttons = {}
		self.inner:Clear()
		self.labels = {}
	
		timer.Simple(0, function()
			--load default actions
			for k, action in pairs(self.actions) do
				if(action.category == "Default") then 
					self:addActionButton(action, k)
				end
			end
		
			--loads nondefault actions
			for k, action in SortedPairsByMemberValue(self.actions or {}, "category" or "") do
				if(action.category == "Default") then continue end
				
				self:addActionButton(action, k)
			end
		end)	
	end
	
	function PANEL:addActionButton(action, actionIndex)
		local categories = self.categories
		local inner = self.inner
	
		local textColor = Color(150,150,150,255)

		local actionData = {}
		if(action.uid) then
			actionData = ACTS.actions[action.uid] or {}
		end

		if(actionData.category) then
			if(!categories[actionData.category]) then
				categories[actionData.category] = true
				
				local catLabel = inner:Add("DLabel")
				catLabel:Dock(TOP)
				catLabel:SetTall(50)
				catLabel:DockMargin(8,8,8,8)
				catLabel:SetFont("nutMenuButtonLightFont")
				catLabel:SetText(" " ..actionData.category.. " ")
				
				catLabel.Paint = function(panel, w, h)
					local textSizeX, textSizeY = panel:GetTextSize()

					surface.SetDrawColor(Color(255, 255, 255, 255))
					surface.DrawLine(0, textSizeY, textSizeX, textSizeY)
				end
				
				self.labels[#self.labels+1] = catLabel
			end
		
			--textColor = colors[actionData.category] or Color(255,255,255,255)
			textColor = Color(255,255,255,255)
		end
		
		local desc
		if(actionData.desc) then
			desc = actionData.desc or ""
		else
			desc = ""
		end
		
		local item
		if(action.weapon) then
			item = nut.item.instances[action.weapon]

			if(item) then
				local name = (item.getName and item:getName()) or item.name or "Unknown Item"
				desc = desc.. "\nItem: " ..name.. "."
			end
		end
	
		local dmg = 0
		local dmgDesc = ""

		if(actionData.weaponMult) then
			if(item) then
				local itemDmg = item:getData("dmg", item.dmg) or {}
				for k, v in pairs(itemDmg) do
					dmg = dmg + v
				end
				
				dmg = dmg * actionData.weaponMult
			end
		
			--desc = desc.. "\nWeapon Damage Multiplier: " ..actionData.weaponMult.. "x."
		end
	
		if(actionData.dmg) then
			dmg = dmg + actionData.dmg
		
			--desc = desc.. "\nBase Damage: " ..actionData.dmg.. " " ..actionData.dmgT.. "."
		end	

		if(dmg > 0) then
			desc = desc.. "\nDamage: " ..dmg
			
			--if(actionData.multi) then
			desc = desc.. " (x" ..(actionData.multi or 1).. ")"
			--end
			
			local dmgT = actionData.dmgT
			if(!dmgT) then
				local itemDmg = (item and item:getData("dmg", item.dmg)) or {}
				local highest = 0
				
				--finds the damage type with the highest value
				for k, v in pairs(itemDmg) do
					if(highest < tonumber(v)) then
						highest = tonumber(v)
						dmgT = k
					end
				end
			end

			desc = desc.. " " ..(dmgT or "Unknown").. "."
		end
		
		if(actionData.radius) then
			desc = desc.. "\nArea of Effect: " ..actionData.radius.. "."
		end
		
		if(actionData.CD) then
			desc = desc.. "\nCooldown: " ..actionData.CD.. " turns."
		end
		
		if(actionData.costAP) then
			desc = desc.. "\nAP Cost: " ..actionData.costAP.. "."
		end
	
		if(actionData.costHP) then
			desc = desc.. "\nHP Cost: " ..actionData.costHP.. "."
		end
	
		local button = inner:Add("DButton")
		button:Dock(TOP)
		button:DockMargin(2,2,2,2)
		
		button:SetFont("nutSmallFont")
		
		local actionName = actionData.name or action.name or "Unnamed Action"
		--puts the weapon name next to the action
		--felt a bit cluttered
		--[[
		if(item and action.weapon) then
			actionName = actionName.. " [" ..(item:getName() or item.name or "Unknown Item").. "]"
		end
		--]]
		
		button:SetTextColor(textColor)
		button:SetText(actionName)
		button:SetToolTip(desc)
		button.DoClick = function(panel)
			self:actionPress(panel)
		end
		button.Paint = function(panel, w, h)
			surface.SetDrawColor(Color(0, 0, 0, 220))
			surface.DrawRect(0, 0, w, h)
		end
		
		button.action = actionIndex

		self.buttons[#self.buttons + 1] = button
	end
	
	function PANEL:OnRemove()
		if(IsValid(self.partTarget)) then
			self.partTarget:Remove()
		end
		
		if(IsValid(self.weaponSelect)) then
			self.weaponSelect:Remove()
		end
	end
vgui.Register("nutActionList", PANEL, "DFrame")