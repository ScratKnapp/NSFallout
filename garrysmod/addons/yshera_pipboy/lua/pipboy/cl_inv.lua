local categories = {"AID", "AMMO", "ARMOR", "FOOD", "WEAPONS"}
-- sort categories by alphabetical order
table.sort(categories)
table.insert(categories, 1, "ALL")
table.insert(categories, "MISC")

-- Old schema used .MaxHP / "HP"; fallout uses .durability / "durability".
local function maxHp(it)
    return it.MaxHP or it.durability or 100
end
local function curHp(it)
    return it:getData("HP", it:getData("durability", maxHp(it)))
end
local cachedpos = {}
local cachedsizes = {}
local inventory = {}
local player = LocalPlayer()
inventory.focus = 1
local Scroll_POS = 0
local function sum(t)
    local s = 0
    for k, v in pairs(t) do
        s = s + v
    end
    return s
end

local gui = nil
-- Effective stack cap, honouring the nwl_stack_size convar (cyr_main).
local function effMaxStack(maxstack)
    if NWL and NWL.GetStackLimit then return NWL.GetStackLimit(maxstack) end
    return maxstack
end
local function IsStackable(item)
    if item.baseStackable then return 1 end
    if item.Stackable then return 2 end
    return false
end

function clearinv()
    player = LocalPlayer()
    local char = player:getChar()
    if not char then return end
    local inventory = char:getInv()
    if not inventory then return end

    local items          = {} -- stackKey -> count (number of instances in this stack)
    local iteminstances  = {} -- stackKey -> array of item ids
    local stackUID       = {} -- stackKey -> uniqueID  (for nut.item.list lookups)
    local firstInstances = {} -- stackKey -> first item instance for the stack
    local partialStacks  = {} -- uniqueID -> {key, count, max, nextIdx} for in-progress packing
    local seen           = {}

    -- Stacking policy: customisable classes (functions.Custom/CustomAtr),
    -- instance custom/equip data, and PreventStacks all force one row per
    -- instance. Otherwise stack when maxStack > 1, packing into buckets of
    -- that size so a row's count never exceeds maxStack.
    local function uniqueKey(v) return v.uniqueID .. "@" .. v.id end
    local function getStackKey(v, cls)
        if cls.PreventStacks then return uniqueKey(v) end
        local fns = cls.functions
        if fns and (fns.Custom or fns.CustomAtr) then
            return uniqueKey(v)
        end
        local d = v.data or {}
        local custom  = d.custom
        local customW = d.customW
        if (custom and next(custom) ~= nil)
            or (customW and next(customW) ~= nil)
            or d.infused or d.edited or d.equip then
            return uniqueKey(v)
        end

        local maxStack = tonumber(cls.maxStack) or 1
        if maxStack <= 1 then return uniqueKey(v) end

        -- Pack into the current bucket; spill into a fresh one at the cap.
        local ps = partialStacks[v.uniqueID]
        if ps and ps.count < ps.max then
            ps.count = ps.count + 1
            return ps.key
        end
        local nextIdx = (ps and ps.nextIdx) or 1
        partialStacks[v.uniqueID] = {
            key     = v.uniqueID .. "#" .. nextIdx,
            count   = 1,
            max     = maxStack,
            nextIdx = nextIdx + 1,
        }
        return partialStacks[v.uniqueID].key
    end

    local function addItem(v)
        if not v or not v.uniqueID or seen[v.id] then return end
        seen[v.id] = true
        local cls = nut.item.list[v.uniqueID]
        if not cls then return end

        local key = getStackKey(v, cls)
        stackUID[key] = v.uniqueID

        items[key] = (items[key] or 0) + 1

        if not firstInstances[key] then firstInstances[key] = v end

        local tbl = iteminstances[key] or {}
        table.insert(tbl, v.id)
        iteminstances[key] = tbl
    end

    for _, v in pairs(inventory:getItems()) do
        addItem(v)
    end

    -- Equipped items are pulled out of the inventory by addEquip, so add
    -- them back from the char's equip table to keep them in the listing.
    if isfunction(player.getEquip) then
        for _, itemID in pairs(player:getEquip() or {}) do
            local v = nut.item.instances[itemID]
            if v then addItem(v) end
        end
    end

    tablet.Inventory = {
        items          = items,
        instances      = iteminstances,
        stackUID       = stackUID,
        firstInstances = firstInstances,
    }
end

local og = {
    ["$pp_colour_addr"] = 0,
    ["$pp_colour_addg"] = 0,
    ["$pp_colour_addb"] = 0,
    ["$pp_colour_brightness"] = 0,
    ["$pp_colour_contrast"] = 1,
    ["$pp_colour_colour"] = 0,
    ["$pp_colour_mulr"] = 0,
    ["$pp_colour_mulg"] = 0,
    ["$pp_colour_mulb"] = 0
}

local function GetITEMS()
    local inventory, Inventory = LocalPlayer():getChar():getInv(), {}
    local items = {}
    local iteminstances = {}
    for i, v in pairs(inventory:getItems()) do
        local item = nut.item.list[v.uniqueID]
        items[item.uniqueID] = (items[item.uniqueID] and items[item.uniqueID] or 0) + 1
        local tbl = iteminstances[item.uniqueID] or {}
        table.insert(tbl, v.id)
        iteminstances[item.uniqueID] = tbl
        --item.functions.drop
    end
    return {
        items = items,
        instances = iteminstances
    }
end

FUSION_ITEM_BUTTON_SIZE = {
    w = 550,
    h = 36,
    ho = 36
}

local ITEMDESCOFFSET = {
    x = 675,
    xT = 680,
    w = 320
}

local InventoryModelView
--we need to set it to a Vector not a Color, so the values are normal RGB values divided by 255.
local indexx = math.random(1, 100000000)
local iTexFlags = bit.bor(1, 262144, 32768, 8388608, 2048, 4, 8)
local tex = GetRenderTargetEx("texture_woA" .. indexx, 256, 256, RT_SIZE_OFFSCREEN, MATERIAL_RT_DEPTH_NONE, 0, 0, IMAGE_FORMAT_RGBA16161616) --[[IMPORTANT]]
local myMat = CreateMaterial("test3x2" .. indexx, "UnlitGeneric", {
    ["$basetexture"] = tex:GetName(),
    ["$translucent"] = "1",
    ["$vertexcolor"] = 1
})

local Mask_Tex = GetRenderTargetEx("mask4-" .. indexx, 256, 256, RT_SIZE_OFFSCREEN, MATERIAL_RT_DEPTH_SEPARATE, 4096, 0, IMAGE_FORMAT_RGBA16161616) --[[IMPORTANT]]
local mat_color = Material("pp/colour")
mat_color:SetFloat("$translucent", "1")
local function RenderColorBlendSpace()
    local tab = {
        ["$pp_colour_addr"] = 0,
        ["$pp_colour_addg"] = 0,
        ["$pp_colour_addb"] = 0,
        ["$pp_colour_brightness"] = -0.01,
        ["$pp_colour_contrast"] = 5,
        ["$pp_colour_colour"] = 0,
        ["$pp_colour_mulr"] = 0,
        ["$pp_colour_mulg"] = 0,
        ["$pp_colour_mulb"] = 0
    }

    for k, v in pairs(tab) do
        mat_color:SetFloat(k, v)
    end

    local pre = mat_color:GetTexture("$fbtexture")
    local txname = Mask_Tex:GetName()
    mat_color:SetTexture("$fbtexture", Mask_Tex:GetName())
    surface.SetMaterial(mat_color)
    surface.DrawTexturedRect(0, 0, 400, 300)
    mat_color:SetTexture("$fbtexture", pre)
end

local function PopBollc()
    render.PushRenderTarget(Mask_Tex)
    cam.Start2D()
    render.ClearDepth()
    render.Clear(0, 0, 0, 0, true, true)
    render.SetWriteDepthToDestAlpha(false)
    InventoryModelView:PaintManual()
    render.SetWriteDepthToDestAlpha(true)
    cam.End2D()
    render.PopRenderTarget()
    render.PushRenderTarget(tex)
    cam.Start2D()
    RenderColorBlendSpace()
    cam.End2D()
    render.PopRenderTarget()
end

local tab = {
    ["$pp_colour_addr"] = 6 / 255,
    ["$pp_colour_addg"] = 12 / 255,
    ["$pp_colour_addb"] = 12 / 255,
    ["$pp_colour_brightness"] = 0,
    ["$pp_colour_contrast"] = 0.52,
    ["$pp_colour_colour"] = 0.8,
    ["$pp_colour_mulr"] = 4 / 255,
    ["$pp_colour_mulg"] = 16 / 255,
    ["$pp_colour_mulb"] = 16 / 255
}

ITEM_DRAWN_THIS_FRAME = nil
-- Constant left indent on every row, reserving space for the equipped
-- indicator box so names stay aligned whether or not a row is equipped.
local EQUIP_BOX_PAD  = 6
local EQUIP_BOX_SIZE = 18
local EQUIP_INDENT   = EQUIP_BOX_SIZE + EQUIP_BOX_PAD

-- Slot → indicator digit. Only primary/sidearm get a digit (1/2);
-- other slots show the box with no number.
local EQUIP_SLOT_LABELS = {
    primary = "1",
    sidearm = "2",
}

local function getInstanceEquipSlot(inst)
    if not inst then return nil end
    if isfunction(inst.getData) and inst:getData("equip") then
        -- Weapons store their slot in data "equipSlot"; equipment classes
        -- carry a static .slot. Prefer the data, fall back to the class.
        local slot = inst:getData("equipSlot") or inst.slot
        if slot then return slot end
    end
    local plr = LocalPlayer()
    if isfunction(plr.getEquip) then
        for slot, id in pairs(plr:getEquip() or {}) do
            if id == inst.id then return slot end
        end
    end
    return nil
end

local function isInstanceEquipped(inst)
    if not inst then return false end
    if isfunction(inst.getData) and inst:getData("equip") then return true end
    return getInstanceEquipSlot(inst) ~= nil
end

local function drawItem(item3, y, pip_color, _amt, ITEM_INSTANCE_RRA)
    --if item then PrintTable(tablet.Inventory.data) end
    surface.SetDrawColor(pip_color)
    --surface.DrawOutlinedRect(-420, 0, 400, 55)
    local item = nut.item.list[item3]
    local inst = item
    -- A stack is one instance carrying an `Amount`; fall back to the
    -- row's instance-bucket count (_amt) for anything not using Amount.
    local amount = 1
    if ITEM_INSTANCE_RRA and isfunction(ITEM_INSTANCE_RRA.getData) then
        amount = tonumber(ITEM_INSTANCE_RRA:getData("Amount")) or 1
    end
    local shown = math.max(amount, _amt or 1)
    local name = (ITEM_INSTANCE_RRA or item):getName()
    local cc = shown > 1 and (" (" .. shown .. ")") or ""
    local rowX = 86 + EQUIP_INDENT
    local rowW = FUSION_ITEM_BUTTON_SIZE.w - EQUIP_INDENT
    local rowY = 116 + (y * FUSION_ITEM_BUTTON_SIZE.ho)
    local fn, click, draww = NzGUI:DrawTextButtonWithDelayedHover(string.upper(name) .. cc, MainFontName .. "@42", rowX, rowY, rowW, FUSION_ITEM_BUTTON_SIZE.h, 1, color_white, color_black, 0, pip_color)

    -- While the action menu is open, pin the highlight to its item so
    -- cursor hover doesn't light up neighbouring rows.
    if PIP_INV_MENU then
        local isMenuItem = ITEM_INSTANCE_RRA and ITEM_INSTANCE_RRA.id == PIP_INV_MENU.itemID
        fn = isMenuItem and true or false
    end

    if fn and InventoryModelView and InventoryModelView.Entity then
        ITEM_DRAWN_THIS_FRAME = ITEM_INSTANCE_RRA or nut.item.list[item3]
        surface.SetDrawColor(pip_color_accent.r, pip_color_accent.g, pip_color_accent.b, 100)
        surface.DrawRect(86, 120 + (y * FUSION_ITEM_BUTTON_SIZE.ho), FUSION_ITEM_BUTTON_SIZE.w, FUSION_ITEM_BUTTON_SIZE.h)
        InventoryModelView.Angle = inst.Angle or angle_zero
        local headpos = InventoryModelView.Entity:GetPos()
        InventoryModelView:SetLookAt(headpos)
        InventoryModelView:SetCamPos(headpos - Vector(-15, 0, 0))
        draww()
        PopBollc()
        -- if inst.Icon then
        InventoryModelView:SetModel(inst.model or "models/props_junk/cardboard_box001a.mdl")
        InventoryModelView:Guess()
        local m = myMat
        surface.SetMaterial(m)
        local x, y = 256, 256
        if x and y then
            local ratio = x / y
            local size = 256
            local width = 256
            surface.DrawTexturedRect(ITEMDESCOFFSET.x, 35, size, size)
            draw.NoTexture()
        end

        local heightOfBoxes = 24
        local heightOfBoxesPadding = 2
        --end
        surface.DrawRect(ITEMDESCOFFSET.x, 230, ITEMDESCOFFSET.w + 2, heightOfBoxes)
        draw.SimpleText("VALUE: " .. (inst.value or 0), MainFontName .. "@32", ITEMDESCOFFSET.xT, 225, color_white, TEXT_ALIGN_LEFT)
        surface.DrawRect(ITEMDESCOFFSET.x, 230 + heightOfBoxes + heightOfBoxesPadding, ITEMDESCOFFSET.w + 2, heightOfBoxes)
        draw.SimpleText("TYPE: " .. (inst.category or "MISC"), MainFontName .. "@32", ITEMDESCOFFSET.xT, 225 + heightOfBoxes + heightOfBoxesPadding, color_white, TEXT_ALIGN_LEFT)
        surface.DrawRect(ITEMDESCOFFSET.x, 230 + heightOfBoxes + heightOfBoxes + heightOfBoxesPadding + heightOfBoxesPadding, ITEMDESCOFFSET.w + 2, heightOfBoxes)
        draw.SimpleText("WEIGHT: " .. (item.weight or "0"), MainFontName .. "@32", ITEMDESCOFFSET.xT, 230 + heightOfBoxes + heightOfBoxes, color_white, TEXT_ALIGN_LEFT)
        --surface.DrawRect(ITEMDESCOFFSET.x, 499 + heightOfBoxes + heightOfBoxes + heightOfBoxesPadding + heightOfBoxesPadding, ITEMDESCOFFSET.w + 2, heightOfBoxes)
        --draw.SimpleText("Body Dr: " .. (item.resisbody or "0"), MainFontName .. "@32", ITEMDESCOFFSET.xT, 499 + heightOfBoxes + heightOfBoxes, color_white, TEXT_ALIGN_LEFT)
        --surface.DrawRect(ITEMDESCOFFSET.x, 525 + heightOfBoxes + heightOfBoxes + heightOfBoxesPadding + heightOfBoxesPadding, ITEMDESCOFFSET.w + 2, heightOfBoxes)
        --draw.SimpleText("Head Dr: " .. (item.resishead or "0"), MainFontName .. "@32", ITEMDESCOFFSET.xT, 525 + heightOfBoxes + heightOfBoxes, color_white, TEXT_ALIGN_LEFT)
        local heightOffset = 0
        local prevWidth = 0
        local endMargin = 2
        local buildup = 0
        local buildupAmount = 0
        local start = 251 + heightOfBoxes + heightOfBoxes + heightOfBoxesPadding + heightOfBoxesPadding
        if inst.struct then
            for i, v in pairs((ITEM_INSTANCE_RRA or inst):struct(inst)) do
                buildupAmount = buildupAmount + 1
                buildup = buildup + math.abs(v[1])
                if buildup == 1 then endMargin = buildupAmount * 2 - 4 end
                if v[1] < 0 then
                    draw.SimpleText(v[2], MainFontName .. "@32", ITEMDESCOFFSET.xT + prevWidth - endMargin - (ITEMDESCOFFSET.w * v[1] * 0.5) - 10, start + heightOffset, color_white, TEXT_ALIGN_CENTER)
                else
                    if v[2] then
                        if v[4] == nil then surface.DrawRect(ITEMDESCOFFSET.x + prevWidth, start + 5 + heightOffset, ITEMDESCOFFSET.w * v[1] - endMargin, heightOfBoxes) end
                        draw.SimpleText(v[2], MainFontName .. "@32", ITEMDESCOFFSET.xT + prevWidth - endMargin, start + heightOffset, color_white, TEXT_ALIGN_LEFT)
                    end

                    if v[3] then
                        surface.SetTextColor(v[3])
                        surface.DrawText(v[4])
                    end
                end

                prevWidth = prevWidth + ITEMDESCOFFSET.w * v[1] + 2
                if buildup == 1 then
                    heightOffset = heightOffset + heightOfBoxes + heightOfBoxesPadding
                    prevWidth = 0
                    endMargin = 0
                    buildup = 0
                    buildupAmount = 0
                end
            end
        end

        if IsUseDown and (_G.EatTimer or 0) > CurTime() then IsUseDown = false end
        -- ITEM_INSTANCE_RRA is the row's instance; alias for clarity.
        local function resolveInstance()
            return ITEM_INSTANCE_RRA
        end
        local function equipToggle(v, slot)
            if not v then return end
            if isfunction(v.getData) and v:getData("equip") then
                netstream.Start("invAct", "EquipUn", v.id, v:getID(), slot)
            elseif v.isWeapon then
                netstream.Start("invAct", "Equip", v.id, v:getID(), slot)
            elseif v.functions and v.functions.EquipSlot then
                local specialSlot = istable(v.specialSlot) and v.specialSlot[1] or v.specialSlot
                netstream.Start("invAct", "EquipSlot", v.id, v:getID(), slot or specialSlot)
            elseif v.functions and v.functions.Equip then
                netstream.Start("invAct", "Equip", v.id, v:getID(), slot)
            else
                netstream.Start("invAct", "use", v.id, v:getID(), v.id)
                _G.EatTimer = CurTime() + 0.5
                if v.functions and v.functions.use and v.functions.use.onRunClient then
                    v.functions.use.onRunClient(v)
                end
            end
        end
        -- Item-row inputs are inert while a menu/selector owns the click.
        if not PIP_INV_MENU and not PIP_DROP_SELECTOR then
            if IsUseDown then
                IsUseDown = false
                local v = resolveInstance()
                if v then
                    netstream.Start("invAct", "use", v.id, v:getID(), v.id)
                    _G.EatTimer = CurTime() + 0.5
                    if v.functions and v.functions.use and v.functions.use.onRunClient then
                        v.functions.use.onRunClient(v)
                    end
                end
            elseif click then
                equipToggle(resolveInstance(), nil)
                _G.EatTimer = CurTime() + 0.25
            elseif IsRightMouseDown then
                IsRightMouseDown = false
                local v = resolveInstance()
                if v then
                    OPEN_PIP_INV_MENU(v, cursor.x, cursor.y)
                    _G.EatTimer = CurTime() + 0.25
                end
            elseif IsReloadUse then
                IsReloadUse = false
                local v = resolveInstance()
                if v then
                    local cls = nut.item.list[v.uniqueID]
                    local maxstack = effMaxStack(cls and cls.maxstack)
                    local amount = tonumber(v:getData("Amount")) or 1
                    if maxstack and maxstack > 1 and amount > 1 then
                        OPEN_PIP_DROP_SELECTOR(v)
                    else
                        netstream.Start("invAct", "drop", v.id, v:getID(), v.id)
                    end
                end
            end
        end
    else
        draww()
    end

    if inst.DrawLabel and ITEM_INSTANCE_RRA then ITEM_INSTANCE_RRA:DrawLabel(86, 116 + (y * FUSION_ITEM_BUTTON_SIZE.ho)) end

    -- Equipped indicator box in the left indent. Drawn last so it sits
    -- atop the hover highlight; primary/sidearm also get a slot digit.
    if isInstanceEquipped(ITEM_INSTANCE_RRA) then
        local boxX = 86 + math.floor(EQUIP_BOX_PAD * 0.5)
        local boxY = rowY + math.floor((FUSION_ITEM_BUTTON_SIZE.h - EQUIP_BOX_SIZE) * 0.5)
        surface.SetDrawColor(color_white)
        surface.DrawRect(boxX, boxY, EQUIP_BOX_SIZE, EQUIP_BOX_SIZE)

        local slot = getInstanceEquipSlot(ITEM_INSTANCE_RRA)
        local digit = slot and EQUIP_SLOT_LABELS[slot]
        if digit then
            draw.SimpleText(
                digit, MainFontName .. "@32",
                boxX + math.floor(EQUIP_BOX_SIZE * 0.5),
                boxY + math.floor(EQUIP_BOX_SIZE * 0.5) - 2,
                color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
            )
        end
    end
end

hook.Add("ItemDataChanged", "ItemDataChanged", function() clearinv() end)
hook.Add("InventoryItemRemoved", "invDatainvData", function() clearinv() end)
hook.Add("ItemInitialized", "ItemInitializedItemInitialized", function() timer.Simple(0, clearinv) end)
-- char:getData("equip") changes aren't covered by the item-data /
-- inventory-removed hooks, so refresh here too or the indicator goes stale.
hook.Add("NutUpdateEquipSlots", "PipboyEquipUpdate", function() clearinv() end)
last_item_page_draw_amt = 0
local color_gray = Color(255, 255, 255, 25)
local color_bright_Gray = Color(255, 255, 255, 55)

-- In-pipboy item action dropdown. Mirrors nutscript's openActionMenu
-- (merges functionsB/functions/functionsD, filters via onCanRun, emits
-- invAct), flattening isMulti entries into one row each. Hand-drawn
-- rather than DermaMenu because the pipboy uses its own in-RT cursor.
PIP_INV_MENU = nil

local function pipInvMenuPlaySound(snd)
    if not snd then return end
    if type(snd) == "table" then
        LocalPlayer():EmitSound(unpack(snd))
    elseif type(snd) == "string" then
        surface.PlaySound(snd)
    end
end

-- specialSlot items live in char:getData("equip"), never set item.data.equip,
-- so their own EquipUn.onCanRun fails. Detect the char slot here so we can
-- inject a synthetic Unequip via the nut_unequip_slot netstream instead.
local function pipInvMenuCharEquipSlot(itemTable)
    if not itemTable or not itemTable.id then return nil end
    local plr = LocalPlayer()
    if not isfunction(plr.getEquip) then return nil end
    for slot, id in pairs(plr:getEquip() or {}) do
        if id == itemTable.id then return slot end
    end
    return nil
end

local function pipInvMenuBuildOptions(itemTable)
    local charSlot = pipInvMenuCharEquipSlot(itemTable)

    local merged = {}
    for k, v in pairs(itemTable.functionsB or {}) do merged[k] = v end
    for k, v in pairs(itemTable.functions  or {}) do merged[k] = v end
    for k, v in pairs(itemTable.functionsD or {}) do merged[k] = v end

    local list = {}

    -- Synthetic Unequip for char.equip-tracked items.
    if charSlot then
        list[#list + 1] = {
            label       = L("Unequip"),
            actionKey   = "nut_unequip_slot",
            data        = charSlot,
            isCharEquip = true,
        }
    end

    -- Detect equipped state (both paths) to hide drop; equipped items
    -- must be unequipped first or the SWEP/buffs desync from the dropped item.
    local isEquipped = charSlot ~= nil
        or (isfunction(itemTable.getData) and itemTable:getData("equip") and true or false)

    for k, v in SortedPairs(merged) do
        -- Hide re-equip entries for char.equip-slotted items (the
        -- synthetic Unequip above is all they need).
        if charSlot and (k == "Equip" or k == "EquipSlot") then continue end
        -- Hide drop on equipped items: requires Unequip first.
        if isEquipped and k == "drop" then continue end
        if isfunction(v.onCanRun) and not v.onCanRun(itemTable) then continue end
        if v.isMulti then
            local subs = isfunction(v.multiOptions)
                and v.multiOptions(itemTable, LocalPlayer())
                or v.multiOptions
            if istable(subs) then
                for _, sub in pairs(subs) do
                    list[#list + 1] = {
                        label     = L(v.name or k) .. ": " .. tostring(sub.name or ""),
                        actionKey = k,
                        action    = v,
                        data      = sub.data,
                    }
                end
            end
        else
            list[#list + 1] = {
                label     = L(v.name or k),
                actionKey = k,
                action    = v,
                data      = nil,
            }
        end
    end

    -- Synthetic Merge: only when there's more than one stack to combine.
    local cls = nut.item.list[itemTable.uniqueID]
    local maxstack = effMaxStack(cls and cls.maxstack)
    if maxstack and maxstack > 1 then
        local inv = LocalPlayer():getChar():getInv()
        if inv and #inv:getItemsOfType(itemTable.uniqueID) > 1 then
            list[#list + 1] = {
                label   = "Merge",
                isMerge = true,
            }
        end
    end

    return list
end

function OPEN_PIP_INV_MENU(itemTable, x, y)
    if not itemTable then return end
    itemTable.player = LocalPlayer()
    local options = pipInvMenuBuildOptions(itemTable)
    itemTable.player = nil
    if #options == 0 then PIP_INV_MENU = nil; return end

    local inv = LocalPlayer():getChar():getInv()
    PIP_INV_MENU = {
        x       = x,
        y       = y,
        options = options,
        itemID  = itemTable:getID(),
        invID   = inv and inv:getID() or nil,
        -- Seed with current LMB state so a held button isn't read as a click.
        lmbPrev = input.IsMouseDown(MOUSE_LEFT),
    }
end

local function pipInvMenuRun(opt)
    local menu = PIP_INV_MENU
    if not menu then return end
    local itemTable = nut.item.instances[menu.itemID]
    if not itemTable then PIP_INV_MENU = nil; return end

    -- Stack drop: open the quantity selector instead of dropping the whole stack.
    if opt.actionKey == "drop" then
        local cls = nut.item.list[itemTable.uniqueID]
        local maxstack = effMaxStack(cls and cls.maxstack)
        local amount = tonumber(itemTable:getData("Amount")) or 1
        if maxstack and maxstack > 1 and amount > 1 then
            PIP_INV_MENU = nil
            OPEN_PIP_DROP_SELECTOR(itemTable)
            return
        end
    end

    -- Merge action: compact partial stacks (handled in sv_stacking.lua).
    if opt.isMerge then
        pipInvMenuPlaySound(SOUND_INVENTORY_INTERACT or nil)
        netstream.Start("cyrMergeStacks", itemTable.uniqueID)
        PIP_INV_MENU = nil
        return
    end

    -- Synthetic Unequip: frees the char.equip slot and returns the item.
    if opt.isCharEquip then
        pipInvMenuPlaySound(SOUND_INVENTORY_INTERACT or nil)
        netstream.Start("nut_unequip_slot", opt.data, itemTable.id)
        PIP_INV_MENU = nil
        return
    end

    itemTable.player = LocalPlayer()
    local send = true
    if isfunction(opt.action.onClick) then
        send = opt.action.onClick(itemTable, opt.data)
    end
    pipInvMenuPlaySound(opt.action.sound or (SOUND_INVENTORY_INTERACT or nil))
    if send ~= false then
        netstream.Start("invAct", opt.actionKey, itemTable.id, menu.invID, opt.data)
    end
    itemTable.player = nil
    PIP_INV_MENU = nil
end

local function pipInvMenuDraw()
    local menu = PIP_INV_MENU
    if not menu then return end

    local rowH = 36
    local pad  = 10
    surface.SetFont(MainFontName .. "@32")
    local maxW = 0
    for _, opt in ipairs(menu.options) do
        local w = surface.GetTextSize(opt.label)
        if w > maxW then maxW = w end
    end
    local menuW = math.max(220, maxW + pad * 2)
    local menuH = rowH * #menu.options + pad

    local screenW = WIDTH or 1300
    local screenH = HEIGHT or 800
    local mx = math.Clamp(menu.x, 0, screenW - menuW)
    local my = math.Clamp(menu.y, 0, screenH - menuH)

    surface.SetDrawColor(0, 0, 0, 230)
    surface.DrawRect(mx, my, menuW, menuH)
    surface.SetDrawColor(pip_color)
    surface.DrawOutlinedRect(mx, my, menuW, menuH)

    -- Raw-input rising-edge click detection (the AddUIButton pulse was
    -- already consumed by the rows), so each press fires once.
    local lmbHeld = input.IsMouseDown(MOUSE_LEFT)
    local justClicked = lmbHeld and not menu.lmbPrev
    menu.lmbPrev = lmbHeld

    local hoveredOpt
    for i, opt in ipairs(menu.options) do
        local ry = my + math.floor(pad * 0.5) + (i - 1) * rowH
        local inside = cursor.x >= mx and cursor.x <= mx + menuW
                   and cursor.y >= ry  and cursor.y <= ry + rowH
        if inside then
            surface.SetDrawColor(pip_color)
            surface.DrawRect(mx + 2, ry, menuW - 4, rowH)
            hoveredOpt = opt
        end
        draw.SimpleText(opt.label, MainFontName .. "@32",
            mx + pad, ry + 4,
            inside and color_black or color_white,
            TEXT_ALIGN_LEFT)
    end

    if justClicked then
        if hoveredOpt then
            pipInvMenuRun(hoveredOpt)
        else
            PIP_INV_MENU = nil
        end
        return
    end

    -- Right-click anywhere also dismisses the menu.
    if IsRightMouseDown then
        IsRightMouseDown = false
        PIP_INV_MENU = nil
    end
end

-- "Drop how many?" selector for stacks (Amount > 1), drawn in the pipboy
-- RT like the action menu. Full amount -> normal drop; partial -> split
-- via cyrDropQuantity (sv_stacking.lua).
PIP_DROP_SELECTOR = nil

function OPEN_PIP_DROP_SELECTOR(itemTable)
    if not itemTable then return end
    local max = tonumber(itemTable:getData("Amount")) or 1
    if max <= 1 then return end
    local inv = LocalPlayer():getChar():getInv()
    PIP_DROP_SELECTOR = {
        itemID  = itemTable:getID(),
        invID   = inv and inv:getID() or nil,
        max     = max,
        value   = max,
        lmbPrev = input.IsMouseDown(MOUSE_LEFT),
    }
end

local function pipDropSelectorDraw()
    local sel = PIP_DROP_SELECTOR
    if not sel then return end
    local item = nut.item.instances[sel.itemID]
    if not item then PIP_DROP_SELECTOR = nil return end

    -- Track the live max in case the stack changes underneath us.
    sel.max = tonumber(item:getData("Amount")) or sel.max
    sel.value = math.Clamp(sel.value, 1, sel.max)

    local screenW = WIDTH or 1300
    local screenH = HEIGHT or 800
    local w, h = 440, 250
    local x = math.floor((screenW - w) * 0.5)
    local y = math.floor((screenH - h) * 0.5)

    surface.SetDrawColor(0, 0, 0, 235)
    surface.DrawRect(x, y, w, h)
    surface.SetDrawColor(pip_color)
    surface.DrawOutlinedRect(x, y, w, h)

    draw.SimpleText("DROP HOW MANY?", MainFontName .. "@42", x + w * 0.5, y + 18, pip_color, TEXT_ALIGN_CENTER)
    local nm = (item.getName and item:getName()) or item.name or ""
    draw.SimpleText(string.upper(nm), MainFontName .. "@32", x + w * 0.5, y + 62, color_white, TEXT_ALIGN_CENTER)

    local lmbHeld = input.IsMouseDown(MOUSE_LEFT)
    local justClicked = lmbHeld and not sel.lmbPrev
    sel.lmbPrev = lmbHeld

    local function rect(rx, ry, rw, rh, label)
        local inside = cursor.x >= rx and cursor.x <= rx + rw
                   and cursor.y >= ry and cursor.y <= ry + rh
        surface.SetDrawColor(pip_color)
        if inside then
            surface.DrawRect(rx, ry, rw, rh)
        else
            surface.DrawOutlinedRect(rx, ry, rw, rh)
        end
        if label then
            draw.SimpleText(label, MainFontName .. "@42", rx + rw * 0.5, ry + rh * 0.5 - 18,
                inside and color_black or color_white, TEXT_ALIGN_CENTER)
        end
        return inside
    end

    -- [-]   value / max   [+]
    local cy = y + 108
    local minusIn = rect(x + 40, cy, 50, 44, "-")
    local plusIn  = rect(x + w - 90, cy, 50, 44, "+")
    draw.SimpleText(sel.value .. " / " .. sel.max, MainFontName .. "@48",
        x + w * 0.5, cy + 2, color_white, TEXT_ALIGN_CENTER)

    -- Confirm / Cancel
    local by = y + h - 60
    local btnW = (w - 90) * 0.5
    local confirmIn = rect(x + 30, by, btnW, 44, "DROP")
    local cancelIn  = rect(x + w - 30 - btnW, by, btnW, 44, "CANCEL")

    if justClicked then
        if minusIn then
            sel.value = math.max(1, sel.value - 1)
        elseif plusIn then
            sel.value = math.min(sel.max, sel.value + 1)
        elseif confirmIn then
            local n = math.Clamp(math.floor(sel.value), 1, sel.max)
            if n >= sel.max then
                netstream.Start("invAct", "drop", sel.itemID, sel.invID, sel.itemID)
            else
                netstream.Start("cyrDropQuantity", sel.itemID, n)
            end
            surface.PlaySound("os/button_6.wav")
            PIP_DROP_SELECTOR = nil
        elseif cancelIn then
            PIP_DROP_SELECTOR = nil
        end
        return
    end

    -- Right-click also cancels, matching the action menu.
    if IsRightMouseDown then
        IsRightMouseDown = false
        PIP_DROP_SELECTOR = nil
    end
end

firsttime = true
local function DrawInventoryPage()
    ITEM_DRAWN_THIS_FRAME = nil
    if firsttime then
        firsttime = false
        clearinv()
        for i = 1, #categories do
            surface.SetFont(MainFontName .. "@48")
            local width, _ = surface.GetTextSize(categories[i] .. " ")
            cachedsizes[i] = width
            cachedpos[i] = (cachedpos[i - 1] or 0) + (cachedsizes[i - 1] or 0)
        end
    end

    if tablet.Inventory == nil then clearinv() end
    for i = 1, #categories do
        if NzGUI:DrawTextButton(categories[i], MainFontName .. "@48", 60 + cachedpos[i], 50, cachedsizes[i], 34, 0, inventory.focus == i and color_white or ((inventory.focus == i - 1 or inventory.focus == i + 1) and color_bright_Gray) or color_gray, pip_color) then
            Scroll_POS = 0
            inventory.focus = i
        end
    end

    local _ = 0
    if tablet.Inventory.cacheKeys == nil then
        -- Order rows by display name (so customised items sort by their
        -- own name); tie-break on stackKey for stable ordering.
        local sortable = {}
        for k in pairs(tablet.Inventory.items) do
            sortable[#sortable + 1] = k
        end
        table.sort(sortable, function(a, b)
            local instA = tablet.Inventory.firstInstances[a]
            local instB = tablet.Inventory.firstInstances[b]
            local clsA  = nut.item.list[tablet.Inventory.stackUID[a]]
            local clsB  = nut.item.list[tablet.Inventory.stackUID[b]]
            local nameA = (instA and instA.getName and instA:getName())
                or (clsA and clsA:getName()) or a
            local nameB = (instB and instB.getName and instB:getName())
                or (clsB and clsB:getName()) or b
            local ua, ub = nameA:upper(), nameB:upper()
            if ua == ub then return tostring(a) < tostring(b) end
            return ua < ub
        end)
        tablet.Inventory.cacheKeys = sortable
    end

    local cache = tablet.Inventory.cacheKeys
    local stack = {}
    local keypos = 1
    for c = 1, #cache do
        local stackKey = cache[c]
        local uniqueID = tablet.Inventory.stackUID[stackKey]
        local cls      = uniqueID and nut.item.list[uniqueID]
        if cls then
            -- Case-insensitive category filter: tabs are upper-case,
            -- fallout categories mixed-case.
            if inventory.focus == 1 or string.upper(cls.category or "MISC") == categories[inventory.focus] then
                -- One row per stackKey: items[] is the count, firstInstances[]
                -- the instance to render/interact with.
                local inst = tablet.Inventory.firstInstances[stackKey]
                stack[keypos] = {uniqueID, _, pip_color, tablet.Inventory.items[stackKey], inst}
                keypos = keypos + 1
                _ = _ + 1
            end
        end
    end

    last_item_page_draw_amt = #stack or 0
     
    if cursor.x > 643 and cursor.x < 643 + 10 and cursor.y > 120 and cursor.y < 120 + 540 or PIP_SCROLL_IS_DOWN then
        if input.IsMouseDown(MOUSE_LEFT) then
            local p = (cursor.y - 120) / 540
            PIP_SCROLL_IS_DOWN = true
            Scroll_POS = math.floor(math.Clamp(p * #stack, 0, last_item_page_draw_amt - 15))
        else 
            PIP_SCROLL_IS_DOWN = false
        end
    end

    local internal_scroll_this_frame = Scroll_POS + 1
    -- reverse stack table
    local baby_i = 0
    for i = internal_scroll_this_frame, internal_scroll_this_frame + 14 do
        if stack[i] then
            stack[i][2] = baby_i
            baby_i = baby_i + 1
            drawItem(unpack(stack[i]))
        end
    end

    -- get left click if in scrollbar region then scroll
    internal_scroll_this_frame = math.Clamp(internal_scroll_this_frame or 0, 0, last_item_page_draw_amt - 15)
    -- Draw Scrollbar
    surface.SetDrawColor(pip_color)
    surface.DrawOutlinedRect(643, 120, 10, 540)
    internal_scroll_this_frame = internal_scroll_this_frame - 1
    local p1 = math.Clamp(internal_scroll_this_frame / #stack, 0, 1)
    local p2 = math.Clamp(15 / #stack, 0, 1)
    surface.DrawRect(643, 120 + (p1 * 540), 10, p2 * 540 + 5)
    PIP_DRAW_FOOTER()

    -- Drawn last so it sits above the list/scrollbar/footer.
    pipInvMenuDraw()
    pipDropSelectorDraw()
end

local wth, ht = ScrW(), ScrH()
hook.Add("pip_changepage", "inv_", function(from, to)
    if to == "INV" then
        if IsValid(InventoryModelView) then InventoryModelView:Remove() end
        local debounce_timer = 0
        hook.Add("PlayerBindPress", "!PlayerBindPressInv", function(ply, bind, pressed, num) if num == MOUSE_WHEEL_UP or num == MOUSE_WHEEL_DOWN then return true end end)
        hook.Add("PlayerButtonDown", "!PlayerBindPressInv", function(ply, num)
            if num == MOUSE_WHEEL_UP or num == MOUSE_WHEEL_DOWN then
                if debounce_timer < CurTime() then
                    debounce_timer = CurTime()
                    Scroll_POS = math.Clamp(Scroll_POS - (num == MOUSE_WHEEL_UP and 1 or -1), 0, last_item_page_draw_amt - 15)
                end
                return true
            end
        end)

        InventoryModelView = vgui.Create("DModelPanel")
        InventoryModelView:SetSize(200, 200)
        InventoryModelView:SetModel("models/player/alyx.mdl") -- you can only change colors on playermodels
        InventoryModelView:SetPaintedManually(true)
        InventoryModelView.Angle = Angle(0, 0, 0)
        function InventoryModelView:Guess()
        end

        hook.Add("PostRenderVGUI", "inv_r", function()
            if ITEM_DRAWN_THIS_FRAME == nil then return end
            render.SetViewPort(ScrW() * 0.2, ScrH() * 0.775, wth, ht)
            local options = {"E) USE", "R) DROP",}
            if ITEM_DRAWN_THIS_FRAME.type == "WEAPON" then
                table.insert(options, "T) REPAIR")
                if KEYBOARD_T_CLICK then
                    ITEM_REPAIRING = ITEM_DRAWN_THIS_FRAME
                    CHANGE_PIP_BOY_PAGE("REPAIR")
                    KEYBOARD_T_CLICK = false
                end
            end

            if ITEM_DRAWN_THIS_FRAME.baseStackable then
                table.insert(options, "G) SPLIT")
                if KEYBOARD_G_CLICK then
                    SHOW_DROPPABLE_STACKABLE_SPLIT(ITEM_DRAWN_THIS_FRAME)
                    KEYBOARD_G_CLICK = false
                    return
                end

                table.insert(options, "X) MERGE")
                if KEYBOARD_X_CLICK then
                    RunConsoleCommand("merge_single", ITEM_DRAWN_THIS_FRAME.uniqueID)
                    KEYBOARD_X_CLICK = false
                    return
                end
            end

            local built = ""
            for k, v in ipairs(options) do -- only add \t if not the last option
                built = built .. v .. (k < #options and "\t" or "  ")
            end

            surface.SetFont(MainFontName .. "@48")
            local tw, th = surface.GetTextSize(built)
            surface.SetDrawColor(pip_color.r, pip_color.g, pip_color.b, 20)
            surface.DrawRect(0, 0, tw, th)
            NzGUI.DrawShadowText(built, 0, 0, c)
            render.SetViewPort(0, 0, wth, ht)
        end)
    else
        hook.Remove("PostRenderVGUI", "inv_r")
        hook.Remove("PlayerBindPress", "!PlayerBindPressInv")
        hook.Remove("PlayerButtonDown", "!PlayerBindPressInv")
    end
end)

local debounce_timer = 0
pipboy:AddRenderPage("INV", DrawInventoryPage)
local DrawPly = {}
function DrawPly.PERKS()
    local perks = {}
    local char = LocalPlayer():getChar()
    if cached_desc == nil then
        cached_desc = {}
        for i, v in pairs(PERKS) do
            cached_desc[v.display] = textWrap(v.desc, MainFontName .. "@32", 350)
        end
    end

    for i, v in pairs(PERKS) do
        if char:isPerkOwned(i) then table.insert(perks, v) end
    end

    for i, v in pairs(perks) do
        local i = i - 1
        local y = math.floor(i / 2)
        local x = i % 2 * 256
        local fn, click, draww = NzGUI:DrawTextButtonWithDelayedHover(v.display:upper(), MainFontName .. "@32", 64 + x, 116 + y * 32, 225, 32, 1, color_white)
        local c = pip_color
        if fn then
            c = color_black
            deltSt = deltSt == 0 and CurTime() or deltSt
            surface.SetDrawColor(pip_color)
            surface.DrawRect(64 + x, 120 + (y * 32), 225, 26)
            surface.SetMaterial(v.image)
            surface.SetDrawColor(pip_color)
            draw.DrawNonParsedText(cached_desc[v.display], MainFontName .. "@32", 600, 400, pip_color, 0)
            surface.DrawTexturedRect(626, 128, 256, 256)
        end

        draww(c)
    end
end

DrawPly["HEAT SIGNATURES"] = function()
    local height = 36
    local width = 400
    local ply = LocalPlayer()
    local character = ply:getChar()
end

-- A respec wipes the perk list, so drop the description cache to rebuild it.
netstream.Hook("nut_respec_done", function()
    cached_desc = nil
end)

local headers = {"HEAT SIGNATURES", "DATABASE"}
local offset = {0, 252, 225, 335}
local offset2 = {200, 120, 100, 100}
SELECTED_HEADER = "HEAT SIGNATURES"
local draw_overview = function(pip_color2)
    for i, v in pairs(headers) do
        local vb, fn = NzGUI:DrawTextButton(v, MainFontName .. "@48", 64 + offset[i], 64, offset2[i], 32, 1, v == SELECTED_HEADER and pip_color or pip_color_accent)
        if vb then SELECTED_HEADER = v end
    end

    if DrawPly[SELECTED_HEADER] then DrawPly[SELECTED_HEADER]() end
    local lb, ub = LocalPlayer():getChar():getSkillXP("level"), LocalPlayer():getChar():getSkillXPForLevel("level")
end

local draw_repair = function(pip_color2)
    if ITEM_REPAIRING == nil or IsReloadUse then
        IsReloadUse = false
        CHANGE_PIP_BOY_PAGE("INV")
    end

    local i = 1
    if KEYBOARD_T_CLICK then
        CHANGE_PIP_BOY_PAGE("INV")
        KEYBOARD_T_CLICK = false
    end

    local inst = ITEM_REPAIRING
    local vb, fn = NzGUI:DrawTextButton("REPAIRING " .. ITEM_REPAIRING:getName(), MainFontName .. "@48", 64 + offset[i], 64, offset2[i], 32, 1, v == SELECTED_HEADER and pip_color or pip_color_accent)
    surface.SetDrawColor(pip_color2)
    draw.SimpleText("Weapon Decay: " .. curHp(inst), MainFontName .. "@32", 64, 100, color_white, TEXT_ALIGN_LEFT)
    -- get repair group
    local repairValue = 0
    local RPG = REPAIR_GROUP:Get(inst.repairGroup or inst.weaponCategory or inst.uniqueID)
    local index = -1
    local charINV = LocalPlayer():getChar():getInv()
    for i, v in pairs(RPG.REPAIR_VALUE) do
        repeat
            if tablet.Inventory.items[i] == nil then
                do
                    break
                end
            end

            index = index + 1
            local y = math.floor(index)
            local x = 0
            local tt = charINV:getItemsOfType(i)[1]
            local name = tt:getName()
            local fn, click, draww = NzGUI:DrawTextButtonWithDelayedHover(name, MainFontName .. "@42", 64 + x, 124 + y * 46, 480, 48, 1, color_white)
            local c = pip_color
            if fn then
                c = color_black
                deltSt = deltSt == 0 and CurTime() or deltSt
                surface.DrawRect(64 + x, 128 + (y * 46), 480, 40)
                surface.SetDrawColor(pip_color)
                local count = charINV.items[i] or 0
                -- draw.DrawNonParsedText(tablet.Inventory.items[i]:getName() .. "X " .. nut.item.list[i]:getName(), MainFontName .. "@32", 580, 180, pip_color, 0)
                repairValue = v
                if IsUseDown then
                    IsUseDown = false
                    netstream.Start("weapon_repair", inst.id, i)
                end
            end

            draww(c)
            draw.SimpleText("CDN", MainFontName .. "@64", 580, 64, color_white, TEXT_ALIGN_LEFT)
            local width_prod = 400
            local padd_ing = 6
            local maxV = maxHp(inst)
            local bar = 1 - (curHp(inst) / maxV)
            local repair_bar = bar + (repairValue / maxV)
            repair_bar = math.Clamp(repair_bar, 0, 1)
            surface.DrawOutlinedRect(580 - padd_ing, 126 - padd_ing, width_prod + padd_ing + padd_ing, 42 + padd_ing + padd_ing, 2)
            surface.DrawRect(580, 126, width_prod * bar, 42, 2)
            surface.SetDrawColor(pip_color2.r, pip_color2.g, pip_color2.b, 50)
            surface.DrawRect(580, 126, width_prod * repair_bar, 42, 2)
            surface.SetDrawColor(pip_color)
        until true
    end
end

hook.Add("pip_changepage", "_repair", function(from, to)
    if to == "REPAIR" then
        hook.Add("PostRenderVGUI", "inv_repair", function()
            if ITEM_DRAWN_THIS_FRAME == nil then return end
            render.SetViewPort(ScrW() * 0.2, ScrH() * 0.775, wth, ht)
            local options = {"E) REPAIR", "T) BACK"}
            local built = ""
            for k, v in ipairs(options) do -- only add \t if not the last option
                built = built .. v .. (k < #options and "\t" or "  ")
            end

            surface.SetFont(MainFontName .. "@48")
            local tw, th = surface.GetTextSize(built)
            surface.SetDrawColor(pip_color.r, pip_color.g, pip_color.b, 20)
            surface.DrawRect(0, 0, tw, th)
            NzGUI.DrawShadowText(built, 0, 0, c)
            render.SetViewPort(0, 0, wth, ht)
        end)
    else
        hook.Remove("PostRenderVGUI", "inv_repair")
    end
end)

pipboy:AddRenderPage("INFO", draw_overview)
pipboy:AddRenderPage("REPAIR", draw_repair)