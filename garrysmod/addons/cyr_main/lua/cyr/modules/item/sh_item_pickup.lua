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
            if item.functions and item.functions.take then
                item.functions.take.onRun(item)
            else
                local inventory = client:getChar():getInv()
                if not inventory then return end
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