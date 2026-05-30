-- Pipboy-styled notification panel. This is a pure Derma DPanel that paints
-- itself with `surface.*` / `draw.*` calls — no DHTML, no Awesomium/CEF — so
-- it matches the FO3 bracket HUD (cl_hud_interface) and combat overlay
-- (cl_combat_hud_theme) visually and behaviourally. Registered at the bottom
-- of this file as `vgui.Register("cyrNotice", PANEL, "DPanel")`.
local PANEL = {}
function PANEL:Init()
    self:SetPaintBackground(false)
end

function PANEL:Paint(w, h)
    local scrModX = ScrW() / 1920
    local scrModY = ScrH() / 1080
    -- Theme — prefer the shared pipboy tint (pip_color, driven by
    -- `fallout_pipboy_color`) so this notify panel matches the rest of the
    -- pipboy-inspired HUDs. Fall back to the cookie if pipboy isn't loaded.
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
    -- Cache for PaintOver, which renders the body text in the same tint so the
    -- message reads as amber-on-black (like pipboy text) rather than white.
    self._pipPrimary = primary
    -- Tactical Box Logic (Simplified for Panel)
    local headerHeight = 20 -- Fixed pixel height for header
    -- Panning Effect Helper
    local function drawPanningBackground(x, y, w, h)
        local time = CurTime() * 25
        local spacing = 40 * scrModX
        local offset = time % spacing
        render.SetScissorRect(x, y, x + w, y + h, true)
        surface.SetDrawColor(primaryVDim)
        for i = -spacing * 5, w + h, spacing do
            surface.DrawLine(x + i + offset, y, x + i + offset - h, y + h)
            surface.DrawLine(x + i + offset + 1, y, x + i + offset - h + 1, y + h)
        end

        render.SetScissorRect(0, 0, 0, 0, false)
    end

    -- Background
    surface.SetDrawColor(bg)
    surface.DrawRect(0, 0, w, h)
    -- Header Panning
    drawPanningBackground(0, 0, w, headerHeight)
    -- Header Outline & Fill
    surface.SetDrawColor(primaryDim)
    surface.DrawRect(1, 1, w - 2, headerHeight)
    -- Main Outline
    surface.SetDrawColor(primary)
    surface.DrawOutlinedRect(0, 0, w, h)
    -- Header Text
    draw.SimpleText("SYSTEM ALERT", "CYR_CombatHUD_Small", w / 2, headerHeight / 2, primary, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:SetText(text)
    -- Calculate size based on text
    surface.SetFont("CYR_CombatHUD_Small")
    local w, h = surface.GetTextSize(text)
    self:SetSize(w + 32, h + 32 + 20) -- +20 for header, +32 for padding
    self.ActualText = text
end

function PANEL:PaintOver(w, h)
    -- Render the body text in the cached pipboy tint (set in Paint) so it
    -- matches the rest of the pipboy-inspired HUDs. Fallback to color_white
    -- only if Paint hasn't run yet on the first frame.
    if self.ActualText then
        local textColor = self._pipPrimary or color_white
        draw.SimpleText(self.ActualText, "CYR_CombatHUD_Small", w / 2, (h + 20) / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

vgui.Register("cyrNotice", PANEL, "DPanel") -- Inherit from DPanel for custom painting, handle text manually
-- Override NutScript Notify
nut.notices = nut.notices or {}
function nut.util.notify(message)
    local notice = vgui.Create("cyrNotice")
    notice:MakePopup()
    notice:SetMouseInputEnabled(false)
    notice:SetKeyboardInputEnabled(false)
    notice:SetZPos(30000)
    local i = table.insert(nut.notices, notice)
    local scrW = ScrW()
    local scrH = ScrH()
    -- Setup
    notice:SetText(message)
    -- Position: Right side, stacking up from bottom or top? 
    -- Original code stacks from top: (k - 1) * (v:GetTall() + 4) + 4
    -- Let's stick to that but maybe adjustable.
    notice:SetPos(scrW, (i - 1) * (notice:GetTall() + 4) + 4)
    -- Animation states
    notice.start = CurTime() + 0.25
    notice.endTime = CurTime() + 7.75
    -- Organize function
    local function OrganizeNotices()
        local scrW = ScrW()
        for k, v in ipairs(nut.notices) do
            local x = scrW - (v:GetWide() + 10) -- 10px padding from right
            local y = (k - 1) * (v:GetTall() + 4) + 10 -- 10px padding from top
            v:MoveTo(x, y, 0.15, (k / #nut.notices) * 0.25)
        end
    end

    OrganizeNotices()
    -- Sound
    MsgC(Color(0, 255, 255), message .. "\n")
    timer.Simple(0.15, function()
        LocalPlayer():EmitSound("buttons/button15.wav", 0.35 * 100) -- Using standard beep for now, volume adjusted
    end)

    -- Removal
    timer.Simple(7.75, function()
        if IsValid(notice) then
            for k, v in ipairs(nut.notices) do
                if v == notice then
                    notice:MoveTo(scrW + notice:GetWide(), notice.y, 0.15, 0.1, nil, function() notice:Remove() end)
                    table.remove(nut.notices, k)
                    OrganizeNotices()
                    break
                end
            end
        end
    end)
end