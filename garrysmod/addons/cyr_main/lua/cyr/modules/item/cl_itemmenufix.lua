-- CYR Item Menu Fix
-- Automatically takes items when pressing E on them
if CLIENT then
    local function func()
        -- Override the gamemode function
        function GAMEMODE:ItemShowEntityMenu(entity)
            -- Remove any existing menus for this entity
            for k, v in ipairs(nut.menu.list) do
                if v.entity == entity then table.remove(nut.menu.list, k) end
            end

            local itemTable = entity:getItemTable()
            if not itemTable then return end
            -- Automatically take the item
            if IsValid(entity) then end
        end

        print("[CYR] Item auto-take loaded!")
    end

    -- We need to override the GM function directly since hooks can't properly override it
    hook.Add("InitPostEntity", "CYR_FixItemMenuInit", function() timer.Simple(1, func) end)
    if GAMEMODE then timer.Simple(0.1, func) end
end

hook.Add("ItemShowEntityMenu", "CYR_PreventItemMenu", function(entity)
    if not IsValid(entity) then return true end
    netstream.Start("invAct", "take", entity)
    return true
end)