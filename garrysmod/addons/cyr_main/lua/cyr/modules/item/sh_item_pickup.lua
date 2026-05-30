if SERVER then
    local function StopPickup(client)
        client:setAction(false)
        timer.Remove("nutStare" .. client:UniqueID())
        client.nutPickingUp = nil
    end

    hook.Add("PlayerUse", "CYR_BlockItemPickup", function(client, entity)
        -- We block immediate pickup for items to allow hold-interaction
        if IsValid(entity) and entity:GetClass() == "nut_item" then return false end
    end)

    hook.Add("KeyPress", "CYR_ItemPickupKeyPress", function(client, key)
        if key ~= IN_USE or client:getNetVar("restricted") then return end
        local tr = client:GetEyeTrace()
        local entity = tr.Entity
        if not IsValid(entity) or entity:GetClass() ~= "nut_item" then return end
        if entity:GetPos():DistToSqr(client:GetShootPos()) > 10000 then return end
        local pickupTime = NWL.ItemPickupTime or 1.5
        client.nutPickingUp = entity
        client:setAction("Picking up...", pickupTime)
        client:doStaredAction(entity, function()
            if not IsValid(entity) or not IsValid(client) then return end
            if client.nutPickingUp ~= entity then return end
            local item = nut.item.instances[entity.nutItemID]
            if not item then return end
            local char = client:getChar()
            local inventory = char and char:getInv()
            -- Auto-stack maxstack/Amount items into existing stacks before
            -- taking a fresh slot; everything else falls through unchanged.
            local itemDef = nut.item.list[item.uniqueID]
            local maxstack = NWL.GetStackLimit(itemDef and itemDef.maxstack)
            if inventory and maxstack and maxstack > 1 then
                item.player = client
                local remaining = tonumber(item:getData("Amount")) or 1
                local existingCount = #inventory:getItemsOfType(item.uniqueID)
                for _, existing in pairs(inventory:getItemsOfType(item.uniqueID)) do
                    if remaining <= 0 then break end
                    local cur = tonumber(existing:getData("Amount")) or 1
                    local space = maxstack - cur
                    if space > 0 then
                        local move = math.min(space, remaining)
                        existing:setData("Amount", cur + move)
                        remaining = remaining - move
                    end
                end

                if remaining <= 0 then
                    -- Fully absorbed; destroy the world item.
                    item:remove()
                else
                    -- Leftover becomes its own stack; if the add is rejected
                    -- (full) the item stays in the world with the remainder.
                    item:setData("Amount", remaining)
                    inventory:add(item):next(function() if IsValid(entity) then entity:Remove() end end):catch(function() end)
                end

                item.player = nil
                client.nutPickingUp = nil
                return
            end

            if item.functions and item.functions.take then
                item.player = client
                item.functions.take.onRun(item)
                item.player = nil
            elseif inventory then
                inventory:add(item):next(function() if IsValid(entity) then entity:Remove() end end)
            end

            client.nutPickingUp = nil
        end, pickupTime, function()
            if IsValid(client) then
                client:setAction(false)
                client.nutPickingUp = nil
            end
        end)
    end)

    hook.Add("KeyRelease", "CYR_ItemPickupKeyRelease", function(client, key) if key == IN_USE and client.nutPickingUp then StopPickup(client) end end)
end