local function formattedText(text1, text2, x, y, font)
    font = font or "Morton Medium@48"
    surface.SetFont(font)
    draw.DrawText(text1, font, x, y, color_white)
    local width, _ = surface.GetTextSize(text1 .. " ")
    draw.DrawText(text2, font, x + width, y, pip_color)
end

local attribute_width = 400
local error_mat = Material("piboy5")
local function DrawHPBar(x, y, p, w)
    w = w or 52
    x = x - 35
    y = y + 100
    surface.SetDrawColor(pip_color)
    surface.DrawOutlinedRect(x, y, w + 8, 16)
    surface.DrawRect(x + 4, y + 4, w * p, 8)
    surface.SetDrawColor(pip_color_negative)
    surface.DrawRect(x + 4 + w * p, y + 4, (1 - p) * w, 8)
end

local function AttributeDisplay(name, desc, progress, level, y, x)
    y = y + 7
    draw.DrawText(name, "Morton Medium@64", 80 + x, 0 + y, color_white)
    draw.DrawText(desc, "Morton Medium@19", 80 + x, 48 + y, color_white)
    draw.DrawText("LEVEL " .. level, "Morton Medium@48", 80 + x + attribute_width, 12 + y, pip_color, TEXT_ALIGN_RIGHT)
    draw.NoTexture()
    surface.SetDrawColor(color_white)
    -- Render stuff here bb 
    local offset24 = attribute_width * progress
    surface.DrawRect(81 + offset24 + x, 70 + y, attribute_width * (1 - progress), 11)
    surface.SetDrawColor(pip_color)
    surface.DrawRect(79 + x, 70 + y, attribute_width * progress, 11)
end

local DrawPly = {}
-- Hoisted from the PERKS section: DrawPly.STATS (just below) references this
-- color in its respec modal, so the local must be declared before the function
-- is defined or Lua binds the name to a nil global at compile time.
local perk_req_negative = Color(255, 35, 35)
function DrawPly.STATS()
    local ply = LocalPlayer()
    local character = ply:getChar()
    local faction = nut.faction.indices[character:getFaction()]
    -- Use the combat plugin's HP (ply:getHP/getMaxHP) instead of engine
    -- health so the pipboy mirrors what the combat HUD shows.
    local hp, hpMax
    if isfunction(ply.getHP) and isfunction(ply.getMaxHP) then
        hp, hpMax = ply:getHP(), ply:getMaxHP()
    else
        hp, hpMax = ply:Health(), ply:GetMaxHealth()
    end
    --Draw Player Info
    formattedText("Name:", character:getName(), 64, 132)
    formattedText("HP:", math.ceil(hp) .. "/" .. math.ceil(hpMax), 64, 128 + 64)
    formattedText("Faction:", faction and faction.name or "None", 64, 128 + 128)

    -- DESCRIPTION as its own header with the text in a smaller wrapped body.
    draw.DrawText("DESCRIPTION", "Morton Medium@48", 64, 380, pip_color)
    local desc = character:getDesc() or ""
    -- RT is 1024 wide; leave a 64px gutter on each side so text never clips
    -- against the curved CRT edge.
    local wrapped = textWrap(desc, "Morton Medium@24", 1024 - 64 - 64)
    draw.DrawNonParsedText(wrapped, "Morton Medium@24", 64, 440, color_white)

    surface.SetDrawColor(pip_color)
    surface.SetMaterial(error_mat)
    surface.DrawTexturedRect(600, 200, 200, 300)

    if PIPBOY_SHOW_BODY_HP then
        DrawHPBar(685, 80, 1 - (character:getData("hp_head", 0) / 300))
        DrawHPBar(800, 200, 1 - (character:getData("hp_arm_left", 0) / 300))
        DrawHPBar(580, 200, 1 - (character:getData("hp_arm_right", 0) / 300))
        DrawHPBar(800, 350, 1 - (character:getData("hp_leg_right", 0) / 300))
        DrawHPBar(580, 350, 1 - (character:getData("hp_leg_left", 0) / 300))
    end

    -- Respec entry button. Click opens the confirmation modal below; the
    -- actual nut_respec netstream is only fired from the modal's CONFIRM so a
    -- stray click can't wipe a character.
    local rx, ry, rw, rh = 600, 540, 300, 40
    local fn, click, draww = NzGUI:DrawTextButtonWithDelayedHover("RESPEC", "Morton Medium@42", rx, ry, rw, rh, 1, color_white)
    local rc = pip_color_accent or pip_color
    surface.SetDrawColor(pip_color)
    surface.DrawOutlinedRect(rx, ry, rw, rh)
    if fn then
        rc = color_black
        surface.SetDrawColor(pip_color)
        surface.DrawRect(rx, ry, rw, rh)
    end
    draww(rc)
    if click and not RESPEC_MODAL then
        RESPEC_MODAL = true
    end

    if RESPEC_MODAL then
        local MX, MY, MW, MH = 192, 180, 640, 360
        surface.SetDrawColor(0, 0, 0, 220)
        surface.DrawRect(0, 96, 1024, 608)
        surface.SetDrawColor(0, 0, 0, 250)
        surface.DrawRect(MX, MY, MW, MH)
        surface.SetDrawColor(pip_color)
        surface.DrawOutlinedRect(MX, MY, MW, MH)
        surface.DrawOutlinedRect(MX - 2, MY - 2, MW + 4, MH + 4)

        draw.DrawText("RESPEC CHARACTER", "Morton Medium@48", MX + MW * 0.5, MY + 24, pip_color, TEXT_ALIGN_CENTER)

        local bodyLines = {
            "This will reset your SPECIAL, skills, and traits.",
            "Spend points will be refunded based on your current level.",
            "Hidden traits and your level itself are preserved.",
            "",
            "This action cannot be undone.",
        }
        local by = MY + 100
        for _, line in ipairs(bodyLines) do
            draw.DrawText(line, "Morton Medium@32", MX + MW * 0.5, by, color_white, TEXT_ALIGN_CENTER)
            by = by + 34
        end

        local btnY, btnH = MY + MH - 60, 40
        local btnW = 220
        local cfx = MX + 24
        surface.SetDrawColor(perk_req_negative)
        surface.DrawOutlinedRect(cfx, btnY, btnW, btnH)
        if NzGUI:DrawTextButton("CONFIRM", "Morton Medium@42", cfx, btnY - 2, btnW, btnH, 0, perk_req_negative) then
            netstream.Start("nut_respec")
            surface.PlaySound("buttons/button3.wav")
            RESPEC_MODAL = false
        end

        local cx = MX + MW - 24 - btnW
        surface.SetDrawColor(pip_color)
        surface.DrawOutlinedRect(cx, btnY, btnW, btnH)
        if NzGUI:DrawTextButton("CANCEL", "Morton Medium@42", cx, btnY - 2, btnW, btnH, 0, pip_color) then
            RESPEC_MODAL = false
        end
    end
end

local attri = {"Strength", "Perception", "Endurance", "Charisma", "Intelligence", "Agility", "Luck"}
local attri_a = {"str", "per", "end", "cha", "int", "agi", "luck"}
local attri_desc = {"Strength is a measure of your raw physical power. It affects how much you can carry, and determines the effectiveness of all melee attacks.", 'Perception is your environmental awareness and "sixth sense," and allows you to see things other people may not see.', "Endurance is the measure of overall physical fitness. It affects your total health and the action point drain from sprinting", "Charisma is your ability to charm and convince others. It affects your success to persuade others in dialogue and prices when you barter. It also allows you to inspire people in your party increase everyones max health.", "Intelligence is the measure of your overall mental acuity, and increases the amount of experience points earned.", "Agility is a measure of your overall finesse and reflexes. It affects the number of Action Points and your ability to sneak. Decreases reload time.", "Luck is a measure of your general good fortune, and affects the recharge rates of critical hits."}
for i, v in pairs(attri_desc) do
    attri_desc[i] = textWrap(v, "Morton Medium@24", 350)
end

local attriIMG = {Material("vault_boy/str"), Material("vault_boy/per"), Material("vault_boy/end"), Material("vault_boy/chr"), Material("vault_boy/int"), Material("vault_boy/agi"), Material("vault_boy/luck")}
local color_black = Color(0, 0, 0)
local f = Material("vault_boy/agi")
local deltSt = 0
-- When true, the STATS sub-page draws a confirmation modal over the page
-- before firing the nut_respec netstream. Cleared on confirm/cancel and on
-- pipboy page change (see pip_changepage hook below).
local RESPEC_MODAL = false
function DrawPly.SPECIAL()
    local ply = LocalPlayer()
    local character = ply:getChar()
    local amts = (character:getSkillLevel("specialpoints") or 1) - 1
    draw.DrawText("SPECIAL POINTS: " .. amts, "Morton Medium@42", 950, 64, amts > 0 and pip_color or color_white, TEXT_ALIGN_RIGHT)
    for y, v in pairs(attri) do
        local fn, click, draww = NzGUI:DrawTextButtonWithDelayedHover(v, "Morton Medium@48", 64, 116 + (y * 44), 400, 40, 1, color_white)
        local c = pip_color
        if fn then
            c = color_black
            surface.SetDrawColor(pip_color)
            surface.DrawRect(64, 118 + (y * 44), 500 - 64, 42)
            if IS_R_DOWN then
                deltSt = deltSt == 0 and CurTime() or deltSt
                --
                --
                if amts > 0 then
                    local p = math.Clamp((CurTime() - deltSt) * 0.75, 0.01, 1)
                    surface.SetDrawColor(pip_color.r * 0.5, pip_color.g * 0.5, pip_color.b * 0.5)
                    surface.DrawRect(64, 118 + (y * 44), (500 - 64) * p, 42)
                    if p == 1 then
                        IsReloadUse = false
                        local attribKey = attri_a[y]
                        local newVal = (LocalPlayer():getChar():getAttrib(attribKey, 0) or 0) + 1
                        netstream.Start("statIncrease", attribKey, newVal)
                        deltSt = 0
                    end
                else
                    deltSt = 0
                end
            else
                deltSt = 0
            end

            surface.SetMaterial(attriIMG[y])
            surface.SetDrawColor(pip_color)
            draw.DrawNonParsedText(attri_desc[y], "Morton Medium@24", 600, 400, pip_color, 0)
            if y == 1 then
                surface.DrawTexturedRect(626 + 42, 128, 150, 256)
            elseif y == 5 then
                surface.DrawTexturedRect(626 + 62, 138, 150, 200)
            else
                surface.DrawTexturedRect(626, 128, 256, 256)
            end
        end

        local iness = character:getAttrib(attri_a[y], 0)
        draw.DrawText(iness, "Morton Medium@48", 500, 116 + (y * 44), c, TEXT_ALIGN_RIGHT)
        draww(c)

        -- Click-to-spend "+" square at the right of each row. Drawn outside the
        -- hover block so the player can target it even when the row itself
        -- isn't highlighted. Hidden entirely when no specialpoints remain.
        if amts > 0 then
            local bx, by, bs = 515, 120 + (y * 44), 32
            surface.SetDrawColor(pip_color)
            surface.DrawOutlinedRect(bx, by, bs, bs)
            local hit = NzGUI:DrawTextButton("+", "Morton Medium@42", bx, by - 6, bs, bs, 0, pip_color)
            if hit then
                local attribKey = attri_a[y]
                local newVal = (character:getAttrib(attribKey, 0) or 0) + 1
                netstream.Start("statIncrease", attribKey, newVal)
            end
        end
    end
end

local skill_def = {
    {"guns", "Guns"},
    {"energy", "Energy Weapons"},
    {"explosives", "Explosives"},
    {"throwing", "Throwing"},
    {"melee", "Melee"},
    {"unarmed", "Unarmed"},
    {"science", "Science"},
    {"medicine", "Medicine"},
    {"repair", "Repair"},
    {"lockpick", "Lockpicking"},
    {"sneak", "Sneak"},
    {"evasion", "Evasion"},
    {"survival", "Survival"},
    {"athletics", "Athletics"},
    {"piloting", "Piloting"},
    {"speech", "Speech"},
}
local skill_desc = {}
for _i, _v in ipairs(skill_def) do
    local def = nut.skills and nut.skills.list and nut.skills.list[_v[1]]
    skill_desc[_i] = textWrap(def and def.desc or "", "Morton Medium@24", 400)
end
local SELECTED_HEADER
local wth, ht = ScrW(), ScrH()
-- Cleans up the screen-space "R [HOLD]) SPEND POINT ON..." hint that the old
-- code attached when the STATS page opened. The counters now live inside the
-- pipboy RT on each sub-page, so this hook is no longer needed; remove any
-- copy that survived a hot-reload.
hook.Remove("PostRenderVGUI", "SKILLS")

hook.Add("pip_changepage", "SKILLS_", function(from, to)
    -- Leaving the STATS page closes any open modal so it doesn't pop back up
    -- the next time the player returns.
    if from == "STATS" and to ~= "STATS" then
        PERK_MODAL = nil
        RESPEC_MODAL = false
    end
end)

local cached_desc = nil
-- Maps perk requirement keys to human-readable labels for the requirement list.
local perk_req_format = {
    str = "Strength", agi = "Agility", per = "Perception", luc = "Luck",
    luck = "Luck", int = "Intelligence", cha = "Charisma", ["end"] = "Endurance",
    S = "Strength", P = "Perception", E = "Endurance", C = "Charisma",
    I = "Intelligence", A = "Agility", L = "Luck", level = "Level",
}
local PERKS_SORTED = nil
-- false = show all perks (locked + owned), true = show only owned perks.
local PERK_FILTER_OWNED = false
-- When non-nil, a perk detail modal is open over the PERKS sub-page. Holds
-- the perk table being viewed. Interactions with the underlying grid are
-- suppressed while it's set.
local PERK_MODAL = nil

-- Server fires this after PLUGIN:Respec commits. The catalogue itself doesn't
-- change, but blowing away the cached/sorted tables forces the next PERKS
-- draw to rebuild from a clean slate, which also re-derives the owned/locked
-- ordering with the now-empty trait list.
netstream.Hook("nut_respec_done", function()
    cached_desc = nil
    PERKS_SORTED = nil
end)
function DrawPly.PERKS()
    local char = LocalPlayer():getChar()
    if not char then return end

    -- Build the sorted catalogue + wrapped descriptions once.
    if cached_desc == nil then
        cached_desc = {}
        PERKS_SORTED = {}
        for i, v in pairs(PERKS) do
            v._idx = i
            cached_desc[v.display] = textWrap(v.desc, "Morton Medium@32", 350)
            table.insert(PERKS_SORTED, v)
        end
        table.sort(PERKS_SORTED, function(a, b)
            return (a.requirements.level or 0) < (b.requirements.level or 0)
        end)
    end

    local amtss = (char:getSkillLevel("perkpoints") or 1) - 1
    draw.DrawText("PERK POINTS: " .. amtss, "Morton Medium@42", 950, 64, amtss > 0 and pip_color or color_white, TEXT_ALIGN_RIGHT)
    local hovered = nil
    local modal_open = PERK_MODAL ~= nil

    -- Toggle between the full catalogue and an owned-only view. Centered at the
    -- bottom of the 3-column list area (columns span x=64..560, 15 rows from
    -- y=112 end at y=532), so it sits just below the last row.
    local toggleTxt = "SHOW: " .. (PERK_FILTER_OWNED and "OWNED" or "ALL")
    local toggleClick = NzGUI:DrawTextButton(toggleTxt, "Morton Medium@32", 172, 540, 280, 32, 0, pip_color)
    if toggleClick and not modal_open then PERK_FILTER_OWNED = not PERK_FILTER_OWNED end

    -- Build the visible list each frame: owned perks first (level order
    -- preserved), then the locked ones unless we're filtering to owned only.
    -- Perks whose underlying trait is flagged `hidden` are suppressed from the
    -- locked-list pass so they only appear here if the player has actually
    -- unlocked them (mirroring how respec preserves hidden traits).
    local traitList = TRAITS and TRAITS.traits or nil
    local function isHidden(uid)
        local t = traitList and traitList[uid]
        return t and t.hidden == true
    end
    local display = {}
    for _, v in ipairs(PERKS_SORTED) do
        if char:isPerkOwned(v._idx) then display[#display + 1] = v end
    end
    if not PERK_FILTER_OWNED then
        for _, v in ipairs(PERKS_SORTED) do
            if not char:isPerkOwned(v._idx) and not isHidden(v.uid) then
                display[#display + 1] = v
            end
        end
    end

    -- Left side: perk list in three columns. The three columns occupy the same
    -- total room the old two columns did: each new column is (240+240)/3 = 160
    -- wide, with the same 8px gap, so the right edge still lands at x=560.
    local PERK_COL_W = 160
    local PERK_COL_STRIDE = 168
    local PERK_ROWS = 15
    for i, v in ipairs(display) do
        local idx = i - 1
        local row = idx % PERK_ROWS
        local col = math.floor(idx / PERK_ROWS)
        local px = 64 + col * PERK_COL_STRIDE
        local py = 112 + row * 28
        local owned = char:isPerkOwned(v._idx)
        local fn, click, draww = NzGUI:DrawTextButtonWithDelayedHover(v.display:upper(), "Morton Medium@24", px, py, PERK_COL_W, 28, 1, color_white)
        local base = owned and pip_color_accent or color_white
        local c = base
        if fn and not modal_open then
            hovered = v
            c = color_black
            surface.SetDrawColor(pip_color)
            surface.DrawRect(px, py + 2, PERK_COL_W, 24)

            -- Click opens the detail modal; the modal carries the UNLOCK action.
            if click then PERK_MODAL = v end

            -- Hold R still works as a quick-unlock shortcut for users who
            -- prefer the keyboard-hold pattern used on SPECIAL/SKILLS.
            local canUnlock = not owned and amtss > 0
            if canUnlock then
                for rk, rv in pairs(v.requirements) do
                    if not CheckSkill({rk, rv}) then canUnlock = false break end
                end
            end

            if IS_R_DOWN and canUnlock then
                deltSt = deltSt == 0 and CurTime() or deltSt
                local p = math.Clamp((CurTime() - deltSt) * 0.75, 0.01, 1)
                surface.SetDrawColor(pip_color.r * 0.5, pip_color.g * 0.5, pip_color.b * 0.5)
                surface.DrawRect(px, py + 2, 240 * p, 24)
                if p == 1 then
                    IsReloadUse = false
                    netstream.Start("perkAdd", v.uid)
                    deltSt = 0
                end
            else
                deltSt = 0
            end
        end

        draww(c)
    end

    -- Right side: detail panel for the hovered perk (image, description,
    -- requirement checklist). Hidden while the modal is up so it doesn't
    -- compete with the modal's own image/description block.
    if hovered and not modal_open then
        if hovered.material then
            surface.SetMaterial(hovered.material)
            surface.SetDrawColor(pip_color)
            surface.DrawTexturedRect(626, 128, 256, 256)
        end

        draw.DrawText(hovered.display:upper(), "Morton Medium@48", 600, 96, pip_color)
        draw.DrawNonParsedText(cached_desc[hovered.display], "Morton Medium@32", 600, 400, pip_color, 0)

        local ry = 540
        if next(hovered.requirements) ~= nil then
            draw.DrawText("REQUIREMENTS", "Morton Medium@42", 600, ry, pip_color)
            ry = ry + 48
            for rk, rv in pairs(hovered.requirements) do
                local ok = CheckSkill({rk, rv})
                local label = (ok and "+ " or "x ") .. (perk_req_format[rk] or rk) .. " " .. rv
                draw.DrawText(label, "Morton Medium@32", 600, ry, ok and color_white or perk_req_negative)
                ry = ry + 34
            end
        end
    end

    -- Modal overlay. Drawn last so it sits on top of the grid + preview. The
    -- modal carries the image, description, requirement checklist, and an
    -- UNLOCK button that fires perkAdd. Owned/unmet-requirement perks open
    -- the same modal but the action button is disabled.
    if PERK_MODAL then
        local v = PERK_MODAL
        local MX, MY, MW, MH = 132, 100, 760, 560

        -- Dim the page behind the modal.
        surface.SetDrawColor(0, 0, 0, 220)
        surface.DrawRect(0, 96, 1024, 608)

        -- Modal background + border.
        surface.SetDrawColor(0, 0, 0, 250)
        surface.DrawRect(MX, MY, MW, MH)
        surface.SetDrawColor(pip_color)
        surface.DrawOutlinedRect(MX, MY, MW, MH)
        surface.DrawOutlinedRect(MX - 2, MY - 2, MW + 4, MH + 4)

        -- Image (top-left) + name (top-right of image).
        if v.material then
            surface.SetMaterial(v.material)
            surface.SetDrawColor(pip_color)
            surface.DrawTexturedRect(MX + 24, MY + 32, 200, 200)
        end
        draw.DrawText(v.display:upper(), "Morton Medium@48", MX + 250, MY + 40, pip_color)

        -- Description.
        if cached_desc[v.display] then
            draw.DrawNonParsedText(cached_desc[v.display], "Morton Medium@32", MX + 250, MY + 110, color_white, 0)
        end

        -- Requirements block (or NONE if the perk has no gating).
        local ry = MY + 260
        draw.DrawText("REQUIREMENTS", "Morton Medium@32", MX + 24, ry, pip_color)
        ry = ry + 40
        if next(v.requirements) ~= nil then
            for rk, rv in pairs(v.requirements) do
                local ok = CheckSkill({rk, rv})
                local label = (ok and "+ " or "x ") .. (perk_req_format[rk] or rk) .. " " .. rv
                draw.DrawText(label, "Morton Medium@32", MX + 24, ry, ok and color_white or perk_req_negative)
                ry = ry + 34
            end
        else
            draw.DrawText("NONE", "Morton Medium@32", MX + 24, ry, color_white)
        end

        -- Status line above the buttons so the player knows why UNLOCK might
        -- be disabled (owned / not enough perk points / requirements unmet).
        local owned = char:isPerkOwned(v._idx)
        local reqsMet = true
        for rk, rv in pairs(v.requirements) do
            if not CheckSkill({rk, rv}) then reqsMet = false break end
        end
        local canUnlock = not owned and amtss > 0 and reqsMet

        local statusY = MY + MH - 110
        local statusTxt
        if owned then
            statusTxt = "ALREADY OWNED"
        elseif not reqsMet then
            statusTxt = "REQUIREMENTS NOT MET"
        elseif amtss <= 0 then
            statusTxt = "NO PERK POINTS AVAILABLE"
        else
            statusTxt = "PERK POINTS: " .. amtss
        end
        draw.DrawText(statusTxt, "Morton Medium@32", MX + MW * 0.5, statusY, canUnlock and pip_color or color_white, TEXT_ALIGN_CENTER)

        -- Action buttons: UNLOCK (left) + CLOSE (right).
        local btnY, btnH = MY + MH - 60, 40
        local unlockCol = canUnlock and pip_color or Color(120, 120, 120)
        local ux, uw = MX + 24, 220
        surface.SetDrawColor(unlockCol)
        surface.DrawOutlinedRect(ux, btnY, uw, btnH)
        local unlockLabel = owned and "OWNED" or (canUnlock and "UNLOCK" or "LOCKED")
        if NzGUI:DrawTextButton(unlockLabel, "Morton Medium@42", ux, btnY - 2, uw, btnH, 0, unlockCol) and canUnlock then
            netstream.Start("perkAdd", v.uid)
            PERK_MODAL = nil
        end

        local cx, cw = MX + MW - 244, 220
        surface.SetDrawColor(pip_color)
        surface.DrawOutlinedRect(cx, btnY, cw, btnH)
        if NzGUI:DrawTextButton("CLOSE", "Morton Medium@42", cx, btnY - 2, cw, btnH, 0, pip_color) then
            PERK_MODAL = nil
        end
    end
end

function DrawPly.SKILLS()
    local height = 34
    local width = 400
    local offset = 80
    local ply = LocalPlayer()
    local character = ply:getChar()
    local amt = (character:getSkillLevel("skillpoints") or 1) - 1
    draw.DrawText("SKILL POINTS: " .. amt, "Morton Medium@42", 950, 64, amt > 0 and pip_color or color_white, TEXT_ALIGN_RIGHT)
    for y, v in pairs(skill_def) do
        local fn, click, draww = NzGUI:DrawTextButtonWithDelayedHover(v[2]:upper(), "Morton Medium@42", 64, offset - 2 + (y * height), width, height, 1, color_white)
        local c = pip_color
        if fn then
            c = color_black
            surface.SetDrawColor(pip_color)
            surface.DrawRect(64, offset + (y * height), (width + 100) - 64, height)
            c = color_black
            --
            surface.SetMaterial(attriIMG[1])
            surface.SetDrawColor(pip_color)
            draw.DrawNonParsedText(skill_desc[y], "Morton Medium@24", 600, 400, pip_color, 0)
            if IS_R_DOWN and amt > 0 then
                deltSt = deltSt == 0 and CurTime() or deltSt
                --
                --
                local p = math.Clamp((CurTime() - deltSt) * 0.75, 0.01, 1)
                surface.SetDrawColor(pip_color.r * 0.5, pip_color.g * 0.5, pip_color.b * 0.5)
                surface.DrawRect(64, offset + (y * height), ((width + 100) - 64) * p, height)
                if p == 1 then
                    IsReloadUse = false
                    -- updateSkill on the server *adds* the value (it's a delta,
                    -- not a target), so send 1 per spent point. Sending
                    -- current+1 doubled the skill each click (1->3->7->15).
                    netstream.Start("skillIncrease", v[1], 1)
                    deltSt = 0
                end
            else
                deltSt = 0
            end
        end

        draw.DrawText(character:getSkillLevel(v[1]), "Morton Medium@48", width + 100, offset - 8 + (y * height), c, TEXT_ALIGN_RIGHT)
        draww(c)

        -- Click-to-spend "+" square sits to the right of the value text.
        -- Hidden entirely when no skillpoints remain to spend.
        if amt > 0 then
            local bx, by, bs = 525, offset + 2 + (y * height), 28
            surface.SetDrawColor(pip_color)
            surface.DrawOutlinedRect(bx, by, bs, bs)
            local hit = NzGUI:DrawTextButton("+", "Morton Medium@32", bx, by - 4, bs, bs, 0, pip_color)
            if hit then
                -- See the hold-R branch above: skillIncrease is a delta on the
                -- server side (skills[key] += value), so we send 1.
                netstream.Start("skillIncrease", v[1], 1)
            end
        end
    end
end

local headers = {"STATS", "SPECIAL", "SKILLS", "PERKS"}
local offset = {0, 102, 225, 335}
local offset2 = {100, 120, 100, 100}
SELECTED_HEADER = "STATS"
local draw_overview = function(pip_color2)
    for i, v in pairs(headers) do
        local vb, fn = NzGUI:DrawTextButton(v, "Morton Medium@48", 64 + offset[i], 64, offset2[i], 32, 1, v == SELECTED_HEADER and pip_color or pip_color_accent)
        if vb then SELECTED_HEADER = v end
    end

    if DrawPly[SELECTED_HEADER] then DrawPly[SELECTED_HEADER]() end
    local lb, ub = LocalPlayer():getChar():getSkillXP("level"), LocalPlayer():getChar():getSkillXPForLevel("level")
    surface.SetDrawColor(128, 128, 128, 2)
    surface.DrawRect(0, 700, 200, 48)
    surface.DrawRect(210, 700, 400, 48)
    surface.DrawRect(620, 700, 230, 48)
    surface.DrawRect(860, 700, 230, 48)
    draw.DrawText("LEVEL " .. LocalPlayer():getChar():getSkillLevel("level"), "Morton Medium@48", 214, 700, pip_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    surface.SetDrawColor(pip_color)
    surface.DrawOutlinedRect(350, 715, 244, 22)
    surface.DrawOutlinedRect(351, 716, 242, 20)
    surface.DrawRect(350, 715, 244 * (lb / ub), 22)
    formattedText("XP", lb .. "/" .. ub, 630, 700, "Morton Medium@42")
end

pipboy:AddRenderPage("STATS", draw_overview)

-- ===========================================================================
-- BUSINESS page: the cyr_main F1 "Business" shop, reimplemented as a native
-- pipboy page. Same data path as F1MenuHTML:ShowBusiness() -- items come from
-- nut.item.list filtered by the CanPlayerUseBusiness hook, priced via
-- item:getPrice()/nut.currency.get, and a cart is submitted with the exact
-- same netstream the F1 menu uses: netstream.Start("bizBuy", { [uid] = qty }).
-- ===========================================================================
pipboy:AddHeader("BUSINESS")

local biz_cart = {}            -- { [uniqueID] = qty }
local biz_items = nil          -- cached filtered catalogue
local biz_index = nil          -- uid -> {name, price}
local biz_cats = nil           -- {"ALL", cat, cat, ...}
local biz_cat_sel = 1
local biz_cat_open = false     -- category dropdown expanded?
local biz_page = 0
local biz_next_build = 0
local biz_perpage = 36         -- 2 columns * 15 rows
local biz_rmb_down = false     -- right-mouse edge tracking (cart removal)
local biz_paging_y = 690       -- Y of the PREV / PAGE X/X / NEXT row (tweak here)
local biz_buy_t = 0

-- Item model preview. This mirrors the inventory page's render-target
-- pipeline (DModelPanel -> mask RT -> pp/colour blend -> unlit RT material)
-- so the model picks up the same pip-boy green tint as the INV page.
local biz_mv                                   -- DModelPanel (created on page enter)
local biz_mv_model                             -- last model assigned (avoid re-set churn)
local biz_rt_idx = math.random(1, 100000000)
local biz_tex = GetRenderTargetEx("biz_modelrt" .. biz_rt_idx, 256, 256, RT_SIZE_OFFSCREEN, MATERIAL_RT_DEPTH_NONE, 0, 0, IMAGE_FORMAT_RGBA16161616)
local biz_myMat = CreateMaterial("biz_modelmat" .. biz_rt_idx, "UnlitGeneric", {
    ["$basetexture"] = biz_tex:GetName(),
    ["$translucent"] = "1",
    ["$vertexcolor"] = 1,
})
local biz_mask = GetRenderTargetEx("biz_modelmask" .. biz_rt_idx, 256, 256, RT_SIZE_OFFSCREEN, MATERIAL_RT_DEPTH_SEPARATE, 4096, 0, IMAGE_FORMAT_RGBA16161616)
local biz_cmat = Material("pp/colour")
biz_cmat:SetFloat("$translucent", "1")

local function biz_color_blend()
    local p = {
        ["$pp_colour_addr"] = 0,
        ["$pp_colour_addg"] = 0,
        ["$pp_colour_addb"] = 0,
        ["$pp_colour_brightness"] = -0.01,
        ["$pp_colour_contrast"] = 5,
        ["$pp_colour_colour"] = 0,
        ["$pp_colour_mulr"] = 0,
        ["$pp_colour_mulg"] = 0,
        ["$pp_colour_mulb"] = 0,
    }
    for k, v in pairs(p) do biz_cmat:SetFloat(k, v) end
    local pre = biz_cmat:GetTexture("$fbtexture")
    biz_cmat:SetTexture("$fbtexture", biz_mask:GetName())
    surface.SetMaterial(biz_cmat)
    surface.DrawTexturedRect(0, 0, 400, 300)
    biz_cmat:SetTexture("$fbtexture", pre)
end

local function biz_pop()
    render.PushRenderTarget(biz_mask)
    cam.Start2D()
    render.ClearDepth()
    render.Clear(0, 0, 0, 0, true, true)
    render.SetWriteDepthToDestAlpha(false)
    biz_mv:PaintManual()
    render.SetWriteDepthToDestAlpha(true)
    cam.End2D()
    render.PopRenderTarget()
    render.PushRenderTarget(biz_tex)
    cam.Start2D()
    biz_color_blend()
    cam.End2D()
    render.PopRenderTarget()
end

-- Draw the hovered item's model into a square at (x, y). Same call sequence
-- as the inventory page's drawItem().
local function biz_draw_model(model, ang, x, y, size)
    if not (IsValid(biz_mv) and biz_mv.Entity) then return end
    biz_mv.Angle = ang or angle_zero
    local hp = biz_mv.Entity:GetPos()
    biz_mv:SetLookAt(hp)
    biz_mv:SetCamPos(hp - Vector(-15, 0, 0))
    biz_pop()
    local target = model or "models/props_junk/cardboard_box001a.mdl"
    if target ~= biz_mv_model then
        biz_mv:SetModel(target)
        biz_mv_model = target
    end
    surface.SetMaterial(biz_myMat)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(x, y, size, size)
    draw.NoTexture()
end

-- Create/destroy the model panel alongside the BUSINESS page, exactly like
-- the inventory page does for InventoryModelView.
hook.Add("pip_changepage", "biz_modelview", function(from, to)
    if to == "BUSINESS" then
        if IsValid(biz_mv) then biz_mv:Remove() end
        biz_mv = vgui.Create("DModelPanel")
        biz_mv:SetSize(200, 200)
        biz_mv:SetModel("models/props_junk/cardboard_box001a.mdl")
        biz_mv:SetPaintedManually(true)
        biz_mv.Angle = Angle(0, 0, 0)
        biz_mv_model = "models/props_junk/cardboard_box001a.mdl"
        function biz_mv:Guess() end
    elseif from == "BUSINESS" then
        if IsValid(biz_mv) then biz_mv:Remove() end
        biz_mv = nil
        biz_mv_model = nil
    end
end)

local function biz_build()
    biz_items = {}
    biz_index = {}
    local catset = {}
    for uid, itemTable in SortedPairsByMemberValue(nut.item.list, "name") do
        if hook.Run("CanPlayerUseBusiness", LocalPlayer(), uid) then
            local cat = itemTable.category or "Misc"
            local price = itemTable:getPrice() or 0
            local name = L(itemTable.name or uid)
            local model = itemTable.model
            local ang = itemTable.Angle
            catset[cat] = true
            biz_items[#biz_items + 1] = {uid = uid, name = name, cat = cat, price = price, model = model, angle = ang}
            biz_index[uid] = {name = name, price = price}
        end
    end
    biz_cats = {"ALL"}
    for cat in SortedPairs(catset) do biz_cats[#biz_cats + 1] = cat end
    if biz_cat_sel > #biz_cats then biz_cat_sel = 1 end
end

netstream.Hook("bizResp", function()
    biz_cart = {}
    biz_next_build = 0 -- force a catalogue rebuild (permits/flags may differ)
    surface.PlaySound("buttons/button3.wav")
end)

pipboy:AddRenderPage("BUSINESS", function()
    local char = LocalPlayer():getChar()
    if not char then return end

    if biz_items == nil or CurTime() > biz_next_build then
        biz_build()
        biz_next_build = CurTime() + 2
    end

    local curCat = biz_cats[biz_cat_sel] or "ALL"

    -- Category dropdown: a single header button showing the current
    -- category; clicking it toggles an option list that overlays the grid.
    local DD_X, DD_Y, DD_W, DD_H = 64, 56, 360, 32
    if NzGUI:DrawTextButton((biz_cat_open and "v " or "> ") .. "CATEGORY: " .. curCat:upper(), "Morton Medium@32", DD_X, DD_Y, DD_W, DD_H, 0, pip_color) then
        biz_cat_open = not biz_cat_open
    end
    surface.SetDrawColor(pip_color)
    surface.DrawOutlinedRect(DD_X, DD_Y, DD_W, DD_H)

    local gridTop = 112
    local perpage = biz_perpage

    -- Filter to the selected category.
    local view = {}
    for _, it in ipairs(biz_items) do
        if curCat == "ALL" or it.cat == curCat then view[#view + 1] = it end
    end

    local pages = math.max(1, math.ceil(#view / perpage))
    biz_page = math.Clamp(biz_page, 0, pages - 1)

    local hovered = nil
    local rmb = input.IsMouseDown(MOUSE_RIGHT)
    local rmbPressed = rmb and not biz_rmb_down

    if not biz_cat_open then
        -- Empty state: the catalogue is permit-gated (CanPlayerUseBusiness), so
        -- a character holding no permits sees nothing here -- explain that
        -- instead of leaving a blank grid that looks broken.
        if #view == 0 then
            if #biz_items == 0 then
                draw.DrawText("NO MERCHANDISE AVAILABLE", "Morton Medium@42", 64, gridTop + 28, perk_req_negative)
                draw.DrawText("You need the relevant permit in your inventory", "Morton Medium@32", 64, gridTop + 84, pip_color)
                draw.DrawText("before any goods can be requisitioned.", "Morton Medium@32", 64, gridTop + 118, pip_color)
            else
                draw.DrawText("NOTHING IN THIS CATEGORY", "Morton Medium@42", 64, gridTop + 28, pip_color)
            end
        end

        -- Item grid: 2 columns x 15 rows. Left click cycles quantity, right
        -- click removes a unit (edge-detected so it fires once per press).
        local startIdx = biz_page * perpage
        for slot = 0, perpage - 1 do
            local it = view[startIdx + slot + 1]
            if not it then break end
            local col = slot % 2
            local row = math.floor(slot / 2)
            local px = 64 + col * 248
            local py = gridTop + row * 28
            local qty = biz_cart[it.uid] or 0
            -- Shrink the font for names that would overflow the 230px slot so
            -- they stay on one line (the qty marker eats the right ~30px).
            local label = it.name:upper()
            local nameFont = "Morton Medium@24"
            surface.SetFont(nameFont)
            if surface.GetTextSize(label) > (qty > 0 and 200 or 228) then
                nameFont = "Morton Medium@19"
            end
            local fn, click, draww = NzGUI:DrawTextButtonWithDelayedHover(label, nameFont, px, py, 230, 28, 1, color_white)
            local c = qty > 0 and pip_color_accent or color_white
            if fn then
                hovered = it
                c = color_black
                surface.SetDrawColor(pip_color)
                surface.DrawRect(px, py + 2, 230, 24)
                -- Left click adds one (capped at 20); use the cart [-]/[+] to
                -- fine-tune from there.
                if click then biz_cart[it.uid] = math.min(qty + 1, 20) end
                -- Right click removes a single unit from the cart (nil at zero).
                if rmbPressed then
                    local n = qty - 1
                    biz_cart[it.uid] = n > 0 and n or nil
                end
            end
            draww(c)
            if qty > 0 then
                draw.DrawText("x" .. qty, "Morton Medium@24", px + 228, py, c, TEXT_ALIGN_RIGHT)
            end
        end

        -- Paging controls under the grid.
        if pages > 1 then
            -- Centered text button (align 0) that underlines on hover.
            local function pagingBtn(lbl, bx)
                local click, hover = NzGUI:DrawTextButton(lbl, "Morton Medium@32", bx, biz_paging_y, 130, 32, 0, pip_color)
                if hover then
                    surface.SetFont("Morton Medium@32")
                    local tw, th = surface.GetTextSize(lbl)
                    surface.SetDrawColor(pip_color)
                    surface.DrawRect(bx + (130 - tw) / 2, biz_paging_y + th, tw, 2)
                end
                return click
            end
            local prevC = pagingBtn("< PREV", 64)
            draw.DrawText("PAGE " .. (biz_page + 1) .. " / " .. pages, "Morton Medium@32", 312, biz_paging_y, pip_color, TEXT_ALIGN_CENTER)
            local nextC = pagingBtn("NEXT >", 430)
            if prevC then biz_page = math.max(0, biz_page - 1) end
            if nextC then biz_page = math.min(pages - 1, biz_page + 1) end
        end
    end
    biz_rmb_down = rmb

    -- Right panel: hovered item detail + spinning model preview (INV logic).
    if hovered then
        biz_draw_model(hovered.model, hovered.angle, 600, 96, 180)
        draw.DrawText("CAT: " .. hovered.cat:upper(), "Morton Medium@24", 800, 110, pip_color)
        draw.DrawText("PRICE: " .. nut.currency.get(hovered.price), "Morton Medium@24", 800, 150, pip_color)
        draw.DrawText("IN CART: " .. (biz_cart[hovered.uid] or 0), "Morton Medium@24", 800, 190, pip_color)
        -- Name sits just above the CART header (y=320) so it never collides
        -- with the full-width category tab strip at the top.
        draw.DrawText(hovered.name:upper(), "Morton Medium@32", 600, 284, pip_color)
    end

    -- Right panel: cart summary + total. The CRT is curved, so keep everything
    -- inside the safe band: right edge at BIZ_R (not the 1024 RT edge) and the
    -- purchase bar above BIZ_BOTTOM so the curve doesn't clip it.
    local BIZ_L = 600          -- right-panel left edge
    local BIZ_R = 940          -- safe right edge for right-aligned values
    local total, lines = 0, 0
    draw.DrawText("CART", "Morton Medium@42", BIZ_L, 320, pip_color)
    local cy = 366
    -- Quantity tweaks are deferred until after the loop: SortedPairs snapshots
    -- the keys, but mutating biz_cart mid-iteration (esp. removing at zero) is
    -- still cleaner to apply once we are done drawing.
    local cartUid, cartDelta
    for uid, qty in SortedPairs(biz_cart) do
        local info = biz_index[uid]
        if info and qty > 0 then
            total = total + info.price * qty
            if lines < 6 then
                if NzGUI:DrawTextButton("[-]", "Morton Medium@24", BIZ_L, cy, 34, 26, 0, pip_color) then
                    cartUid, cartDelta = uid, -1
                end
                if NzGUI:DrawTextButton("[+]", "Morton Medium@24", BIZ_L + 36, cy, 34, 26, 0, pip_color) then
                    cartUid, cartDelta = uid, 1
                end
                draw.DrawText(info.name .. "  x" .. qty, "Morton Medium@24", BIZ_L + 78, cy, color_white)
                draw.DrawText(nut.currency.get(info.price * qty), "Morton Medium@24", BIZ_R, cy, pip_color, TEXT_ALIGN_RIGHT)
                cy = cy + 30
            end
            lines = lines + 1
        end
    end
    if cartUid then
        -- Cap at 20; zero removes the line.
        local nv = math.Clamp((biz_cart[cartUid] or 0) + cartDelta, 0, 20)
        biz_cart[cartUid] = nv > 0 and nv or nil
    end
    if lines > 6 then
        draw.DrawText("+ " .. (lines - 6) .. " more...", "Morton Medium@24", BIZ_L, cy, pip_color)
    end

    local money = char.getMoney and char:getMoney() or 0
    draw.DrawText("YOUR CAPS: " .. nut.currency.get(money), "Morton Medium@32", BIZ_L, 588, pip_color)
    draw.DrawText("TOTAL: " .. nut.currency.get(total), "Morton Medium@42", BIZ_L, 626, total > money and perk_req_negative or pip_color)

    -- Hold R to submit the cart (same netstream as the F1 checkout).
    local boxY, boxW = 672, BIZ_R - BIZ_L
    local canBuy = lines > 0 and total <= money
    if IS_R_DOWN and canBuy then
        biz_buy_t = biz_buy_t == 0 and CurTime() or biz_buy_t
        local p = math.Clamp((CurTime() - biz_buy_t) * 0.75, 0.01, 1)
        surface.SetDrawColor(pip_color.r * 0.5, pip_color.g * 0.5, pip_color.b * 0.5)
        surface.DrawRect(BIZ_L, boxY, boxW * p, 34)
        if p == 1 then
            IsReloadUse = false
            netstream.Start("bizBuy", biz_cart)
            biz_buy_t = 0
        end
    else
        biz_buy_t = 0
    end
    surface.SetDrawColor(pip_color)
    surface.DrawOutlinedRect(BIZ_L, boxY, boxW, 34)
    draw.DrawText(canBuy and "HOLD R TO REQUISITION" or (lines == 0 and "CART EMPTY" or "NOT ENOUGH CAPS"), "Morton Medium@32", BIZ_L + 20, boxY + 4, pip_color)

    -- Open dropdown is drawn LAST so it overlays the grid and the right-hand
    -- cart panel instead of rendering behind them. Each row selects a category
    -- and closes the menu; the current one is highlighted. Past 19 entries the
    -- list spills into additional columns so it never runs off the screen.
    if biz_cat_open then
        local DD_PERCOL = 19
        local listY = DD_Y + DD_H + 4
        local cols = math.ceil(#biz_cats / DD_PERCOL)
        local rowsInCol = math.min(#biz_cats, DD_PERCOL)
        local panelH = rowsInCol * 34 + 6
        local colStride = DD_W + 12
        local panelW = (cols - 1) * colStride + DD_W
        surface.SetDrawColor(0, 0, 0, 230)
        surface.DrawRect(DD_X, listY, panelW, panelH)
        surface.SetDrawColor(pip_color)
        surface.DrawOutlinedRect(DD_X, listY, panelW, panelH)
        for i, cat in ipairs(biz_cats) do
            local col = math.floor((i - 1) / DD_PERCOL)
            local rowI = (i - 1) % DD_PERCOL
            local ox = DD_X + col * colStride
            local oy = listY + 4 + rowI * 34
            local sel = i == biz_cat_sel
            local cl, hv = NzGUI:DrawTextButton(cat:upper(), "Morton Medium@32", ox + 4, oy, DD_W - 8, 30, 0, sel and pip_color or pip_color_accent)
            if hv then
                surface.SetDrawColor(pip_color.r, pip_color.g, pip_color.b, 40)
                surface.DrawRect(ox + 2, oy, DD_W - 4, 30)
            end
            if cl then
                biz_cat_sel = i
                biz_page = 0
                biz_cat_open = false
            end
        end
    end
end)
-- // local ply = LocalPlayer()
-- // local JawScale = Vector(1, 1, 1)
-- // local PlyPos = Vector(0, 0, 0)
-- // ply:ManipulateBoneScale(ply:LookupBone("skin_bone_R_EyeUnder"), JawScale)
-- // ply:ManipulateBoneScale(ply:LookupBone("skin_bone_R_EyeUnder"), JawScale)
-- // ply:ManipulateBonePosition(ply:LookupBone("skin_bone_R_EyeUnder"), PlyPos)
-- // ply:ManipulateBonePosition(ply:LookupBone("skin_bone_R_EyeUnder"), PlyPos)
tablet.pages["MAP"] = function(pip_color) end
if IsValid(icon) then icon:Remove() end
SELECTED_HEADER = "STATS"
print("MAP")
local mpp_texture = Material("alaska_map01.png", "smooth")
MAP_ICON_SETTLEMENT = Material("map_icons/settlement.png", "smooth")
--14303 14303 
MAP_LOCATIONS = {{"The Store", Vector(-244.423615, -3355.505615, 92.031250), MAP_ICON_SETTLEMENT}}
MAP_ZONE_TYPE_WARZONE = {Color(255, 0, 0, 25)}
MAP_ZONES = {{"FREE4ALL", MAP_ZONE_TYPE_WARZONE, util.JSONToTable('[{"y":118.43226227534807,"x":562.4651077926608},{"y":118.03404185579342,"x":589.1908673825369},{"y":115.39816770686375,"x":603.6853898151413},{"y":112.80391262344355,"x":620.3225932822946},{"y":114.6097056523339,"x":643.2328405814881},{"y":120.39672050389498,"x":642.8041905630865},{"y":142.8898726461387,"x":641.1381460659081},{"y":163.2534320753849,"x":639.6298083558241},{"y":178.5575555495921,"x":641.9212290299331},{"y":190.9211015610624,"x":647.0196843564067},{"y":208.4650112325953,"x":649.1260834854015},{"y":226.890756302521,"x":647.7612920168067},{"y":240.40832688002213,"x":646.7600503933326},{"y":248.70051236735567,"x":646.1684582592161},{"y":254.8048336579157,"x":637.9454581787094},{"y":260.78230904588119,"x":606.0205260822395},{"y":253.91523511776973,"x":590.7617774527695},{"y":244.1922834370974,"x":579.1439482955591},{"y":236.4950325476906,"x":574.9705707442649},{"y":228.8116786404343,"x":572.2867460168374},{"y":214.57968337882606,"x":566.1634152121159},{"y":198.75864008924735,"x":565.1051510362356},{"y":182.83003894988657,"x":567.5592113270948},{"y":162.18880344108443,"x":567.3672892115332},{"y":118.32170938630924,"x":581.5302877537877},{"y":110.27042089646075,"x":579.8008083251549}]')},}
MAP_ZONES_DEBUG = MAP_ZONES_DEBUG or {}
print(util.TableToJSON(MAP_ZONES_DEBUG))
local map = {
    x = 100,
    y = 50,
    width = 800,
    height = 800
}

function MAP_ZONE_OPTIMISE()
    for i, a in pairs(MAP_ZONES) do
        for c, v in pairs(a[2]) do
            local playerPos = v
            local pX = ((playerPos.x + 1000) / 16303) / 2 + 0.5
            local pY = 1 - ((playerPos.Y / 16303) / 2 + 0.5)
            print(pX, pY)
            a[2][c] = {
                x = map.x + (map.width * pX),
                y = map.y + (map.height * pY)
            }
        end
    end
end

print("==========")
concommand.Add("markpoint", function(ply, cmd, args)
    local playerPos = LocalPlayer():GetPos()
    local pX = ((playerPos.x + 1000) / 16303) / 2 + 0.5
    local pY = 1 - ((playerPos.Y / 16303) / 2 + 0.5)
    table.insert(MAP_ZONES_DEBUG, {
        x = map.x + (map.width * pX),
        y = map.y + (map.height * pY)
    })
end)

concommand.Add("clearpoints", function(ply, cmd, args) MAP_ZONES_DEBUG = {} end)
local function TickBox(optionName, bool, func, x, y)
    local fn, click, draww = NzGUI:DrawTextButtonWithDelayedHover("          " .. optionName, "Morton Medium@32", x, y, 400, 32, 1, pip_color)
    -- if bool is true then draw a filled box
    if click then func() end
    if fn then surface.SetAlphaMultiplier(0.5) end
    surface.DrawOutlinedRect(x, y, 32, 32)
    if bool then surface.DrawRect(x + 4, y + 4, 24, 24) end
    surface.SetAlphaMultiplier(1)
    draww(bool and pip_color or color_white)
end

local function getPipboy()
    local self = LocalPlayer():getChar()
    local apperance = self:getApperance()
    return apperance.pipboy == 1
end

local volIndicator = 0.5
local pipboyColor = {255, 255, 255}
local function Slides(str, colorIndex, x, y, width)
    local startX = 15 + x
    local startY = 250 + y
    draw.DrawText(str, "Morton Black@42", startX, startY)
    surface.DrawLine(startX, startY + 50, startX + width, startY + 50)
    surface.DrawRect(startX + ((pipboyColor[colorIndex] / 255) * width) - 8, startY + 50 - 8, 18, 16)
    if CheckIfCursorInRange(startX, startY, width, 80) and input.IsMouseDown(MOUSE_LEFT) then
        volIndicator = math.Clamp((cursor.x - startX) / width, 0, 1)
        pipboyColor[colorIndex] = volIndicator * 255
        pip_color = Color(pipboyColor[1], pipboyColor[2], pipboyColor[3])
        timer.Create("pipboyColor", 1, 1, function() LocalPlayer():ConCommand("fallout_pipboy_color " .. pipboyColor[1] .. " " .. pipboyColor[2] .. " " .. pipboyColor[3]) end)
    end
end

pipboy:AddRenderPage("OPTIONS", function()
    surface.SetDrawColor(pip_color.r, pip_color.g, pip_color.b, 255)
    TickBox("Wear Pipboy", not getPipboy(), function()
        LocalPlayer():ConCommand("toggle_pipboy")
        local self = LocalPlayer():getChar()
        local apperance = self:getApperance()
        apperance.pipboy = apperance.pipboy == 1 and 0 or 1
    end, 100, 100)

    pipboyColor = {pip_color.r, pip_color.g, pip_color.b}
    Slides("HUD COLOR R", 1, 0, 350, 200)
    Slides("G ", 2, 333, 350, 200)
    Slides("B", 3, 666, 350, 200)
end)

-- MAP_ZONE_OPTIMISE() 
pipboy:AddRenderPage("MAP", function()
    surface.SetMaterial(mpp_texture)
    surface.SetDrawColor(pip_color.r, pip_color.g, pip_color.b, 75)
    surface.DrawTexturedRect(100, 50, 800, 800)
    for i, v in pairs(MAP_ZONES) do
        surface.SetDrawColor(v[2][1])
        draw.NoTexture()
        surface.DrawPoly(v[3])
    end

    surface.SetDrawColor(pip_color.r, pip_color.g, pip_color.b, 255)
    local playerPos = LocalPlayer():GetPos()
    local pX = ((playerPos.x + 1000) / 16303) / 2 + 0.5
    local pY = 1 - ((playerPos.Y / 16303) / 2 + 0.5)
    surface.DrawRect(map.x + (map.width * pX) - 4, map.y + (map.height * pY) - 4, 8, 8)
    for i, v in pairs(MAP_LOCATIONS) do
        local playerPos = v[2]
        local pX = ((playerPos.x + 1000) / 16303) / 2 + 0.5
        local pY = 1 - ((playerPos.Y / 16303) / 2 + 0.5)
        surface.SetMaterial(v[3])
        surface.DrawTexturedRect(map.x + (map.width * pX) - 16, map.y + (map.height * pY) - 16, 32, 32)
    end

    surface.SetDrawColor(pip_color.r + 50, pip_color.g + 50, pip_color.b + 50, 255)
    --surface.SetDrawColor( 0,255,0, 100 )
    --draw.NoTexture()
    --surface.DrawPoly( MAP_ZONES_DEBUG )
end)

--[[
skin_bone_C_MasterMouth
skin_bone_L_MouthCorner
skin_bone_L_MouthBot
skin_bone_L_MouthTop
skin_bone_C_MouthBot
skin_bone_C_MouthTop
skin_bone_R_MouthBot
skin_bone_R_MouthCorner
skin_bone_R_MouthTop
skin_bone_L_Cheek
skin_bone_C_MasterEyebrow
skin_bone_R_EyebrowIn
skin_bone_R_EyebrowOut
skin_bone_L_EyebrowIn
skin_bone_L_EyebrowOut
]]
--LocalPlayer():SetPlayerColor(Vector(1, 1.1, 1.3))
--[[  
LocalPlayer():SetSubMaterial(7, "models/kuma96/solesurvivor_vault111_female/vault111suit2.vmt")
LocalPlayer():SetPlayerColor(Vector(1, 1, 1))
local vm = LocalPlayer():GetViewModel(0)
vm:SetSubMaterial(9, "models/kuma96/solesurvivor_vault111_female/vault111suit2.vmt")

function vm:GetPlayerColor()
    return LocalPlayer():GetPlayerColor()
end

if IsValid(icon) thenx
    icon:Remove()
end]]
function CREATE_PERK_MENU()
    if IsValid(PerkPanel) then PerkPanel:Remove() end
    PerkPanel = vgui.Create("DPanel")
    PerkPanel:SetPos(10, 30) -- Set the position of the panel
    PerkPanel:SetSize(1000, 720) -- Set the size of the panel
    PerkPanel:Center()
    PerkPanel:MakePopup() -- Makes your mouse be able to move around.
    local close = PerkPanel:Add("DButton")
    close:SetSize(48, 48)
    close:SetText("X")
    close:SetFont("Morton Medium@48")
    close:SetPos(950, 0)
    close:SetZPos(100)
    close.DoClick = function() PerkPanel:Remove() end
    close:SetTextColor(pip_color)
    close.Paint = function() end
    function PerkPanel:Paint(w, h)
        Derma_DrawBackgroundBlur(self, 0)
        surface.SetDrawColor(pip_color.r * 0.5, pip_color.g * 0.5, pip_color.b * 0.5, 150)
        surface.DrawRect(0, 0, w, h)
        self:NoClipping(true)
        surface.DrawShadow(0, 0, 64, 4, pip_color)
        surface.DrawShadow(256, 0, w - 255, 4, pip_color)
        surface.SetFont("Morton Medium@48")
        NzGUI.DrawShadowText("PERKS", 120, -24, pip_color)
        surface.DrawShadow(0, 4, 4, h - 6, pip_color)
        surface.DrawShadow(0, h - 6, w, 4, pip_color)
        surface.DrawShadow(w - 4, 0, 4, h - 2, pip_color)
    end

    local formatString = {
        ["str"] = "Strength",
        ["agi"] = "Agility",
        ["per"] = "Perception",
        ["luc"] = "Luck",
        ["int"] = "Intelligence",
        ["cha"] = "Charisma",
        ["end"] = "Endurance",
        level = "Level"
    }

    local DScrollPanel = vgui.Create("DScrollPanel", PerkPanel)
    DScrollPanel:Dock(LEFT)
    DScrollPanel:SetWide(400)
    DScrollPanel:DockMargin(7, 24, 7, 7)
    local scrollbar = DScrollPanel.VBar
    function scrollbar:PerformLayout()
        local Wide = self:GetWide()
        local BtnHeight = 0
        if self:GetHideButtons() then BtnHeight = 0 end
        local Scroll = self:GetScroll() / self.CanvasSize
        local BarSize = math.max(self:BarScale() * (self:GetTall() - (BtnHeight * 2)), 10)
        local Track = self:GetTall() - (BtnHeight * 2) - BarSize
        Track = Track + 1
        Scroll = Scroll * Track
        self.btnGrip:SetPos(0, BtnHeight + Scroll)
        self.btnGrip:SetSize(Wide, BarSize)
        if BtnHeight > 0 then
            self.btnUp:SetPos(0, 0, Wide, Wide)
            self.btnUp:SetSize(0, 0)
            self.btnDown:SetPos(0, self:GetTall() - BtnHeight)
            self.btnDown:SetSize(Wide, 0)
            self.btnUp:SetVisible(true)
            self.btnDown:SetVisible(true)
        else
            self.btnUp:SetVisible(false)
            self.btnDown:SetVisible(false)
            self.btnDown:SetSize(Wide, BtnHeight)
            self.btnUp:SetSize(Wide, BtnHeight)
        end
    end

    local sbar = DScrollPanel:GetVBar()
    sbar.btnUp:SetVisible(false)
    function sbar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end

    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, pip_color)
    end

    local RightPanel = PerkPanel:Add("DPanel")
    RightPanel:Dock(FILL)
    RightPanel:DockMargin(0, 24, 0, 0)
    RightPanel.Header = ""
    local _VVV = nil
    local function computeDescMarkup(self, description, w)
        --  if (self.desc ~= description) then
        self.body = "<font=Morton Medium@32>" .. description .. "</font>"
        self.body = self.body .. "<font=Morton Medium@42>" .. "\nRequirements\n" .. "</font>"
        for i, v in pairs(self.requirements) do
            local isValid = CheckSkill({i, v})
            local display = formatString[i] or i
            if isValid then
                self.body = self.body .. "<font=Morton Medium@42><color=255,255,255>✓  " .. display .. " " .. v .. " </color>\n"
            else
                self.body = self.body .. "<font=Morton Medium@42><color=255,35,35>✗  " .. display .. " " .. v .. " </color>\n"
            end
        end

        -- self.body = self.body .. "<font=Morton Medium@42><color=255,255,255> ✓5 SCIENCE </color>\n"
        self.body = self.body .. "</font>"
        self.markup = nut.markup.parse(self.body, w - 20)
        -- end
        return self.markup
    end

    function RightPanel:Paint(w, h)
        if RightPanel.Ready then
            surface.SetFont("Morton Medium@48")
            NzGUI.DrawShadowText(self.Header, 0, 00, pip_color)
            if self.v.image then
                surface.SetDrawColor(pip_color)
                surface.SetMaterial(self.v.image)
                surface.DrawTexturedRect(w * 0.25, 50, w * 0.5, 240)
            end

            computeDescMarkup(self.v, self.v.desc, w)
            if self.v.markup then
                self.v.markup:draw(0, 280, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, alpha)
            else
                computeDescMarkup(self.v, self.v.desc, w)
                self.v.markup:draw(0, 280, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, alpha)
            end
        end
    end

    local Unlock = RightPanel:Add("DButton")
    Unlock:Dock(BOTTOM)
    Unlock:SetTall(32)
    Unlock:SetText("")
    Unlock.PaintOver = function(self, w, h)
        surface.SetFont("Morton Medium@32")
        NzGUI.DrawShadowText("UNLOCK", w / 2 - 32, 0, self.col)
    end

    local function ApplyFocus(v, i)
        v = v or _VVV
        if not IsValid(RightPanel) then return end
        RightPanel.Header = v.display
        RightPanel.v = v
        RightPanel.id = i
    end

    local PERK_SELECTED_ID = 0
    local function SetFocus(v, i)
        _VVV = v
        PERK_SELECTED_ID = v.id or 0
    end

    Unlock.DoClick = function()
        if PERK_SELECTED_ID == 0 then return end
        netstream.Start("perkAdd", PERK_SELECTED_ID)
    end
    local doonce = true
    local perksSorted = table.Copy(PERKS)
    -- sort perks by level required
    table.sort(perksSorted, function(a, b) return (a.requirements.level or 0) < (b.requirements.level or 0) end)
    for i, v in pairs(perksSorted) do
        local isOwned = LocalPlayer():hasTrait(v.uid) == true
        timer.Simple(isOwned and 0 or FrameTime() * 2, function()
            if doonce then
                doonce = false
                SetFocus(v, v.id)
                ApplyFocus(v, v.id)
                if IsValid(RightPanel) then RightPanel.Ready = true end
            end

            local DButton = DScrollPanel:Add("DButton")
            DButton:Dock(TOP)
            DButton:SetTall(32)
            DButton:SetColor(pip_color)
            DButton:SetFont("Morton Medium@32")
            DButton:SetText("")
            DButton.PaintOver = function(self, w, h)
                local isOwned = LocalPlayer():hasTrait(v.uid) == true
                if DButton.Calced == nil then
                    local weCanDoThis = true
                    for _c, _v in pairs(v.requirements) do
                        local isValid = CheckSkill({_c, _v}, ply)
                        if not isValid then weCanDoThis = false end
                    end

                    DButton.Calced = weCanDoThis
                end

                local prefix = "" -- weCanDoThis and not isOwned and " + " or ""
                DButton.col = isOwned and pip_color or Color(255, 255, 255)
                NzGUI.DrawShadowText(prefix .. v.display, 4, 0, self.col) --.. "   \\ " .. i
            end

            DButton.DoClick = function() SetFocus(v, v.id) end
            function DButton:OnCursorEntered()
                ApplyFocus(v, i)
            end

            function DButton:OnCursorExited()
                ApplyFocus(nil)
            end

            DButton:DockMargin(0, 0, 6, 2)
        end)
    end
end

function proc_luck()
    surface.PlaySound("luck.wav")
    local luckmat1 = Material("vault_boy/luckproc")
    timer.Simple(2, function() hook.Remove("HUDPaint", "LUCK") end)
    hook.Add("HUDPaint", "LUCK", function()
        surface.SetMaterial(luckmat1)
        luckmat1:SetInt("$frame", 4)
        surface.SetDrawColor(0, 0, 0)
        surface.DrawTexturedRect(ScrW() / 2 - 62, ScrH() - 254, 128, 128)
        surface.SetDrawColor(pip_color)
        surface.DrawTexturedRect(ScrW() / 2 - 64, ScrH() - 256, 128, 128)
    end)
end

hook.Add("InitializedPlugins", "InitializedPlugins_SV_POLK", function() netstream.Hook("luck", proc_luck) end)
if nut or NUT or Nut then netstream.Hook("luck", proc_luck) end