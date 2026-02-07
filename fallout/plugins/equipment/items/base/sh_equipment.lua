ITEM.name = "Equipment Base"
ITEM.desc = ""
ITEM.model = "models/props_junk/gnome.mdl"
ITEM.category = "Equipment"
ITEM.width = 1
ITEM.height = 1
ITEM.flag = "v"
ITEM.slot = "Default"

--gives SWEP on equip
--ITEM.class = "weapon_pistol"

--scrapping
--ITEM.multiChance = 10

--[[
ITEM.salvage = {
	["j_scrap_plastics"] = 1
}
--]]

--[[
ITEM.faction = {

}
--]]

--[[
ITEM.armor = 0
ITEM.dmg = {
	["Crush"] = 5,
}
ITEM.scaling = {
	["str"] = 0.2,
}
--]]

--[[
ITEM.augBuffs = {
	["maxHealth"] = 1,
	["runSpeed"] = 1,
	["jumpPower"] = 1,
}
--]]

--[[
ITEM.reqStats = {
	["str"] = 5,
}
--]]

ITEM.customizable = {
	["name"] = true,
	["desc"] = true,
	["model"] = true,
	["modelScale"] = true,
	["modelColor"] = true,
	["material"] = true,
	["color"] = true,
	["img"] = true,
	
	["dmg"] = true,
	["res"] = true,
	["resEffect"] = true,
	["amp"] = true,
	["attrib"] = true,
	["skills"] = true,
	
	["accuracy"] = true,
	["evasion"] = true,
	["critC"] = true,
	["critM"] = true,
	["critBC"] = true,
	["critBM"] = true,
	
	["armor"] = true,
	["scale"] = true,
}

ITEM.updateSWEP = function(item, client, weapon)
	if(nut.plugin.list["customization"]) then
		nut.plugin.list["customization"]:updateSWEP(client, item, weapon)
	end
end

ITEM.buffRefresh = function(item, player)
	local client = player
	if(!client) then
		client = item.player
		
		if(!client) then return end
	end

	local char = client:getChar()
	if(!char) then return end

	local customBoosts = item:getData("attrib", item.attrib or {})
	for k, v in pairs(customBoosts) do
		char:addBoost(item:getName(), k, v)
	end
	
	local customSkillBoosts = item:getData("skill", item.skill or {})
	for k, v in pairs(customSkillBoosts) do
		char:addSkillBoost(item:getName(), k, v)
	end
end

ITEM.onEquip = function(item, client)
	local char = client:getChar()

	if(item.class) then
		if (client:HasWeapon(item.class)) then
			client:StripWeapon(item.class)
		end
		
		local weapon = client:Give(item.class)

		if (IsValid(weapon)) then
			item:updateSWEP(client, weapon)
			
			client.equip = client.equip or {}

			weapon:SetClip1(item:getData("ammo", 0))
			weapon.item = item.id
			client.equip[item.slot] = weapon
			
			if (item.onEquipWeapon) then
				item:onEquipWeapon(client, weapon)
			end
			
			client:EmitSound(item.equipSound or "items/ammo_pickup.wav", 80)
		end
	else
		client:EmitSound(item.equipSound or "ui_items_takeall.wav", 75, 80)
	end
	
	--buffs the specified attributes.
	if (item:getData("attrib", item.attrib) or item:getData("skill", item.skill)) then
		item:buffRefresh(client)
	end
	
	if(item.augBuffs) then
		local playerBuffs = client:buffsFromEquip()
			
		--jumping power
		client:SetJumpPower(playerBuffs.jumpPower)
		
		--runspeed
		client:SetRunSpeed(playerBuffs.runSpeed)
		
		--health
		client:SetMaxHealth(playerBuffs.maxHealth)
		client:SetHealth(playerBuffs.maxHealth)
	end
end

ITEM.onEquipUn = function(item, client, test)
	local char = client:getChar()

	if(item.class) then
		client.equip = client.equip or {}
	
		local weapon = client.equip[item.slot]

		if (!weapon or !IsValid(weapon)) then
			weapon = client:GetWeapon(item.class)	
		end

		if (IsValid(weapon)) then
			item:setData("ammo", weapon:Clip1())
		
			client:StripWeapon(item.class)
		else
			print(Format("[Nutscript] Weapon %s does not exist!", item.class))
		end
		
		client.equip[item.slot] = nil
		
		if (item.onUnequipWeapon) then
			item:onUnequipWeapon(client, weapon)
		end
		
		client:EmitSound(item.unequipSound or "items/ammo_pickup.wav", 80)
	else
		client:EmitSound(item.unequipSound or "npc/roller/blade_in.wav", 75, 80)
	end
	
	--removes the buffs
	local customBoosts = item:getData("attrib", item.attrib or {})
	if (!table.IsEmpty(customBoosts)) then
		for k, v in pairs(customBoosts) do
			char:removeBoost(item:getName(), k)
		end
	end
	
	--removes the buffs
	local customSkillBoosts = item:getData("skill", item.skill or {})
	if (!table.IsEmpty(customSkillBoosts)) then
		for k, v in pairs(customSkillBoosts) do
			char:removeSkillBoost(item:getName(), k)
		end
	end
	
	if(item.augBuffs) then
		local playerBuffs = client:buffsFromEquip()
			
		--jumping power
		client:SetJumpPower(playerBuffs.jumpPower)
		
		--runspeed
		client:SetRunSpeed(playerBuffs.runSpeed)
		
		--health
		client:SetMaxHealth(playerBuffs.maxHealth)
		client:SetHealth(playerBuffs.maxHealth)
	end
end
--
-- On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Unequip",
	icon = "icon16/cross.png",
	--sound = "npc/roller/blade_in.wav",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
	
		if(IsValid(client.nutRagdoll)) then
			client:notify("You cannot do this right now.")
			return false
		end
		
		item:setData("equip", false)
		
		--nut.chat.send(client, "me", "unequips " ..item:getName().. ".")
		
		item:onEquipUn(client)

		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity) and item:getData("equip") == true)
	end
}

-- On player eqipped the item, Gives a weapon to player and load the ammo data from the item.
ITEM.functions.Equip = {
	name = "Equip",
	icon = "icon16/tick.png",
	--sound = "npc/roller/blade_in.wav",
	onRun = function(item)		
		local client = item.player
		local char = client:getChar()
		
		if(item.trait) then
			if(!client:hasTrait(item.trait)) then
				client:notify("You do not have the trait to equip this.")
				return false
			end
		end
		
		--prevents equip when fallen over
		if(IsValid(item.player.nutRagdoll)) then
			client:notify("You cannot do this right now.")
			return false
		end
		
		if(item.faction) then
			if(char:getFaction() != item.faction) then
				client:notify("Your faction cannot equip this.")
				return false
			end
		end
		
		if(item.equipLoad) then
			local load = client:getEquipLoad()
			local loadMax = client:getMaxLoad()
			
			if(load + item.equipLoad > loadMax) then
				client:notify("Not enough cybernetic load capacity.")
				return false
			end
		end
		
		local items = client:getChar():getInv():getItems()

		for k, v in pairs(items) do --checks if they have that slot filled already
			if (v.id != item.id) then
				local itemTable = nut.item.instances[v.id]
				
				if (!itemTable) then
					--client:notifyLocalized("tellAdmin", "wid!xt")

					return false
				else
					if ((itemTable:getData("equip") and itemTable.slot) and (string.lower(itemTable:getData("customSlot", itemTable.slot)) == string.lower(item:getData("customSlot", item.slot)))) then
						client:notify("Your " ..item.slot.. " slot is already filled.")

						return false
					end
				end
			end
		end
		
		local reqStats = item:getData("reqStats", item.reqStats)
		if(reqStats) then
			for k, v in pairs(reqStats) do
				if(char:getAttrib(k, 0) < v) then
					local attrib = nut.attribs.list[k] or {}
					local attribName = attrib.name or "Unknown"
				
					client:notify("You need " ..v.. " " ..attribName.. " to equip this.")
					return false
				end
			end
		end
		
		--nut.chat.send(client, "me", "equips " ..item:getName().. ".")
		
		if(item.specialSlot) then
			client:addEquip(item.specialSlot, item)
		else
			item:setData("equip", true)
			item:onEquip(client)
		end
		
		return false
	end,
	onCanRun = function(item)
		if(IsValid(item.entity)) then
			return false
		end
		
		if(item:getData("equip")) then
			return false
		end
		
		if(item.specialSlot) then
			return false
		end
	
		return true
	end
}

ITEM.functions.Unload = {
	name = "Unload",
	icon = "icon16/arrow_out.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
	
		nut.plugin.list["fancyammo"]:EjectAmmo(client, item)

		return false
	end,
	onCanRun = function(item)
		local client = item.player

		local curMag = item:getData("currentMag", {})
		local curID, curAmt = curMag[1], curMag[2]
		
		if(curID and curAmt) then
			return true
		end
	
		return false
	end
}

ITEM.functions.EquipSlot = {
	name = "Equip",
	icon = "icon16/contrast.png",
	isMulti = true,
	multiOptions = function(item, client)
		local targets = {}
		
		local inventory = client:getChar():getInv()

		local slots
		if(istable(item.specialSlot)) then
			slots = item.specialSlot
		else
			slots = {item.specialSlot}
		end

		for k, v in pairs(slots) do
			local newAbs = {
				name = v,
				data = v
			}
			
			table.insert(targets, newAbs)
		end
		
		return targets
	end,
	onRun = function(item, data)
		if(!data) then return false end
	
		local client = item.player
		local char = client:getChar()
	
		if(item.trait) then
			if(!client:hasTrait(item.trait)) then
				client:notify("You do not have the trait to equip this.")
				return false
			end
		end
		
		if(item.faction) then
			if(char:getFaction() != item.faction) then
				client:notify("Your faction cannot equip this.")
				return false
			end
		end
		
		if(item.equipLoad) then
			local load = client:getEquipLoad()
			local loadMax = client:getMaxLoad()
			
			if(load + item.equipLoad > loadMax) then
				client:notify("Not enough cybernetic load capacity.")
				return false
			end
		end
		
		local reqStats = item:getData("reqStats", item.reqStats)
		if(reqStats) then
			for k, v in pairs(reqStats) do
				if(char:getAttrib(k, 0) < v) then
					local attrib = nut.attribs.list[k] or {}
					local attribName = attrib.name or "Unknown"
				
					client:notify("You need " ..v.. " " ..attribName.. " to equip this.")
					return false
				end
			end
		end
	
		--prevents equip when fallen over
		if(IsValid(item.player.nutRagdoll)) then
			client:notify("You cannot do this right now.")
			return false
		end
		
		local items = client:getChar():getInv():getItems()

		if(!client:canEquip(data, item)) then
			client:notify("Your " ..data.. " slot is already filled.")
			return false
		end
	
		--nut.chat.send(client, "me", "equips " ..item:getName().. ".")
		
		client:addEquip(data, item)
	
		return false
	end,
	onCanRun = function(item)
		local client = item.player
		
		if(IsValid(item.entity)) then
			return false
		end
		
		if(item.specialSlot) then
			return true
		end
	end
}

ITEM.functions.RemoveAttach = {
	name = "Attachments",
	icon = "icon16/contrast.png",
	isMulti = true,
	multiOptions = function(item, client)
		local targets = {}
		
		local inventory = client:getChar():getInv()

		local upgradeSlots = item:getData("upgradeSlots", {})

		for k, v in pairs(upgradeSlots) do
			local itemTbl = nut.item.list[v]
			if(itemTbl) then
				local name = itemTbl.getName and itemTbl:getName() or itemTbl.name
			
				local newAbs = {
					name = name,
					data = {k,v}
				}
				
				table.insert(targets, newAbs)
			end
		end
		
		return targets
	end,
	onRun = function(item, data)
		if(!data) then return false end
	
		local upgradeSlot = data[1]
		local upgradeUID = data[2]
	
		local client = item.player
		local char = client:getChar()
		local inventory = char:getInv()
	
		local upgradeItem = nut.item.list[upgradeUID]
		if(upgradeItem) then
			inventory:addSmart(upgradeUID)
			upgradeItem:upgrade(upgradeItem, item, true)
			
			local upgradeSlots = item:getData("upgradeSlots", {})
			upgradeSlots[upgradeSlot] = nil
			item:setData("upgradeSlots", upgradeSlots)
		end
	
		return false
	end,
	onCanRun = function(item)
		local client = item.player
		
		if(IsValid(item.entity)) then
			return false
		end
		
		local upgradeSlots = item:getData("upgradeSlots")
		if(upgradeSlots and !table.IsEmpty(upgradeSlots)) then
			return true
		end
	end
}

ITEM.functions.InstallForward = {
	name = "Install Forward",
	icon = "icon16/contrast.png",
	isMulti = true,
	multiOptions = function(item, client)
		local targets = {}
		
		local inventory = client:getChar():getInv()

		local slots
		if(istable(item.specialSlot)) then
			slots = item.specialSlot
		else
			slots = {item.specialSlot}
		end

		for k, v in pairs(slots) do
			local newAbs = {
				name = v,
				data = v
			}
			
			table.insert(targets, newAbs)
		end
		
		return targets
	end,
	onRun = function(item, data)
		if(!data) then return false end
	
		local client = item.player
	
		if(item.trait) then
			if(!client:hasTrait(item.trait)) then
				client:notify("You do not have the trait to do this.")
				return false
			end
		end

		local trace = client:GetEyeTraceNoCursor()
		local target = trace.Entity

		if(!IsValid(target) or !target:IsPlayer()) then
			client:notify("Look at a valid target.")
			return false
		end

		if(!item.pendingInstall or item.pendingInstall < CurTime()) then --so you can't spam people
			item.pendingInstall = CurTime() + 30
			
			target:requestQuery(client:Name().. " wants to install " ..item:getName().. " on you.", "Installation", function(text)
				item.pendingInstall = nil
				
				local targetChar = target:getChar()
				
				--prevents equip when fallen over
				if(IsValid(client.nutRagdoll)) then
					client:notify("You cannot do this right now.")
					return false
				end
				
				if(item.faction) then
					if(targetChar:getFaction() != item.faction) then
						client:notify("Their faction cannot equip this.")
						return false
					end
				end
				
				if(item.equipLoad) then
					local load = target:getEquipLoad()
					local loadMax = target:getMaxLoad()
					
					if(load + item.equipLoad > loadMax) then
						client:notify("Not enough cybernetic load capacity.")
						return false
					end
				end
				
				local items = targetChar:getInv():getItems()

				if(!target:canEquip(data, item)) then
					client:notify("Their " ..data.. " slot is already filled.")
					return false
				end
			
				nut.chat.send(client, "me", "installs " ..item:getName().. ".")
				
				target:addEquip(data, item)
			end)
		else
			client:notify("Item is already pending install.")
		end
		
		return false
	end,
	onCanRun = function(item)
		local client = item.player
		
		if(IsValid(item.entity)) then
			return false
		end
		
		if(!item.specialSlot) then
			return false
		end
		
		if(!item.trait) then
			return false
		end
		
		return true
	end
}


ITEM.functions.EjectAmmo = {
	tip = "Eject Ammo",
	icon = "icon16/arrow_out.png",
	--sound = "npc/manhack/grind"..math.random(1,5)..".wav",
	onRun = function(item)
		local client = item.player
	
		PLUGIN:EjectAmmo(client, item)
		
		client:EmitSound("items/ammo_pickup.wav", 75)
		
		return false
	end,
	onCanRun = function(item)
		if(!item.salvage) then
			return false
		end
		
		if(item:getData("equip")) then
			return false
		end
		
		local client = item.player
		return client:getChar():hasFlags("q") or client:getChar():getInv():getFirstItemOfType("kit_salvager")
	end
}

ITEM.functions.Inspect = {
	name = "Inspect",
	tip = "Inspect this item",
	icon = "icon16/picture.png",
	onClick = function(item)
		local frame = vgui.Create("DFrame")
		frame:SetSize(540, 680)
		frame:SetTitle(item.name)
		frame:MakePopup()
		frame:Center()

		frame.html = frame:Add("DHTML")
		frame.html:Dock(FILL)
		
		local customData = item:getData("custom", {})
		
		local imageCode = [[<img src = "]]..customData.img..[["/>]]
		
		frame.html:SetHTML([[<html><body style="background-color: #000000; color: #282B2D; font-family: 'Book Antiqua', Palatino, 'Palatino Linotype', 'Palatino LT STD', Georgia, serif; font-size 16px; text-align: justify;">]]..imageCode..[[</body></html>]])
	end,
	onRun = function(item)
		return false
	end,
	onCanRun = function(item)
		local customData = item:getData("custom", {})
	
		if(!customData.img) then
			return false
		end
		
		return true
	end
}

ITEM.functions.Scrap = {
	tip = "Scrap this item",
	icon = "icon16/wrench.png",
	--sound = "npc/manhack/grind"..math.random(1,5)..".wav",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
		local inv = char:getInv()
		local position = client:getItemDropPos()
		local scrap
		local amt
		
		client:requestQuery("Are you sure you want to scrap this item?", "Scrap", function(text) --confirmation message
			local roll = math.random(1,100)
			local chance = item.multiChance or 0
			local multi = 1
			
			if(TRAITS and client:hasTrait("scrapper")) then --trait increases chance of multi result
				chance = chance + 10
			end
			
			if(roll < chance) then
				multi = 2
			end
			
			if(istable(item.salvage)) then
				for i = 1, multi do
					amt, scrap = table.Random(item.salvage)
					
					local itemTable = nut.item.list[scrap]
					if(itemTable) then
						if(itemTable.maxstack) then
							timer.Simple(i/2, function()
								inv:addSmart(scrap, 1, position, {Amount = amt})
							end)
						else
							inv:addSmart(scrap, amt, position)
						end
					end
				end
			end
			
			local customBoosts = item:getData("attrib", item.attrib or {})
			if (!table.IsEmpty(customBoosts)) then			
				for k, v in pairs(customBoosts) do
					client:getChar():removeBoost(item:getName(), k)
				end
			end
			
			local customSkillBoosts = item:getData("skill", item.skill or {})
			if (!table.IsEmpty(customSkillBoosts)) then			
				for k, v in pairs(customSkillBoosts) do
					client:getChar():removeSkillBoost(item:getName(), k)
				end
			end
			
			--Randomized sounds don't work up there so I had to do this.
			client:EmitSound("npc/manhack/grind"..math.random(1,5)..".wav", 70, math.random(85,105))
					
			item:remove()
		end)
		
		return false
	end,
	onCanRun = function(item)
		if(!item.salvage) then
			return false
		end
		
		local client = item.player
		return client:getChar():hasFlags("q") or client:getChar():getInv():getFirstItemOfType("kit_salvager")
	end
}

ITEM.functions.Repair = {
	name = "Repair",
	tip = "useTip",
	icon = "icon16/wrench_orange.png",
	onRun = function(item)
		local inventory = item.player:getChar():getInv()
		local kit = inventory:getFirstItemOfType("repair_kit")
		kit:remove()
		
		local customData = item:getData("custom", {})
		customData.dura = item:getData("maxDura", 7000)
		item:setData("custom", customData)
		
		item.player:EmitSound("doors/vent_open1.wav", 50, 140)
		
		return false
	end,
	onCanRun = function(item)
		local client = item.player
		local inventory = client:getChar():getInv()
	
		if(!item.dura) then return false end
	
		local kit = inventory:getFirstItemOfType("repair_kit")
		if(!kit) then
			return false
		end
		
		local customData = item:getData("custom", {})
		if(customData.dura) then
			local maxDura = item:getData("maxDura", 7000)
		
			if(customData.dura < maxDura) then
				return true
			end
		else
			return false
		end
	end
}

ITEM.functions.Custom = {
	name = "Customize",
	tip = "Customize this item",
	icon = "icon16/wrench.png",
	onRun = function(item)		
		nut.plugin.list["customization"]:startCustom(item.player, item)
		
		return false
	end,
	
	onCanRun = function(item)
		local client = item.player
		return client:getChar():hasFlags("1")
	end
}

ITEM.functions.CustomW = {
	name = "Customize Weapon",
	tip = "Customize this item",
	icon = "icon16/wrench.png",
	onRun = function(item)		
		nut.plugin.list["customization"]:startCustomWeap(item.player, item)
		
		return false
	end,
	
	onCanRun = function(item)
		local client = item.player
		
		--only for weapons
		if(!item.class) then
			return false
		end
		
		return client:getChar():hasFlags("1")
	end
}

ITEM.functions.Clone = {
	name = "Clone",
	tip = "Clone this item",
	icon = "icon16/wrench.png",
	onRun = function(item)
		local client = item.player	
	
		client:requestQuery("Are you sure you want to clone this item?", "Clone", function(text)
			local inventory = client:getChar():getInv()
			local data = item.data
			data.x = nil
			data.y = nil
			data.equip = nil

			if(!inventory:add(item.uniqueID, 1, data)) then
				client:notify("Inventory is full")
			end
		end)
		return false
	end,
	onCanRun = function(item)
		local client = item.player
		return client:getChar():hasFlags("1")
	end
}

-- On item is dropped, Remove a weapon from the player and keep the ammo in the item.
ITEM:hook("drop", function(item)
	if (item:getData("equip")) then
		local client = item.player
	
		item:setData("equip", nil)
		
		if(item.class) then
			client.equip = client.equip or {}

			local weapon = client.equip[item.slot]
			
			if (IsValid(weapon)) then
				item:setData("ammo", weapon:Clip1())
				
				client:StripWeapon(item.class)
				client.equip[item.slot] = nil
				
				client:EmitSound(item.unequipSound or "items/ammo_pickup.wav", 80)
			end
		end
		
		local customBoosts = item:getData("attrib", item.attrib or {})
		if (!table.IsEmpty(customBoosts)) then
			for k, v in pairs(customBoosts) do
				client:getChar():removeBoost(item:getName(), k)
			end
		end
		
		local customSkillBoosts = item:getData("skill", item.skill or {})
		if (!table.IsEmpty(customSkillBoosts)) then
			for k, v in pairs(customSkillBoosts) do
				client:getChar():removeSkillBoost(item:getName(), k)
			end
		end
	end
end)

--prevents equipped items from being transferred
function ITEM:onCanBeTransfered(oldInventory, newInventory)
	if (newInventory and self:getData("equip")) then
		return false
	end
	
	local client = self.player
	if(client and IsValid(client.nutRagdoll)) then
		return false
	end

	return true
end

function ITEM:getName()
	local name = self.name
	
	local customData = self:getData("custom", {})
	if(customData.name) then
		name = customData.name
	end
	
	return name
end

function ITEM:getDesc(partial)
	local desc = self.desc
	local client = self.player

	local customData = self:getData("custom", {})
	if(customData.desc) then
		desc = customData.desc
	end

	if(!partial) then
		if(self.ammoString) then
			desc = desc .. "\nThis weapon uses " ..self.ammoString.. "."
		elseif(self.class) then
			local swep = weapons.Get(self.class)
			if(swep) then
				if(nut.ammo and nut.ammo.types and nut.ammo.types[swep.Primary.Ammo]) then
					desc = desc .. "\nThis weapon uses " ..nut.ammo.types[swep.Primary.Ammo].name.. "."
				end
			end
		end
	
		local slot = self:getData("customSlot", self.slot)
		if(slot and slot != "Default") then
			slot = string.upper(string.sub(slot, 0, 1))..string.sub(slot, 2)
		
			desc = desc .. "\nSlot: " ..slot.. "."
		end
		
		local specialSlot = self.specialSlot
		if(specialSlot) then
			if(istable(specialSlot)) then
				local slotString = ""
			
				for k, v in pairs(specialSlot) do
					slotString = slotString..v

					if(k < #specialSlot) then
						slotString = slotString.. ", "
					end
				end
				
				desc = desc .. "\nSlot: " ..slotString.. "."
			else
				desc = desc .. "\nSlot: " ..specialSlot.. "."
			end
		end
			
		if(customData.quality) then
			desc = desc .. "\nQuality: " ..customData.quality
		end
		
		local boostsAttrib = self:getData("attrib", self.attrib)
		local boostsSkill = self:getData("skill", self.skill)
		if(
		(boostsAttrib and !table.IsEmpty(boostsAttrib)) or 
		(boostsSkill and !table.IsEmpty(boostsSkill))
		) then
			desc = desc .. "\n\n<color=50,200,50>Bonuses</color>"
			
			for k, v in pairs(boostsAttrib or {}) do
				if(v != 0) then
					desc = desc .. "\n " ..((nut.attribs.list[k] and nut.attribs.list[k].name) or k).. ": " ..v
				end
			end
			
			for k, v in pairs(boostsSkill or {}) do
				if(v != 0) then
					desc = desc .. "\n " ..(nut.skills.list[k] and nut.skills.list[k].name).. ": " ..v
				end
			end
		end
		
		if(nut.config.get("combatDamageDisplay") or client:IsAdmin()) then
			local dmg = self:getData("dmg", self.dmg)
			local multi = self.multi
			local armor = self:getData("armor", self.armor)
			local scaling = self:getData("scale", self.scaling)
			
			local critC = self:getData("critC", self.critC)
			local critM = self:getData("critM", self.critM)
			
			local evasion = self:getData("evasion", self.evasion)
			local accuracy = self:getData("accuracy", self.accuracy)
			local critBC = self:getData("critBC", self.critBC) --bonus chance
			local critBM = self:getData("critBM", self.critBM) --bonus multiplier

			if(dmg and !table.IsEmpty(dmg)) then
				desc = desc .. "\n\n<color=50,200,50>Damage</color>"
				
				for dmgT, dmgV in pairs(dmg) do
					if(dmgV != 0) then
						desc = desc .. "\n " ..dmgV.. " " ..dmgT.. " Damage."
					
						if(multi) then
							desc = desc.. " [x" ..multi.. "]"
						end
					end
				end
			end
			
			if(critC) then
				desc = desc.. "\n Weapon Crit Chance: " ..critC.. "."
			end
			
			if(critM) then
				desc = desc.. "\n Weapon Crit Multiplier: " ..critM.. "."
			end
			
			if(critBC) then
				desc = desc.. "\n Bonus Crit Chance: " ..critBC.. "."
			end
			
			if(critBM) then
				desc = desc.. "\n Bonus Crit Multiplier: " ..critBM.. "."
			end
			
			if(evasion) then
				desc = desc.. "\n Evasion Bonus: " ..evasion.. "."
			end
			
			if(accuracy) then
				desc = desc.. "\n Accuracy Bonus: " ..accuracy.. "."
			end
			
			if(armor) then
				if(istable(armor)) then
					desc = desc.. "\n\nPhysical Armor:"
				
					for k, v in pairs(armor) do
						desc = desc.. "\n   " ..k.. ": " ..v.. "."
					end
				else
					desc = desc.. "\n\nPhysical Armor: " ..armor.. "."
				end
			end
			
			local res = self:getData("res", self.res)
			if(res and !table.IsEmpty(res)) then --no bonuses means no need for bonuses in the desc
				desc = desc.. "\n\n<color=50,200,50>Resistances</color>"
				
				local combatPlugin = nut.plugin.list["combat"]
				
				for k, v in pairs(res) do
					if(v != 0) then
						local dmgType = (combatPlugin and combatPlugin.dmgTypes[k])
						
						local effect = EFFS.effects[k]
						
						if(dmgType) then
							desc = desc.. "\n " ..dmgType.name.. " Resistance: " ..v.. "%."
						elseif(effect) then
							desc = desc.. "\n " ..effect.name.. " Resistance: " ..v.. "%."
						end
					end
				end
			end	
			
			local amp = self:getData("amp", self.amp)
			if(amp and !table.IsEmpty(amp)) then --no bonuses means no need for bonuses in the desc
				desc = desc.. "\n\n<color=50,200,50>Amplifications</color>"
				
				local combatPlugin = nut.plugin.list["combat"]
				
				for k, v in pairs(amp) do
					if(v != 0) then
						local dmgType = (combatPlugin and combatPlugin.dmgTypes[k])
						if(dmgType) then
							desc = desc.. "\n " ..dmgType.name.. " Amplification: " ..v.. "%."
						end
					end
				end
			end
		end
		
		local reqStats = self:getData("reqStats", self.reqStats)
		if(reqStats) then --no bonuses means no need for bonuses in the desc
			desc = desc.. "\n\n<color=50,200,50>Requirements</color>"
			
			local combatPlugin = nut.plugin.list["combat"]
			
			for k, v in pairs(reqStats) do
				local attrib = nut.attribs.list[k] or {}
				local attribName = attrib.name or "Unknown"
			
				desc = desc.. "\n " ..attribName.. ": " ..v.. "."
			end
		end
		
		if(self.magSize) then
			local curMag = self:getData("currentMag", {})
			local curUID, curAmt = curMag[1], curMag[2]
			if(curUID and curAmt and curAmt > 0) then
				local ammoItem = nut.item.list[curUID]
				
				if(ammoItem) then
					desc = desc.. "\n\n<color=50,200,50>Ammo</color>"
					desc = desc.. "\n " ..curAmt.. "x " ..ammoItem.dmgT.."."
				end
			end
		end
		
		if(self.durability) then
			local dura = self:getData("dura", self.durability) or 0
			local maxDura = self.durability
			local percent = math.Round((dura/maxDura)*100)
			
			desc = desc.. "\n Durability: " ..percent.. "%"
		end
		
		local equipLoad = self:getData("equipLoad", self.equipLoad)
		if(equipLoad) then
			desc = desc.. "\n Cybernetic Load: " ..equipLoad.. "."
		end
		
		local upgradeSlots = self:getData("upgradeSlots")
		if(upgradeSlots and !table.IsEmpty(upgradeSlots)) then
			desc = desc.. "\n\n<color=50,200,50>Upgrades</color>"

			for k, v in pairs(upgradeSlots) do
				local itemTbl = nut.item.list[v]
				if(itemTbl) then
					local name = itemTbl.getName and itemTbl:getName() or itemTbl.name
				
					desc = desc.. "\n   " ..name.. "."
				end
			end
		end
	end
	
	if(CLIENT) then
		local edited = self:getData("edited")
		if(LocalPlayer():IsAdmin() and edited) then
			desc = desc.. "\nLast edited by " ..edited.. "."
		end
	end
	
	return desc
end

function ITEM:onGetDropModel()
	local model = self.model
	
	local customData = self:getData("custom", {})
	if(customData.model) then
		model = customData.model
	end
	
	return Format(model)
end

function ITEM:onSave()
	if(self.class) then
		local weapon = self.player:GetWeapon(self.class)

		if (IsValid(weapon)) then
			self:setData("ammo", weapon:Clip1())
		end
	end
end

function ITEM:onLoadout()
	local client = self.player

	if(self:getData("equip")) then
		self:onEquip(client)
	end
	
	self:sync()
end

-- Inventory drawing
if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		if (item:getData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
		
	function ITEM:DrawWorldModel(entity)
		if (!entity.WElements) then 
			entity:DrawModel()
			return
		end
		
		if (!entity.wRenderOrder) then
			entity.wRenderOrder = {}

			for k, v in pairs(entity.WElements) do
				if (v.type == "Model") then
					table.insert(entity.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(entity.wRenderOrder, k)
				end
			end
		end
		
		// when the weapon is dropped
		bone_ent = entity

		for k, name in pairs(entity.wRenderOrder) do
		
			local v = entity.WElements[name]
			if (!v) then entity.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( entity.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( entity.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end

			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				model:SetAngles(entity:GetAngles())
				
				//model:SetModelScale(v.size)
				--[[
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				--]]
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end
	
	function ITEM:GetBoneOrientation( basetab, tab, ent, bone_override )
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			local v = basetab[tab.rel]
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )

			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end

			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			--[[
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r // Fixes mirrored models
			end
			--]]
		
		end
		
		return pos, ang
	end

	function ITEM:CreateModels( tab, entity )
		if (!tab) then return end
		
		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				if(IsValid(v.modelEnt)) then 
					v.modelEnt:Remove()
				end

				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)

				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(entity:GetPos())
					v.modelEnt:SetAngles(entity:GetAngles())
					v.modelEnt:SetParent(entity)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function ITEM:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			// !! WORKAROUND !! //
			// We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			// !! ----------- !! //
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				// !! WORKAROUND !! //
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				// !! ----------- !! //
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function ITEM:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end
	
	// Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	// Does not copy entities of course, only copies their reference.
	// WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) // recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
	function ITEM:drawEntity(entity)
		if (!self.WElements) then 
			entity:DrawModel()
			return
		end
	
		if(!entity.WElementGenerated) then
			entity.WElements = table.FullCopy(self.WElements)
			self:CreateModels(entity.WElements, entity) // create worldmodels
			
			entity.WElementGenerated = true
		else
			self:DrawWorldModel(entity)
			entity:DrawModel()
		end
	end
end