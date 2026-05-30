local SimpleInv = nut.Inventory:extend("SimpleInv")
local MAX_WEIGHT = 50
local function CanAccessInventoryIfCharacterIsOwner(inventory, action, context)
	local ownerID = inventory:getData("char")
	local client = context.client
	if table.HasValue(client.nutCharList, ownerID) then return true end
end


function GET_ITEM_WEIGHT(item)
	local base = type(item.weight) == "function" and item:weight(item) or item.weight or 1
	-- A stack of N weighs N * base.
	local amount = (isfunction(item.getData) and tonumber(item:getData("Amount", 1))) or 1
	return base * amount
end


local function CanAddItemIfNotWeightRestricted(inventory, action, context)
	if action ~= "add" then return end
	if context.forced then return true end
	local weight = inventory:getWeight()
	local maxWeight = inventory:getMaxWeight()
	local itemWeight = GET_ITEM_WEIGHT(context.item)
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
		quantity = quantity or 1
		assert(isnumber(quantity), "quantity must be a number")
		local d = deferred.new()
		if quantity <= 0 then return d:reject("quantity must be positive") end
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

		local context = {
			item = item,
			forced = forced,
			quantity = quantity
		}

		-- Partial stacking by weight: take what fits under the cap, drop the rest.
		if justAddDirectly and not forced then
			local base = type(item.weight) == "function" and item:weight(item) or item.weight or 1
			local amount = tonumber(item:getData("Amount", 1)) or 1
			local remaining = self:getMaxWeight() - self:getWeight()
			if base > 0 and amount > 1 and base * amount > remaining then
				local maxFit = math.floor(remaining / base)
				if maxFit < 1 then return d:reject("noFit") end
				if maxFit < amount then
					local ply = (IsValid(item.player) and item.player) or nil
					if not ply then
						local charID = self:getData("char")
						local char = charID and nut.char and nut.char.loaded and nut.char.loaded[tonumber(charID) or charID]
						if char and isfunction(char.getPlayer) then ply = char:getPlayer() end
					end
					local dropPos
					if IsValid(ply) then
						dropPos = ply:getItemDropPos()
					elseif IsValid(item.entity) then
						dropPos = item.entity:GetPos()
					end
					if not dropPos then return d:reject("noFit") end

					-- Trim to what fits; spawn the rest as a world stack with its data.
					item:setData("Amount", maxFit)
					local data = table.Copy(item:getData(true) or {})
					data.x, data.y = nil, nil
					data.Amount = amount - maxFit
					nut.item.spawn(item.uniqueID, dropPos, nil, nil, data)
				end
			end
		end

		local canAccess, reason = self:canAccess("add", context)
		if not canAccess then return d:reject(reason or "noAccess") end
		if justAddDirectly then
			self:addItem(item)
			return d:resolve(item)
		end

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

	-- Mirror of GridInv:addSmart: make `number` instances of `item` with
	-- `data`; ones that don't fit (weight cap) drop at `position`.
	function SimpleInv:addSmart(item, number, position, data)
		local itemObj = nut.item.list[item]
		if not itemObj then return false end
		number = tonumber(number) or 1

		local items = {}
		for i = 1, number do
			nut.item.instance(0, item, data or {}, 0, 0, function(newItem)
				if self:tryPlaceItem(newItem) then
					items[#items + 1] = newItem
				elseif position then
					newItem:spawn(position)
				end
			end)
		end
		return items
	end

	function SimpleInv:remove(itemTypeOrID, quantity)
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
		weight = weight + GET_ITEM_WEIGHT(item)
	end
	return weight
end

function SimpleInv:getMaxWeight()
	local maxWeight = self:getData("maxWeight", nut.config.get("invMaxWeight", MAX_WEIGHT))

	return maxWeight
end

SimpleInv:register("simple")

-- Inventory-type-agnostic placement helpers. The grid-only
-- findFreePosition + setData x/y + addItem pattern crashes on the simple
-- inventory (findFreePosition is nil), so install slot helpers on both
-- types. Installed per-class because extend()'s table.Inherit is a
-- one-shot copy, so methods added to nut.Inventory later don't propagate.
--   findItemSlot -> grid: (x,y)/nil ; simple: (true,nil)/nil
--   tryPlaceItem -> finds slot, sets x/y if needed, adds; true on success
nut.inv = nut.inv or {}
function nut.inv.installPlacementHelpers(class)
    if not class then return end

    function class:findItemSlot(item)
        if isfunction(self.findFreePosition) then
            local x, y = self:findFreePosition(item)
            if x and y then return x, y end
            return nil
        end
        -- List inventory: defer to access rules so the weight cap applies.
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
-- Also install on GridInv when loaded (no-op otherwise).
nut.inv.installPlacementHelpers(nut.inventory and nut.inventory.types and nut.inventory.types["grid"])