-- Caps deposit/withdraw for the barter storage UI. Caps live on the storage
-- entity's inventory as a `storCaps` data key — Inventory:setData persists
-- to nut_inv_data in the DB and auto-syncs to clients via syncData, so the
-- client UI can read inv:getData("storCaps", 0) and get the live value
-- without any custom networking on our end.

util.AddNetworkString("nutBarterDepositCaps")
util.AddNetworkString("nutBarterWithdrawCaps")

local CAPS_KEY = "storCaps"

local function getActiveStorage(client)
	local ent = client.nutStorageEntity
	if not IsValid(ent) then return nil end
	-- Distance gate matches the existing storage Use range so a deposit
	-- can't be triggered after the player walks away from the locker.
	if client:GetPos():Distance(ent:GetPos()) > 128 then return nil end
	return ent
end

local function getStorageInv(storage)
	if not IsValid(storage) then return nil end
	return storage.getInv and storage:getInv() or nil
end

net.Receive("nutBarterDepositCaps", function(_, client)
	local amount = net.ReadUInt(32)
	if amount <= 0 then return end

	local storage = getActiveStorage(client)
	if not storage then return end
	local inv = getStorageInv(storage)
	if not inv then return end

	local char = client:getChar()
	if not char then return end

	-- Clamp to what the player actually has — they may have spent caps
	-- between opening the popup and confirming.
	local have   = char.getMoney and char:getMoney() or 0
	local actual = math.min(amount, have)
	if actual <= 0 then return end

	char:takeMoney(actual)
	inv:setData(CAPS_KEY, (inv:getData(CAPS_KEY, 0)) + actual)
end)

net.Receive("nutBarterWithdrawCaps", function(_, client)
	local amount = net.ReadUInt(32)
	if amount <= 0 then return end

	local storage = getActiveStorage(client)
	if not storage then return end
	local inv = getStorageInv(storage)
	if not inv then return end

	-- Clamp to what's still in the storage — another player may have
	-- withdrawn between this client opening the popup and confirming.
	local current = inv:getData(CAPS_KEY, 0)
	local actual  = math.min(amount, current)
	if actual <= 0 then return end

	local char = client:getChar()
	if not char then return end

	inv:setData(CAPS_KEY, current - actual)
	char:giveMoney(actual)
end)
