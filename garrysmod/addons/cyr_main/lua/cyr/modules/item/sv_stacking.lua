if CLIENT then return end
netstream.Hook("cyrCombineItems", function(client, sourceID, targetID)
    print("[STACKING] Received request from", client, "Source:", sourceID, "Target:", targetID)
    if not sourceID or not targetID or sourceID == targetID then return end
    local sourceItem = nut.item.instances[sourceID]
    local targetItem = nut.item.instances[targetID]
    if not sourceItem or not targetItem then
        print("[STACKING] Source or Target item not found")
        return
    end

    print("[STACKING] Valid items found:", sourceItem, targetItem)
    -- Basic security / distance check (they should be in an inventory)
    if sourceItem.invID == 0 or targetItem.invID == 0 then
        print("[STACKING] Invalid inventory ID")
        return
    end

    -- Must be the same item type
    if sourceItem.uniqueID ~= targetItem.uniqueID then
        print("[STACKING] UniqueID mismatch:", sourceItem.uniqueID, targetItem.uniqueID)
        return
    end

    -- Check for custom onCombine hooks (like in fancyammo)
    if isfunction(sourceItem.onCombine) then
        print("[STACKING] Custom onCombine hook found")
        sourceItem.player = client
        sourceItem:onCombine(targetItem)
        sourceItem.player = nil
        return
    end

    -- Generic Stacking Logic
    print("[STACKING] Generic logic start")
    local itemDef = nut.item.list[sourceItem.uniqueID]
    local maxstack = NWL.GetStackLimit(itemDef.maxstack) or itemDef.maxQuantity or 1
    print("[STACKING] Max Stack:", maxstack)
    -- Determine current amounts (handle both NS quantity and custom Amount data)
    local sourceAmt = sourceItem:getData("Amount") or sourceItem:getQuantity() or 1
    local targetAmt = targetItem:getData("Amount") or targetItem:getQuantity() or 1
    print("[STACKING] Amounts - Source:", sourceAmt, "Target:", targetAmt)
    if maxstack <= 1 then
        print("[STACKING] Item not stackable")
        return
    end

    if targetAmt >= maxstack then -- Target full
        print("[STACKING] Target full")
        return
    end

    local combined = sourceAmt + targetAmt
    print("[STACKING] Combined amount:", combined)
    if combined > maxstack then
        print("[STACKING] Partial merge")
        -- Fill target to max, reduce source by diff
        local toTransfer = maxstack - targetAmt
        local newSourceAmt = sourceAmt - toTransfer
        -- Update Target to MAX
        if itemDef.maxstack then
            targetItem:setData("Amount", maxstack)
        else
            targetItem:setQuantity(maxstack)
        end

        -- Update Source to Remainder
        if itemDef.maxstack then
            sourceItem:setData("Amount", newSourceAmt)
        else
            sourceItem:setQuantity(newSourceAmt)
        end
    else
        print("[STACKING] Full merge")
        -- Fully merge into target
        if itemDef.maxstack then
            targetItem:setData("Amount", combined)
        else
            targetItem:setQuantity(combined)
        end

        -- Remove source
        sourceItem:remove()
    end

    client:EmitSound("os/button_6.wav", 65, 120)
    -- Force UI Refresh
    netstream.Start(client, "nutInventoryRefresh") -- Try to trigger generic refresh
end)

-- Splits a quantity off a stack and drops it as a separate world item.
netstream.Hook("cyrDropQuantity", function(client, itemID, amount)
    amount = tonumber(amount)
    if not itemID or not amount then return end
    local item = nut.item.instances[itemID]
    if not item then return end
    -- Must be a stack in the requesting player's own inventory.
    local char = client:getChar()
    if not char then return end
    local inv = char:getInv()
    if not inv or item.invID ~= inv:getID() then return end
    if item.noDrop then return end
    local itemDef = nut.item.list[item.uniqueID]
    local maxstack = NWL.GetStackLimit(itemDef and itemDef.maxstack)
    if not maxstack or maxstack <= 1 then return end
    local current = tonumber(item:getData("Amount")) or 1
    amount = math.floor(amount)
    if amount < 1 then return end
    if amount >= current then
        -- Whole stack: hand off to the normal drop path.
        item.player = client
        item:removeFromInventory(true):next(function() item:spawn(client) end)
        item.player = nil
        return
    end

    -- Reduce the source and spawn the split as a new world item, keeping data.
    item:setData("Amount", current - amount)
    local data = table.Copy(item:getData(true) or {})
    data.x, data.y = nil, nil
    data.Amount = amount
    nut.item.spawn(item.uniqueID, client:getItemDropPos(), nil, nil, data)
    client:EmitSound("os/button_6.wav", 65, 120)
    netstream.Start(client, "nutInventoryRefresh")
end)

-- Mergeable only if it carries no per-instance data that combining would
-- destroy (custom attributes, mods, infusion/edit flags, equipped state).
local function isPlainStack(item)
    local d = item:getData(true) or {}
    if (d.custom and next(d.custom) ~= nil) or (d.customW and next(d.customW) ~= nil) or d.infused or d.edited or d.equip then return false end
    local def = nut.item.list[item.uniqueID]
    local fns = def and def.functions
    if fns and (fns.Custom or fns.CustomAtr) then return false end
    return true
end

-- Compacts every plain stack of a uniqueID into the fewest stacks possible.
local function compactStacks(inv, uniqueID)
    local def = nut.item.list[uniqueID]
    local maxstack = NWL.GetStackLimit(def and def.maxstack)
    if not maxstack or maxstack <= 1 then return false end
    local stacks = {}
    for _, it in pairs(inv:getItemsOfType(uniqueID)) do
        if isPlainStack(it) then stacks[#stacks + 1] = it end
    end

    if #stacks < 2 then return false end
    local total = 0
    for _, it in ipairs(stacks) do
        total = total + (tonumber(it:getData("Amount")) or 1)
    end

    -- Refill the first ceil(total/maxstack) stacks; drop the rest.
    local idx, remaining = 1, total
    while remaining > 0 and idx <= #stacks do
        local give = math.min(maxstack, remaining)
        stacks[idx]:setData("Amount", give)
        remaining = remaining - give
        idx = idx + 1
    end

    for k = idx, #stacks do
        stacks[k]:remove()
    end
    return true
end

-- Exposed so other systems (e.g. storage transfers) can fold a freshly moved
-- item into existing stacks instead of leaving separate instances.
NWL.CompactStacks = compactStacks
-- Merge action: combine scattered partial stacks of one item type in the
-- player's inventory. Triggered from the pipboy's right-click menu.
netstream.Hook("cyrMergeStacks", function(client, uniqueID)
    print("[CYR STACK] cyrMergeStacks request", client, uniqueID)
    if not isstring(uniqueID) then return end
    local char = client:getChar()
    if not char then return end
    local inv = char:getInv()
    if not inv then return end
    local def = nut.item.list[uniqueID]
    local total, plain = 0, 0
    for _, it in pairs(inv:getItemsOfType(uniqueID)) do
        total = total + 1
        if isPlainStack(it) then plain = plain + 1 end
    end

    print("[CYR STACK] merge", uniqueID, "maxstack=", tostring(def and def.maxstack), "total=", total, "plain(mergeable)=", plain)
    if compactStacks(inv, uniqueID) then
        client:EmitSound("os/button_6.wav", 65, 120)
        netstream.Start(client, "nutInventoryRefresh")
    end
end)

-- Auto-stack after NutScript's "take" action. Deferred a tick so the async
-- inventory add has resolved (item.invID set), then compact that type.
hook.Add("OnPlayerInteractItem", "CYR_AutoStackOnTake", function(client, action, item, result)
    if action ~= "take" then return end
    if result == false then return end
    if not item or not IsValid(client) then return end
    local uniqueID = item.uniqueID
    timer.Simple(0, function()
        if not IsValid(client) then return end
        local char = client:getChar()
        local inv = char and char:getInv()
        if not inv then return end
        local merged = compactStacks(inv, uniqueID)
        if merged then netstream.Start(client, "nutInventoryRefresh") end
    end)
end)