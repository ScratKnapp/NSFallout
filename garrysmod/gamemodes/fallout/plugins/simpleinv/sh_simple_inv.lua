local SimpleInv = nut.Inventory:extend("SimpleInv")
local MAX_WEIGHT = 50
-- Useful access rules:
local function CanAccessInventoryIfCharacterIsOwner(inventory, action, context)
	local ownerID = inventory:getData("char")
	local client = context.client
	if table.HasValue(client.nutCharList, ownerID) then return true end
end


function GET_ITEM_WEIGHT(item)
return  type(item.weight) == "function" and item:weight(item) or item.weight or 1
end


local function CanAddItemIfNotWeightRestricted(inventory, action, context)
	if action ~= "add" then return end
	if context.forced then return true end
	local weight = inventory:getWeight()
	local maxWeight = inventory:getMaxWeight()
	local itemWeight = type(context.item.weight) == "function" and context.item:weight(context.item) or context.item.weight or 1
	if weight + (itemWeight) > maxWeight then return false, "noFit" end
	return true
end

function SimpleInv:configure()
	if SERVER then
		self:addAccessRule(CanAddItemIfNotWeightRestricted)
		self:addAccessRule(CanAccessInventoryIfCharacterIsOwner)
	end
end

if SERVER then
	function SimpleInv:add(itemTypeOrItem, quantity, forced)
		-- Validate that quantity is positive and itemType is valid.
		quantity = quantity or 1
		assert(isnumber(quantity), "quantity must be a number")
		local d = deferred.new()
		if quantity <= 0 then return d:reject("quantity must be positive") end
		-- Get the table for the item type.
		local item, justAddDirectly
		if nut.item.isItem(itemTypeOrItem) then
			item = itemTypeOrItem
			quantity = 1
			justAddDirectly = true
		else
			item = nut.item.list[itemTypeOrItem]
		end

		if not item then
			return d:resolve({
				error = "invalid item type"
			})
		end

		-- Permission check adding the item(s).
		local context = {
			item = item,
			forced = forced,
			quantity = quantity
		}

		local canAccess, reason = self:canAccess("add", context)
		if not canAccess then return d:reject(reason or "noAccess") end
		-- If given an item instance, there's no need for a new instance.
		if justAddDirectly then
			self:addItem(item)
			return d:resolve(item)
		end

		-- Otherwise, make quantity number of instances.
		local items = {}
		local itemType = item.uniqueID
		for i = 1, quantity do
			nut.item.instance(self:getID(), itemType, nil, 0, 0, function(item)
				self:addItem(item)
				items[#items + 1] = item
				if #items == quantity then d:resolve(quantity == 1 and items[1] or items) end
			end)
		end
		return d
	end

	function SimpleInv:remove(itemTypeOrID, quantity)
		-- Validate that the itemType is valid and quantity is positive.
		quantity = quantity or 1
		assert(isnumber(quantity), "quantity must be a number")
		local d = deferred.new()
		if quantity <= 0 then return d:reject("quantity must be positive") end
		if isnumber(itemTypeOrID) then
			self:removeItem(itemTypeOrID)
		else
			local items = self:getItemsOfType(itemTypeOrID)
			for i = 1, math.min(quantity, #items) do
				self:removeItem(items[i]:getID())
			end
		end

		d:resolve()
		return d
	end
end

function SimpleInv:getItemsOfType(itemType)
	local items = {}
	for _, item in pairs(self.items) do
		if item.uniqueID == itemType then items[#items + 1] = item end
	end
	return items
end

function SimpleInv:getWeight()
	local weight = 0
	for _, item in pairs(self.items) do
		local weightTotal = (type(item.weight) == "function" and item:weight(item)) or item.weight or 1
		weight = weight + weightTotal
	end
	return weight
end

function SimpleInv:getMaxWeight()
	local maxWeight = self:getData("maxWeight", nut.config.get("invMaxWeight", MAX_WEIGHT))

	return maxWeight
end

SimpleInv:register("simple")

-- =============================================================
-- Inventory-type-agnostic placement helpers.
--
-- Several gamemode plugins (equipment, combat, activity, crafting,
-- storage, ...) shared the same `inventory:findFreePosition` + setData
-- x/y + addItem dance that's only meaningful for the grid inventory
-- type. When the simple/list inventory is in use, findFreePosition is
-- nil and the call crashes.
--
-- `nut.Inventory:extend` uses `table.Inherit` — a shallow one-shot
-- copy of the parent class's fields into the subclass at extend-time.
-- Methods added to `nut.Inventory` *after* a subclass is extended
-- don't reach the subclass (or its instances). So we install the
-- helpers on `SimpleInv` directly here, and on `GridInv` from its own
-- plugin file. `nut.inv.installPlacementHelpers(class)` keeps the
-- single source of truth — both inventory plugins call into it.
--
--   inv:findItemSlot(itemOrClass)
--     -> grid: (x, y) when there's room, nil when full
--     -> simple: (true, nil) when there's room, nil when refused by an
--        access rule (e.g. weight cap)
--     The caller can branch on the truthiness of the first return
--     value to decide whether to add the item or spawn / reject it.
--
--   inv:tryPlaceItem(item)
--     Convenience for the common pattern: finds a slot, sets x/y when
--     the inventory type wants them, calls addItem, and returns true
--     on success / false on rejection so the caller can spawn the
--     item in the world (or notify the player) on a miss.

nut.inv = nut.inv or {}
function nut.inv.installPlacementHelpers(class)
    if not class then return end

    function class:findItemSlot(item)
        if isfunction(self.findFreePosition) then
            local x, y = self:findFreePosition(item)
            if x and y then return x, y end
            return nil
        end
        -- List-style inventory: defer to the access rules so weight
        -- caps (and any other "add" gates) still apply.
        if isfunction(self.canAccess) then
            local ok = self:canAccess("add", {item = item})
            if ok == false then return nil end
        end
        return true, nil
    end

    function class:tryPlaceItem(item)
        local x, y = self:findItemSlot(item)
        if x == nil then return false end
        if isnumber(x) and isnumber(y) then
            item:setData("x", x)
            item:setData("y", y)
        end
        self:addItem(item)
        return true
    end
end

nut.inv.installPlacementHelpers(SimpleInv)
-- Also install on GridInv if the grid inventory plugin is loaded.
-- nutscript plugins are loaded before gamemode plugins, so by the
-- time this file runs the "grid" type is already registered when
-- gridinv is active. Harmless no-op when grid isn't loaded.
nut.inv.installPlacementHelpers(nut.inventory and nut.inventory.types and nut.inventory.types["grid"])