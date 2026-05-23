local o_box128 = Material("materials/o-box-128.png", "noclamp smooth")
local o_box64 = Material("materials/o-box-128.png", "noclamp smooth")
local ammo = Material("materials/bullet.png", "noclamp smooth")
local function safeText(text)
    return string.match(text, "^#([a-zA-Z_]+)$") and text .. " " or text
end

local _color = FindMetaTable("Color")
function _color.__add(lhs, rhs)
    if type(lhs) == "number" then
        return Color(rhs.x + lhs, rhs.y + lhs)
    elseif type(rhs) == "number" then
        return Color(lhs.x + rhs, lhs.y + rhs)
    else
        return Color(lhs.x + rhs.x, lhs.y + rhs.y)
    end
end

function _color.__sub(lhs, rhs)
    return Color(lhs.r - rhs.r, lhs.g - rhs.g, lhs.b - rhs.b)
end

function _color.__add(lhs, rhs)
    return Color(lhs.r + rhs.r, lhs.g + rhs.g, lhs.b + rhs.b)
end

local function charWrap(text, remainingWidth, maxWidth)
    local totalWidth = 0
    text = text:gsub(".", function(char)
        totalWidth = totalWidth + surface.GetTextSize(char)
        -- Wrap around when the max width is reached
        if totalWidth >= remainingWidth then
            -- totalWidth needs to include the character width because it's inserted in a new line
            totalWidth = surface.GetTextSize(char)
            remainingWidth = maxWidth
            return "\n" .. char
        end
        return char
    end)
    return text, totalWidth
end

function draw.DrawNonParsedText(text, font, x, y, color, xAlign)
    return draw.DrawText(safeText(text), font, x, y, color, xAlign)
end

function draw.DrawNonParsedSimpleText(text, font, x, y, color, xAlign, yAlign)
    return draw.SimpleText(safeText(text), font, x, y, color, xAlign, yAlign)
end

function draw.DrawNonParsedSimpleTextOutlined(text, font, x, y, color, xAlign, yAlign, outlineWidth, outlineColor)
    return draw.SimpleTextOutlined(safeText(text), font, x, y, color, xAlign, yAlign, outlineWidth, outlineColor)
end

function surface.DrawNonParsedText(text)
    return surface.DrawText(safeText(text))
end

function surface.textWrap(text, font, maxWidth)
    local totalWidth = 0
    local spaces = 0
    surface.SetFont(font)
    local spaceWidth = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
        local char = string.sub(word, 1, 1)
        if char == "\n" or char == "\t" then totalWidth = 0 end
        local wordlen = surface.GetTextSize(word)
        totalWidth = totalWidth + wordlen
        -- Wrap around when the max width is reached
        if wordlen >= maxWidth then -- Split the word if the word is too big
            local splitWord, splitPoint = charWrap(word, maxWidth - (totalWidth - wordlen), maxWidth)
            totalWidth = splitPoint
            return splitWord
        elseif totalWidth < maxWidth then
            return word
        end

        -- Split before the word
        if char == ' ' then
            totalWidth = wordlen - spaceWidth
            return '\n' .. string.sub(word, 2)
        end

        totalWidth = wordlen
        return '\n' .. word
    end)
    return text
end

function surface.textWrap2(text, font, maxWidth)
    local totalWidth = 0
    local spaces = 1
    surface.SetFont(font)
    local spaceWidth = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
        local char = string.sub(word, 1, 1)
        if char == "\n" or char == "\t" then totalWidth = 0 end
        local wordlen = surface.GetTextSize(word)
        totalWidth = totalWidth + wordlen
        -- Wrap around when the max width is reached
        if wordlen >= maxWidth then -- Split the word if the word is too big
            local splitWord, splitPoint = charWrap(word, maxWidth - (totalWidth - wordlen), maxWidth)
            totalWidth = splitPoint
            return splitWord
        elseif totalWidth < maxWidth then
            return word
        end

        -- Split before the word
        if char == ' ' then
            totalWidth = wordlen - spaceWidth
            spaces = spaces + 1
            return '\n' .. string.sub(word, 2)
        end

        totalWidth = wordlen
        spaces = spaces + 1
        return '\n' .. word
    end)
    return text, spaces
end

function chat.AddNonParsedText(...)
    local tbl = {...}
    for i = 2, #tbl, 2 do
        tbl[i] = safeText(tbl[i])
    end
    return chat.AddText(unpack(tbl))
end

--CYR_UI.Primary = Color (165,225,225)
RARITY = RARITY or {
    COMMON = Color(255, 255, 255),
    UNCOMMON = Color(30, 255, 0),
    RARE = Color(30, 54, 255),
    EPIC = Color(163, 53, 238),
    LEGENDARY = Color(255, 127, 54),
}

surface.CreateFont("preview-name", {
    font = "MicrogrammaDEEBolExt", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = false,
    size = 24,
    weight = 500,
})

surface.CreateFont("preview-desc", {
    font = "mynamejeff", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = false,
    size = 18,
    weight = 500,
})

surface.CreateFont("preview-desc", {
    font = "mynamejeff", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = false,
    size = 18,
    weight = 500,
})

surface.CreateFont("preview-error", {
    font = "mynamejeff", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = false,
    size = 36,
    weight = 500,
})

surface.CreateFont("StatTextFont", {
    font = "Roboto", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = false,
    size = 16,
    weight = 300,
})

ATTRIBUTE_TRANSLATION = {
    armor = "Armor",
    health = "Health",
    reflect = "Reflect",
}

local redrawINV = nil
local PLAYER_INV_DB = nil
local ___ = function(c) return Material("materials/png/" .. c, "noclamp smooth") end
local GearSlotMaterials = {
    HEAD = ___("helmeticon1.png"),
    ["LEFT\nSHOULDER"] = ___("shouldericon1.png"),
    ["RIGHT\nSHOULDER"] = ___("shouldericon2.png"),
    CHEST = ___("chesticon1.png"),
    LEGS = ___("legicon1.png"),
    FEET = ___("feeticon1.png"),
    HANDS = ___("glovesicon1.png"),
    ["UNDER\nARMOR"] = ___("underarmoricon1.png"),
    SHIELD = ___("shieldicon1.png"),
    PRIMARY = ___("primaryicon1.png"),
    SECONDARY = ___("secondaryicon1.png"),
    SUPPLY = ___("supplyicon1.png"),
    Utility = ___("utilityicon1.png"),
}

NS_ICON_SIZE = 122
surface.CreateFont("PlayerNAME", {
    font = "MicrogrammaDEEBolExt", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = false,
    size = 42,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

surface.CreateFont("PlayerNAME", {
    font = "MicrogrammaDEEBolExt", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = false,
    size = 32,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

surface.CreateFont("Ammo2_", {
    font = "mynamejeff", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = false,
    size = 32,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

surface.CreateFont("Ammo2", {
    font = "mynamejeff", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = false,
    size = 42,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

surface.CreateFont("Ammo4", {
    font = "mynamejeff", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = false,
    size = 24,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

surface.CreateFont("Ammo3", {
    font = "mynamejeff", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = false,
    size = 24,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

local detectRange = 1000
local detectAngle = 90
local detectRangeSQ = detectRange * detectRange
local sin, cos = math.sin, math.cos
local function rotatePoint(cx, cy, ang, p)
    local s, c = sin(ang), cos(ang)
    p.x = p.x - cx
    p.y = p.y - cy
    --Rotate Point
    return {
        x = (p.x * c - p.y * s) + cx,
        y = (p.x * s + p.y * c) + cy
    }
end

local ScreenWidth, ScreenHeight = ScrW(), ScrH()
local minimap_Raidus = 340
local radar_raidus = 266
local radar_offset = 300
local orignal_minimap_radium_X, orignal_minimap_radium_Y = (0.15625 * ScrW()) - 5, ScreenHeight - 165
local minimap_radium_X = orignal_minimap_radium_X - (radar_offset / 2)
local minimap_radium_Y = orignal_minimap_radium_Y - (radar_offset / 2)
local minimap_tau = minimap_Raidus / 2
COLOR_HACKERBLUE = Color(25, 89, 179)
COLOR_BABYBLUE = Color(55, 125, 179)
COLOR_BABYBLUE_ALPHA = Color(55, 125, 179, 100)
local minimap_pos_x, minimap_pos_y = minimap_radium_X - 35, ScrH() - 350
local poly = {
    {
        x = minimap_pos_x,
        y = minimap_pos_y
    },
    {
        x = minimap_pos_x + minimap_Raidus,
        y = minimap_pos_y
    },
    {
        x = minimap_pos_x + minimap_Raidus,
        y = minimap_pos_y + minimap_Raidus
    }
}

for i = 1, #poly do
    poly[i] = rotatePoint(minimap_pos_x + minimap_tau, minimap_pos_y + minimap_tau, -0.37, poly[i])
end

local LAST__ANGLE = Angle(0, 0, 0)
local GLOBAL_ALPHA = 1
local HP = 1
local ARMOR = 1
local mp3 = nil
local n = sound.PlayFile("sound/low_health.wav", "noplay", function(station, errCode, errStr) mp3 = station end)
hook.Add("CanDrawAmmoHUD", "disablePlaylist", function() return false end)
hook.Add("ShouldHideBars", "disablePlaylist2", function() return true end)
local matOutlnie = Material("cyr/ui/hp_bar_outline.png", "noclamp smooth")
local matInfill = Material("cyr/ui/hp_bar_fill.png", "noclamp smooth")
-- ===========================================================================
--  Fallout: New Vegas style HUD.
--  Textures come from the FONV UI addon (materials/fonvui/hud/...).
--    hud_left_main  / hud_right_main      - the corner bracket frames
--    compass (.vmt) - 1024x65 360-degree panorama strip
--    hud_condition_triangle - 16x16 fixed compass centre marker
--    hud_condition_bar      - 56x8 soft white bar, tinted for HP/AP/CND fills
--    hud_tick_mark          - 18x32 segment tick
--  Everything is drawn with DrawTexturedRect / DrawTexturedRectUV so swapping
--  a path above is enough to reskin it.
-- ===========================================================================
local FO3 = {
    left_frame = Material("fonvui/hud/hud_left_main.png", "noclamp smooth"),
    right_frame = Material("fonvui/hud/hud_right_main.png", "noclamp smooth"),
    compass = Material("fonvui/hud/compass.png", "noclamp smooth"),
    compass_marker = Material("fonvui/hud/hud_condition_triangle.png", "noclamp smooth"),
    pip = Material("fixed_pip4.png", "noclamp smooth"),
}

-- A full bar is this many pips; pips above the current value are drawn dimmed
-- (the "empty" alpha) instead of being a separate fill colour.
local BAR_PIPS = 50
local PIP_EMPTY_ALPHA = 45
-- Horizontal fade for the compass. A render-target / dest-alpha mask is
-- unreliable with MSAA on (the backbuffer is multisampled, a custom RT is
-- not), so the strip is drawn as a gradient quad with per-vertex alpha via
-- the mesh library: plain forward rendering, no dest-alpha, MSAA-safe.
-- ===========================================================================
--  Live-tweakable HUD layout. `fallout_hud_edit` opens a slider editor; the
--  values are persisted to garrysmod/data/cyr_fo3_hud.json so changes survive
--  across sessions. Every numeric layout knob is sourced from HUDCFG below.
-- ===========================================================================
local HUDCFG_DEFAULTS = {
    frameW            = 400,
    marginX           = 44.407894736842,
    frameBottomGap    = 14,
    lineFrac          = 0.47039473684210525,
    -- LEFT bracket (hud_left_main.png is 386x256).
    innerL            = 0.041776315789474,
    innerR            = 0.905,
    innerWMul         = 1.10,
    -- RIGHT bracket (hud_right_main.png is 381x256; not a perfect mirror).
    innerLRight       = 0.17993421052632,
    innerRRight       = 0.94440789473684,
    innerWMulRight    = 1.00,
    compHFrac         = 0.34,
    barHFrac          = 0.12,
    gap               = 5,
    hpBarPadLMul      = 0.10,
    hpBarPadRMul      = 0.14144736842105265,
    hpValueXOff       = 9.8684210526316,
    hpValueYOff       = -12.236842105263,
    -- RIGHT bracket AP / CND / ammo placement (px @ 1080 unless noted *Mul).
    apPadLMul         = 0.00,
    apPadRMul         = 0.00,
    apLabelXOff       = 0,
    cndX              = 0,
    cndY              = 41.44736842105263,
    cndW              = 120,
    cndLabelXOff      = 0,
    ammoXOff          = -3.9473684210526017,
    ammoYOff          = 16.973684210526315,
    compassFadeStart  = 0.55,
    compassFOV        = 180,
    compassHeadingOff = 17,
}
local HUDCFG = table.Copy(HUDCFG_DEFAULTS)
local HUDCFG_PATH = "cyr_fo3_hud.json"
local function HUDCFG_Load()
    local raw = file.Read(HUDCFG_PATH, "DATA")
    if not raw then return end
    local ok, t = pcall(util.JSONToTable, raw)
    if ok and istable(t) then
        for k in pairs(HUDCFG_DEFAULTS) do
            if type(t[k]) == "number" then HUDCFG[k] = t[k] end
        end
    end
end
local function HUDCFG_Save()
    file.Write(HUDCFG_PATH, util.TableToJSON(HUDCFG, true))
end
//HUDCFG_Load()

local HUDCFG_FRAME
local OpenHUDExport       -- forward-declared, assigned further below
local function OpenHUDEditor()
    if IsValid(HUDCFG_FRAME) then HUDCFG_FRAME:Remove() end
    local f = vgui.Create("DFrame")
    HUDCFG_FRAME = f
    f:SetTitle("Fallout HUD Layout")
    f:SetSize(400, 580)
    f:Center()
    f:MakePopup()

    local sc = vgui.Create("DScrollPanel", f)
    sc:Dock(FILL)

    local function addSlider(label, key, lo, hi, decimals)
        local s = sc:Add("DNumSlider")
        s:Dock(TOP)
        s:DockMargin(6, 2, 6, 2)
        s:SetText(label)
        s:SetMin(lo) s:SetMax(hi)
        s:SetDecimals(decimals or 2)
        s:SetValue(HUDCFG[key])
        s.OnValueChanged = function(_, v)
            HUDCFG[key] = tonumber(v) or HUDCFG[key]
            HUDCFG_Save()
        end
    end

    addSlider("Frame width (px @1080)", "frameW",            100, 1000, 0)
    addSlider("Margin X (px)",          "marginX",           0,   300,  0)
    addSlider("Bottom gap (px)",        "frameBottomGap",   -50,  300,  0)
    addSlider("Rail line (frac)",       "lineFrac",          0,    1,   3)
    addSlider("L: Inner left",          "innerL",           -0.2,  0.5, 3)
    addSlider("L: Inner right",         "innerR",            0.5,  1.2, 3)
    addSlider("L: Inner width mul",     "innerWMul",         0.5,  2,   3)
    addSlider("R: Inner left",          "innerLRight",      -0.2,  0.5, 3)
    addSlider("R: Inner right",         "innerRRight",       0.5,  1.2, 3)
    addSlider("R: Inner width mul",     "innerWMulRight",    0.5,  2,   3)
    addSlider("Compass height (frac)",  "compHFrac",         0,    1,   3)
    addSlider("Bar height (frac)",      "barHFrac",          0,    1,   3)
    addSlider("Vertical gap (px)",      "gap",              -20,   60,  0)
    addSlider("HP bar pad L (mul)",     "hpBarPadLMul",     -0.5,  0.5, 3)
    addSlider("HP bar pad R (mul)",     "hpBarPadRMul",     -0.5,  0.5, 3)
    addSlider("HP value X (px)",        "hpValueXOff",     -300,  300,  0)
    addSlider("HP value Y (px)",        "hpValueYOff",      -60,   60,  0)
    addSlider("R: AP pad L (mul)",      "apPadLMul",        -0.5,  0.5, 3)
    addSlider("R: AP pad R (mul)",      "apPadRMul",        -0.5,  0.5, 3)
    addSlider("R: AP label X (px)",     "apLabelXOff",     -200,  200,  0)
    addSlider("R: CND bar X (px)",      "cndX",            -200,  400,  0)
    addSlider("R: CND bar Y (px)",      "cndY",             -60,   60,  0)
    addSlider("R: CND bar width (px)",  "cndW",             0,    400,  0)
    addSlider("R: CND label X (px)",    "cndLabelXOff",    -200,  200,  0)
    addSlider("R: Ammo X (px)",         "ammoXOff",        -300,  100,  0)
    addSlider("R: Ammo Y (px)",         "ammoYOff",         -60,   60,  0)
    addSlider("Compass fade start",     "compassFadeStart",  0,    1,   3)
    addSlider("Compass FOV (deg)",      "compassFOV",        30,   360, 0)
    addSlider("Compass heading offset", "compassHeadingOff",-180,  180, 2)

    local export = vgui.Create("DButton", f)
    export:Dock(BOTTOM)
    export:DockMargin(6, 0, 6, 0)
    export:SetText("Export current values...")
    export.DoClick = function() OpenHUDExport() end

    local reset = vgui.Create("DButton", f)
    reset:Dock(BOTTOM)
    reset:DockMargin(6, 6, 6, 6)
    reset:SetText("Reset to defaults")
    reset.DoClick = function()
        for k, v in pairs(HUDCFG_DEFAULTS) do HUDCFG[k] = v end
        HUDCFG_Save()
        f:Remove()
        OpenHUDEditor()
    end
end

-- Pops a window with the current HUDCFG serialised as a paste-ready Lua
-- table + a Copy-to-clipboard button. Opened by the Export button in the
-- editor, or directly with `fallout_hud_edit export`.
local HUDCFG_EXPORT_FRAME
function OpenHUDExport()
    if IsValid(HUDCFG_EXPORT_FRAME) then HUDCFG_EXPORT_FRAME:Remove() end
    local f = vgui.Create("DFrame")
    HUDCFG_EXPORT_FRAME = f
    f:SetTitle("Fallout HUD Layout - Export")
    f:SetSize(460, 460)
    f:Center()
    f:MakePopup()

    local te = vgui.Create("DTextEntry", f)
    te:Dock(FILL)
    te:DockMargin(6, 6, 6, 6)
    te:SetMultiline(true)
    te:SetFont("DermaDefaultBold")
    te:SetEditable(true)

    local keys = {}
    for k in pairs(HUDCFG_DEFAULTS) do keys[#keys + 1] = k end
    table.sort(keys)
    local lines = { "local HUDCFG_DEFAULTS = {" }
    for _, k in ipairs(keys) do
        local v = HUDCFG[k]
        lines[#lines + 1] = string.format("    %-18s = %s,", k, tostring(v))
    end
    lines[#lines + 1] = "}"
    te:SetText(table.concat(lines, "\n"))

    local jsonBtn = vgui.Create("DButton", f)
    jsonBtn:Dock(BOTTOM)
    jsonBtn:DockMargin(6, 0, 6, 6)
    jsonBtn:SetText("Show JSON (data/cyr_fo3_hud.json)")
    jsonBtn.DoClick = function()
        te:SetText(util.TableToJSON(HUDCFG, true))
    end

    local copyBtn = vgui.Create("DButton", f)
    copyBtn:Dock(BOTTOM)
    copyBtn:DockMargin(6, 0, 6, 0)
    copyBtn:SetText("Copy to clipboard")
    copyBtn.DoClick = function()
        SetClipboardText(te:GetValue())
        surface.PlaySound("buttons/button14.wav")
    end
end
concommand.Add("fallout_hud_edit", function(_, _, args)
    if args and args[1] == "export" then
        OpenHUDExport()
    else
        OpenHUDEditor()
    end
end)

-- One quad of `mat` over the given UV span, alpha `aL` at the left edge and
-- `aR` at the right edge (RGB taken from `col`).
local function drawFadedStrip(mat, x, y, w, h, u0, u1, col, aL, aR)
    render.SetMaterial(mat)
    mesh.Begin(MATERIAL_QUADS, 1)
        mesh.Position(Vector(x, y, 0));         mesh.TexCoord(0, u0, 0); mesh.Color(col.r, col.g, col.b, aL); mesh.AdvanceVertex()
        mesh.Position(Vector(x + w, y, 0));     mesh.TexCoord(0, u1, 0); mesh.Color(col.r, col.g, col.b, aR); mesh.AdvanceVertex()
        mesh.Position(Vector(x + w, y + h, 0)); mesh.TexCoord(0, u1, 1); mesh.Color(col.r, col.g, col.b, aR); mesh.AdvanceVertex()
        mesh.Position(Vector(x, y + h, 0));     mesh.TexCoord(0, u0, 1); mesh.Color(col.r, col.g, col.b, aL); mesh.AdvanceVertex()
    mesh.End()
end
-- HUD fonts are recreated at a size proportional to screen height, so the
-- text occupies the same fraction of the screen at 1080p and 4K (the frame /
-- bars already scale by ScrH()/1080, the fixed-size fonts did not).
local FO3_FONT_BASE = {
    label = 36,
    value = 42
}

local FO3_FONT_H = -1
local function EnsureHUDFonts()
    local h = ScrH()
    if h == FO3_FONT_H then return end
    FO3_FONT_H = h
    local s = h / 1080
    surface.CreateFont("FO3_HUD_Label", {
        font = "Monofonto",
        extended = false,
        size = math.Round(FO3_FONT_BASE.label * s),
        weight = 500,
        antialias = true,
    })

    surface.CreateFont("FO3_HUD_Value", {
        font = "Monofonto",
        extended = false,
        size = math.Round(FO3_FONT_BASE.value * s),
        weight = 600,
        antialias = true,
    })
end

EnsureHUDFonts()
-- HUD tint colour. The canonical source is the pipboy's `pip_color` global
-- (set from the `fallout_pipboy_color` convar in yshera_pipboy/cl_pipboy.lua,
-- default amber RGB 255,182,66). We prefer that so every pipboy-inspired HUD
-- (this FO3 bracket HUD, the combat overlay, the notify panel) all tint
-- identically and respond to the same convar / colour-picker the player uses
-- on the pipboy itself. The `fallout_hud_color` convar remains as a fallback
-- for hosts who don't have the pipboy addon loaded.
local FALLOUT_HUD_COLOR = CreateClientConVar("fallout_hud_color", "#ffb642", true, false, "Fallout HUD tint colour (hex, e.g. #ffb642)")
local function GetHUDColor()
    local s = FALLOUT_HUD_COLOR:GetString()
    local c
    if s and s:sub(1, 1) == "#" then
        c = HexToColor(s)
    else
        local r, g, b = (s or ""):match("(%d+)%s+(%d+)%s+(%d+)")
        if r then c = Color(tonumber(r), tonumber(g), tonumber(b)) end
    end
    if not c then
        if pip_color then return ColorAlpha(pip_color, 255) end
        c = Color(255, 182, 66)
    end
    return ColorAlpha(c, 255)
end
-- Publish globally so other pipboy-styled HUD files (cl_combat_hud_theme,
-- cl_notify_override) can call the same helper without re-implementing the
-- pip_color preference. Safe to call from Paint hooks at any time — both the
-- function and `pip_color` resolve at call time.
_G.CYR_GetHUDColor = GetHUDColor

-- Source-art geometry, measured from the bracket textures (386x256 / 381x256):
--   art occupies y 4..131, the horizontal rail is at y~65, end-caps at the
--   far left/right. We crop away the transparent lower half and express the
--   rail / usable strip as fractions of the *drawn* (cropped) region.
local FRAME_SRC_V = 140 / 256 -- crop: only the top 140px holds art
local FRAME_ART_RATIO = 140 / 386 -- drawn height : drawn width for that crop
local FRAME_LINE_FRAC = 65 / 140 -- the rail row, as a frac of drawn height
local FRAME_INNER_L = 0.040 -- usable strip start (after the left tick)
local FRAME_INNER_R = 0.905 -- usable strip end (before the right step)
-- A horizontal bar made of `pips` evenly tiled pip glyphs. The pip texture
-- tiles (noclamp), so the whole bar is just two draws: one dim pass across
-- all pips, then one bright pass over the filled cells.
local function fo3Bar(x, y, w, h, perc, color, pips)
    pips = pips or BAR_PIPS
    perc = math.Clamp(perc or 0, 0, 1)
    -- floor (not round) so a pip never lights until fully earned, and snap
    -- the bright width to whole pip cells / pixel boundaries to avoid sub-
    -- pixel rasterization showing a half-lit pip at the edge.
    local filled = math.floor(perc * pips)
    surface.SetMaterial(FO3.pip)
    surface.SetDrawColor(color.r, color.g, color.b, PIP_EMPTY_ALPHA)
    surface.DrawTexturedRectUV(x, y, w, h, 0, 0, pips, 1)
    if filled > 0 then
        local fw = math.floor(w * filled / pips + 0.5)
        surface.SetDrawColor(color.r, color.g, color.b, 255)
        surface.DrawTexturedRectUV(x, y, fw, h, 0, 0, filled, 1)
    end
end

-- Scrolling compass: the strip is a full 360-degree panorama, so we slide a
-- `fov`-wide window across it via UVs and pin a marker dead centre.
function DrawCompass(primary, x, y, w, h)
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    if not primary then
        primary = GetHUDColor()
        local s = ScrH() / 1080
        w, h = w or 300 * s, h or 42 * s
        x = x or 40 * (ScrW() / 1920)
        y = y or ScrH() - 155 * s
    end

    y = y + 10
    local compassOffset = GetConVar("nwl_compass_offset"):GetFloat()
    local heading = (-(ply:EyeAngles().y + compassOffset)) % 360 + HUDCFG.compassHeadingOff
    local fov = HUDCFG.compassFOV
    local u0 = (heading / 360) - (fov / 360) / 2
    local u1 = u0 + (fov / 360)
    -- Two gradient quads: a solid section, then one that ramps alpha to 0 on
    -- the right. Per-vertex alpha via mesh = no RT, works with MSAA on.
    local fs = HUDCFG.compassFadeStart
    local uMid = u0 + (u1 - u0) * fs
    drawFadedStrip(FO3.compass, x, y, w * fs, h, u0, uMid, primary, 255, 255)
    drawFadedStrip(FO3.compass, x + w * fs, y, w * (1 - fs), h, uMid, u1, primary, 255, 0)
end

-- Bottom-left bracket: compass + "HP" health bar.
-- Bottom-right bracket: "AP" stamina bar, ammo counter + "CND" condition bar.
local function DrawTheHUD()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    EnsureHUDFonts()
    local scale = ScrH() / 1080
    local primary = GetHUDColor()
    local frameW = HUDCFG.frameW * scale
    local frameH = frameW * FRAME_ART_RATIO
    local marginX = HUDCFG.marginX * scale
    local frameY = ScrH() - frameH - HUDCFG.frameBottomGap * scale
    local lineY = frameY + frameH * HUDCFG.lineFrac
    local compH = frameH * HUDCFG.compHFrac -- compass strip height
    local barH = frameH * HUDCFG.barHFrac -- meter bar height
    local gap = HUDCFG.gap * scale
    -- ===================== BOTTOM LEFT : HP + COMPASS =====================
    local lx = marginX
    surface.SetDrawColor(primary)
    surface.SetMaterial(FO3.left_frame)
    surface.DrawTexturedRectUV(lx, frameY, frameW, frameH, 0, 0, 1, FRAME_SRC_V)
    local innerX = lx + frameW * HUDCFG.innerL
    local innerW = frameW * (HUDCFG.innerR - HUDCFG.innerL) * HUDCFG.innerWMul
    -- HP bar + value sit just above the rail, fully inside the bracket.
    -- When the combat SWEP is active, use the combat plugin's HP (ply:getHP/getMaxHP)
    -- instead of the engine health — combat damage is tracked there, not on Entity:Health().
    local hp, hpMax
    local activeWepForHP = ply:GetActiveWeapon()
    local usingCombatHP = IsValid(activeWepForHP)
        and activeWepForHP:GetClass() == "nut_cswep"
        and isfunction(ply.getHP) and isfunction(ply.getMaxHP)
    if usingCombatHP then
        hp, hpMax = ply:getHP(), ply:getMaxHP()
    else
        hp, hpMax = ply:Health(), ply:GetMaxHealth()
    end
    local hpPerc = hpMax > 0 and (hp / hpMax) or 0
    local barY = lineY - gap - barH
    -- Compass rides just below the rail.
    DrawCompass(primary, innerX, lineY + gap, innerW, compH)
    local valW = 70 * scale
    draw.SimpleText("HP", "FO3_HUD_Label", innerX, barY - gap, primary, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    fo3Bar(innerX + lx * HUDCFG.hpBarPadLMul, barY, innerW - valW - lx * HUDCFG.hpBarPadRMul, barH, hpPerc, primary)
    draw.SimpleText(math.ceil(hp), "FO3_HUD_Value", innerX + innerW + HUDCFG.hpValueXOff * scale, barY + barH / 2 + HUDCFG.hpValueYOff * scale, primary, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    -- ===================== BOTTOM RIGHT : AP + AMMO + CND =====================
    local rx = ScrW() - marginX - frameW
    surface.SetDrawColor(primary)
    surface.SetMaterial(FO3.right_frame)
    surface.DrawTexturedRectUV(rx, frameY, frameW, frameH, 0, 0, 1, FRAME_SRC_V)
    local rInnerX = rx + frameW * HUDCFG.innerLRight
    local rInnerW = frameW * (HUDCFG.innerRRight - HUDCFG.innerLRight) * HUDCFG.innerWMulRight
    -- AP (stamina) bar sits directly above the rail (mirrors the compass).
    local stamina = ply:getLocalVar("stm", 100)
    local apPerc = math.Clamp(stamina / 100, 0, 1)
    local apY = lineY - gap - barH
    local apX = rInnerX + marginX * HUDCFG.apPadLMul
    local apW = rInnerW - marginX * (HUDCFG.apPadLMul + HUDCFG.apPadRMul)
    draw.SimpleText("AP", "FO3_HUD_Label", apX + apW + HUDCFG.apLabelXOff * scale, apY - gap, primary, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
    fo3Bar(apX, apY, apW, barH, apPerc, primary)
    -- Ammo counter + "CND" weapon-condition bar below the rail.
    local activeWep = ply:GetActiveWeapon()
    if IsValid(activeWep) and activeWep.Clip1 then
        local clip = activeWep:Clip1()
        if clip ~= -1 then
            local ammoCount = ply:GetAmmoCount(activeWep:GetPrimaryAmmoType())
            local rowY = lineY + gap
            local cndPerc = 1
            if isfunction(activeWep.GetCondition) then
                cndPerc = math.Clamp(activeWep:GetCondition() / 100, 0, 1)
            elseif isfunction(activeWep.GetNWFloat) then
                cndPerc = math.Clamp(activeWep:GetNWFloat("condition", 100) / 100, 0, 1)
            end

            local cndBarX = rInnerX + HUDCFG.cndX * scale
            local cndBarY = rowY + HUDCFG.cndY * scale
            local cndBarW = HUDCFG.cndW * scale
            draw.SimpleText("CND", "FO3_HUD_Label", cndBarX + HUDCFG.cndLabelXOff * scale, cndBarY - gap, primary, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
            fo3Bar(cndBarX, cndBarY, cndBarW, barH, cndPerc, primary)
            draw.SimpleText(clip .. "/" .. ammoCount, "FO3_HUD_Value", rInnerX + rInnerW + HUDCFG.ammoXOff * scale, rowY + barH / 2 + HUDCFG.ammoYOff * scale, primary, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end
    end
end

local tex_name = "RenderTargetTexture_Texture" .. math.random(1, 100000)
local mat_name = "RenderTargetTexture_Material" .. math.random(1, 100000)
local tex = GetRenderTargetEx(tex_name, ScrW(), ScrH(), RT_SIZE_FULL_FRAME_BUFFER_ROUNDED_UP, MATERIAL_RT_DEPTH_SHARED, 0, 0, IMAGE_FORMAT_RGBA8888)
local myMat = CreateMaterial(mat_name, "UnlitGeneric", {
    ["$basetexture"] = tex:GetName(),
    ["$translucent"] = "1",
    ["$model"] = "1",
})

local ply = LocalPlayer()
local _scale = 130
local heightRatio = ScrW() / ScrH()
if heightRatio == 1.25 then _scale = 180 end
local scaleXY = {
    x = 1,
    y = 1
}

local scale = Vector(_scale + 2, _scale * heightRatio, _scale * 0.8 * 1)
local mat = Matrix()
mat:Scale(scale)
cvars.AddChangeCallback("cl_safezone_x", function(convar_name, value_old, value_new)
    local scale = Vector(_scale + 2, _scale * heightRatio, _scale * 0.8 * value_new)
    local mat = Matrix()
    mat:Scale(scale)
    frame.Entity:EnableMatrix("RenderMultiply", mat)
end)

if frame then frame:Remove() end
frame = nil
-- 
local scaleOFFSETINDEXMETASHITSTUFF = 0
local CURVEDHUD = false
hook.Add("HUDPaint", "uihud_halo", function()
    local ply = LocalPlayer()
    if ply:getChar() == nil then return end
    local stats = ply:getChar():getData("stats") or {}
    stats.VISOR_CURVE = stats.VISOR_CURVE or 0
    stats.VISOR_COLOR_TYPE = stats.VISOR_COLOR_TYPE or 0
    stats.VISOR_SCAN_DEGREES = stats.VISOR_SCAN_DEGREES or 90
    stats.VISOR_SCAN_RAIDUS = stats.VISOR_SCAN_RAIDUS or 1000
    local inx = stats.VISOR_COLOR_TYPE or 0
    if stats.VISOR_SCAN_DEGREES ~= detectAngle then detectAngle = stats.VISOR_SCAN_DEGREES end
    if stats.VISOR_SCAN_RAIDUS ~= detectRange then
        detectRange = stats.VISOR_SCAN_RAIDUS or 1000
        detectRangeSQ = detectRange * detectRange
    end

    if CURVEDHUD then
        if frame == nil then
            frame = vgui.Create("DModelPanel")
            frame:SetSize(ScrW(), ScrH())
            frame:SetModel("models/theopathy/curvedscreen.mdl")
            frame:SetPaintedManually(true)
            frame:SetEnabled(false)
            frame:SetFOV(100)
            -- disables default rotation
            function frame:LayoutEntity(Entity)
                return
            end

            frame:SetMouseInputEnabled(false)
            frame:SetLookAt(Vector(0, 0, 0))
            frame:SetFOV(104)
            frame.Entity:SetAngles(Angle(55, 45, 0))
            frame.Entity:EnableMatrix("RenderMultiply", mat)
            frame.Entity:SetMaterial("!" .. mat_name)
        end

        if scaleOFFSETINDEXMETASHITSTUFF ~= stats.VISOR_CURVE then
            scaleOFFSETINDEXMETASHITSTUFF = stats.VISOR_CURVE
            local scale = Vector(_scale + 2, _scale * heightRatio, _scale * (0.8 + stats.VISOR_CURVE or 0))
            local mat = Matrix()
            mat:Scale(scale)
            frame.Entity:EnableMatrix("RenderMultiply", mat)
        end

        -- Render stuff here
        render.PushRenderTarget(tex)
        render.OverrideAlphaWriteEnable(true, true)
        cam.Start2D()
        render.Clear(0, 0, 0, 0, true)
        DrawTheHUD()
        hook.Run("HudPaintToCurve", true)
        cam.End2D()
        render.PopRenderTarget()
        --[[surface.SetDrawColor( color_white )
		surface.SetMaterial( myMat )
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )]]
        frame:PaintManual()
        render.OverrideAlphaWriteEnable(true, true)
    else
        DrawTheHUD()
        hook.Run("HudPaintToCurve", false)
    end
end)

radar_scan = {"ply", "npc_"}
radar_scan_hostile = {
    ["npc_vortigaunt"] = true,
    ["npc_tf2_ghost"] = true,
}

radar_HOSTILE = Color(255, 100, 100)
radar_FRIENDLY = Color(255, 242, 128)
local hide = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["DarkRP_LocalPlayerHUD"] = true,
}

hook.Add("HUDShouldDraw", "HideHUD", function(name) if hide[name] then return false end end)
-- Don't return anything here, it may break other addons that rely on this hook.
local center = {
    x = minimap_radium_X + (radar_raidus / 2),
    y = minimap_radium_Y + (radar_raidus / 2)
}

function drawRadar(curAngle)
    if true then return end
    local ply = LocalPlayer()
    local entites = {}
    for i = 1, 1000 do
        local ent = ents.GetByIndex(i)
        if ent:IsValid() then
            local type = ent:GetClass()
            for k, v in ipairs(radar_scan) do
                if string.find(type, v) then table.insert(entites, ent) end
            end
        end
    end

    draw.NoTexture()
    local pPOS = ply:GetPos()
    pPOS.z = 0
    for i, v in pairs(entites) do
        local e = v:GetPos()
        e.z = 0
        local distance = pPOS:DistToSqr(e)
        if distance < detectRangeSQ and distance ~= 0 then
            local n = {
                x = 0,
                y = 0
            }

            local p = math.sqrt(distance) / detectRange
            local angleP = math.deg(math.atan2(pPOS.y - e.y, pPOS.x - e.x))
            angleP = angleP - 90
            angleP = -angleP + curAngle.y
            local legacyAngle = angleP
            angleP = math.rad(angleP)
            n.x = n.x + (((radar_raidus / 2) * p) * math.cos(angleP))
            n.y = n.y + (((radar_raidus / 2) * p) * math.sin(angleP))
            local anglediff = ((legacyAngle + 90) + 180 + 360) % 360 - 180
            local dtA = detectAngle / 2
            if radar_scan_hostile[v:GetClass()] then
                if p < 0.17 or (anglediff <= dtA and anglediff >= -dtA) then
                    --  if (angleP < -1.1)then 
                    surface.SetDrawColor(radar_HOSTILE)
                    surface.SetMaterial(radardot)
                    surface.DrawTexturedRect(center.x - 5 + n.x, center.y - 5 + n.y, 12, 12)
                end
            else
                surface.SetDrawColor(radar_FRIENDLY)
                surface.SetMaterial(radardot)
                surface.DrawTexturedRect(center.x - 5 + n.x, center.y - 5 + n.y, 12, 12)
            end
        end
    end
end

steamworks.DownloadUGC("3631632238", function(path) game.MountGMA(path) end)