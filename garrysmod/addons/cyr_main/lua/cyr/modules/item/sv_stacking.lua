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
    local maxstack = itemDef.maxstack or itemDef.maxQuantity or 1
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