if SERVER then return end
surface.CreateFont("CYR_CombatHUD", {
    font = "VCR OSD Mono",
    size = 22,
    weight = 400,
    antialias = true,
    shadow = false,
    outline = false
})

surface.CreateFont("CYR_CombatHUD_Small", {
    font = "VCR OSD Mono",
    size = 18,
    weight = 400,
    antialias = true,
    shadow = false,
    outline = false
})

surface.CreateFont("CYR_CombatHUD_Large", {
    font = "VCR OSD Mono",
    size = 36,
    weight = 600,
    antialias = true,
    shadow = false,
    outline = false
})

-- Override DrawHUD for combat weapons
local function ApplyCombatTheme()
    local function DrawHUD(self)
        if not CLIENT then return end
        local client = LocalPlayer()
        local user = self:getNetVar("selected", client)
        if not IsValid(user) then user = client end
        local scrModX = ScrW() / 1920
        local scrModY = ScrH() / 1080
        -- --- START ORIGINAL LOGIC RESTORATION --- --
        local actions = (self.GetActions and self:GetActions()) or {}
        local action = actions[self.actNum or 1] or {}
        local altPressed = client:KeyDown(IN_WALK)
        if (self.nextCEntTrace or 0) < CurTime() then
            local data = {
                start = client:GetShootPos(),
                endpos = client:GetShootPos() + client:GetAimVector() * 4096,
                filter = {client, self}
            }

            local trace = util.TraceLine(data)
            if trace.Hit then
                local entity = trace.Entity
                if (action and action.selfOnly) or altPressed then
                    self.viewed = user
                elseif IsValid(entity) and (entity.combat or entity:IsPlayer()) then
                    self.viewed = entity
                    self.nextCEntTrace = CurTime() + 1
                else
                    self.viewed = nil
                end

                if action and action.radius then
                    local targetPos = self.viewed and self.viewed:GetPos() or trace.HitPos
                    client.ccAreaShow = {targetPos, action.radius}
                else
                    client.ccAreaShow = nil
                end
            end
        end

        -- --- END ORIGINAL LOGIC RESTORATION --- --
        -- Get Theme Colors — prefer the shared pipboy tint (pip_color, set by
        -- yshera_pipboy's `fallout_pipboy_color` convar) so this combat overlay
        -- matches the FO3 bracket HUD and the notify panel. Fall back to the
        -- legacy cyr_f4_primary cookie if pip_color isn't available yet.
        local primary
        if CYR_GetHUDColor then
            primary = CYR_GetHUDColor()
        elseif pip_color then
            primary = ColorAlpha(pip_color, 255)
        else
            primary = ColorAlpha(HexToColor(cookie.GetString("cyr_f4_primary", "#ffb642")), 255)
        end
        local primaryDim = ColorAlpha(primary, 40)
        local primaryVDim = ColorAlpha(primary, 10)
        local bg = Color(5, 5, 5, 230)
        -- Helper for panning effect
        local function drawPanningBackground(x, y, w, h)
            local time = CurTime() * 25
            local spacing = 40 * scrModX
            local offset = time % spacing
            render.SetScissorRect(x, y, x + w, y + h, true)
            surface.SetDrawColor(primaryVDim)
            for i = -spacing * 5, w + h, spacing do
                -- Triple lines for "scanline" look
                surface.DrawLine(x + i + offset, y, x + i + offset - h, y + h)
                surface.DrawLine(x + i + offset + 1, y, x + i + offset - h + 1, y + h)
                surface.DrawLine(x + i + offset + 2, y, x + i + offset - h + 2, y + h)
            end

            render.SetScissorRect(0, 0, 0, 0, false)
        end

        -- Helper to draw a tactical box
        local function drawTacticalBox(x, y, w, h, title)
            local headerHeight = 25 * scrModY
            -- Background
            surface.SetDrawColor(bg)
            surface.DrawRect(x, y, w, h)
            -- Constrain panning animation to header
            drawPanningBackground(x, y, w, headerHeight)
            -- Border
            surface.SetDrawColor(primary)
            surface.DrawOutlinedRect(x, y, w, h)
            -- Header highlight
            surface.SetDrawColor(primaryDim)
            surface.DrawRect(x + 1, y + 1, w - 2, headerHeight)
            -- Title
            if title then draw.SimpleText(title, "CYR_CombatHUD_Small", x + w / 2, y + 12 * scrModY, primary, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
            return y + h + 15 * scrModY
        end

        -- Target Selected (Top Center)
        if user ~= client then
            local name = self:getNetVar("selectedName", "Unknown Target")
            local tx, ty = ScrW() * 0.5 - 150 * scrModX, ScrH() * 0.2
            drawTacticalBox(tx, ty, 300 * scrModX, 45 * scrModY, "TARGET: " .. name:upper())
        end

        -- Turn State (Center/Top)
        local APCircle = client:getNetVar("showAPCircle")
        local turnOver = client:getNetVar("turnOverIcon")
        if APCircle or turnOver then
            local turnState = turnOver and "TURN OVER" or "YOUR TURN"
            local tx, ty = ScrW() * 0.5 - 100 * scrModX, 70 * scrModY
            drawTacticalBox(tx, ty, 200 * scrModX, 45 * scrModY, turnState)
        end

        local posX = ScrW() - 320 * scrModX
        local posY = 50 * scrModY
        local width = 280 * scrModX
        -- AP Display
        local AP = (user.getAP and user:getAP()) or 0
        local APMax = (user.getAPMax and user:getAPMax()) or 0
        if AP and APMax then
            local title = "AP: [" .. AP .. "/" .. APMax .. "]"
            posY = drawTacticalBox(posX, posY, width, 40 * scrModY, title)
        end

        -- Buff Display
        local buffs = user.getBuffs and user:getBuffs()
        if buffs and table.Count(buffs) > 0 then
            local items = {}
            for k, v in pairs(buffs) do
                table.insert(items, v.name or k)
            end

            local listHeight = 35 + (25 * #items)
            local currentTop = posY
            posY = drawTacticalBox(posX, posY, width, listHeight * scrModY, "[BUFFS]")
            local textY = currentTop + 40 * scrModY
            for _, name in ipairs(items) do
                draw.SimpleText(name, "CYR_CombatHUD", posX + width / 2, textY, primary, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                textY = textY + 25 * scrModY
            end
        end

        -- Cooldown Display
        local cooldowns = user.getCooldowns and user:getCooldowns()
        if cooldowns and table.Count(cooldowns) > 0 then
            local items = {}
            for k, v in pairs(cooldowns) do
                local actionTbl = ACTS and ACTS.actions and ACTS.actions[k]
                local name = actionTbl and actionTbl.name or k
                table.insert(items, name:upper() .. " " .. (v.duration or 0) .. "T")
            end

            local listHeight = 35 + (25 * #items)
            local currentTop = posY
            posY = drawTacticalBox(posX, posY, width, listHeight * scrModY, "[COOLDOWNS]")
            local textY = currentTop + 40 * scrModY
            for _, nameDur in ipairs(items) do
                draw.SimpleText(nameDur, "CYR_CombatHUD", posX + width / 2, textY, primary, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                textY = textY + 25 * scrModY
            end
        end
    end

    -- nut_cswep is intentionally NOT in this list: its own DrawHUD renders the
    -- full V.A.T.S. overlay (dim layer, banner, limb chips, target panel). If
    -- this theme overwrites it, V.A.T.S. input/sounds still fire but nothing
    -- visible appears on screen. Re-add nut_cswep here only if you also port
    -- the V.A.T.S. rendering from lua/weapons/nut_cswep.lua's DrawHUD over.
    local weps = {"nut_cmover", "nut_turnswep"}
    for _, class in ipairs(weps) do
        local SWEP = weapons.GetStored(class)
        if SWEP then SWEP.DrawHUD = DrawHUD end
        if IsValid(LocalPlayer()) then
            local activeWep = LocalPlayer():GetWeapon(class)
            if IsValid(activeWep) then activeWep.DrawHUD = DrawHUD end
        end
    end
end

-- Apply on reload
ApplyCombatTheme()
hook.Add("InitPostEntity", "CYR_ApplyCombatHUDTheme_Final", ApplyCombatTheme)