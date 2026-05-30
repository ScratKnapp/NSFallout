PLUGIN.name = "Simple Inv UI"
PLUGIN.author = "Cheesenut"
PLUGIN.desc = "Adds a simple interface for list inventories."
local INVENTORY_TYPE_ID = "simple"
if CLIENT then
	function PLUGIN:CreateInventoryPanel(inventory, parent)
		if inventory.typeID ~= INVENTORY_TYPE_ID then return end
		-- Use vgui.Create rather than parent:Add: the inventory `show` flow
		-- (e.g. gridstorage's `localInv:show()`) passes no parent, so
		-- parent:Add would crash on a nil indexee. vgui.Create accepts nil
		-- and just makes a top-level panel — same convention as the sibling
		-- gridinvui plugin's CreateInventoryPanel hook.
		local panel = vgui.Create("nutListInventory", parent)
		panel:setInventory(inventory)
		panel:Center()
		return panel
	end

	function PLUGIN:getItemStackKey(item)
		local elements = {}
		if nut.item.list[item.uniqueID].PreventStacks then return item.uniqueID .. item:getID() end
		for key, value in SortedPairs(item.data) do
			elements[#elements + 1] = key
			elements[#elements + 1] = value
		end
		return item.uniqueID .. pon.encode(elements)
	end

	function PLUGIN:getItemStacks(inventory)
		local stacks = {}
		local stack, key
		for _, item in SortedPairs(inventory:getItems()) do
			key = self:getItemStackKey(item)
			stack = stacks[key] or {}
			stack[#stack + 1] = item
			stacks[key] = stack
		end
		return stacks
	end
end