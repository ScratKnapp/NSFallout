-- 1. MAIN FRAME
CYR_UI = CYR_UI or {}
function OverridePaint()
    print("CYR INJECTION INTO BASE DERMAS")
    local nut_bar = vgui.GetControlTable("nutSkillBar")
    if not nut_bar then return end
    nut_bar.oldPaint = nut_bar.oldPaint or nut_bar.Paint
    nut_bar.Paint = function(self, w, h)
        surface.SetDrawColor(CYR.Primary)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    -- old init function
    nut_bar.oldInit = nut_bar.oldInit or nut_bar.Init
    nut_bar.Init = function(self)
        self:oldInit()
        self.bar.Paint = function(this, w, h)
            self.t = Lerp(FrameTime() * 10, self.t, 1)
            local value = (self.value / self.max) * self.t
            local boostedValue = self.boostValue or 0
            local barWidth = w * value
            surface.SetAlphaMultiplier(0.5)
            if value > 0 then
                -- your stat
                surface.SetDrawColor(CYR.Primary)
                surface.DrawRect(0, 0, barWidth, h)
            end

            -- boosted stat
            if boostedValue ~= 0 then
                local boostW = math.Clamp(math.abs(boostedValue / self.max), 0, 1) * w * self.t + 1
                if boostedValue < 0 then
                    surface.SetDrawColor(CYR.Primary)
                    surface.DrawRect(barWidth - boostW, 0, boostW, h)
                else
                    surface.SetDrawColor(CYR.PrimaryActive)
                    surface.DrawRect(barWidth, 0, boostW, h)
                end
            end

            surface.SetAlphaMultiplier(1)
        end

        self.add:SetImage("cyr/ui/PLUS.png")
        self.add:SetColor(CYR.Primary)
        self.sub:SetImage("cyr/ui/SUB.png")
        self.sub:SetColor(CYR.Primary)
    end

    vgui.Register("nutSkillBar", nut_bar, "DPanel")
    local nut_bar = vgui.GetControlTable("nutAttribBar")
    nut_bar.oldPaint = nut_bar.oldPaint or nut_bar.Paint
    nut_bar.Paint = function(self, w, h)
        surface.SetDrawColor(CYR.Primary)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    -- old init function
    nut_bar.oldInit = nut_bar.oldInit or nut_bar.Init
    nut_bar.Init = function(self)
        self:oldInit()
        self.bar.Paint = function(this, w, h)
            self.t = Lerp(FrameTime() * 10, self.t, 1)
            local value = (self.value / self.max) * self.t
            local boostedValue = self.boostValue or 0
            local barWidth = w * value
            surface.SetAlphaMultiplier(0.5)
            if value > 0 then
                -- your stat
                surface.SetDrawColor(CYR.Primary)
                surface.DrawRect(0, 0, barWidth, h)
            end

            -- boosted stat
            if boostedValue ~= 0 then
                local boostW = math.Clamp(math.abs(boostedValue / self.max), 0, 1) * w * self.t + 1
                if boostedValue < 0 then
                    surface.SetDrawColor(CYR.Primary)
                    surface.DrawRect(barWidth - boostW, 0, boostW, h)
                else
                    surface.SetDrawColor(CYR.PrimaryActive)
                    surface.DrawRect(barWidth, 0, boostW, h)
                end
            end

            surface.SetAlphaMultiplier(1)
        end

        self.add:SetImage("cyr/ui/PLUS.png")
        self.add:SetColor(CYR.Primary)
        self.sub:SetImage("cyr/ui/SUB.png")
        self.sub:SetColor(CYR.Primary)
    end

    vgui.Register("nutAttribBar", nut_bar, "DPanel")
end

OverridePaint()
hook.Add("InitializedPlugins", "CYR_OverrideSkillBarPaint", OverridePaint)
function PaintScrollBar(scroll)
    scroll:GetVBar().Paint = function(s, w, h)
        -- draw as solid color with outline
        surface.SetAlphaMultiplier(0.3)
        surface.SetDrawColor(CYR_UI.Primary)
        surface.DrawRect(0, 0, w, h)
        surface.SetAlphaMultiplier(1)
        surface.SetDrawColor(CYR_UI.Primary)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    scroll:GetVBar().btnGrip.Paint = function(s, w, h)
        surface.SetDrawColor(CYR_UI.Primary)
        surface.DrawRect(2, 2, w - 4, h - 4)
    end

    scroll:GetVBar():SetHideButtons(true)
end

-- Standalone F4 Menu Logic
include("cl_f4_html_content.lua") -- Ensure Inventory HTML is loaded
include("cl_tooltip.lua")
function CreateCYRWindow()
    if CYR_EQUIPMENTMENU and IsValid(CYR_EQUIPMENTMENU) then CYR_EQUIPMENTMENU:Remove() end
    local frame = vgui.Create("DFrame")
    CYR_EQUIPMENTMENU = frame
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
        if key == KEY_TAB then self:Remove() end
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
        json = json:gsub("\\", "\\\\"):gsub("\"", "\\\"")
        html:Call("Webhooks.trigger('" .. hookName .. "', JSON.parse(\"" .. json .. "\"))")
    end

    -- --- DATA FETCHING HELPERS ---
    local function GetItemData(item)
        if not item then return nil end
        local itemDef = nut.item.list[item.uniqueID] or {}
        local iconPath = "asset://garrysmod/materials/error.png"
        if itemDef.icon then
            iconPath = "asset://garrysmod/materials/" .. itemDef.icon
        elseif itemDef.model then
            local mdl = itemDef.model:lower():gsub("%.mdl$", ".png")
            iconPath = "asset://garrysmod/materials/spawnicons/" .. mdl
        end

        local amount = item:getData("Amount", item.defaultAmount) or item:getQuantity() or 1
        local maxstack = itemDef.maxstack or itemDef.maxQuantity or 1
        return {
            id = item:getID(),
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
        local char = LocalPlayer():getChar()
        if not char then return {} end
        local inv = char:getInv()
        if not inv then return {} end
        local items = {}
        for k, v in pairs(inv:getItems()) do
            table.insert(items, GetItemData(v))
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

    local function RunItemAction(itemID, actionKey, subData, suppressOnClick)
        print("[CYR EQUIP DEBUG] RunItemAction Called - ID:", itemID, "Key:", actionKey, "Suppress:", suppressOnClick)
        local item = nut.item.instances[itemID]
        if not item then
            print("[CYR EQUIP DEBUG] RunItemAction: Item not found for ID:", itemID)
            return
        end

        local func = item.functions[actionKey]
        if not func then
            print("[CYR EQUIP DEBUG] RunItemAction: Function not found for key:", actionKey)
            return false
        end

        item.player = LocalPlayer()
        -- Smart Slot Logic: Bypass onClick/menu if we can auto-pick a slot
        -- We run this BEFORE onCanRun check because sometimes onCanRun is strict about submenus/slots
        -- but we are manually defining the slot here.
        local handledSmart = false
        local isEquipAction = actionKey:lower() == "equip" or actionKey == "EquipSlot"
        if isEquipAction then
            local itemDef = nut.item.list[item.uniqueID]
            local isWeapon = item.isWeapon or (itemDef and itemDef.isWeapon) or (itemDef and itemDef.category and itemDef.category:lower() == "weapons")
            if isWeapon then
                print("[CYR EQUIP DEBUG] RunItemAction: Smart Slot Logic Triggered for Weapon")
                local equip = LocalPlayer():getEquip() or {}
                local preferredSlot = itemDef.slot or "sidearm"
                -- Check for specialSlot (EquipSlot)
                if item.specialSlot then
                    if istable(item.specialSlot) then
                        preferredSlot = item.specialSlot[1] -- Default to first
                        local slotLower = preferredSlot:lower()
                        -- Check case-insensitive against "sidearm"
                        if slotLower == "sidearm" and equip["sidearm"] and not equip["primary"] then
                            -- Check if primary is an option
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
                -- Standard fallback logic if not specialSlot handled above
                if not item.specialSlot then
                    -- Check for weapon category or standard slot fallback
                    -- If item has no specialSlot but is a weapon, it might default to sidearm in definition
                    -- But here preferredSlot is already set from itemDef.slot or "sidearm"
                    local slotLower = preferredSlot:lower()
                    if slotLower == "sidearm" and equip["sidearm"] and not equip["primary"] then targetSlot = "primary" end
                end

                -- Directly trigger the equip netstream
                print("[CYR EQUIP DEBUG] Sending smart equip netstream to:", targetSlot)
                -- Should use EquipSlot key if that's what we are running, or Equip?
                -- If we found EquipSlot, actionKey is EquipSlot.
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
            print("[CYR EQUIP DEBUG] RunItemAction: onCanRun returned false")
            item.player = nil
            return
        end

        local send = true
        -- Smart Slot Logic: Bypass onClick/menu if we can auto-pick a slot
        if actionKey:lower() == "equip" then
            local itemDef = nut.item.list[item.uniqueID]
            if itemDef and itemDef.category == "weapon" then
                print("[CYR EQUIP DEBUG] RunItemAction: Smart Slot Logic Triggered")
                local equip = LocalPlayer():getEquip() or {}
                local preferredSlot = itemDef.slot or "sidearm"
                local targetSlot = preferredSlot
                -- If sidearm is taken and it's a sidearm, try primary
                if preferredSlot == "sidearm" and equip["sidearm"] and not equip["primary"] then targetSlot = "primary" end
                -- Directly trigger the equip netstream
                print("[CYR EQUIP DEBUG] Sending smart equip netstream to:", targetSlot)
                netstream.Start("invAct", actionKey, item.id, item.invID, targetSlot)
                send = false
            end
        end

        if send ~= false and not suppressOnClick then
            print("[CYR EQUIP DEBUG] RunItemAction: Checking onClick")
            -- Fallback to default onClick (might open a menu)
            if func.onClick then
                print("[CYR EQUIP DEBUG] RunItemAction: Executing onClick")
                send = func.onClick(item)
            end
        elseif suppressOnClick then
            print("[CYR EQUIP DEBUG] RunItemAction: Suppressed onClick")
        end

        if send ~= false then
            print("[CYR EQUIP DEBUG] RunItemAction: Sending default invAct netstream")
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
        if name == "playSound" then
            if data.sound then surface.PlaySound(data.sound) end
        elseif name == "useItem" then
            local itemID = tonumber(data.itemID)
            print("[CYR EQUIP DEBUG] Webhook useItem - ID:", itemID)
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
                print("[CYR EQUIP DEBUG] Item:", safeName)
                print("[CYR EQUIP DEBUG] Found keys - EquipSlot:", equipSlotKey, "Equip:", equipKey, "Wear:", wearKey)
                -- Helper to check and run
                local function tryRun(key)
                    if not key then return false end
                    local func = item.functions[key]
                    if not func then
                        print("[CYR EQUIP DEBUG] No function for key:", key)
                        return false
                    end

                    item.player = LocalPlayer()
                    local canRun = true
                    -- BYPASS: If this is a Weapon Equip, we bypass the strict onCanRun check
                    -- because RunItemAction has smart logic to handle it (and onCanRun might fail for submenus)
                    local itemDef = nut.item.list[item.uniqueID]
                    local isWeapon = item.isWeapon or (itemDef and itemDef.isWeapon) or (itemDef and itemDef.category and itemDef.category:lower() == "weapons")
                    local isEquip = key == equipKey or key == equipSlotKey
                    if isWeapon and isEquip then
                        print("[CYR EQUIP DEBUG] Bypassing onCanRun for Weapon Smart Equip")
                    else
                        if isfunction(func.onCanRun) and not func.onCanRun(item) then
                            canRun = false
                            print("[CYR EQUIP DEBUG] onCanRun failed for:", key)
                        end
                    end

                    item.player = nil
                    if canRun then
                        print("[CYR EQUIP DEBUG] Attempting to run:", key)
                        RunItemAction(itemID, key, nil, true) -- true = suppress onClick
                        if isEquip then sound.Play("nl_ui_pickup_item.wav", LocalPlayer():GetPos(), 75, 100, 0.35) end
                        return true
                    end
                    return false
                end

                if tryRun(equipSlotKey) then return end
                if tryRun(equipKey) then return end
                if tryRun(wearKey) then return end
                print("[CYR EQUIP DEBUG] No valid Equip/Wear action found. Doing nothing. (Use Right Click for Menu)")
            else
                print("[CYR EQUIP DEBUG] Item instance not found for ID:", itemID)
            end
        elseif name == "unequip" then
            if data.slot then
                netstream.Start("nut_unequip_slot", data.slot)
                sound.Play("nl_ui_pickup_item.wav", LocalPlayer():GetPos(), 75, 100, 0.35)
                timer.Simple(0.1, UpdateAll)
            end
        elseif name == "closeMenu" then
            if IsValid(frame) then frame:Remove() end
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
            OpenItemMenu(data.itemID)
        elseif name == "showTooltip" then
            if CYR.UI and CYR.UI.ShowTooltip then
                sound.Play("nl_ui_menu_focus.wav", LocalPlayer():GetPos(), 75, 100, 0.35)
                data.colors = {
                    primary = cookie.GetString("cyr_f4_primary", "#FF4400"),
                    secondary = cookie.GetString("cyr_f4_secondary", "#E0E0E0"),
                    tertiary = cookie.GetString("cyr_f4_tertiary", "#FF0000")
                }

                CYR.UI.ShowTooltip(data, gui.MouseX(), gui.MouseY())
            end
        elseif name == "hideTooltip" then
            if CYR.UI and CYR.UI.HideTooltip then CYR.UI.HideTooltip() end
        elseif name == "combineItems" then
            local sourceID = tonumber(data.sourceID)
            local targetID = tonumber(data.targetID)
            print("[CYR EQUIP DEBUG] combineItems webhook received - source:", sourceID, "target:", targetID)
            if sourceID and targetID and sourceID ~= targetID then
                netstream.Start("cyrCombineItems", sourceID, targetID)
                sound.Play("os/button_6.wav", LocalPlayer():GetPos(), 75, 120, 0.35)
                timer.Simple(0.2, UpdateAll)
            else
                print("[CYR EQUIP DEBUG] combineItems FAILED - invalid IDs or same item")
            end
        end
    end)

    -- Inject HTML Content (Use InventoryHTML)
    html:SetHTML(CYR.UI.InventoryHTML or "<h1>ERROR: INVENTORY HTML NOT FOUND</h1>")
    timer.Simple(0.1, function() if IsValid(html) then UpdateAll() end end)
    local uniqueID = "CYR_F4Menu_Update_" .. tostring(SysTime())
    hook.Add("InventoryItemAdded", uniqueID, function() timer.Simple(0, function() if IsValid(html) then UpdateAll() end end) end)
    hook.Add("InventoryItemRemoved", uniqueID, function() timer.Simple(0, function() if IsValid(html) then UpdateAll() end end) end)
    html.OnRemove = function()
        hook.Remove("InventoryItemAdded", uniqueID)
        hook.Remove("InventoryItemRemoved", uniqueID)
    end
end

-- Refresh if open
if CYR_EQUIPMENTMENU and IsValid(CYR_EQUIPMENTMENU) then
    CYR_EQUIPMENTMENU:Remove()
    CreateCYRWindow()
end

if netstream then
    netstream.Hook("nut_UpdateTraits", function() hook.Run("OnCharacterTraitUpdate") end)
    netstream.Hook("nut_skill_increase", function() hook.Run("OnNut_skill_increase") end)
    netstream.Hook("nut_stat_increase", function() hook.Run("OnNut_stat_increase") end)
end

hook.Remove("PlayerBindPress", "CYR_F4_Open")
hook.Remove("Think", "OnThinkF4")