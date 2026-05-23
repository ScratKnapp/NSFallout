MATERIALS = MATERIALS or {}
CYR_UI = CYR_UI or {}
local hueShiftConvar = CreateClientConVar("cyr_hue_shift", "0", true, false)
local function HueShiftColor(color, shift)
    local h, s, v = ColorToHSV(color)
    h = (h + shift) % 360
    local c = HSVToColor(h, s, v)
    c.a = color.a
    return c
end

function INIT_CYR_COLORS()
    CYR_UI.BG = Color(10, 48, 61, 222)
    CYR_UI.BGX = Color(10, 48, 61, 255)
    CYR_UI.Primary = HexToColor("87DDFC")
    CYR_UI.PrimaryActive = HexToColor("0EB4F0")
    -- loop though all of CYR colors and hue shift them based on convar
    local shift = hueShiftConvar:GetFloat()
    for k, v in pairs(CYR_UI) do
        CYR_UI[k] = HueShiftColor(v, shift)
    end

    if nut then nut.config.set("color", CYR_UI.Primary) end
end

INIT_CYR_COLORS()
cvars.AddChangeCallback("cyr_hue_shift", function(convar_name, value_old, value_new) INIT_CYR_COLORS() end)
-- convar for hue offset
-- HueShift colors
CYR = CYR_UI
--
local DermaMT = FindMetaTable("Panel")
function DermaMT:UseCustomText()
    self.txt = self:GetText()
    self:SetText("")
end

function DermaMT:SetCustomText(x)
    self.txt = x
    self:SetText("")
end

function RespecPaint(self, w, h)
    surface.SetAlphaMultiplier(1)
    surface.SetDrawColor(CYR_UI.Primary)
    surface.SetMaterial(FUT_INV_BUTTON)
    surface.Draw9Slice(0, 0, w, h, 8, 128)
    surface.SetFont("nutMediumFont")
    local levelText = "RESPEC"
    local textSizeX, textSizeY = surface.GetTextSize(levelText)
    surface.SetTextColor(255, 255, 255)
    surface.SetTextPos(w * 0.5 - textSizeX * 0.5, h * 0.5 - textSizeY * 0.5)
    surface.DrawText(levelText)
end

function XPBarPaint(self, w, h)
    local client = LocalPlayer()
    local char = client:getChar()
    local level = client:getLevel()
    local nextLevel = nut.plugin.list["level"]:getLevelThresh(level)
    local xp = char:getData("xp", 0)
    local ratio = math.Clamp(xp / nextLevel, 0, 1)
    local barSize = w * math.Round(ratio, 2)
    surface.SetDrawColor(CYR_UI.BG)
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(CYR_UI.Primary)
    surface.DrawRect(0, 0, barSize, h)
    surface.SetDrawColor(CYR_UI.Primary)
    surface.DrawOutlinedRect(0, 0, w, h, 2)
    surface.SetFont("nutMediumFont")
    local levelText = "Level " .. level .. " (" .. xp .. "/" .. nextLevel .. ")"
    local textSizeX, textSizeY = surface.GetTextSize(levelText)
    surface.SetTextColor(255, 255, 255)
    surface.SetTextPos(w * 0.5 - textSizeX * 0.5, h * 0.5 - textSizeY * 0.5)
    surface.DrawText(levelText)
end

circuity = Material("cyr/netrunner/bg.png", "smooth mips")
CloseButtonInactive = Material("cyr/ui/CloseIdle.png", "smooth mips")
CloseButtonActive = Material("cyr/ui/CloseActive.png", "smooth mips")
local EquipmentMenuBackground = Material("cyr/ui/FUT_BACKGROUND2.png", "smooth mips")
local EqipmentMenuBackgroundAccent = Material("cyr/ui/FUT_BACKGROUND_ACCENT3.png", "noclamp smooth mips")
EqipmentMenuBackgroundAccentModule = Material("cyr/ui/FUT_DECO_RAINFALL2.png", "noclamp smooth")
local FooterWarningEquipment = Material("cyr/ui/FUT_FOOTER_WARNING.png", "noclamp smooth mips")
FUT_INV_BUTTON = Material("cyr/ui/FUT_INV_BUTTON2.png", "smooth ")
local FUT_BACKGROUND_CENTER = Material("cyr/ui/FUT_BACKGROUND_CENTER.png", "smooth mips")
local DISPATCHER = Material("cyr/ui/DISPATCH2.png", "smooth")
local NERVES = Material("cyr/ui/Nerves.png", "smooth mips")
local Steel = Material("cyr/ui/Steel4.png", "smooth mips")
FutFill = Material("cyr/ui/FutFillNoAlpha.png", "smooth")
FutOutline = Material("cyr/ui/FutOutline.png", "smooth")
function CharModelPaint(s, w, h)
    surface.SetMaterial(Steel)
    surface.SetAlphaMultiplier(1)
    surface.SetDrawColor(CYR_UI.Primary)
    surface.DrawTexturedRect(w * -.2, h * -.05, w * 1.4, h * 1.1)
    draw.SimpleText("EQUIPMENT", "CYR_CharacterEquipment", w / 2, -32, CYR_UI.Primary, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
end

function CharModelPaintSkeleton(s, w, h)
    draw.SimpleText("CYBERWARE", "CYR_CharacterEquipment", w / 2, -32, CYR_UI.Primary, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    surface.SetAlphaMultiplier(1)
    surface.SetDrawColor(CYR_UI.Primary)
    surface.SetMaterial(Steel)
    surface.DrawTexturedRect(w * -.2, h * -.05, w * 1.4, h * 1.1)
    surface.SetAlphaMultiplier(1)
    surface.SetMaterial(NERVES)
    surface.SetDrawColor(CYR_UI.Primary)
    surface.DrawTexturedRect(w * -.2, h * -.05, w * 1.4, h * 1.1)
end

LerpColor = LerpColor or function(fraction, from, to) return Color(Lerp(fraction, from.r, to.r), Lerp(fraction, from.g, to.g), Lerp(fraction, from.b, to.b), Lerp(fraction, from.a, to.a)) end
function surface.Draw9Slice(x, y, w, h, margin, textureSize)
    -- benchmark code `
    local uv_margin = margin / textureSize
    -- -- Top-left corner
    surface.DrawTexturedRectUV(x, y, margin, margin, 0, 0, uv_margin, uv_margin)
    -- Top edge
    surface.DrawTexturedRectUV(x + margin, y, w - margin * 2, margin, uv_margin, 0, 1 - uv_margin, uv_margin)
    -- Top-right corner
    surface.DrawTexturedRectUV(x + w - margin, y, margin, margin, 1 - uv_margin, 0, 1, uv_margin)
    -- Left edge
    surface.DrawTexturedRectUV(x, y + margin, margin, h - margin * 2, 0, uv_margin, uv_margin, 1 - uv_margin)
    -- Center
    surface.DrawTexturedRectUV(x + margin, y + margin, w - margin * 2, h - margin * 2, uv_margin, uv_margin, 1 - uv_margin, 1 - uv_margin)
    -- Right edge
    surface.DrawTexturedRectUV(x + w - margin, y + margin, margin, h - margin * 2, 1 - uv_margin, uv_margin, 1, 1 - uv_margin)
    -- Bottom-left corner
    surface.DrawTexturedRectUV(x, y + h - margin, margin, margin, 0, 1 - uv_margin, uv_margin, 1)
    -- Bottom edge
    surface.DrawTexturedRectUV(x + margin, y + h - margin, w - margin * 2, margin, uv_margin, 1 - uv_margin, 1 - uv_margin, 1)
    -- Bottom-right corner
    surface.DrawTexturedRectUV(x + w - margin, y + h - margin, margin, margin, 1 - uv_margin, 1 - uv_margin, 1, 1)
end

local MEMFAULT = SEGTIMER
local MEMFAULT2 = SEGTIMER
local intLimit = 2 ^ 32
timer.Create("CYR_MEMFAULT_ANIM", 0.2, 0, function()
    MEMFAULT = string.format("%X", math.random(0, intLimit)) .. string.format("%X", math.random(0, intLimit))
    MEMFAULT2 = string.format("%X", math.random(0, intLimit)) .. string.format("%X", math.random(0, intLimit))
end)

local matBlurScreen = Material("pp/blurscreen")
function CharacterEquipmentPaintBackground(s, w, h)
    -- Background Image
    -- 0.08
    local Fraction = 1
    local starttime = s.m_fCreateTime
    if starttime then Fraction = math.Clamp((SysTime() - starttime) * 4, 0, 1) end
    local x, y = s:LocalToScreen(0, 0)
    local wasEnabled = DisableClipping(true)
    -- Menu cannot do blur
    if not MENU_DLL then
        surface.SetMaterial(matBlurScreen)
        surface.SetDrawColor(255, 255, 255, 255)
        for i = 0.33, 1, 0.33 do
            matBlurScreen:SetFloat("$blur", Fraction * 5 * i)
            matBlurScreen:Recompute()
            if render then -- Todo: Make this available to menu Lua
                render.UpdateScreenEffectTexture()
            end

            surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
        end
    end

    surface.SetDrawColor(10, 10, 10, 200 * Fraction)
    surface.DrawRect(x * -1, y * -1, ScrW(), ScrH())
    DisableClipping(wasEnabled)
    surface.SetAlphaMultiplier(1)
    surface.SetDrawColor(CYR_UI.BG)
    surface.SetMaterial(EquipmentMenuBackground)
    surface.DrawTexturedRect(0, 0, w, h)
    surface.SetMaterial(circuity)
    -- draw textured rect uv, centered but make it so it covers the whole area keep aspect ratio and height
    surface.SetAlphaMultiplier(0.015)
    surface.SetDrawColor(CYR_UI.Primary)
    surface.DrawTexturedRectUV(0, 0, w, h, 0, 0, 1, 0.8)
    surface.SetAlphaMultiplier(1)
    surface.SetDrawColor(CYR_UI.Primary)
    surface.SetMaterial(EqipmentMenuBackgroundAccent)
    surface.DrawTexturedRect(0, 0, w, h)
    surface.SetMaterial(EqipmentMenuBackgroundAccentModule)
    surface.DrawTexturedRectUV(-140, 128, 128, 512, 0, 0, 1, 1)
    surface.DrawTexturedRectUV(w + 12, 128, 128, 512, 1, 0, 0, 1)
    -- draw text at top
    draw.SimpleText("MEM INDEXING: ", "CYR_CharacterEquipment_TitleBold", 20, 10, CYR_UI.Primary, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    surface.SetAlphaMultiplier(0.3)
    draw.SimpleText(MEMFAULT, "CYR_CharacterEquipment_TitleBold", 125, 10, CYR_UI.Primary, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    surface.SetAlphaMultiplier(1)
    draw.SimpleText(MEMFAULT2, "CYR_CharacterEquipment_TitleBold", 128, 10, CYR_UI.Primary, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    -- draw lovely overlay
    surface.SetMaterial(DISPATCHER)
    surface.SetDrawColor(CYR_UI.Primary)
    surface.DrawTexturedRect(20, 32, 64, 32)
end

function CharacterEquipmentFooterPaint(s, w, h)
    local scale = 0.7
    surface.SetAlphaMultiplier(0.5)
    surface.SetDrawColor(CYR_UI.Primary)
    surface.SetMaterial(FooterWarningEquipment)
    surface.DrawTexturedRect(w / 2 - (256 * scale), h / 2 - (32 * scale), 512 * scale, 64 * scale)
end

function InventoryItemSlotPaint(s, w, h)
    s.i = s.i or 0
    if s:IsHovered() then
        s.i = 1
    else
        s.i = math.max(s.i - FrameTime() * 2, 0)
    end

    surface.SetMaterial(FUT_INV_BUTTON)
    surface.SetAlphaMultiplier(0.8)
    surface.SetDrawColor(LerpColor(s.i, CYR_UI.Primary, CYR_UI.PrimaryActive))
    surface.DrawTexturedRect(0, 0, w, h)
    local amount = s.data.instances[1]:getData("Amount", 1)
    local quantity2 = s.data.instances[1]:getData("quantity2", -1)
    if quantity2 and quantity2 > 0 then amount = quantity2 end
    -- draw amount at bottom right`
    if amount > 1 then
        local p = 0.2
        local s = 24
        surface.DrawTexturedRectUV(w - s + 1 - 2, h - s - 1, s, s, 0, 0, p, p)
        draw.SimpleText(amount, "CYR_CharacterEquipment_TitleBold", w - s / 2, h - s / 2 - 1, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function InventoryItemSlotPaintEquipment(s, w, h)
    s.i = s.i or 0
    if s:IsHovered() then
        s.i = 1
    else
        s.i = math.max(s.i - FrameTime() * 2, 0)
    end

    surface.SetMaterial(FUT_INV_BUTTON)
    surface.SetAlphaMultiplier(0.8)
    surface.SetDrawColor(LerpColor(s.i, CYR_UI.Primary, CYR_UI.PrimaryActive))
    surface.DrawTexturedRect(0, 0, w, h)
    -- draw text underneath
    local txt = s.txt
    surface.SetAlphaMultiplier(1)
    draw.SimpleText(txt, "CYR_CharacterEquipment_Title", w / 2, h + 5, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

function ITEMSorterRenderPaint(s, w, h)
    if s:IsHovered() then
        s.i = 1
    else
        s.i = math.max(s.i - FrameTime() * 2, 0)
    end

    surface.SetMaterial(FUT_INV_BUTTON)
    surface.SetAlphaMultiplier(s.active == true and 1 or 0.3)
    surface.SetDrawColor(LerpColor(s.i, CYR_UI.Primary, CYR_UI.PrimaryActive))
    surface.Draw9Slice(0, 0, w, h, 8, 128)
    local txt = s.txt
    surface.SetAlphaMultiplier(1)
    draw.SimpleText(txt, s:IsHovered() and "CYR_CharacterEquipment_TitleBold" or "CYR_CharacterEquipment_Title", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

FUT_BACKGROUND_CENTERPAINT = function(s, w, h)
    surface.SetAlphaMultiplier(1)
    surface.SetDrawColor(CYR_UI.Primary)
    surface.SetMaterial(FUT_BACKGROUND_CENTER)
    surface.DrawTexturedRect(-12, -12, w + 24, h + 24)
    -- draw text center top
    draw.SimpleText("INVENTORY", "CYR_CharacterEquipment", w / 2, 0, CYR_UI.Primary, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
end

FUT_CLOSE = function(s, w, h)
    s.i = s.i or 0
    if s:IsHovered() then
        s.i = 1
    else
        s.i = math.max(s.i - FrameTime() * 5, 0)
    end

    surface.SetAlphaMultiplier(0.5 - s.i)
    surface.SetDrawColor(CYR_UI.Primary)
    surface.SetMaterial(CloseButtonInactive)
    surface.DrawTexturedRect(0, 0, w, h)
    surface.SetAlphaMultiplier(s.i)
    surface.SetDrawColor(CYR_UI.Primary)
    surface.SetMaterial(CloseButtonActive)
    surface.DrawTexturedRect(0, 0, w, h)
end

WeightBarPaint = function(s, w, h)
    surface.SetDrawColor(CYR_UI.Primary)
    surface.DrawOutlinedRect(5, 0, w - 10, h - 7)
    -- draw filled portion
    local char = LocalPlayer():getChar()
    local inv = char and char:getInv()
    local weight = inv and inv:getWeight() or 0
    local maxWeight = inv and inv:getMaxWeight() or 100
    local p = weight / maxWeight
    surface.DrawRect(7, 2, (w - 14) * p, h - 11)
    -- Draw BlackText
    -- format weight as 0.00
    weight = string.format("%.2f", weight)
    maxWeight = string.format("%.2f", maxWeight)
    draw.SimpleText("WEIGHT: " .. weight .. " / " .. maxWeight .. "", "CYR_WeightBar", w / 2, h / 2 - 3, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PaintHeaderF1MenuWrapper(s, w, h, tab)
    -- draw text
    tab.c = tab.c or 0
    local c = tab.c
    draw.SimpleText(tab.txt, "nutMenuButtonLightFont", w / 2, 24, CYR_UI.Primary, TEXT_ALIGN_CENTER)
    if s.activeTab == tab then
        tab.c = math.min(c + FrameTime() * 4, 1)
    elseif tab.Hovered then
        surface.SetAlphaMultiplier(0.3)
        tab.c = math.min(c + FrameTime() * 12, 1)
    else
        tab.c = math.max(c - FrameTime() * 12, 0)
    end

    surface.SetDrawColor(CYR_UI.Primary)
    -- Draw expanding bar from center
    local barWidth = w * math.ease.InOutSine(tab.c)
    local barX = (w - barWidth) / 2
    surface.DrawRect(barX, 70, barWidth, 2)
end

--include("cyr/modules/ui/cl_equipmentMenu.lua")
function PerkPopupPaint(panel, w, h, name)
    -- blur
    surface.SetAlphaMultiplier(1)
    surface.SetDrawColor(CYR.BG)
    surface.SetMaterial(FUT_INV_BUTTON)
    surface.DrawRect(0, 0, w, h)
    surface.DrawOutlinedRect(0, 0, w, h, 2)
    surface.SetFont("nutMediumFont")
    --name        
    surface.SetDrawColor(CYR.Primary)
    surface.DrawOutlinedRect(0, 0, w, h, 2)
    local name = panel.name or "ERROR"
    local desc = panel.desc or "No description available."
    local nameSizeX, nameSizeY = surface.GetTextSize(name)
    surface.SetAlphaMultiplier(1)
    surface.SetTextColor(CYR.Primary)
    surface.SetTextPos(w * 0.5 - nameSizeX * 0.5, nameSizeY * 0.5)
    surface.DrawText(name)
    surface.SetDrawColor(CYR.Primary)
    surface.DrawOutlinedRect(0, nameSizeY + 16, w, 2, 2)
    --description
    local _, descSizeY = surface.GetTextSize(desc)
    local descLines = nut.util.wrapText(desc, w - 64, "nutMediumFont")
    local offsetY = 0
    for k, v in pairs(descLines) do
        surface.SetTextColor(color_white)
        surface.SetTextPos(8, nameSizeY + descSizeY * 0.5 + 16 + offsetY)
        surface.DrawText(v)
        offsetY = offsetY + nameSizeY + descSizeY * 0.5 + 8
    end
end

if CYR_EQUIPMENTMENU and IsValid(CYR_EQUIPMENTMENU) then
    CYR_EQUIPMENTMENU:Remove()
    CreateCYRWindow()
end

local PANEL = {}
function PANEL:Init()
    if IsValid(nut.gui.quick) then nut.gui.quick:Remove() end
    nut.gui.quick = self
    self:SetSize(0,0)
    self:SetPos(ScrW() - 36, -36)
    self:MakePopup()
    self:SetKeyboardInputEnabled(false)
    self:SetZPos(999)
    self:SetMouseInputEnabled(true)
    self.title = self:Add("DLabel")
    self.title:SetTall(36)
    self.title:Dock(TOP)
    self.title:SetFont("nutMediumFont")
    self.title:SetText(L"quickSettings")
    self.title:SetContentAlignment(4)
    self.title:SetTextInset(44, 0)
    self.title:SetTextColor(Color(250, 250, 250))
    self.title:SetExpensiveShadow(1, Color(0, 0, 0, 175))
    self.title.Paint = function(this, w, h)
        surface.SetDrawColor(nut.config.get("color"))
        surface.DrawRect(0, 0, w, h)
    end

    self.expand = self:Add("DButton")
    self.expand:SetContentAlignment(5)
    self.expand:SetText("`")
    self.expand:SetFont("nutIconsMedium")
    self.expand:SetPaintBackground(false)
    self.expand:SetTextColor(color_white)
    self.expand:SetExpensiveShadow(1, Color(0, 0, 0, 150))
    self.expand:SetSize(36, 36)
    self.expand.DoClick = function(this)
        if self.expanded then
            self:SizeTo(self:GetWide(), 36, 0.15, nil, nil, function() self:MoveTo(ScrW() - 36, 30, 0.15) end)
            self.expanded = false
        else
            self:MoveTo(ScrW() - 400, 30, 0.15, nil, nil, function()
                local height = 0
                for k, v in pairs(self.items) do
                    if IsValid(v) then height = height + v:GetTall() + 1 end
                end

                height = math.min(height, ScrH() * 0.5)
                self:SizeTo(self:GetWide(), height, 0.15)
            end)

            self.expanded = true
        end
    end

    self.scroll = self:Add("DScrollPanel")
    self.scroll:SetPos(0, 36)
    self.scroll:SetSize(self:GetWide(), ScrH() * 0.5)
    self:MoveTo(self.x, 30, 0.05)
    self.items = {}
  
end

local function paintButton(button, w, h)
    local alpha = 0
    if button.Depressed or button.m_bSelected then
        alpha = 5
    elseif button.Hovered then
        alpha = 2
    end

    surface.SetDrawColor(255, 255, 255, alpha)
    surface.DrawRect(0, 0, w, h)
end

function PANEL:addCategory(text)
    local label = self.scroll:Add("DLabel")
    label:SetText(text)
    label:SetFont("nutSmallFont")
    label:SetTextColor(color_white)
    label:SetContentAlignment(4)
    label:Dock(TOP)
    label:DockMargin(0, 0, 0, 0)
    label:SetTall(24)
    label:SetTextInset(8, 0)
    label.Paint = function(this, w, h)
        surface.SetDrawColor(0, 0, 0, 100)
        surface.DrawRect(0, 0, w, h)
    end

    self.items[#self.items + 1] = label
    return label
end

function PANEL:addButton(text, callback)
    local button = self.scroll:Add("DButton")
    button:SetText(text)
    button:SetTall(36)
    button:Dock(TOP)
    button:DockMargin(0, 1, 0, 0)
    button:SetFont("nutMediumLightFont")
    button:SetExpensiveShadow(1, Color(0, 0, 0, 150))
    button:SetContentAlignment(4)
    button:SetTextInset(8, 0)
    button:SetTextColor(color_white)
    button.Paint = paintButton
    if callback then button.DoClick = callback end
    self.items[#self.items + 1] = button
    return button
end

function PANEL:addSpacer()
    local panel = self.scroll:Add("DPanel")
    panel:SetTall(1)
    panel:Dock(TOP)
    panel:DockMargin(0, 1, 0, 0)
    panel.Paint = function(this, w, h)
        surface.SetDrawColor(255, 255, 255, 10)
        surface.DrawRect(0, 0, w, h)
    end

    self.items[#self.items + 1] = panel
    return panel
end

local color_dark = Color(255, 255, 255, 5)
function PANEL:addCheck(text, callback, checked)
    local x, y
    local color
    local button = self:addButton(text, function(panel)
        panel.checked = not panel.checked
        if callback then callback(panel, panel.checked) end
    end)

    button.PaintOver = function(this, w, h)
        x, y = w - 8, h * 0.5
        if this.checked then
            color = nut.config.get("color")
        else
            color = color_dark
        end

        draw.SimpleText(self.icon or "F", "nutIconsSmall", x, y, color, 2, 1)
    end

    button.checked = checked
    return button
end

function PANEL:setIcon(char)
    self.icon = char
end

function PANEL:Paint(w, h)
    nut.util.drawBlur(self)
    surface.SetDrawColor(nut.config.get("color"))
    surface.DrawRect(0, 0, w, 36)
    surface.SetDrawColor(255, 255, 255, 5)
    surface.DrawRect(0, 0, w, h)
end

vgui.Register("nutQuick", PANEL, "EditablePanel")
local PANEL = {}
function PANEL:Init()
    self:SetFont("nutCharButtonFont")
    self:SizeToContentsY()
    self:SetTextColor(CYR.Primary)
    self:SetPaintBackground(false)
end

function PANEL:OnCursorEntered()
    nut.gui.character:hoverSound()
    self:SetTextColor(CYR.PrimaryActive)
end

function PANEL:OnCursorExited()
    self:SetTextColor(CYR.Primary)
end

function PANEL:OnMousePressed()
    nut.gui.character:clickSound()
    DButton.OnMousePressed(self)
end

vgui.Register("nutCharButton", PANEL, "DButton")
-- inject stuff into init of panel "nutCharacterCreateStep"
local vguiPanel = vgui.GetControlTable("nutCharacterCreateStep")
vguiPanel.InitOld = vguiPanel.InitOld or vguiPanel.Init
function vguiPanel:Init()
    self:InitOld()
    PaintScrollBar(self)
end