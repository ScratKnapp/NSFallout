local categories = {"AID", "AMMO", "ARMOR", "FOOD", "WEAPONS"}
-- sort categories by alphabetical order
table.sort(categories)
table.insert(categories, 1, "ALL")
table.insert(categories, "MISC")

-- The pipboy was built against an older item schema with .MaxHP and a "HP"
-- data field; fallout items use .durability and a "durability" data field.
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
local function IsStackable(item)
    if item.baseStackable then return 1 end
    if item.Stackable then return 2 end
    return false
end

function clearinv()
    player = LocalPlayer()
    local inventory = player:getChar():getInv()
    local items = {}
    local iteminstances = {}
    local stackCounter = 0
    for i, v in pairs(inventory:getItems()) do
        local uniqueID = v.uniqueID
        --stackid
        local item = nut.item.list[uniqueID]
        if IsStackable(item) then
            if items[uniqueID] then
                table.insert(items[uniqueID], v)
            else
                items[uniqueID] = {v}
            end
        else
            items[uniqueID] = (items[uniqueID] and items[uniqueID] or 0) + 1
        end

        local tbl = iteminstances[uniqueID] or {}
        table.insert(tbl, v.id)
        iteminstances[uniqueID] = tbl
        --item.functions.drop
    end

    tablet.Inventory = {
        items = items,
        instances = iteminstances
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
local function drawItem(item3, y, pip_color, _amt, ITEM_INSTANCE_RRA)
    --if item then PrintTable(tablet.Inventory.data) end 
    surface.SetDrawColor(pip_color)
    --surface.DrawOutlinedRect(-420, 0, 400, 55)
    local item = nut.item.list[item3]
    local amt = item:getData("amount") or 1
    local cc = amt == 1 and "" or " (" .. amt .. ")"
    local name = (ITEM_INSTANCE_RRA or item):getName()
    local inst = nut.item.list[item3]
    if (IsStackable(inst) == false) and _amt > 1 then name = inst.name .. " (" .. _amt .. ")" end
    local fn, click, draww = NzGUI:DrawTextButtonWithDelayedHover(string.upper(name) .. cc, "Morton Medium@42", 86, 116 + (y * FUSION_ITEM_BUTTON_SIZE.ho), FUSION_ITEM_BUTTON_SIZE.w, FUSION_ITEM_BUTTON_SIZE.h, 1, color_white, color_black, 0, pip_color)
    if fn and InventoryModelView and InventoryModelView.Entity then
        ITEM_DRAWN_THIS_FRAME = ITEM_INSTANCE_RRA
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
        draw.SimpleText("VALUE: " .. (inst.value or 0), "Morton Medium@32", ITEMDESCOFFSET.xT, 225, color_white, TEXT_ALIGN_LEFT)
        surface.DrawRect(ITEMDESCOFFSET.x, 230 + heightOfBoxes + heightOfBoxesPadding, ITEMDESCOFFSET.w + 2, heightOfBoxes)
        draw.SimpleText("TYPE: " .. (inst.category or "MISC"), "Morton Medium@32", ITEMDESCOFFSET.xT, 225 + heightOfBoxes + heightOfBoxesPadding, color_white, TEXT_ALIGN_LEFT)
        surface.DrawRect(ITEMDESCOFFSET.x, 230 + heightOfBoxes + heightOfBoxes + heightOfBoxesPadding + heightOfBoxesPadding, ITEMDESCOFFSET.w + 2, heightOfBoxes)
        draw.SimpleText("WEIGHT: " .. (item.weight or "0"), "Morton Medium@32", ITEMDESCOFFSET.xT, 230 + heightOfBoxes + heightOfBoxes, color_white, TEXT_ALIGN_LEFT)
        --surface.DrawRect(ITEMDESCOFFSET.x, 499 + heightOfBoxes + heightOfBoxes + heightOfBoxesPadding + heightOfBoxesPadding, ITEMDESCOFFSET.w + 2, heightOfBoxes)
        --draw.SimpleText("Body Dr: " .. (item.resisbody or "0"), "Morton Medium@32", ITEMDESCOFFSET.xT, 499 + heightOfBoxes + heightOfBoxes, color_white, TEXT_ALIGN_LEFT)
        --surface.DrawRect(ITEMDESCOFFSET.x, 525 + heightOfBoxes + heightOfBoxes + heightOfBoxesPadding + heightOfBoxesPadding, ITEMDESCOFFSET.w + 2, heightOfBoxes)
        --draw.SimpleText("Head Dr: " .. (item.resishead or "0"), "Morton Medium@32", ITEMDESCOFFSET.xT, 525 + heightOfBoxes + heightOfBoxes, color_white, TEXT_ALIGN_LEFT)
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
                    draw.SimpleText(v[2], "Morton Medium@32", ITEMDESCOFFSET.xT + prevWidth - endMargin - (ITEMDESCOFFSET.w * v[1] * 0.5) - 10, start + heightOffset, color_white, TEXT_ALIGN_CENTER)
                else
                    if v[2] then
                        if v[4] == nil then surface.DrawRect(ITEMDESCOFFSET.x + prevWidth, start + 5 + heightOffset, ITEMDESCOFFSET.w * v[1] - endMargin, heightOfBoxes) end
                        draw.SimpleText(v[2], "Morton Medium@32", ITEMDESCOFFSET.xT + prevWidth - endMargin, start + heightOffset, color_white, TEXT_ALIGN_LEFT)
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
        local function resolveInstance()
            if ITEM_INSTANCE_RRA then return ITEM_INSTANCE_RRA end
            local Inventory = GetITEMS()
            return LocalPlayer():getChar():getInv().items[Inventory.instances[item3][1]]
        end
        local function equipToggle(v, slot)
            if v:getData("equip") then
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
                if v.functions.use and v.functions.use.onRunClient then v.functions.use.onRunClient(v) end
            end
        end
        if IsUseDown then
            IsUseDown = false
            local v = resolveInstance()
            netstream.Start("invAct", "use", v.id, v:getID(), v.id)
            _G.EatTimer = CurTime() + 0.5
            if v.functions.use and v.functions.use.onRunClient then v.functions.use.onRunClient(v) end
        elseif click then
            local v = resolveInstance()
            equipToggle(v, nil)
            _G.EatTimer = CurTime() + 0.25
        elseif IsRightMouseDown then
            IsRightMouseDown = false
            local v = resolveInstance()
            if v.isWeapon then
                equipToggle(v, "sidearm")
                _G.EatTimer = CurTime() + 0.25
            end
        elseif IsReloadUse then
            IsReloadUse = false
            local v = resolveInstance()
            netstream.Start("invAct", "drop", v.id, v:getID(), v.id)
        end
    else
        draww()
    end

    if inst.DrawLabel and ITEM_INSTANCE_RRA then ITEM_INSTANCE_RRA:DrawLabel(86, 116 + (y * FUSION_ITEM_BUTTON_SIZE.ho)) end
end

hook.Add("ItemDataChanged", "ItemDataChanged", function() clearinv() end)
hook.Add("InventoryItemRemoved", "invDatainvData", function() clearinv() end)
hook.Add("ItemInitialized", "ItemInitializedItemInitialized", function() timer.Simple(0, clearinv) end)
last_item_page_draw_amt = 0
local color_gray = Color(255, 255, 255, 25)
local color_bright_Gray = Color(255, 255, 255, 55)
firsttime = true
local function DrawInventoryPage()
    ITEM_DRAWN_THIS_FRAME = nil
    if firsttime then
        firsttime = false
        clearinv()
        for i = 1, #categories do
            surface.SetFont("Morton Medium@48")
            local width, _ = surface.GetTextSize(categories[i] .. " ")
            cachedsizes[i] = width
            cachedpos[i] = (cachedpos[i - 1] or 0) + (cachedsizes[i - 1] or 0)
        end
    end

    if tablet.Inventory == nil then clearinv() end
    for i = 1, #categories do
        if NzGUI:DrawTextButton(categories[i], "Morton Medium@48", 60 + cachedpos[i], 50, cachedsizes[i], 34, 0, inventory.focus == i and color_white or ((inventory.focus == i - 1 or inventory.focus == i + 1) and color_bright_Gray) or color_gray, pip_color) then
            Scroll_POS = 0
            inventory.focus = i
        end
    end

    local _ = 0
    local cache = tablet.Inventory.cache
    if tablet.Inventory.cacheKeys == nil then
        local temp_build = {}
        local temp_build_key = {}
        local ind = 0
        for i, v in pairs(tablet.Inventory.items) do
            ind = ind + 1
            temp_build[nut.item.list[i]:getName()] = i
            temp_build_key[ind] = nut.item.list[i]:getName()
        end

        table.sort(temp_build_key, function(a, b) return a:upper() < b:upper() end)
        local temp_build_sorted = temp_build_key
        local convertTable = {}
        for i = 1, #temp_build_sorted do
            convertTable[i] = temp_build[temp_build_sorted[i]]
        end

        --tablet.Inventory.cache = CurTime()+3
        tablet.Inventory.cacheKeys = convertTable
    end

    local cache = tablet.Inventory.cacheKeys
    local stack = {}
    local keypos = 1
    for c = 1, #cache do
        local i = cache[c]
        local v = tablet.Inventory.items[i]
        --for i, v in pairs(tablet.Inventory.items) do
        if inventory.focus == 1 or nut.item.list[i].category == categories[inventory.focus] then
            if IsStackable(nut.item.list[i]) then
                for _unstack, dostack in pairs(tablet.Inventory.items[i]) do
                    stack[keypos] = {i, _, pip_color, 1, dostack}
                    keypos = keypos + 1
                    _ = _ + 1
                end
            else
                stack[keypos] = {i, _, pip_color, tablet.Inventory.items[i]}
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
            local isWep = ITEM_DRAWN_THIS_FRAME.isWeapon or ITEM_DRAWN_THIS_FRAME.type == "WEAPON"
            local equipLabel = ITEM_DRAWN_THIS_FRAME:getData("equip") and "UNEQUIP" or "EQUIP"
            local options = {"LMB) " .. equipLabel}
            if isWep then table.insert(options, "RMB) SIDEARM") end
            table.insert(options, "E) USE")
            table.insert(options, "R) DROP")
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

            surface.SetFont("Morton Medium@48")
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
            cached_desc[v.display] = textWrap(v.desc, "Morton Medium@32", 350)
        end
    end

    for i, v in pairs(PERKS) do
        if char:isPerkOwned(i) then table.insert(perks, v) end
    end

    for i, v in pairs(perks) do
        local i = i - 1
        local y = math.floor(i / 2)
        local x = i % 2 * 256
        local fn, click, draww = NzGUI:DrawTextButtonWithDelayedHover(v.display:upper(), "Morton Medium@32", 64 + x, 116 + y * 32, 225, 32, 1, color_white)
        local c = pip_color
        if fn then
            c = color_black
            deltSt = deltSt == 0 and CurTime() or deltSt
            surface.SetDrawColor(pip_color)
            surface.DrawRect(64 + x, 120 + (y * 32), 225, 26)
            surface.SetMaterial(v.image)
            surface.SetDrawColor(pip_color)
            draw.DrawNonParsedText(cached_desc[v.display], "Morton Medium@32", 600, 400, pip_color, 0)
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

local headers = {"HEAT SIGNATURES", "DATABASE"}
local offset = {0, 252, 225, 335}
local offset2 = {200, 120, 100, 100}
SELECTED_HEADER = "HEAT SIGNATURES"
local draw_overview = function(pip_color2)
    for i, v in pairs(headers) do
        local vb, fn = NzGUI:DrawTextButton(v, "Morton Medium@48", 64 + offset[i], 64, offset2[i], 32, 1, v == SELECTED_HEADER and pip_color or pip_color_accent)
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
    local vb, fn = NzGUI:DrawTextButton("REPAIRING " .. ITEM_REPAIRING:getName(), "Morton Medium@48", 64 + offset[i], 64, offset2[i], 32, 1, v == SELECTED_HEADER and pip_color or pip_color_accent)
    surface.SetDrawColor(pip_color2)
    draw.SimpleText("Weapon Decay: " .. curHp(inst), "Morton Medium@32", 64, 100, color_white, TEXT_ALIGN_LEFT)
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
            local fn, click, draww = NzGUI:DrawTextButtonWithDelayedHover(name, "Morton Medium@42", 64 + x, 124 + y * 46, 480, 48, 1, color_white)
            local c = pip_color
            if fn then
                c = color_black
                deltSt = deltSt == 0 and CurTime() or deltSt
                surface.DrawRect(64 + x, 128 + (y * 46), 480, 40)
                surface.SetDrawColor(pip_color)
                local count = charINV.items[i] or 0
                -- draw.DrawNonParsedText(tablet.Inventory.items[i]:getName() .. "X " .. nut.item.list[i]:getName(), "Morton Medium@32", 580, 180, pip_color, 0)
                repairValue = v
                if IsUseDown then
                    IsUseDown = false
                    netstream.Start("weapon_repair", inst.id, i)
                end
            end

            draww(c)
            draw.SimpleText("CDN", "Morton Medium@64", 580, 64, color_white, TEXT_ALIGN_LEFT)
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

            surface.SetFont("Morton Medium@48")
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