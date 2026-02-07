local PLUGIN = PLUGIN
local playerMeta = FindMetaTable("Player")
--formar of "equip" data table
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
	if equipTbl[slot] then return false, "Slot full." end
	return true
end

if SERVER then
	function PLUGIN:PlayerLoadedChar(client)
		local equipTbl = client:getEquip()
		for slot, itemID in pairs(equipTbl) do
			local item = nut.item.instances[itemID]
			if not item then nut.item.loadItemByID(itemID) end
		end
	end

	--equip something
	function playerMeta:addEquip(slot, item)
		local canEquip, error = self:canEquip(slot, item)
		if not canEquip then return false end
		local char = self:getChar()
		local equipTbl = self:getEquip()
		equipTbl[slot] = item.id
		char:setData("equip", equipTbl)
		item:removeFromInventory(true) --remove the bird from the inventory since it's delivering a message.
		--remove item from inventory
		--add item to slot
		--network the GUI updates to player
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
			x, y = inventory:findFreePosition(item)
			if x and y then
				item:setData("x", x)
				item:setData("y", y)
				inventory:addItem(item)
			else
				item:spawn(position)
			end
		end

		local equipTbl = self:getEquip()
		equipTbl[slot] = nil
		-- network
		-- nut_updateEquipSlots
		local char = self:getChar()
		netstream.Start(self, "nut_updateEquipSlots")
		--network the GUI updates to player
		return true
	end
end

--debug command
nut.command.add("unequipalltest", {
	--adminOnly = true,
	syntax = "<string command>",
	onRun = function(client, arguments)
		local equipTbl = client:getEquip()
		for slot, item in pairs(equipTbl) do
			client:removeEquip(slot)
		end
	end
})