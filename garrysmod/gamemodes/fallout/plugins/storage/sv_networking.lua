util.AddNetworkString("nutStorageOpen")
util.AddNetworkString("nutStorageExit")
util.AddNetworkString("nutStorageUnlock")
util.AddNetworkString("nutStorageTransfer")
util.AddNetworkString("cyrStorageTransferQuantity")

local TRANSFER = "transfer"

local function getValidStorage(client)
	local storage = client.nutStorageEntity
	if (not IsValid(storage)) then return end
	if (client:GetPos():Distance(storage:GetPos()) > 128) then return end
	return storage
end

net.Receive("nutStorageExit", function(_, client)
	local storage = client.nutStorageEntity
	if (IsValid(storage)) then
		storage.receivers[client] = nil
	end
	client.nutStorageEntity = nil
end)

net.Receive("nutStorageUnlock", function(_, client)
	local password = net.ReadString()
	local storage = getValidStorage(client)
	local passwordDelay = nut.config.get("passwordDelay",1)
	if (not storage) then return end
		
	if (client.lastPasswordAttempt and CurTime() < client.lastPasswordAttempt + passwordDelay) then
		client:notifyLocalized("passwordTooQuick")
	else
		if (storage.password == password) then
			storage:openInv(client)
		else
			client:notifyLocalized("wrongPassword")
			client.nutStorageEntity = nil
		end
		client.lastPasswordAttempt = CurTime()
	end
end)

net.Receive("nutStorageTransfer", function(_, client)
	-- Get the item that the player is swapping.
	local itemID = net.ReadUInt(32)

	-- Get the storage that the player opened.
	if (not client:getChar()) then return end
	local storage = getValidStorage(client)
	if (not storage or not storage.receivers[client]) then return end

	-- Get the inventory that we are transfering to and from.
	local clientInv = client:getChar():getInv()
	local storageInv = storage:getInv()
	if (not clientInv or not storageInv) then return end
	local item = clientInv.items[itemID] or storageInv.items[itemID]
	if (not item) then return end
	local toInv = clientInv:getID() == item.invID and storageInv or clientInv
	local fromInv = toInv == clientInv and storageInv or clientInv

	-- Permission check before moving the item around.
	if (hook.Run("StorageCanTransferItem", client, storage, item) == false) then
		return
	end
	local context = {
		client = client,
		item = item,
		storage = storage,
		from = fromInv,
		to = toInv
	}
	if (
		clientInv:canAccess(TRANSFER, context) == false or
		storageInv:canAccess(TRANSFER, context) == false
	) then
		return
	end

	if (client.storageTransaction and client.storageTransactionTimeout > RealTime()) then
		return
	end

	client.storageTransaction = true
	client.storageTransactionTimeout = RealTime() + .1

	-- Swap the item between the storage inventory and character's inventory.
	local failItemDropPos = client:getItemDropPos()
	fromInv:removeItem(itemID, true)
		:next(function()
			return toInv:add(item)
		end)
		:next(function(res)
			client.storageTransaction = nil
			hook.Run("ItemTransfered", context)
			-- Fold the moved item into an existing destination stack rather
			-- than leaving a separate instance.
			if (NWL and NWL.CompactStacks) then NWL.CompactStacks(toInv, item.uniqueID) end
			return res
		end)
		:catch(function(err)
			client.storageTransaction = nil
			if (IsValid(client)) then
				client:notifyLocalized(err)
			end
			return fromInv:add(item)
		end)
		:catch(function(err)
			client.storageTransaction = nil
			item:spawn(failItemDropPos)
			if (IsValid(client)) then
				client:notifyLocalized("itemOnGround")
			end
		end)
end)

-- Transfer a partial quantity off a stack (split its Amount) between the
-- storage and the player's inventory. The whole-stack case is handled by the
-- normal nutStorageTransfer; this only runs when moving fewer than the full
-- stack. When the destination is the player it's clamped to carry-weight.
net.Receive("cyrStorageTransferQuantity", function(_, client)
	local itemID = net.ReadUInt(32)
	local amount = net.ReadUInt(32)

	if (not client:getChar()) then return end
	local storage = getValidStorage(client)
	if (not storage or not storage.receivers[client]) then return end

	local clientInv = client:getChar():getInv()
	local storageInv = storage:getInv()
	if (not clientInv or not storageInv) then return end
	local item = clientInv.items[itemID] or storageInv.items[itemID]
	if (not item) then return end
	local toInv = clientInv:getID() == item.invID and storageInv or clientInv
	local fromInv = toInv == clientInv and storageInv or clientInv

	if (hook.Run("StorageCanTransferItem", client, storage, item) == false) then return end
	local context = {
		client = client,
		item = item,
		storage = storage,
		from = fromInv,
		to = toInv
	}
	if (
		clientInv:canAccess(TRANSFER, context) == false or
		storageInv:canAccess(TRANSFER, context) == false
	) then
		return
	end

	-- Stackable only.
	local def = nut.item.list[item.uniqueID]
	local maxstack = (NWL and NWL.GetStackLimit and NWL.GetStackLimit(def and def.maxstack))
		or (def and def.maxstack)
	if (not maxstack or maxstack <= 1) then return end

	local current = tonumber(item:getData("Amount")) or 1
	amount = math.floor(tonumber(amount) or 0)
	if (amount < 1) then return end

	-- Clamp to the destination inventory's carry-weight. Storage has its own
	-- weight cap too, so depositing is limited the same way as withdrawing.
	if (isfunction(toInv.getMaxWeight)) then
		local base = (type(item.weight) == "function" and item:weight(item)) or item.weight or 0
		if (base > 0) then
			amount = math.min(amount, math.floor((toInv:getMaxWeight() - toInv:getWeight()) / base))
		end
	end
	if (amount < 1) then
		if (IsValid(client)) then client:notifyLocalized("noFit") end
		return
	end

	local uniqueID = item.uniqueID

	if (amount >= current) then
		-- Whole stack: move the instance outright, then fold into any existing
		-- destination stack.
		local failItemDropPos = client:getItemDropPos()
		fromInv:removeItem(itemID, true)
			:next(function() return toInv:add(item) end)
			:next(function() if (NWL and NWL.CompactStacks) then NWL.CompactStacks(toInv, uniqueID) end end)
			:catch(function() item:spawn(failItemDropPos) end)
		return
	end

	-- Partial: trim the source stack and create the moved amount in the
	-- destination, preserving the source's data (quality, etc.). Then fold it
	-- into the first existing destination stack instead of leaving a separate
	-- instance.
	item:setData("Amount", current - amount)
	local data = table.Copy(item:getData(true) or {})
	data.x, data.y = nil, nil
	data.Amount = amount
	nut.item.instance(toInv:getID(), uniqueID, data, 0, 0, function(newItem)
		if (IsValid(client) and not toInv.items[newItem:getID()]) then
			toInv:addItem(newItem)
		end
		if (NWL and NWL.CompactStacks) then NWL.CompactStacks(toInv, uniqueID) end
	end)
end)
