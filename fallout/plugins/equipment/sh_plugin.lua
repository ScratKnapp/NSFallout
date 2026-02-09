local PLUGIN = PLUGIN
PLUGIN.name = "Equipment Slots"
PLUGIN.author = "Chancer"
PLUGIN.desc = "Fancy equipment slots."
--nut.flag.add("x", "Augments")
PLUGIN.equipSlots = {
	["headgear"] = {
		x = 556,
		y = 156,
	},
	["primary"] = {
		x = 224,
		y = 565,
	},
	["sidearm"] = {
		x = 224,
		y = 700,
	},
	["body"] = {
		x = 642,
		y = 565,
	},
	["arms"] = {
		x = 642,
		y = 430,
	},
	["utility"] = {
		x = 224,
		y = 430,
	},
	["legs"] = {
		x = 642,
		y = 700,
	},
}

PLUGIN.augSlots = {
	["skeleton"] = {
		x = 148,
		y = 156,
	},
	["neural"] = {
		x = 302,
		y = 156,
	},
	["optics"] = {
		x = 556,
		y = 156,
	},
	["left arm"] = {
		x = 224,
		y = 430,
	},
	["right arm"] = {
		x = 642,
		y = 430,
	},
	["implant 1"] = {
		x = 224,
		y = 565,
	},
	["implant 2"] = {
		x = 642,
		y = 565,
	},
	["left leg"] = {
		x = 224,
		y = 700,
	},
	["right leg"] = {
		x = 642,
		y = 700,
	},
}

PLUGIN.EQUIPMENT_DESC_AETHERSTONE = "<color=175,0,255>[Aetherstone]</color> "
PLUGIN.EQUIPMENT_DESC_HELIOS = "<color=240,180,5>[HELIOS]</color> "
PLUGIN.EQUIPMENT_DESC_VISSEI = "<color=45,45,45>[Vissei Supply]</color> "
PLUGIN.EQUIPMENT_DESC_HANWHA = "<color=145,50,30>[Hanwha Group]</color> "
PLUGIN.EQUIPMENT_DESC_PIANZI = "<color=120,40,40>[Pianzi Manufacturing]</color> "
PLUGIN.EQUIPMENT_DESC_ARINT = "<color=100,250,180>[ARINT]</color> "
PLUGIN.EQUIPMENT_DESC_AEGIS = "<color=115,155,255>[Aegis Unlimited]</color> "
PLUGIN.EQUIPMENT_DESC_OMEGA = "<color=45,55,80>[Omega Global]</color> "
PLUGIN.EQUIPMENT_DESC_TRITEK = "<color=100,250,180>[Tri-Tek]</color> "
PLUGIN.EQUIPMENT_DESC_VARIOUS = "<color=29,255,255>[Various Companies]</color> "
PLUGIN.EQUIPMENT_TIER_1 = "<color=65,245,90>[T1]</color> "
PLUGIN.EQUIPMENT_TIER_2 = "<color=235,165,55>[T2]</color> "
PLUGIN.EQUIPMENT_TIER_3 = "<color=235,220,50>[T3]</color> "
PLUGIN.EQUIPMENT_TIER_4 = "<color=50,130,235>[T4]</color> "
PLUGIN.EQUIPMENT_GRADE_CIVILIAN = "<color=65,245,90>[CIVILIAN]</color> "
PLUGIN.EQUIPMENT_GRADE_PERFORMANCE = "<color=235,165,55>[PERFORMANCE]</color> "
PLUGIN.EQUIPMENT_GRADE_INDUSTRIAL = "<color=235,220,50>[INDUSTRIAL]</color> "
PLUGIN.EQUIPMENT_GRADE_SECURITY = "<color=50,130,235>[SECURITY]</color> "
PLUGIN.EQUIPMENT_GRADE_TECH = "<color=55,235,200>[TECH]</color> "
local playerMeta = FindMetaTable("Player")
--format of "equip" data table
--[[
	[slot] = itemID
--]]
--gets currently equipped items
function playerMeta:getEquip()
	--grab the table and return it
	local char = self:getChar()
	if char then return char:getData("equip", {}) end
	return {}
end

--checks if the player can equip the thing
function playerMeta:canEquip(slot, item)
	if not item or not slot then return false end
	local equipTbl = self:getEquip()
	if equipTbl[string.lower(slot)] then return false, "Slot full." end
	return true
end

function PLUGIN:getEquippedItems(client, onlyEquipped)
	local char = client:getChar()
	local inventory = char:getInv()
	local equipment = {}
	for k, v in pairs(client:getEquip()) do
		local item = nut.item.instances[v]
		if not item then continue end
		equipment[#equipment + 1] = item
	end

	for k, v in pairs(inventory:getItems()) do
		if onlyEquipped and (v:getData("equip") or v.action) then
			equipment[#equipment + 1] = v
		elseif not onlyEquipped and (v.base == "base_equipment" or v.action) then
			equipment[#equipment + 1] = v
		end
	end
	return equipment
end

function playerMeta:getEquipLoad()
	local equipment = PLUGIN:getEquippedItems(self, true)
	local load = 0
	for k, v in pairs(equipment) do
		if v.equipLoad then load = load + v.equipLoad end
	end
	return load
end

function playerMeta:getMaxLoad()
	local char = self:getChar()

	local maxLoad = 2
	
	maxLoad = maxLoad + char:getAttrib("int", 0)*0.5
	maxLoad = maxLoad + char:getAttrib("end", 0)*0.5
	
	maxLoad = math.floor(maxLoad)
	
	return maxLoad
end

if SERVER then
	function PLUGIN:PlayerLoadedChar(client)
		local equipTbl = client:getEquip()
		for slot, itemID in pairs(equipTbl) do
			local item = nut.item.instances[itemID]
			if not item then nut.item.loadItemByID(itemID) end
		end
	end

	netstream.Hook("nut_unequip_slot", function(client, slot, itemID) client:removeEquip(slot) end)
	netstream.Hook("nut_equipmentItemSync", function(client)
		if client:getChar() then
			for slot, itemID in pairs(client:getEquip()) do
				local item = nut.item.instances[itemID]
				if item then item:sync() end
			end
		end
	end)

	--equip something
	function playerMeta:addEquip(slot, item)
		local canEquip, error = self:canEquip(slot, item)
		if not canEquip then return false end
		local char = self:getChar()
		local equipTbl = self:getEquip()
		equipTbl[string.lower(slot)] = item.id
		char:setData("equip", equipTbl)
		if item.onEquip then item:onEquip(self) end
		--remove the item from the inventory
		item:removeFromInventory(true)
		--refresh the gui
		netstream.Start(self, "nut_updateEquipSlots")
		return true
	end

	--unequip something
	function playerMeta:removeEquip(slot)
		local equipTbl = self:getEquip()
		local itemID = equipTbl[slot]
		local item = nut.item.instances[itemID]
		if not item then
			nut.item.loadItemByID(itemID)
			return false
		end

		local inventory = self:getChar():getInv()
		if inventory then
			local position = self:getItemDropPos()
			
			local x, y = inventory:findFreePosition(item)
			if(x and y) then
				item:setData("x", x)
				item:setData("y", y)
			
				inventory:addItem(item)
			else
				item:spawn(position)
			end
		end

		local char = self:getChar()
		equipTbl[slot] = nil
		char:setData("equip", equipTbl)
		if item.onEquipUn then item:onEquipUn(self) end
		--refresh the gui
		netstream.Start(self, "nut_updateEquipSlots")
		return true
	end

	--doing more melee damage, or run faster, or have slightly higher health
	function playerMeta:buffsFromEquip()
		local playerBuffs = {
			maxHealth = 100,
			runSpeed = nut.config.get("runSpeed"),
			jumpPower = 160,
		}

		for _, itemID in pairs(self:getEquip()) do
			local item = nut.item.instances[itemID]
			if item then
				local augBuffs = item.augBuffs or {}
				for k, v in pairs(augBuffs) do
					if playerBuffs[k] then playerBuffs[k] = playerBuffs[k] * v end
				end
			end
		end
		return playerBuffs
	end

	function PLUGIN:PlayerLoadout(client)
		--timer so it loads after all the other stuff, scuffed
		if not IsValid(client) then return end
		timer.Simple(0, function()
			local equipTbl = client:getEquip()
			for slot, itemID in pairs(equipTbl) do
				local item = nut.item.instances[itemID]
				if item then
					item:onEquip(client, true)
					item:sync()
				else
					timer.Simple(10, function()
						item = nut.item.instances[itemID]
						if item then
							item:onEquip(client, true)
							item:sync()
						end
					end)
				end
			end
		end)
	end
else --CLIENT
	local schemaUI = nut.config.get("schemaUI", "fonvui")
	--local augmentMat = Material("fonvui/augments.png")
	--local equipMat = Material("fonvui/equipment.png")
	local augmentMat = Material(schemaUI .. "/augments.png")
	local equipMat = Material(schemaUI .. "/equipment.png")
	function PLUGIN:CreateEquipmentMenu(panel, inventory)
		local client = LocalPlayer()
		--augment menu
		local augment = vgui.Create("nutSlots")
		augment:createButtons("augment", augmentMat, PLUGIN.augSlots)
		augment:MoveLeftOf(inventory, 0)
		augment:SetParent(panel)
		nut.gui.augment = augment
		local weight = vgui.Create("DLabel")
		weight:SetParent(augment)
		weight:SetSize(augment:GetWide(), 40)
		weight:SetPos(0, augment:GetTall() * 0.9)
		weight:SetText("")
		weight.Paint = function(self, w, h)
			local load = client:getEquipLoad()
			local loadMax = client:getMaxLoad()
			local loadMsg = "LOAD: (" .. load .. "/" .. loadMax .. ")"
			--surface.SetFont("nutTitleFont")
			surface.SetFont("nutChatFont")
			surface.SetTextColor(255, 255, 255)
			surface.SetTextPos(w * 0.2, h * 0.5)
			surface.DrawText(loadMsg)
		end

		--equipment menu
		local equip = vgui.Create("nutSlots")
		equip:createButtons("equipment", equipMat, PLUGIN.equipSlots)
		equip:MoveRightOf(inventory, 0)
		equip:SetParent(panel)
		local sizeX, sizeY = panel:GetSize()
		local XPBar = vgui.Create("DPanel")
		XPBar:SetSize(sizeX, ScrH() * 0.03)
		XPBar:SetPos(ScrW() * 0.5 - sizeX * 0.5, ScrH() * 0.9)
		XPBar:SetParent(panel)
		XPBar:MakePopup()
		XPBar.OnKeyCodePressed = function(this, key)
			if key == KEY_F1 then
				this:Remove()
				if IsValid(nut.gui.menu) then nut.gui.menu:remove() end
			end
		end

		XPBar.Paint = function(self, w, h)
			local client = LocalPlayer()
			local char = client:getChar()
			local level = client:getLevel()
			local nextLevel = nut.plugin.list["level"]:getLevelThresh(level)
			local xp = char:getData("xp", 0)
			local ratio = math.Clamp(xp / nextLevel, 0, 1)
			local barSize = w * math.Round(ratio, 2)
			surface.SetDrawColor(0, 47, 0, 150)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(0, 238, 0, 150)
			surface.DrawRect(0, 0, barSize, h)
			surface.SetDrawColor(0, 238, 0, 150)
			surface.DrawOutlinedRect(0, 0, w, h, 2)
			surface.SetFont("nutMediumFont")
			local levelText = "Level " .. level .. " (" .. xp .. "/" .. nextLevel .. ")"
			local textSizeX, textSizeY = surface.GetTextSize(levelText)
			surface.SetTextColor(255, 255, 255)
			surface.SetTextPos(w * 0.5 - textSizeX * 0.5, h * 0.5 - textSizeY * 0.5)
			surface.DrawText(levelText)
		end

		self.XPBar = XPBar
		nut.gui.equipment = equip
	end

	function PLUGIN:onInventoryPanelCreated(panel, inventory)
		if inventory.ShowCloseButton then inventory:ShowCloseButton(false) end
		PLUGIN:CreateEquipmentMenu(panel, inventory)
	end

	function PLUGIN:CreateMenuButtons(tabs)

		if true then end -- we have custom inventory remove this

		--this should be elsewhere but this function is run at a convenient time
		netstream.Start("nut_equipmentItemSync")
		local margin = 10
		tabs["Equipment"] = function(panel)
			local inventory = LocalPlayer():getChar():getInv()
			if inventory then
				local mainPanel = inventory:show(panel)
				local sortPanels = {}
				local totalSize = {
					x = 0,
					y = 0,
					p = 0
				}

				table.insert(sortPanels, mainPanel)
				totalSize.x = totalSize.x + mainPanel:GetWide() + margin
				totalSize.y = math.max(totalSize.y, mainPanel:GetTall())
				local px, py, pw, ph = mainPanel:GetBounds()
				local x, y = px + pw / 2 - totalSize.x / 2, py + ph / 2
				for _, panel in pairs(sortPanels) do
					panel:ShowCloseButton(true)
					panel:SetPos(x, y - panel:GetTall() / 2)
					x = x + panel:GetWide() + margin
				end

				hook.Run("onInventoryPanelCreated", panel, mainPanel)
				hook.Add("PostRenderVGUI", mainPanel, function() hook.Run("PostDrawInventory", mainPanel) end)
			end
		end
	end

	--hacky solution to errors yeeting all data, just put it in a timer and it'll only screw itself over
	function PLUGIN:InitPostEntity()
		local margin = 10
		hook.Add("CreateMenuButtons", "nutInventory", function(tabs) tabs["inv"] = nil end)
	end

	netstream.Hook("nut_updateEquipSlots", function()
		hook.Run("NutUpdateEquipSlots")
		if IsValid(nut.gui.augment) then nut.gui.augment:refreshButtons() end
		if IsValid(nut.gui.equipment) then nut.gui.equipment:refreshButtons() end
	end)
end

--debug command
nut.command.add("purgeequipment", {
	adminOnly = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])
		if IsValid(target) and target:getChar() then
			local equipTbl = target:getEquip()
			for slot, item in pairs(equipTbl) do
				target:removeEquip(slot)
			end

			local char = target:getChar()
			char:setData("equip", {})
		end
	end
})

function PLUGIN:InitializedItems()
	for k, v in pairs(nut.item.list) do
		if not v.dmg then continue end
		local ACT = {
			uid = v.uniqueID,
			name = v:getName(),
			desc = v.desc,
			attackString = "uses " .. v:getName(),
			category = "Equipment",
			costAP = v.costAP or 1,
			dmg = 0, --v.dmg,
			dmgT = v.dmgT,
			accuracy = v.accuracy or 0,
			multi = v.multi or 1,
			ammoUse = v.ammoUse or 0, --how much ammo it uses
			radius = v.radius,
			notarget = v.radius and true,
			weaponMult = 1,
			restrict = true, --if you don't put this anyone can use it
		}

		ACTS:Register(ACT)
	end
end