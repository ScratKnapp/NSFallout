if SERVER then return end
CYR = CYR or {}
CYR.UI = CYR.UI or {}
include("cl_f4_html_content.lua")
include("cl_tooltip.lua")
function CreateCYRF1Menu()
    if CYR_F1MENU and IsValid(CYR_F1MENU) then
        CYR_F1MENU:Remove()
        return
    end

    local frame = vgui.Create("DFrame")
    CYR_F1MENU = frame
    frame:SetSize(ScrW(), ScrH())
    frame:Center()
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:MakePopup()
    frame:SetDraggable(false)
    frame.Paint = function(s, w, h)
        -- Transparent background, let HTML handle the visuals
    end

    -- Open Sound
    sound.Play("nl_ui_menu_next1.wav", LocalPlayer():GetPos(), 75, 100, 0.35)
    function frame:OnKeyCodePressed(key)
        if key == KEY_F4 or key == KEY_ESCAPE then self:Remove() end
    end

    frame.OnRemove = function()
        if CYR.UI and CYR.UI.HideTooltip then CYR.UI.HideTooltip() end
        sound.Play("nl_ui_menu_back" .. math.random(1, 3) .. ".wav", LocalPlayer():GetPos(), 75, 100, 0.35)
    end

    local html = vgui.Create("DHTML", frame)
    html:Dock(FILL)
    html.Paint = function() end
    -- Helper to send data to JS
    local function SendToJS(hookName, data)
        if not IsValid(html) then return end
        local json = util.TableToJSON(data or {})
        print("[CYR DEBUG] SendToJS payload size:", #json)
        if #json < 500 then
            print("[CYR DEBUG] FULL JSON:", json)
        else
            print("[CYR DEBUG] JSON PREVIEW:", string.sub(json, 1, 200))
        end

        -- Use Base64 to avoid escaping hell
        local b64 = util.Base64Encode(json)
        if b64 then b64 = string.gsub(b64, "\n", "") end
        html:Call("Webhooks.trigger('" .. hookName .. "', JSON.parse(atob('" .. b64 .. "')))")
    end

    -- --- DATA FETCHING HELPERS ---
    local function GetItemData(item)
        if not item then return nil end
        -- TEST DATA INJECTION TO VERIFY TRANSMISSION
        if item == "TEST_ITEM" then
            return {
                id = "99999",
                uniqueID = "test_item",
                amount = 100,
                maxstack = 100,
                definition = {
                    name = "DEBUG TEST ITEM",
                    desc = "If you see this, transmission works.",
                    model = "models/props_junk/watermelon01.mdl",
                    iconPath = "asset://garrysmod/materials/error.png"
                }
            }
        end

        local itemDef = nut.item.list[item.uniqueID] or {}
        local iconPath = "asset://garrysmod/materials/error.png"
        if itemDef.icon then
            iconPath = "asset://garrysmod/materials/" .. itemDef.icon
        elseif itemDef.model then
            local mdl = itemDef.model:lower():gsub("%.mdl$", ".png")
            iconPath = "asset://garrysmod/materials/spawnicons/" .. mdl
        end

        local amount = item:getData("Amount") or item:getQuantity() or 1
        local maxstack = itemDef.maxstack or itemDef.maxQuantity or 1
        return {
            id = tostring(item:getID()),
            uniqueID = item.uniqueID,
            amount = amount,
            maxstack = maxstack,
            definition = {
                name = itemDef.name or "Unknown Item",
                desc = itemDef.desc,
                category = itemDef.category,
                model = itemDef.model,
                uniqueID = item.uniqueID,
                iconPath = iconPath,
                weight = itemDef.weight or 0,
                maxstack = maxstack
            },
            instances = {
                {
                    id = item:getID()
                }
            }
        }
    end

    local function GetInventoryData()
        print("[CYR DEBUG] GetInventoryData STARTED")
        local char = LocalPlayer():getChar()
        if not char then return {} end
        local inv = char:getInv()
        if not inv then return {} end
        local items = {}
        -- Always add test item first
        table.insert(items, GetItemData("TEST_ITEM"))
        for k, v in pairs(inv:getItems()) do
            local data = GetItemData(v)
            if data then
                print("[CYR DEBUG] Processing Item:", v, "ID:", v:getID(), "Type:", type(v:getID()))
                table.insert(items, data)
            else
                print("[CYR DEBUG] Failed to get data for item:", v)
            end
        end

        print("[CYR DEBUG] Sending Inventory Data, count:", #items)
        if #items > 0 then
            print("[CYR DEBUG] First Item Sample:")
            PrintTable(items[1])
        end
        return {
            Inventory = items
        }
    end

    local function GetEquipmentData()
        if not LocalPlayer().getEquip then return {} end
        local equip = LocalPlayer():getEquip() or {}
        local data = {}
        for k, v in pairs(equip) do
            local item = nut.item.instances[v]
            if item then data[k] = GetItemData(item) end
        end
        return data
    end

    local function GetPlayerStats()
        local char = LocalPlayer():getChar()
        if not char then
            return {
                money = 0,
                name = "Loading...",
                currency = NWL and NWL.CurrencySymbol or "€$",
                attribs = {}
            }
        end

        local attribs = {}
        if nut.attribs and nut.attribs.list then
            for k, v in pairs(nut.attribs.list) do
                table.insert(attribs, {
                    key = k,
                    name = v.name,
                    val = char:getAttrib(k, 0)
                })
            end
        end

        table.sort(attribs, function(a, b) return a.name < b.name end)
        return {
            money = char:getMoney(),
            name = char:getName(),
            currency = NWL and NWL.CurrencySymbol or "€$",
            attribs = attribs
        }
    end

    local function UpdateAll()
        print("[CYR DEBUG] UpdateAll STARTED")
        SendToJS("updateInventory", GetInventoryData())
        SendToJS("updateEquipment", GetEquipmentData())
        SendToJS("updateStats", GetPlayerStats())
        local settings = {
            primary = cookie.GetString("cyr_f4_primary", "#00f0ff"),
            secondary = cookie.GetString("cyr_f4_secondary", "#d600ff"),
            tertiary = cookie.GetString("cyr_f4_tertiary", "#ccff00")
        }

        SendToJS("loadSettings", settings)
    end

    -- Helper for Context Menu
    local function RunItemAction(itemID, actionKey, subData, suppressOnClick)
        print("[CYR DEBUG] RunItemAction Called - ID:", itemID, "Key:", actionKey, "Suppress:", suppressOnClick)
        local item = nut.item.instances[itemID]
        if not item then
            print("[CYR DEBUG] RunItemAction: Item not found for ID:", itemID)
            return
        end

        local func = item.functions[actionKey]
        if not func then
            print("[CYR DEBUG] RunItemAction: Function not found for key:", actionKey)
            return false
        end

        item.player = LocalPlayer()
        -- Smart Slot Logic: Bypass onClick/menu if we can auto-pick a slot
        local handledSmart = false
        local isEquipAction = actionKey:lower() == "equip" or actionKey == "EquipSlot"
        if isEquipAction then
            local itemDef = nut.item.list[item.uniqueID]
            local isWeapon = item.isWeapon or (itemDef and itemDef.isWeapon) or (itemDef and itemDef.category and itemDef.category:lower() == "weapons")
            if isWeapon then
                print("[CYR DEBUG] RunItemAction: Smart Slot Logic Triggered for Weapon")
                local equip = LocalPlayer():getEquip() or {}
                local preferredSlot = itemDef.slot or "sidearm"
                -- Check for specialSlot (EquipSlot)
                if item.specialSlot then
                    if istable(item.specialSlot) then
                        preferredSlot = item.specialSlot[1] -- Default to first
                        if preferredSlot:lower() == "sidearm" and equip["sidearm"] and not equip["primary"] then
                            for _, s in pairs(item.specialSlot) do
                                if s:lower() == "primary" then
                                    preferredSlot = s
                                    break
                                end
                            end
                        end
                    else
                        preferredSlot = item.specialSlot
                    end
                end

                local targetSlot = preferredSlot
                local slotLower = preferredSlot:lower()
                if not item.specialSlot and slotLower == "sidearm" and equip["sidearm"] and not equip["primary"] then targetSlot = "primary" end
                -- Directly trigger the equip netstream
                print("[CYR DEBUG] Sending smart equip netstream to:", targetSlot)
                netstream.Start("invAct", actionKey, item.id, item.invID, targetSlot)
                handledSmart = true
            end
        end

        if handledSmart then
            item.player = nil
            timer.Simple(0.1, function() UpdateAll() end)
            return
        end

        if isfunction(func.onCanRun) and not func.onCanRun(item) then
            print("[CYR DEBUG] RunItemAction: onCanRun returned false")
            item.player = nil
            return
        end

        local send = true
        if send ~= false and not suppressOnClick then
            print("[CYR DEBUG] RunItemAction: Checking onClick")
            -- Fallback to default onClick (might open a menu)
            if func.onClick then
                print("[CYR DEBUG] RunItemAction: Executing onClick")
                send = func.onClick(item)
            end
        elseif suppressOnClick then
            print("[CYR DEBUG] RunItemAction: Suppressed onClick")
        end

        if send ~= false then
            print("[CYR DEBUG] RunItemAction: Sending default invAct netstream")
            netstream.Start("invAct", actionKey, item.id, item.invID, subData)
        end

        item.player = nil
        timer.Simple(0.1, function() UpdateAll() end)
    end

    local function OpenItemMenu(itemID)
        local item = nut.item.instances[itemID]
        if not item then return end
        local menu = DermaMenu()
        for k, v in SortedPairs(item.functions) do
            item.player = LocalPlayer()
            if isfunction(v.onCanRun) and not v.onCanRun(item) then
                item.player = nil
                continue
            end

            item.player = nil
            if v.isMulti then
                local sub, subOption = menu:AddSubMenu(L(v.name or k))
                subOption:SetImage(v.icon or "icon16/brick.png")
                local options = v.multiOptions(item, LocalPlayer())
                for _, subData in pairs(options) do
                    sub:AddOption(L(subData.name or "Unknown"), function()
                        -- Use helper
                        RunItemAction(itemID, k, subData.data)
                    end)
                end
            else
                local option = menu:AddOption(L(v.name or k), function() RunItemAction(itemID, k) end)
                if v.icon then option:SetImage(v.icon) end
            end
        end

        menu:Open()
    end

    html:AddFunction("gmod", "webhook", function(name, jsonStr)
        local data = {}
        if jsonStr and jsonStr ~= "" then data = util.JSONToTable(jsonStr) or {} end
        if name ~= "showTooltip" and name ~= "hideTooltip" then print("[CYR DEBUG] Webhook received:", name, table.ToString(data)) end
        if name == "playSound" then
            if data.sound then surface.PlaySound(data.sound) end
        elseif name == "useItem" then
            local itemID = tonumber(data.itemID)
            print("[CYR DEBUG] Webhook useItem - ID:", itemID)
            local item = nut.item.instances[itemID]
            if item then
                local function findKey(target)
                    target = target:lower()
                    for k, v in pairs(item.functions) do
                        if k:lower() == target then return k end
                    end
                end

                local equipSlotKey = findKey("EquipSlot")
                local equipKey = findKey("Equip") or findKey("EquipUn")
                local wearKey = findKey("Wear") -- Support for PAC/Accessories
                local safeName = item.name or (nut.item.list[item.uniqueID] and nut.item.list[item.uniqueID].name) or "Unknown Item"
                print("[CYR DEBUG] Item:", safeName)
                print("[CYR DEBUG] Found keys - EquipSlot:", equipSlotKey, "Equip:", equipKey, "Wear:", wearKey)
                -- Helper to check and run
                local function tryRun(key)
                    if not key then return false end
                    local func = item.functions[key]
                    if not func then
                        print("[CYR DEBUG] No function for key:", key)
                        return false
                    end

                    item.player = LocalPlayer()
                    local itemDef = nut.item.list[item.uniqueID]
                    local isWeapon = item.isWeapon or (itemDef and itemDef.isWeapon) or (itemDef and itemDef.category and itemDef.category:lower() == "weapons")
                    local isEquip = key == equipKey or key == equipSlotKey
                    local canRun = true
                    if isWeapon and isEquip then
                        print("[CYR DEBUG] Bypassing onCanRun for Weapon Smart Equip")
                    elseif isfunction(func.onCanRun) and not func.onCanRun(item) then
                        canRun = false
                        print("[CYR DEBUG] onCanRun failed for:", key)
                    end

                    if not canRun then return false end
                    print("[CYR DEBUG] Attempting to run:", key)
                    RunItemAction(itemID, key, nil, true) -- true = suppress onClick
                    if isEquip then sound.Play("nl_ui_pickup_item.wav", LocalPlayer():GetPos(), 75, 100, 0.35) end
                    return true
                end

                if tryRun(equipSlotKey) then return end
                if tryRun(equipKey) then return end
                if tryRun(wearKey) then return end
                -- If we got here, it's a generic use or failed action.
                -- Maybe context menu opened? We don't play equip sound.
                print("[CYR DEBUG] No valid Equip/Wear action found. Doing nothing.")
            else
                print("[CYR DEBUG] Item instance not found for ID:", itemID)
            end
        elseif name == "unequip" then
            if data.slot then
                netstream.Start("nut_unequip_slot", data.slot)
                timer.Simple(0.1, UpdateAll)
                sound.Play("nl_ui_pickup_item.wav", LocalPlayer():GetPos(), 75, 100, 0.35)
            end
        elseif name == "closeMenu" then
            frame:Close()
        elseif name == "openMenu" then
            OpenItemMenu(tonumber(data.itemID))
        elseif name == "saveSettings" then
            if data.primary then cookie.Set("cyr_f4_primary", data.primary) end
            if data.secondary then cookie.Set("cyr_f4_secondary", data.secondary) end
            if data.tertiary then cookie.Set("cyr_f4_tertiary", data.tertiary) end
        elseif name == "requestSettings" then
            local settings = {
                primary = cookie.GetString("cyr_f4_primary", "#FF4400"),
                secondary = cookie.GetString("cyr_f4_secondary", "#E0E0E0"),
                tertiary = cookie.GetString("cyr_f4_tertiary", "#FF0000")
            }

            SendToJS("loadSettings", settings)
        elseif name == "contextMenu" then
            OpenItemMenu(tonumber(data.itemID))
        elseif name == "showTooltip" then
            if CYR.UI and CYR.UI.ShowTooltip then
                data.colors = {
                    primary = cookie.GetString("cyr_f4_primary", "#FF4400"),
                    secondary = cookie.GetString("cyr_f4_secondary", "#E0E0E0"),
                    tertiary = cookie.GetString("cyr_f4_tertiary", "#1A1A1A")
                }

                CYR.UI.ShowTooltip(data, gui.MouseX(), gui.MouseY())
                sound.Play("nl_ui_menu_focus.wav", LocalPlayer():GetPos(), 75, 100, 0.35)
            end
        elseif name == "hideTooltip" then
            if CYR.UI and CYR.UI.HideTooltip then CYR.UI.HideTooltip() end
        elseif name == "combineItems" then
            print("[CYR DEBUG] combineItems webhook received - raw data:", data.sourceID, data.targetID)
            local sourceID = tonumber(data.sourceID)
            local targetID = tonumber(data.targetID)
            print("[CYR DEBUG] combineItems parsed IDs - source:", sourceID, "target:", targetID)
            if sourceID and targetID and sourceID ~= targetID then
                netstream.Start("cyrCombineItems", sourceID, targetID)
                sound.Play("os/button_6.wav", LocalPlayer():GetPos(), 75, 120, 0.35)
                timer.Simple(0.2, UpdateAll)
            else
                print("[CYR DEBUG] combineItems FAILED - invalid IDs or same item")
            end
        end
    end)

    html:SetHTML(CYR.UI.InventoryHTML or "<h1>ERROR: INVENTORY HTML NOT FOUND</h1>")
    timer.Simple(0.1, function()
        if IsValid(html) then
            print("[CYR DEBUG] Document Ready Timer - Calling UpdateAll")
            UpdateAll()
        end
    end)

    local uniqueID = "CYR_F1Menu_Update_" .. tostring(SysTime())
    hook.Add("InventoryItemAdded", uniqueID, function() timer.Simple(0, function() if IsValid(html) then UpdateAll() end end) end)
    hook.Add("InventoryItemRemoved", uniqueID, function() timer.Simple(0, function() if IsValid(html) then UpdateAll() end end) end)
    html.OnRemove = function()
        hook.Remove("InventoryItemAdded", uniqueID)
        hook.Remove("InventoryItemRemoved", uniqueID)
    end
end

hook.Remove("ShowSpare2", "CYR_F4Menu_Override")
hook.Remove("PlayerBindPress", "CYR_F4Menu_Override")