local itemWidth = ScrW() * .15
local PADDING = 12
local PADDING_HALF = PADDING * 0.5

-- V.A.T.S. terminal palette + frame painter, hoisted so the tooltip hooks
-- below can share the same RobCo-terminal look as the AP / ACTIVE EFFECTS
-- panels and the nutActionList further down in this file.
local TERM_BG     = Color(2, 14, 4, 235)
local TERM_DIM    = Color(0, 70, 12, 220)
local TERM_GREEN  = Color(203, 255, 211, 235)
local TERM_BRIGHT = Color(130, 255, 150, 255)
local TERM_SCAN   = Color(0, 0, 0, 70)

local function drawTermPanel(x, y, w, h, title)
    surface.SetDrawColor(TERM_BG)
    surface.DrawRect(x, y, w, h)
    surface.SetDrawColor(TERM_SCAN)
    for sy = y + 1, y + h - 2, 3 do
        surface.DrawLine(x + 1, sy, x + w - 2, sy)
    end
    surface.SetDrawColor(TERM_GREEN)
    surface.DrawOutlinedRect(x, y, w, h, 1)
    surface.SetDrawColor(TERM_DIM)
    surface.DrawOutlinedRect(x + 2, y + 2, w - 4, h - 4, 1)
    -- corner brackets in TERM_BRIGHT
    local c = 7
    surface.SetDrawColor(TERM_BRIGHT)
    surface.DrawLine(x, y, x + c, y);                  surface.DrawLine(x, y, x, y + c)
    surface.DrawLine(x + w - c - 1, y, x + w - 1, y);  surface.DrawLine(x + w - 1, y, x + w - 1, y + c)
    surface.DrawLine(x, y + h - 1, x + c, y + h - 1);  surface.DrawLine(x, y + h - c - 1, x, y + h - 1)
    surface.DrawLine(x + w - c - 1, y + h - 1, x + w - 1, y + h - 1)
    surface.DrawLine(x + w - 1, y + h - c - 1, x + w - 1, y + h - 1)
    if title then
        surface.SetFont("nutCombatHUD")
        local tx, ty = surface.GetTextSize(title)
        local bw, bh = tx + 14, ty
        local bx = x + (w - bw) * 0.5
        local by = y - bh * 0.5
        surface.SetDrawColor(TERM_GREEN)
        surface.DrawRect(bx, by, bw, bh)
        surface.SetTextColor(0, 16, 4, 255)
        surface.SetTextPos(bx + 7, by)
        surface.DrawText(title)
    end
end

hook.Add("TooltipInitialize", "nutItemTooltip", function(self, panel)
    if panel.nutToolTip or panel.itemID then
        self.markupObject = nut.markup.parse(self:GetText(), itemWidth)
        self:SetText("")
        self:SetWide(math.max(itemWidth, 200) + PADDING)
        self:SetHeight(self.markupObject:getHeight() + PADDING)
        self:SetAlpha(0)
        self:AlphaTo(255, 0.2, 0)
        self.isItemTooltip = true
    end

    self:SetFont("DeezNutFont")
    self:SetTextColor(TERM_BRIGHT)
end)

hook.Add("SetupQuickMenu", "CyrColor", function(PANEL)
    function PANEL:addSlider(text, callback, min, max, decimal)
        local panel = self.scroll:Add("DPanel")
        panel:SetTall(56)
        panel:Dock(TOP)
        panel:DockMargin(0, 1, 0, 0)
        panel.Paint = paintButton
        local label = panel:Add("DLabel")
        label:SetFont("nutMediumLightFont")
        label:SetText(text)
        label:SizeToContents()
        label:SetPos(8, 4)
        label:SetTextColor(color_white)
        label:SetExpensiveShadow(1, Color(0, 0, 0, 150))
        local slider = panel:Add("DNumSlider")
        slider:Dock(BOTTOM)
        slider:DockMargin(8, 0, 8, 8)
        slider:SetMin(tonumber(min) or 0)
        slider:SetMax(tonumber(max) or 1)
        slider:SetDecimals(tonumber(decimal) or 2)
        -- Note: DNumSlider usually takes value via SetValue.
        -- We probably need a 'default' or 'value' argument.
        -- NutScript usually passes: text, callback, value, min, max, decimals?
        -- sh_plugin.lua:
        -- menu:addSlider("Desc Width Modifier", func, val, min, max, decimal)
        -- So 6 args if we include value.
        -- Let's re-read sh_plugin.lua line 26:
        -- menu:addSlider(text, callback, value, min, max, decimal)
    end
end)

-- Wait, I should rewrite the whole hook for clarity and correctness.
-- The previous replace call was too small. Let me replace the entire hook block.
hook.Add("TooltipPaint", "nutItemTooltip", function(self, w, h)
    if self.isItemTooltip then
        nut.util.drawBlur(self, 2, 2)
        drawTermPanel(0, 0, w, h)
        if self.markupObject then self.markupObject:draw(PADDING_HALF, PADDING_HALF + 2) end
        return true
    end
end)

hook.Add("TooltipLayout", "nutItemTooltip", function(self) if self.isItemTooltip then return true end end)
local tooltip_delay = 0.01
local PANEL = {}
function PANEL:Init()
    self:SetDrawOnTop(true)
    self.DeleteContentsOnClose = false
    self:SetText("")
    self:SetFont("nutToolTipText")
end

function PANEL:UpdateColours(skin)
    return self:SetTextStyleColor(color_black)
end

function PANEL:SetContents(panel, bDelete)
    panel:SetParent(self)
    self.Contents = panel
    self.DeleteContentsOnClose = bDelete or false
    self.Contents:SizeToContents()
    self:InvalidateLayout(true)
    self.Contents:SetVisible(false)
end

function PANEL:PerformLayout()
    local override = hook.Run("TooltipLayout", self)
    if not override then
        if self.Contents then
            self:SetWide(self.Contents:GetWide() + 8)
            self:SetTall(self.Contents:GetTall() + 8)
            self.Contents:SetPos(4, 4)
        else
            local w, h = self:GetContentSize()
            -- min w,h as 32 by 32
            w = math.max(w, 16)
            h = math.max(h, 16)
            self:SetSize(w + 8, h + 24)
            self:SetContentAlignment(5)
        end
    end
end

function PANEL:PositionTooltip()
    if not IsValid(self.TargetPanel) then
        self:Remove()
        return
    end

    self:PerformLayout()
    local x, y = input.GetCursorPos()
    local w, h = self:GetSize()
    local lx, ly = self.TargetPanel:LocalToScreen(0, 0)
    x = x + (w / 2)
    y = y + 12
    -- Fixes being able to be drawn off screen
    self:SetPos(math.Clamp(x - w * 0.5, 0, ScrW() - self:GetWide()), math.Clamp(y, 0, ScrH() - self:GetTall()))
end

function PANEL:Paint(w, h)
    self:PositionTooltip()
    local override = hook.Run("TooltipPaint", self, w, h)
    if override then return end
    if self:GetText() == "" then return end
    nut.util.drawBlur(self, 2, 2)
    drawTermPanel(0, 0, w, h)
end

function PANEL:OpenForPanel(panel)
    self.TargetPanel = panel
    self:PositionTooltip()
    hook.Run("TooltipInitialize", self, panel)
    if tooltip_delay > 0 then
        self:SetVisible(false)
        timer.Simple(tooltip_delay, function()
            if not IsValid(self) then return end
            if not IsValid(panel) then return end
            self:PositionTooltip()
            self:SetVisible(true)
        end)
    end
end

function PANEL:Close()
    if not self.DeleteContentsOnClose and self.Contents then
        self.Contents:SetVisible(false)
        self.Contents:SetParent(nil)
    end

    self:Remove()
end

derma.DefineControl("DTooltip", "", PANEL, "DLabel")
local PLUGIN = NUT_SWEP_COMBAT_PLUGIN

local PANEL = {}
function PANEL:Init()
    local client = LocalPlayer()
    local char = client:getChar()
    if IsValid(nut.gui.actionL) then nut.gui.actionL:Remove() end
    nut.gui.actionL = self
    self:SetSize(ScrW() * 0.3, ScrH() * 0.6)
    self:Center()
    self:SetTitle("")
    self:MakePopup()
    self:ShowCloseButton(false)
    self.Paint = function(this, w, h)
        drawTermPanel(0, 0, w, h, "ACTIONS")
    end

    local inner = vgui.Create("DScrollPanel", self)
    inner:Dock(FILL)
    inner:DockMargin(12, 16, 12, 12)
    inner.Paint = function() end
    self.inner = inner
    local vBar = inner:GetVBar()
    function vBar:Paint(w, h)
        surface.SetDrawColor(TERM_BG)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(TERM_DIM)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end

    function vBar.btnUp:Paint(w, h)
        surface.SetDrawColor(TERM_GREEN)
        surface.DrawRect(0, 0, w, h)
    end

    function vBar.btnDown:Paint(w, h)
        surface.SetDrawColor(TERM_GREEN)
        surface.DrawRect(0, 0, w, h)
    end

    function vBar.btnGrip:Paint(w, h)
        surface.SetDrawColor(TERM_GREEN)
        surface.DrawRect(0, 0, w, h)
    end

    local closeButton = vgui.Create("DButton", self)
    closeButton:SetPos(self:GetWide() - 26, 4)
    closeButton:SetSize(20, 16)
    closeButton:SetText("")
    closeButton.Paint = function(panel, w, h)
        surface.SetDrawColor(TERM_BG)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(TERM_GREEN)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
        surface.SetFont("nutCombatHUD")
        local tx, ty = surface.GetTextSize("X")
        surface.SetTextColor(TERM_BRIGHT)
        surface.SetTextPos(w * 0.5 - tx * 0.5, h * 0.5 - ty * 0.5)
        surface.DrawText("X")
    end
    closeButton.DoClick = function() self:Close() end
    --drop down menu for parts targetting
    local partTarget = vgui.Create("DComboBox")
    partTarget:SetPos(self:GetPos())
    partTarget:SetSize(ScrW() * 0.1, ScrH() * 0.05)
    partTarget:MoveRightOf(self, 8)
    partTarget:SetFont("nutCombatHUD")
    partTarget:SetToolTip("This affects accuracy and damage output.")
    partTarget:SetTextColor(TERM_BRIGHT)
    partTarget:SetText("[ BODY ]")
    local parts = PLUGIN:getPartsModifiers()
    for k, v in pairs(parts) do
        partTarget:AddChoice(k)
    end

    partTarget.Paint = function(panel, w, h)
        surface.SetDrawColor(TERM_BG)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(TERM_GREEN)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
        surface.SetDrawColor(TERM_DIM)
        surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 1)
    end

    partTarget.OpenMenuOld = partTarget.OpenMenu
    function partTarget:OpenMenu()
        self:OpenMenuOld()
        if IsValid(self.Menu) then
            self.Menu.Paint = function(panel, w, h)
                surface.SetDrawColor(TERM_BG)
                surface.DrawRect(0, 0, w, h)
                surface.SetDrawColor(TERM_GREEN)
                surface.DrawOutlinedRect(0, 0, w, h, 1)
            end
            for k, v in pairs(self.Menu:GetCanvas():GetChildren()) do
                v.Paint = function(panel, w, h)
                    if panel:IsHovered() then
                        surface.SetDrawColor(TERM_DIM)
                        surface.DrawRect(2, 1, w - 4, h - 2)
                    end
                end
                v.OnCursorEntered = function(this) if this.IsHovered and this:IsHovered() then sound.Play("nl_ui_menu_focus.wav", LocalPlayer():GetPos(), 75, 100, 0.35) end end
                v.DoClickOld = v.DoClickOld or v.DoClick
                v.DoClick = function(this)
                    sound.Play("nl_ui_menu_next1.wav", LocalPlayer():GetPos(), 75, 100, 0.35)
                    if this.DoClickOld then this:DoClickOld() end
                end
                v:DockMargin(4, 2, 4, 2)
                v:SetColor(TERM_BRIGHT)
            end
        end
    end

    partTarget.OnSelect = function(panel, index, value)
        panel:SetText("[ " .. string.upper(value) .. " ]")
        self:selectPart(value)
    end
    self.partTarget = partTarget
    --[[
		--drop down menu for weapon selecting
		local weaponSelect = vgui.Create("DComboBox")
		weaponSelect:SetPos(self:GetPos())
		weaponSelect:SetSize(ScrW()*0.1, ScrH()*0.05)
		weaponSelect:MoveRightOf(self, 8)
		weaponSelect:MoveBelow(partTarget, 8)

		weaponSelect:SetFont("nutSmallFont")
		weaponSelect:SetToolTip("What weapon to use for your attacks.")

		local equipment = {}
		for k, itemID in pairs(client:getEquip()) do
			local item = nut.item.instances[itemID]
			
			if(item) then
				equipment[#equipment+1] = item
			end
		end
		for k, item in pairs(char:getInv():getItems()) do
			if(item:getData("equip")) then
				equipment[#equipment+1] = item
			end
		end

		for k, item in pairs(equipment) do
			local dmg = item:getData("dmg", item.dmg)
			
			if(dmg) then
				weaponSelect:AddChoice(item:getName(), item)
			end
		end
		
		weaponSelect.OnSelect = function(panel, index, value, data)
			self:selectWeapon(data)
		end
		
		self.weaponSelect = weaponSelect
		--]]
    self:loadActions()
end

function PANEL:actionPress(button)
    for k, v in pairs(self.buttons) do
        v.active = false
    end

    button.active = true
    if self.actions and self.swep then
        self.swep:selectAction(button.action)
        --[[
		elseif(self.entity) then
			for k, v in pairs(self.entity.actions) do
				if(v.name == button:GetText()) then
					self.entity.casting = true --might be temporary
					
					self.entity.actCur = k
					netstream.Start("ccActionSelect", self.entity, k)
				end
			end
		--]]
    end
end

function PANEL:selectPart(partTarget)
    if self.swep then self.swep:selectPart(partTarget) end
end

--[[
	function PANEL:selectWeapon(item)
		if(self.swep) then
			self.swep:selectWeapon(item)
		end
	end
	--]]
--loads all the actions and category headers
function PANEL:loadActions()
    --clears existing actions (so we can reload them)
    self.categories = {}
    self.buttons = {}
    self.inner:Clear()
    self.labels = {}
    timer.Simple(0, function()
        --load default actions
        for k, action in pairs(self.actions) do
            if action.category == "Default" then self:addActionButton(action, k) end
        end

        --loads nondefault actions
        for k, action in SortedPairsByMemberValue(self.actions or {}, "category" or "") do
            if action.category == "Default" then continue end
            self:addActionButton(action, k)
        end
    end)
end

function PANEL:addActionButton(action, actionIndex)
    local categories = self.categories
    local inner = self.inner
    local actionData = {}
    if action.uid then actionData = ACTS.actions[action.uid] or {} end
    if actionData.category then
        if not categories[actionData.category] then
            categories[actionData.category] = true
            local catText = "== " .. string.upper(actionData.category) .. " =="
            local catLabel = inner:Add("DLabel")
            catLabel:Dock(TOP)
            catLabel:SetTall(36)
            catLabel:DockMargin(4, 12, 4, 4)
            catLabel:SetFont("nutCombatHUD")
            catLabel:SetText("")
            catLabel.Paint = function(panel, w, h)
                surface.SetFont("nutCombatHUD")
                local tx, ty = surface.GetTextSize(catText)
                surface.SetTextColor(TERM_BRIGHT)
                surface.SetTextPos(4, h * 0.5 - ty * 0.5)
                surface.DrawText(catText)
                surface.SetDrawColor(TERM_DIM)
                surface.DrawLine(tx + 12, h - 6, w - 4, h - 6)
            end
            self.labels[#self.labels + 1] = catLabel
        end
    end

    local desc
    if actionData.desc then
        desc = actionData.desc or ""
    else
        desc = ""
    end

    local item
    if action.weapon then
        item = nut.item.instances[action.weapon]
        if item then
            local name = (item.getName and item:getName()) or item.name or "Unknown Item"
            desc = desc .. "\nItem: " .. name .. "."
        end
    end

    local dmg = 0
    local dmgDesc = ""
    if actionData.weaponMult then
        if item then
            local itemDmg = item:getData("dmg", item.dmg) or {}
            for k, v in pairs(itemDmg) do
                dmg = dmg + (tonumber(v) or 0)
            end

            dmg = dmg * actionData.weaponMult
        end
        --desc = desc.. "\nWeapon Damage Multiplier: " ..actionData.weaponMult.. "x."
    end

    if actionData.dmg then
        dmg = dmg + actionData.dmg
        --desc = desc.. "\nBase Damage: " ..actionData.dmg.. " " ..actionData.dmgT.. "."
    end

    if dmg > 0 then
        desc = desc .. "\nDamage: " .. dmg
        --if(actionData.multi) then
        desc = desc .. " (x" .. (actionData.multi or 1) .. ")"
        --end
        local dmgT = actionData.dmgT
        if not dmgT then
            local itemDmg = (item and item:getData("dmg", item.dmg)) or {}
            local highest = 0
            --finds the damage type with the highest value
            for k, v in pairs(itemDmg) do
                local nv = tonumber(v) or 0
                if highest < nv then
                    highest = nv
                    dmgT = k
                end
            end
        end

        desc = desc .. " " .. (dmgT or "Unknown") .. "."
    end

    if actionData.radius then desc = desc .. "\nArea of Effect: " .. actionData.radius .. "." end
    if actionData.CD then desc = desc .. "\nCooldown: " .. actionData.CD .. " turns." end
    if actionData.costAP then desc = desc .. "\nAP Cost: " .. actionData.costAP .. "." end
    if actionData.costHP then desc = desc .. "\nHP Cost: " .. actionData.costHP .. "." end
    local button = inner:Add("DButton")
    button:Dock(TOP)
    button:SetHeight(28)
    button:DockMargin(2, 2, 2, 2)
    button:SetFont("nutCombatHUD")
    local actionName = actionData.name or action.name or "Unnamed Action"
    button:SetText("")
    button:SetToolTip(desc)
    button.DoClick = function(panel)
        LocalPlayer():EmitSound("nl_ui_menu_next1.wav", 0, 100, 0.35)
        self:actionPress(panel)
    end

    button.OnCursorEntered = function(panel) sound.Play("nl_ui_menu_focus.wav", LocalPlayer():GetPos(), 75, 100, 0.35) end
    button.Paint = function(panel, w, h)
        local hover = panel:IsHovered()
        local active = panel.active

        if active then
            surface.SetDrawColor(TERM_GREEN)
            surface.DrawRect(0, 0, w, h)
            surface.SetTextColor(0, 16, 4, 255)
        elseif hover then
            surface.SetDrawColor(TERM_DIM)
            surface.DrawRect(0, 0, w, h)
            surface.SetTextColor(TERM_BRIGHT)
        else
            surface.SetTextColor(TERM_GREEN)
        end

        surface.SetFont("nutCombatHUD")
        local prefix = active and "> " or "  "
        surface.SetTextPos(8, h * 0.5 - select(2, surface.GetTextSize("M")) * 0.5)
        surface.DrawText(prefix .. actionName)
    end

    button.action = actionIndex
    self.buttons[#self.buttons + 1] = button
end

function PANEL:OnRemove()
    if IsValid(self.partTarget) then self.partTarget:Remove() end
    if IsValid(self.weaponSelect) then self.weaponSelect:Remove() end
    sound.Play("nl_ui_menu_back" .. math.random(1, 3) .. ".wav", LocalPlayer():GetPos(), 75, 100, 0.35)
end

vgui.Register("nutActionList", PANEL, "DFrame")
local PANEL = {}
PANEL.ANIM_SPEED = 0.1
PANEL.FADE_SPEED = 0.5
-- Called when the tabs for the character menu should be created.
function PANEL:createTabs()
    local load, create
    -- Only show the load tab if playable characters exist.
    if nut.characters and #nut.characters > 0 then load = self:addTab("continue", self.createCharacterSelection) end
    -- Only show the create tab if the local player can create characters.
    if hook.Run("CanPlayerCreateCharacter", LocalPlayer()) ~= false then create = self:addTab("create", self.createCharacterCreation) end
    -- By default, select the continue tab, or the create tab.
    if IsValid(load) then
        load:setSelected()
    elseif IsValid(create) then
        create:setSelected()
    end

    -- If the player has a character (i.e. opened this menu from F1 menu), then
    -- don't add a disconnect button. Just add a close button.
    if LocalPlayer():getChar() then
        self:addTab("return", function() if IsValid(self) and LocalPlayer():getChar() then self:fadeOut() end end, true)
        return
    end

    -- Otherwise, add a disconnect button.
    self:addTab("leave", function() vgui.Create("nutCharacterConfirm"):setTitle(L("disconnect"):upper() .. "?"):setMessage(L("You will disconnect from the server."):upper()):onConfirm(function() LocalPlayer():ConCommand("disconnect") end) end, true)
end

function PANEL:createTitle()
    self.title = self:Add("DLabel")
    self.title:Dock(TOP)
    self.title:DockMargin(64, 48, 0, 0)
    self.title:SetContentAlignment(1)
    self.title:SetTall(96)
    self.title:SetFont("nutCharTitleFont")
    self.title:SetText("")
    self.title:SetTextColor(CYR.Primary)
    local centerlogo = nut.config.get("centerlogo")
    if centerlogo and centerlogo:find("%S") then
        self.schemaLogo = self:Add("DHTML")
        self.schemaLogo:SetSize(ScrW(), ScrH())
        self.schemaLogo:SetPos(ScrW() * 0.30, 25)
        self.schemaLogo:SetZPos(-197)
        self.schemaLogo:OpenURL(centerlogo)
    end

    local icon, iconIMG = nut.config.get("icon1URL"), nut.config.get("icon1IMG")
    if icon and icon:find("%S") and iconIMG and iconIMG:find("%S") then
        self.icon = self:Add("DHTML")
        self.icon:SetPos(ScrW() - 96, 8)
        self.icon:SetSize(86, 86)
        self.icon:SetHTML([[
			<html>
				<body style="margin: 0; padding: 0; overflow: hidden;">
					<img src="]] .. iconIMG .. [[" width="86" height="86" />
				</body>
			</html>
		]])
        --self.icon:SetToolTip("Content")
        self.icon.click = self.icon:Add("DButton")
        self.icon.click:Dock(FILL)
        self.icon.click.DoClick = function(this)
            --gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=773495550")
            gui.OpenURL(icon)
        end

        self.icon.click:SetAlpha(0)
        self.icon:SetAlpha(200)
    end

    local icon2, icon2IMG = nut.config.get("icon2URL"), nut.config.get("icon2IMG")
    if icon2 and icon2:find("%S") and icon2IMG and icon2IMG:find("%S") then
        self.icon2 = self:Add("DHTML")
        self.icon2:SetPos(8, 8)
        self.icon2:SetSize(86, 86)
        self.icon2:SetHTML([[
			<html>
				<body style="margin: 0; padding: 0; overflow: hidden;">
					<img src="]] .. icon2IMG .. [[" width="86" height="86" />
				</body>
			</html>
		]])
        --self.icon2:SetToolTip("Forums")
        self.icon2.click = self.icon2:Add("DButton")
        self.icon2.click:Dock(FILL)
        self.icon2.click.DoClick = function(this)
            --gui.OpenURL("http://spite.boards.net/")
            gui.OpenURL(icon2)
        end

        self.icon2.click:SetAlpha(0)
        self.icon2:SetAlpha(200)
    end

    self.desc = self:Add("DLabel")
    self.desc:Dock(TOP)
    self.desc:DockMargin(64, 0, 0, 0)
    self.desc:SetTall(32)
    self.desc:SetContentAlignment(7)
    self.desc:SetText(L(SCHEMA and SCHEMA.desc or ""):upper())
    self.desc:SetFont("nutCharDescFont")
    self.desc:SetTextColor(CYR.Primary)
end

function PANEL:loadBackground()
    -- Map scene integration.
    local mapScene = nut.plugin.list.mapscene
    if not mapScene or table.Count(mapScene.scenes) == 0 then self.blank = true end
    local url = nut.config.get("backgroundURL")
    if url and url:find("%S") then
        self.background = self:Add("DHTML")
        self.background:SetSize(ScrW(), ScrH())
        if url:find("http") then
            self.background:OpenURL(url)
        else
            self.background:SetHTML(url)
        end

        self.background.OnDocumentReady = function(background) self.bgLoader:AlphaTo(0, 2, 1, function() self.bgLoader:Remove() end) end
        self.background:MoveToBack()
        self.background:SetZPos(-999)
        if nut.config.get("charMenuBGInputDisabled") then
            self.background:SetMouseInputEnabled(false)
            self.background:SetKeyboardInputEnabled(false)
        end

        self.bgLoader = self:Add("DPanel")
        self.bgLoader:SetSize(ScrW(), ScrH())
        self.bgLoader:SetZPos(-998)
        self.bgLoader.Paint = function(loader, w, h)
            surface.SetDrawColor(20, 20, 20)
            surface.DrawRect(0, 0, w, h)
        end
    end
end

local gradient = nut.util.getMaterial("vgui/gradient-d")
local backgroundblir = Material("cyr/ui/blurdream.png", "smooth")
local background = Material("cyr/ui/DecoLongBorder2.png", "smooth")
local backgroundBorder = Material("cyr/ui/LongBorder2.png", "smooth ")
local grad = Color(100, 100, 100, 255)
function PANEL:paintBackground(w, h)
    if self.blank then
        surface.SetDrawColor(grad)
        surface.SetMaterial(backgroundblir)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    surface.SetDrawColor(CYR_UI.BG)
    surface.SetAlphaMultiplier(1)
    surface.SetMaterial(backgroundBorder)
    surface.DrawTexturedRect(32, 32, w - 64, h - 64)
    --background
    surface.SetDrawColor(CYR_UI.Primary)
    surface.SetMaterial(background)
    surface.DrawTexturedRect(32, 32, w - 64, h - 64)
end

function PANEL:addTab(name, callback, justClick)
    local button = self.tabs:Add("nutCharacterTabButton")
    button:setText(L(name):upper())
    if justClick then
        if isfunction(callback) then button.DoClick = function(button) callback(self) end end
        return
    end

    button.DoClick = function(button) button:setSelected(true) end
    if isfunction(callback) then button:onSelected(function() callback(self) end) end
    return button
end

function PANEL:createCharacterSelection()
    self.content:Clear()
    self.content:InvalidateLayout(true)
    self.content:Add("nutCharacterSelection")
end

function PANEL:createCharacterCreation()
    self.content:Clear()
    self.content:InvalidateLayout(true)
    self.content:Add("nutCharacterCreation")
end

function PANEL:fadeOut()
    self:AlphaTo(0, self.ANIM_SPEED, 0, function() self:Remove() end)
end

function PANEL:Init()
    if IsValid(nut.gui.loading) then nut.gui.loading:Remove() end
    if IsValid(nut.gui.character) then nut.gui.character:Remove() end
    nut.gui.character = self
    self:Dock(FILL)
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, self.ANIM_SPEED * 2)
    self:createTitle()
    self.tabs = self:Add("DPanel")
    self.tabs:Dock(TOP)
    self.tabs:DockMargin(64, 32, 64, 0)
    self.tabs:SetTall(48)
    self.tabs:SetDrawBackground(false)
    self.content = self:Add("DPanel")
    self.content:Dock(FILL)
    self.content:DockMargin(64, 0, 64, 64)
    self.content:SetDrawBackground(false)
    self.music = self:Add("nutCharBGMusic")
    self:loadBackground()
    self:showContent()
end

function PANEL:showContent()
    self.tabs:Clear()
    self.content:Clear()
    self:createTabs()
end

function PANEL:setFadeToBlack(fade)
    local d = deferred.new()
    if fade then
        if IsValid(self.fade) then self.fade:Remove() end
        local fade = vgui.Create("DPanel")
        fade:SetSize(ScrW(), ScrH())
        fade:SetSkin("Default")
        fade:SetBackgroundColor(color_black)
        fade:SetAlpha(0)
        fade:AlphaTo(255, self.FADE_SPEED, 0, function() d:resolve() end)
        fade:SetZPos(999)
        fade:MakePopup()
        self.fade = fade
    elseif IsValid(self.fade) then
        local fadePanel = self.fade
        fadePanel:AlphaTo(0, self.FADE_SPEED, 0, function()
            fadePanel:Remove()
            d:resolve()
        end)
    end
    return d
end

function PANEL:Paint(w, h)
    nut.util.drawBlur(self)
    self:paintBackground(w, h)
end

function PANEL:hoverSound()
    LocalPlayer():EmitSound(unpack(SOUND_CHAR_HOVER))
end

function PANEL:clickSound()
    LocalPlayer():EmitSound(unpack(SOUND_CHAR_CLICK))
end

function PANEL:warningSound()
    LocalPlayer():EmitSound(unpack(SOUND_CHAR_WARNING))
end

vgui.Register("nutCharacter", PANEL, "EditablePanel")
local PANEL = {}
function PANEL:Init()
    self:Dock(LEFT)
    self:DockMargin(0, 0, 32, 0)
    self:SetContentAlignment(4)
end

function PANEL:setText(name)
    self:SetText(L(name):upper())
    self:InvalidateLayout(true)
    self:SizeToContentsX()
    self:UseCustomText()
end

function PANEL:onSelected(callback)
    self.callback = callback
end

function PANEL:setSelected(isSelected)
    if isSelected == nil then isSelected = true end
    if isSelected and self.isSelected then return end
    local menu = nut.gui.character
    if isSelected and IsValid(menu) then
        if IsValid(menu.lastTab) then
            menu.lastTab:SetTextColor(CYR.Primary)
            menu.lastTab.isSelected = false
        end

        menu.lastTab = self
    end

    self:SetTextColor(isSelected and CYR.PrimaryActive or CYR.Primary)
    self.isSelected = isSelected
    if isfunction(self.callback) then self:callback() end
end

function PANEL:Paint(w, h)
    if self.isSelected or self:IsHovered() then
        surface.SetDrawColor(self.isSelected and CYR.Primary or CYR.PrimaryActive)
        surface.DrawRect(0, h - 4, w, 4)
        draw.SimpleText(self.txt, "CYR_CharacterEquipment", w / 2, h / 2, self.isSelected and CYR.Primary or CYR.PrimaryActive, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText(self.txt, "CYR_CharacterEquipment", w / 2, h / 2, CYR.Primary, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    -- draw text
end

vgui.Register("nutCharacterTabButton", PANEL, "nutCharButton")
local PANEL = {}
local materialOutline = Material("cyr/ui/CharBgOutline.png", "smooth")
local materialFill = Material("cyr/ui/CharBg.png", "smooth")
function PANEL:Init()
    self:Dock(FILL)
    self:DockMargin(0, 64, 0, 0)
    self:InvalidateLayout(true)
    self.panels = {}
    self.scroll = self:Add("nutHorizontalScroll")
    self.scroll:Dock(FILL)
    local scrollBar = self.scroll:GetHBar()
    scrollBar:SetTall(8)
    scrollBar:SetHideButtons(true)
    scrollBar.Paint = function(scroll, w, h)
        surface.SetDrawColor(255, 255, 255, 10)
        surface.DrawRect(0, 0, w, h)
    end

    scrollBar.btnGrip.Paint = function(grip, w, h)
        local alpha = 50
        if scrollBar.Dragging then
            alpha = 150
        elseif grip:IsHovered() then
            alpha = 100
        end

        surface.SetDrawColor(255, 255, 255, alpha)
        surface.DrawRect(0, 0, w, h)
    end

    self:createCharacterSlots()
    hook.Add("CharacterListUpdated", self, function() self:createCharacterSlots() end)
end

-- Creates a nutCharacterSlot for each of the local player's characters.
function PANEL:createCharacterSlots()
    self.scroll:Clear()
    if #nut.characters == 0 then return nut.gui.character:showContent() end
    for _, id in ipairs(nut.characters) do
        local character = nut.char.loaded[id]
        if not character then continue end
        local panel = self.scroll:Add("nutCharacterSlot")
        panel:Dock(LEFT)
        panel:DockMargin(0, 0, 8, 8)
        panel:setCharacter(character)
        panel.onSelected = function(panel) self:onCharacterSelected(character) end
    end
end

-- Called when a character slot has been selected. This actually loads the
-- character.
function PANEL:onCharacterSelected(character)
    if self.choosing then return end
    if character == LocalPlayer():getChar() then return nut.gui.character:fadeOut() end
    self.choosing = true
    nut.gui.character:setFadeToBlack(true):next(function() return nutMultiChar:chooseCharacter(character:getID()) end):next(function(err)
        self.choosing = false
        if IsValid(nut.gui.character) then
            timer.Simple(0.25, function()
                if not IsValid(nut.gui.character) then return end
                nut.gui.character:setFadeToBlack(false)
                nut.gui.character:Remove()
            end)
        end
    end, function(err)
        self.choosing = false
        nut.gui.character:setFadeToBlack(false)
        nut.util.notify(err)
    end)
end

vgui.Register("nutCharacterSelection", PANEL, "EditablePanel")
local PANEL = {}
local STRIP_HEIGHT = 4
function PANEL:isCursorWithinBounds()
    local x, y = self:LocalCursorPos()
    return x >= 0 and x <= self:GetWide() and y >= 0 and y < self:GetTall()
end

function PANEL:confirmDelete()
    local id = self.character:getID()
    vgui.Create("nutCharacterConfirm"):setMessage(L("Deleting a character cannot be undone.")):onConfirm(function() nutMultiChar:deleteCharacter(id) end)
end

function PANEL:Init()
    local WIDTH = 240
    self:SetWide(WIDTH)
    self:SetPaintBackground(false)
    self.faction = self:Add("DPanel")
    self.faction:Dock(TOP)
    self.faction:SetTall(STRIP_HEIGHT)
    self.faction:SetSkin("Default")
    self.faction:SetAlpha(100)
    self.faction.Paint = function(faction, w, h)
        surface.SetDrawColor(faction:GetBackgroundColor())
        surface.DrawRect(0, 0, w, h)
    end

    self.name = self:Add("DLabel")
    self.name:Dock(TOP)
    self.name:DockMargin(0, 48, 0, 0)
    self.name:SetContentAlignment(5)
    self.name:SetFont("nutCharSmallButtonFont")
    self.name:SetTextColor(nut.gui.character.WHITE)
    self.name:SizeToContentsY()
    self.model = self:Add("nutModelPanel")
    self.model:Dock(FILL)
    self.model:SetFOV(37)
    self.model.PaintOver = function(model, w, h)
        if self.banned then
            local centerX, centerY = w * 0.5, h * 0.5 - 24
            surface.SetDrawColor(250, 0, 0, 40)
            surface.DrawRect(0, centerY - 24, w, 48)
            draw.SimpleText(L("banned"):upper(), "nutCharSubTitleFont", centerX, centerY, color_white, 1, 1)
        end
    end

    self.button = self:Add("DButton")
    self.button:SetSize(WIDTH, ScrH())
    self.button:SetPaintBackground(false)
    self.button:SetText("")
    self.button.OnCursorEntered = function(button) self:OnCursorEntered() end
    self.button.DoClick = function(button)
        nut.gui.character:clickSound()
        if not self.banned then self:onSelected() end
    end

    self.delete = self:Add("DButton")
    self.delete:SetTall(30)
    self.delete:SetFont("nutCharSubTitleFont")
    self.delete:SetText("✕ " .. L("delete"):upper())
    self.delete:SetWide(self:GetWide() - 57)
    self.delete.Paint = function(delete, w, h)
        surface.SetDrawColor(255, 0, 0, 50)
        surface.DrawRect(0, 0, w, h)
    end

    self.delete.DoClick = function(delete)
        nut.gui.character:clickSound()
        self:confirmDelete()
    end

    self.delete.y = ScrH()
    self.delete.showY = self.delete.y - self.delete:GetTall()
end

function PANEL:onSelected()
end

function PANEL:setCharacter(character)
    self.character = character
    self.name:SetText(character:getName():gsub("#", "\226\128\139#"):upper())
    self.model:SetModel(character:getModel())
    self.faction:SetBackgroundColor(team.GetColor(character:getFaction()))
    self.faction.Paint = function(faction, w, h) end
    self:setBanned(character:getData("banned"))
    local entity = self.model.Entity
    if IsValid(entity) then
        -- Match the skin and bodygroups.
        entity:SetSkin(character:getData("skin", 0))
        for k, v in pairs(character:getData("groups", {})) do
            entity:SetBodygroup(k, v)
        end

        -- Approximate the upper body position.
        local mins, maxs = entity:GetRenderBounds()
        local height = math.abs(mins.z) + math.abs(maxs.z)
        local scale = math.max((960 / ScrH()) * 0.5, 0.5)
        self.model:SetLookAt(entity:GetPos() + Vector(0, 0, height * scale))
    end
end

function PANEL:setBanned(banned)
    self.banned = banned
end

function PANEL:onHoverChanged(isHovered)
    local ANIM_SPEED = nut.gui.character.ANIM_SPEED
    if self.isHovered == isHovered then return end
    self.isHovered = isHovered
    local tall = self:GetTall()
    if isHovered then
        self.delete.y = tall
        self.delete:MoveTo(0, tall - self.delete:GetTall(), ANIM_SPEED)
        nut.gui.character:hoverSound()
    else
        self.delete:MoveTo(0, tall, ANIM_SPEED)
    end

    self.faction:AlphaTo(isHovered and 250 or 100, ANIM_SPEED)
end

function PANEL:Paint(w, h)
    surface.SetAlphaMultiplier(0.02)
    surface.SetDrawColor(CYR.Primary)
    surface.SetMaterial(materialFill)
    surface.DrawTexturedRect(0, 0, w, h)
    surface.SetAlphaMultiplier(1)
    surface.SetDrawColor(CYR.Primary)
    surface.SetMaterial(materialOutline)
    surface.DrawTexturedRect(0, 0, w, h)
    surface.SetDrawColor(self.faction:GetBackgroundColor())
    surface.SetMaterial(materialOutline)
    surface.DrawTexturedRectUV(0, 0, w, h, 0, 0, 1, 1)
    if not self:isCursorWithinBounds() and self.isHovered then self:onHoverChanged(false) end
end

function PANEL:OnCursorEntered()
    self:onHoverChanged(true)
end

vgui.Register("nutCharacterSlot", PANEL, "DPanel")
if IsValid(nut.gui.character) then
    nut.gui.character:Remove()
    vgui.Create("nutCharacter")
end

local PANEL = {}
local gradient = nut.util.getMaterial("vgui/gradient-d")
local schemaUI = nut.config.get("schemaUI", "fonvui")
--local hudMessage = Material("fonvui/hud/hud_message_seperator_right.png")
local hudMessage = Material("cyr/ui/Card_Notif.png", "smooth mips")
function PANEL:Init()
    self:SetSize(841 * 0.4, 146 * 0.5)
    self:SetContentAlignment(5)
    self:SetExpensiveShadow(1, Color(0, 0, 0, 150))
    self:SetFont("nutNoticeFont")
    self:SetTextColor(color_white)
    self:SetDrawOnTop(true)
end

function PANEL:Paint(w, h)
    --nut.util.drawBlur(self, 3, 2)
    surface.SetAlphaMultiplier(1)
    surface.SetMaterial(hudMessage)
    surface.SetDrawColor(CYR.Primary)
    surface.DrawTexturedRect(0, 0, w, h)
    local text = self.text
    local lines = nut.util.wrapText(text, w - 100, "nutNoticeFont")
    local posX = 26
    local posY = 18
    for k, v in pairs(lines) do
        surface.SetFont("nutNoticeFont")
        local textX, textY = surface.GetTextSize(v)
        --surface.SetDrawColor(0, 43, 0, 160)
        --surface.DrawRect(posX, posY, textX+8, textY)
        --surface.SetTextColor(0, 238, 0, 255)
        surface.SetTextColor(CYR.Primary)
        surface.SetTextPos(posX, posY)
        surface.DrawText(v)
        posY = posY + textY
    end
end

function PANEL:Think()
    if self:GetText() ~= "" then
        self.text = self:GetText()
        self:SetText("")
    end
end

vgui.Register("nutNotice", PANEL, "DLabel")