local PLUGIN = PLUGIN
NUT_SWEP_COMBAT_PLUGIN = PLUGIN

-- Mirrors the AP / Active Effects HUD palette in nut_cswep.lua's DrawHUD so
-- the action menu reads as the same widget family.
local HUD_BG     = Color(0, 47, 0, 150)
local HUD_LINE   = Color(0, 238, 0, 150)
local HUD_TEXT   = Color(0, 238, 0, 150)
local HUD_TEXT_S = Color(0, 16, 4, 255)
local HUD_DIM    = Color(0, 100, 0, 90)

local function paintHUDBox(w, h)
	surface.SetDrawColor(HUD_BG)
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(HUD_LINE)
	surface.DrawOutlinedRect(0, 0, w, h, 1)
end

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

		self.Paint = function(panel, w, h)
			paintHUDBox(w, h)

			surface.SetFont("nutCombatHUD")
			local header = "[ACTIONS]"
			local tx, ty = surface.GetTextSize(header)
			surface.SetTextColor(HUD_TEXT)
			surface.SetTextPos(w * 0.5 - tx * 0.5, 8)
			surface.DrawText(header)

			surface.SetDrawColor(HUD_LINE)
			surface.DrawLine(10, ty + 16, w - 10, ty + 16)
		end

		local inner = vgui.Create("DScrollPanel", self)
		inner:Dock(FILL)
		inner:DockMargin(8, 32, 8, 8)
		inner.Paint = function() end
		self.inner = inner

		local vBar = inner:GetVBar()
		function vBar:Paint(w, h)
			surface.SetDrawColor(HUD_BG)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(HUD_LINE)
			surface.DrawOutlinedRect(0, 0, w, h, 1)
		end
		function vBar.btnUp:Paint(w, h)
			surface.SetDrawColor(HUD_LINE)
			surface.DrawRect(0, 0, w, h)
		end
		function vBar.btnDown:Paint(w, h)
			surface.SetDrawColor(HUD_LINE)
			surface.DrawRect(0, 0, w, h)
		end
		function vBar.btnGrip:Paint(w, h)
			surface.SetDrawColor(HUD_LINE)
			surface.DrawRect(0, 0, w, h)
		end

		local closeButton = vgui.Create("DButton", self)
		closeButton:SetPos(ScrW()*0.285, 0)
		closeButton:SetSize(20, 20)
		closeButton:SetText("")
		closeButton.Paint = function(panel, w, h)
			surface.SetDrawColor(HUD_BG)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(HUD_LINE)
			surface.DrawOutlinedRect(0, 0, w, h, 1)
			surface.SetFont("nutCombatHUD")
			local tx, ty = surface.GetTextSize("X")
			surface.SetTextColor(HUD_TEXT)
			surface.SetTextPos(w * 0.5 - tx * 0.5, h * 0.5 - ty * 0.5)
			surface.DrawText("X")
		end
		closeButton.DoClick = function()
			self:Close()
		end

		--drop down menu for parts targetting
		local partTarget = vgui.Create("DComboBox")
		partTarget:SetPos(self:GetPos())
		partTarget:SetSize(ScrW()*0.1, ScrH()*0.05)
		partTarget:MoveRightOf(self, 8)

		partTarget:SetFont("nutCombatHUD")
		partTarget:SetToolTip("This affects accuracy and damage output.")
		partTarget:SetTextColor(HUD_TEXT)
		partTarget.Paint = function(panel, w, h)
			paintHUDBox(w, h)
		end

		partTarget:SetText("[BODY]")

		local parts = PLUGIN:getPartsModifiers()

		for k, v in pairs(parts) do
			partTarget:AddChoice(k)
		end

		partTarget.OnSelect = function(panel, index, value)
			panel:SetText("[" .. string.upper(value) .. "]")
			self:selectPart(value)
		end

		self.partTarget = partTarget

		self:loadActions()
	end

	function PANEL:actionPress(button)
		for k, v in pairs(self.buttons) do
			v.active = false
		end

		button.active = true

		if(self.actions and self.swep) then
			self.swep:selectAction(button.action)
		end
	end

	function PANEL:selectPart(partTarget)
		if(self.swep) then
			self.swep:selectPart(partTarget)
		end
	end

	--loads all the actions and category headers
	function PANEL:loadActions()
		--clears existing actions (so we can reload them)
		self.categories = {}
		self.buttons = {}
		self.inner:Clear()
		self.labels = {}

		timer.Simple(0, function()
			local selected = self.selected
			local cooldowns = {}

			if(selected and selected.getCooldowns) then
				cooldowns = selected:getCooldowns()
			end

			--load default actions
			for k, action in pairs(self.actions) do
				if(action.category == "Default") then
					self:addActionButton(action, k, cooldowns)
				end
			end

			--loads nondefault actions
			for k, action in SortedPairsByMemberValue(self.actions or {}, "category" or "") do
				if(action.category == "Default") then continue end

				self:addActionButton(action, k, cooldowns)
			end
		end)
	end

	function PANEL:addActionButton(action, actionIndex, cooldowns)
		local categories = self.categories
		local inner = self.inner

		local actionData = {}
		if(action.uid) then
			actionData = ACTS.actions[action.uid] or {}
		end

		if(actionData.category) then
			if(!categories[actionData.category]) then
				categories[actionData.category] = true

				local catLabel = inner:Add("DLabel")
				catLabel:Dock(TOP)
				catLabel:SetTall(28)
				catLabel:DockMargin(2, 8, 2, 2)
				catLabel:SetFont("nutCombatHUD")
				catLabel:SetText("")

				local catText = "[" .. string.upper(actionData.category) .. "]"
				catLabel.Paint = function(panel, w, h)
					surface.SetFont("nutCombatHUD")
					local tx, ty = surface.GetTextSize(catText)
					surface.SetTextColor(HUD_TEXT)
					surface.SetTextPos(w * 0.5 - tx * 0.5, h * 0.5 - ty * 0.5)
					surface.DrawText(catText)
					surface.SetDrawColor(HUD_LINE)
					surface.DrawLine(4, h - 4, w * 0.5 - tx * 0.5 - 6, h - 4)
					surface.DrawLine(w * 0.5 + tx * 0.5 + 6, h - 4, w - 4, h - 4)
				end

				self.labels[#self.labels+1] = catLabel
			end
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
		if(actionData.weaponMult) then
			if(item) then
				local itemDmg = item:getData("dmg", item.dmg) or {}
				for k, v in pairs(itemDmg) do
					dmg = dmg + v
				end

				dmg = dmg * actionData.weaponMult
			end
		end

		if(actionData.dmg) then
			dmg = dmg + actionData.dmg
		end

		if(dmg > 0) then
			desc = desc.. "\nDamage: " ..dmg
			desc = desc.. " (x" ..(actionData.multi or 1).. ")"

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
		button:DockMargin(2, 2, 2, 2)
		button:SetTall(26)

		button:SetFont("nutCombatHUD")

		local actionName = actionData.name or action.name or "Unnamed Action"

		local cooldown = cooldowns[action.uid]
		if(!cooldown) then
			local weapon = action.weapon
			if(weapon) then
				cooldown = cooldowns[action.uid..weapon]
			end
		end

		local onCD = cooldown ~= nil
		if(onCD) then
			actionName = actionName .. " [CD " .. cooldown.duration .. "T]"
		end

		button:SetText("")
		button:SetToolTip(desc)
		button.DoClick = function(panel)
			self:actionPress(panel)
		end
		button.Paint = function(panel, w, h)
			local hover = panel:IsHovered()
			local active = panel.active

			if active then
				surface.SetDrawColor(HUD_LINE)
				surface.DrawRect(0, 0, w, h)
				surface.SetTextColor(HUD_TEXT_S)
			else
				surface.SetDrawColor(HUD_BG)
				surface.DrawRect(0, 0, w, h)
				surface.SetDrawColor(HUD_LINE)
				surface.DrawOutlinedRect(0, 0, w, h, 1)

				if hover then
					surface.SetDrawColor(HUD_DIM)
					surface.DrawRect(1, 1, w - 2, h - 2)
				end

				surface.SetTextColor(onCD and Color(0, 140, 0, 150) or HUD_TEXT)
			end

			surface.SetFont("nutCombatHUD")
			local tx, ty = surface.GetTextSize(actionName)
			surface.SetTextPos(w * 0.5 - tx * 0.5, h * 0.5 - ty * 0.5)
			surface.DrawText(actionName)
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
