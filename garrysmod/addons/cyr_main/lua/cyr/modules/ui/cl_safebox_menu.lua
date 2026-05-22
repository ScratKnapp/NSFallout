if SERVER then return end
CYR = CYR or {}
CYR.UI = CYR.UI or {}
include("cl_safebox_html_content.lua")
include("cl_tooltip.lua")
function CYR.UI.OpenSafebox(inventory)
    if IsValid(CYR_SAFEBOX_MENU) then CYR_SAFEBOX_MENU:Remove() end
    local frame = vgui.Create("DFrame")
    CYR_SAFEBOX_MENU = frame
    frame:SetSize(ScrW(), ScrH())
    frame:Center()
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:MakePopup()
    frame:SetDraggable(false)
    frame.Paint = function(s, w, h)
        -- Transparent, letting HTML handle it
    end

    -- Open Sound
    sound.Play("nl_ui_menu_next1.wav", LocalPlayer():GetPos(), 75, 100, 0.1)
    function frame:OnKeyCodePressed(key)
        if key == KEY_F4 or key == KEY_ESCAPE then self:Remove() end
    end

    frame.OnRemove = function()
        if CYR.UI and CYR.UI.HideTooltip then CYR.UI.HideTooltip() end
        sound.Play("nl_ui_menu_back" .. math.random(1, 3) .. ".wav", LocalPlayer():GetPos(), 75, 100, 0.1)
    end

    local html = vgui.Create("DHTML", frame)
    html:Dock(FILL)
    html.Paint = function() end -- No paint
    html:SetHTML(CYR.UI.SafeboxHTML or "<h1>ERROR: SAFEBOX HTML NOT FOUND</h1>")
    -- Data Helpers
    local function GetInventoryData(inv)
        if not inv then return {} end
        local items = {}
        for k, v in pairs(inv:getItems()) do
            local itemDef = nut.item.list[v.uniqueID] or {}
            -- Resolve Icon Path
            local iconPath = "asset://garrysmod/materials/error.png"
            if itemDef.icon then
                iconPath = "asset://garrysmod/materials/" .. itemDef.icon
            elseif itemDef.model then
                local mdl = itemDef.model:lower():gsub("%.mdl$", ".png")
                iconPath = "asset://garrysmod/materials/spawnicons/" .. mdl
            end

            table.insert(items, {
                id = v:getID(),
                uniqueID = v.uniqueID,
                name = itemDef.name or "Unknown Item",
                desc = itemDef.desc,
                category = itemDef.category,
                weight = itemDef.weight or 0,
                icon = iconPath,
                count = v:getData("Amount", 1)
            })
        end
        return items
    end

    local function UpdateAll()
        if not IsValid(html) then return end
        local localInv = LocalPlayer():getChar():getInv()
        local remoteInv = inventory
        local localData = {
            items = GetInventoryData(localInv),
            weight = {
                current = localInv:getWeight(),
                max = localInv:getMaxWeight()
            }
        }

        local remoteData = {
            items = GetInventoryData(remoteInv),
            weight = {
                current = remoteInv:getWeight(),
                max = remoteInv:getMaxWeight()
            }
        }

        local function clean(data)
            local json = util.TableToJSON(data or {})
            return json:gsub("\\", "\\\\"):gsub("\"", "\\\"")
        end

        html:Call("Webhooks.trigger('updateLocal', JSON.parse(\"" .. clean(localData) .. "\"))")
        html:Call("Webhooks.trigger('updateRemote', JSON.parse(\"" .. clean(remoteData) .. "\"))")
        -- Load Colors
        local settings = {
            primary = cookie.GetString("cyr_f4_primary", "#FF4400"),
            secondary = cookie.GetString("cyr_f4_secondary", "#E0E0E0"),
            tertiary = cookie.GetString("cyr_f4_tertiary", "#FF0000")
        }

        html:Call("Webhooks.trigger('loadSettings', JSON.parse(\"" .. clean(settings) .. "\"))")
    end

    -- Hook updates
    local uniqueID = "CYR_Safebox_Update_" .. tostring(SysTime())
    hook.Add("InventoryItemAdded", uniqueID, function() timer.Simple(0.1, function() if IsValid(html) then UpdateAll() end end) end)
    hook.Add("InventoryItemRemoved", uniqueID, function() timer.Simple(0.1, function() if IsValid(html) then UpdateAll() end end) end)
    html.OnRemove = function()
        hook.Remove("InventoryItemAdded", uniqueID)
        hook.Remove("InventoryItemRemoved", uniqueID)
    end

    -- Initial Update
    timer.Simple(0.5, function() if IsValid(html) then UpdateAll() end end)
    -- Webhooks
    html:AddFunction("gmod", "webhook", function(name, data)
        if name == "closeMenu" then
            frame:Close()
        elseif name == "showTooltip" then
            if CYR.UI and CYR.UI.ShowTooltip then
                data.colors = {
                    primary = cookie.GetString("cyr_f4_primary", "#FF4400"),
                    secondary = cookie.GetString("cyr_f4_secondary", "#E0E0E0"),
                    tertiary = cookie.GetString("cyr_f4_tertiary", "#1A1A1A")
                }

                CYR.UI.ShowTooltip(data, gui.MouseX(), gui.MouseY())
            end
        elseif name == "hideTooltip" then
            if CYR.UI and CYR.UI.HideTooltip then CYR.UI.HideTooltip() end
        elseif name == "transferItem" then
            local itemID = tonumber(data.itemID)
            local item = nut.item.instances[itemID]
            if not item then return end
            local action = "transfer"
            local targetInvID
            if item.invID == inventory:getID() then
                -- Moving FROM remote TO local
                targetInvID = LocalPlayer():getChar():getInv():getID()
            else
                -- Moving FROM local TO remote
                targetInvID = inventory:getID()
            end

            netstream.Start("safeboxTransfer", itemID, targetInvID)
            sound.Play("nl_ui_pickup_item.wav", LocalPlayer():GetPos(), 75, 100, 0.1)
        end
    end)
end