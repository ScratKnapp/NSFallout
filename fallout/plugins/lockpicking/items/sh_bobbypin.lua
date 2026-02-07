ITEM.name = "Bobby Pin"
ITEM.desc = "A small clip that can be used for lockpicking."
ITEM.model = "models/props_c17/tools_wrench01a.mdl"
ITEM.category = "Lockpicking"
ITEM.width = 1
ITEM.height = 1
ITEM.flag = "v"
ITEM.slot = "Lockpick"

ITEM.maxstack = 30

--gives SWEP on equip
ITEM.class = "lockpick"

ITEM.onEquip = function(item, client)
	if(item.class) then
		if (client:HasWeapon(item.class)) then
			client:StripWeapon(item.class)
		end
		
		local weapon = client:Give(item.class)

		if (IsValid(weapon)) then
			client.equip = client.equip or {}
			client.equip[item.slot] = weapon
			
			weapon.item = item.id
			
			if (item.onEquipWeapon) then
				item:onEquipWeapon(client, weapon)
			end
			
			client:EmitSound(item.equipSound or "items/ammo_pickup.wav", 80)
		end
	else
		client:EmitSound(item.equipSound or "ui_items_takeall.wav", 75, 80)
	end
end

ITEM.onEquipUn = function(item, client, test)
	if(item.class) then
		client.equip = client.equip or {}
		local weapon = client.equip[item.slot]

		if (!weapon or !IsValid(weapon)) then
			weapon = client:GetWeapon(item.class)	
		end

		if (IsValid(weapon)) then
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
		
		nut.chat.send(client, "me", "puts away " ..item:getName().. ".")
		
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
		
		--prevents equip when fallen over
		if(IsValid(item.player.nutRagdoll)) then
			client:notify("You cannot do this right now.")
			return false
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
		
		nut.chat.send(client, "me", "takes out " ..item:getName().. ".")
		
		item:setData("equip", true)
		item:onEquip(client)
		
		return false
	end,
	onCanRun = function(item)
		if(IsValid(item.entity)) then
			return false
		end
		
		if(item:getData("equip")) then
			return false
		end
	
		return true
	end
}

ITEM.functions.Unstack = {
	tip = "Take a part out.",
	icon = "icon16/delete.png",
	onRun = function(item)
		local client = item.player
		local inventory = client:getChar():getInv()
		local position = client:getItemDropPos()
		
		local stack = item:getData("Amount", 1)
		if(stack <= 1) then return false end

		client:requestString("Split", "", function(text)	
			amount = math.Clamp(tonumber(text), 1, stack - 1)
			
			item:setData("Amount", item:getData("Amount") - amount)
			local customData = item:getData("custom", {})
			
			inventory:addSmart(item.uniqueID, 1, position, {Amount = amount, custom = customData})
			
			client:EmitSound("ui_items_takeall.wav", 65, 130)
		end, 1)		

		return false
	end,
	onCanRun = function(item)
		if(item.entity) then
			return false
		end
		
		if(item:getData("Amount", 1) <= 1) then
			return false
		end
		
		return true
	end	
}

ITEM.functions.Stack = {
	tip = "Stack items of the same type.",
	icon = "icon16/add.png",
	onRun = function(item)	
		local client = item.player
		local char = client:getChar()
		local inventory = char:getInv()
		local stack = item:getData("Amount", 1)
		
		local qualities = {}
		local quality = item:getData("custom", {}).quality
		if(quality) then
			table.insert(qualities, quality)
		end
		
		local total = stack
		for k, v in pairs(inventory:getItems()) do
			if(v.id == item.id) then
				continue
			end
		
			if(v.uniqueID == item.uniqueID) then
				total = total + v:getData("Amount", 1)
				
				local qual = item:getData("custom", {}).quality
				if(qual) then
					table.insert(qualities, qual)
				end
				
				if(v.id != item.id) then
					v:remove()
				end
			end
		end
		
		local newQual = table.Random(qualities)
		
		local qualityData
		if(newQual) then
			qualityData = {quality = newQual}
		end
		
		if(total <= item.maxstack) then
			item:setData("Amount", total)
			item:setData("custom", qualityData)
		else
			local position = client:getItemDropPos()
		
			for i = 1, math.floor(total / item.maxstack) do
				timer.Simple(i/5, function()
					inventory:addSmart(item.uniqueID, 1, position, {Amount = item.maxstack})
				end)
			end
			
			local remainder = total - (item.maxstack * math.floor(total / item.maxstack))
			if(remainder > 0) then
				item:setData("Amount", remainder)
				item:setData("custom", qualityData)
			else
				return true
			end
		end
		
		client:EmitSound("ui_items_takeall.wav", 65, 60)
		
		return false
	end,
	onCanRun = function(item)
		if(item.entity) then
			return false
		end
		
		return true
	end
}

ITEM.onCombine = function(itemSelf, itemTarget)
	if(itemSelf.uniqueID == itemTarget.uniqueID) then
		local amountSelf = itemSelf:getData("Amount", 1)
		local amountTarget = itemTarget:getData("Amount", 1)

		local combined = amountSelf + amountTarget
		
		if(combined > itemSelf.maxstack) then
			itemSelf:setData("Amount", itemSelf.maxstack)
			itemTarget:setData("Amount", combined - itemSelf.maxstack)
		else
			itemTarget:remove()
			itemSelf:setData("Amount", amountSelf + amountTarget)
		end
		
		itemSelf.player:EmitSound("ui_items_takeall.wav", 65, 130)
	end
end

-- On item is dropped, Remove a weapon from the player and keep the ammo in the item.
ITEM:hook("drop", function(item)
	if (item:getData("equip")) then
		local client = item.player
	
		item:setData("equip", nil)
		
		if(item.class) then
			client.equip = client.equip or {}

			local weapon = client.equip[item.slot]
			
			if (IsValid(weapon)) then
				client:StripWeapon(item.class)
				client.equip[item.slot] = nil
				
				client:EmitSound(item.unequipSound or "items/ammo_pickup.wav", 80)
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
			surface.DrawRect(14, h - 14, 8, 8)
		end
		
		draw.SimpleText((item.getName and item:getName()) or item.name, "DermaDefault", w * 0.5, h * 0.2, Color(200,200,200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	
		local quantity = item:getData("Amount", 1)

		if (quantity > 1) then
			draw.SimpleText(quantity, "DermaDefault", w - 12, h - 14, Color(50,50,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
		end
	end
end