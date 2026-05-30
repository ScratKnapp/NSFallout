-- Fallout-style barter UI for the simple-inventory storage transfer.
--
-- Lives in cyr_main (not the simpleinv plugin) so iterating on the UI
-- doesn't require touching the gamemode and the panel registration is
-- available client-side regardless of which gamemode plugin opens it.
-- Loaded via `includeModule("ui", "list_storage")` in lua/autorun/init.lua.
--
-- Two bracketed columns (player + storage) sit side-by-side, each in its own
-- FO-style corner-bracket frame. Inside each column: an upper title strip
-- ("< TITLE >" centred with an up-chevron and Caps count), a scrollable list
-- of item rows (name + quantity, value on the right), and a lower strip with
-- a down-chevron. Below both columns sits a separate bracketed footer panel
-- carrying the hovered item's icon and WG / VAL stats, with the
-- "Click an item to transfer" / "[X] Exit" hints on the right side. Click
-- any row to transfer the item across.
--
-- Scaling: all sizes / paddings / fonts derive from `uiScale()` which is
-- ScrH()/1080 clamped to a sensible floor. Designed at 1080p; smaller and
-- larger displays read the same. Fonts are (re)created on screen-size
-- change so a borderless-window resize stays sharp.

local function getThemeColor()
	if CYR_GetHUDColor then return CYR_GetHUDColor() end
	if pip_color then return ColorAlpha(pip_color, 255) end
	return Color(255, 182, 66, 255)  -- FO4 amber fallback
end

local function uiScale()
	return math.max(ScrH() / 1080, 0.55)
end

-- Font (re)creation. Sizes are 1080p-relative; uiScale shifts them for
-- other resolutions. Reregistered on screen-size change.
local function ensureFonts()
	local s = uiScale()
	surface.CreateFont("nutBarterTitle",  { font = "Monofonto",  size = math.Round(26 * s), weight = 600, antialias = true })
	surface.CreateFont("nutBarterHeader", { font = "Monofonto",  size = math.Round(22 * s), weight = 500, antialias = true })
	surface.CreateFont("nutBarterRow",    { font = "Monofonto",  size = math.Round(20 * s), weight = 400, antialias = true })
	surface.CreateFont("nutBarterHint",   { font = "Monofonto",  size = math.Round(18 * s), weight = 400, antialias = true })
	surface.CreateFont("nutBarterValue",  { font = "Monofonto",  size = math.Round(20 * s), weight = 600, antialias = true })
end
ensureFonts()
hook.Add("OnScreenSizeChanged", "nutBarterFontsReload", ensureFonts)

-- FO-style bracket corners around a rectangle — corner ticks only, no full
-- border. Mirrors the FO3/FNV bracket frame in the screenshot.
local function drawBracketCorners(x, y, w, h, col, cornerLen, thick)
	thick = thick or 2
	cornerLen = cornerLen or math.Round(14 * uiScale())
	surface.SetDrawColor(col)
	for t = 0, thick - 1 do
		-- Top-left
		surface.DrawLine(x + t,             y + t,             x + t + cornerLen,  y + t)
		surface.DrawLine(x + t,             y + t,             x + t,              y + t + cornerLen)
		-- Top-right
		surface.DrawLine(x + w - cornerLen - t, y + t,             x + w - t - 1,      y + t)
		surface.DrawLine(x + w - t - 1,     y + t,             x + w - t - 1,      y + t + cornerLen)
		-- Bottom-left
		surface.DrawLine(x + t,             y + h - t - 1,     x + t + cornerLen,  y + h - t - 1)
		surface.DrawLine(x + t,             y + h - cornerLen - t, x + t,           y + h - t - 1)
		-- Bottom-right
		surface.DrawLine(x + w - cornerLen - t, y + h - t - 1,     x + w - t - 1,  y + h - t - 1)
		surface.DrawLine(x + w - t - 1,     y + h - cornerLen - t, x + w - t - 1,  y + h - t - 1)
	end
end

-- Title chip: "[< TITLE >]" rendered along the top of a column. Mirrors the
-- arrow-bracketed headers in the FO3 trade UI.
local function drawTitleChip(cx, y, text, col, font)
	surface.SetFont(font)
	local tw, th = surface.GetTextSize(text)
	local arrowPad = math.Round(18 * uiScale())
	surface.SetTextColor(col)
	surface.SetTextPos(cx - tw * 0.5, y)
	surface.DrawText(text)
	-- Side arrows
	surface.SetTextPos(cx - tw * 0.5 - arrowPad, y)
	surface.DrawText("<")
	surface.SetTextPos(cx + tw * 0.5 + arrowPad - math.Round(6 * uiScale()), y)
	surface.DrawText(">")
end

-- Up/down chevron carets used as the scroll indicators tucked into the
-- top-left and bottom-left of each column frame, FNV-trade-screen style.
local function drawChevronUp(cx, cy, size, col)
	surface.SetDrawColor(col)
	local half = math.floor(size * 0.5)
	for t = 0, 1 do
		surface.DrawLine(cx - size, cy + half + t, cx,        cy - half + t)
		surface.DrawLine(cx,        cy - half + t, cx + size, cy + half + t)
	end
end

local function drawChevronDown(cx, cy, size, col)
	surface.SetDrawColor(col)
	local half = math.floor(size * 0.5)
	for t = 0, 1 do
		surface.DrawLine(cx - size, cy - half + t, cx,        cy + half + t)
		surface.DrawLine(cx,        cy + half + t, cx + size, cy - half + t)
	end
end

-- Right-pointing chevron — used as the "collapsed" state indicator on
-- category headers (rotates to drawChevronDown when expanded).
local function drawChevronRight(cx, cy, size, col)
	surface.SetDrawColor(col)
	local half = math.floor(size * 0.5)
	for t = 0, 1 do
		surface.DrawLine(cx - half + t, cy - size, cx + half + t, cy)
		surface.DrawLine(cx + half + t, cy,        cx - half + t, cy + size)
	end
end

-- Pip-bar fill, same texture as the FNV HP/AP HUD (fixed_pip4.png) but
-- drawn one pip at a time. Each cell is a discrete DrawTexturedRect with
-- a per-cell alpha, so there's no UV-tiling seam between bright and dim
-- and the bar lights/darkens cleanly on whole-pip boundaries.
local PIP_MAT = Material("fixed_pip4.png", "noclamp smooth")
local PIP_EMPTY_ALPHA = 45
local function drawPipBar(x, y, pipPx, h, filled, pips, col)
	if not pips or pips < 1 then return end
	filled = math.Clamp(filled or 0, 0, pips)
	surface.SetMaterial(PIP_MAT)
	for i = 1, pips do
		if i <= filled then
			surface.SetDrawColor(col.r, col.g, col.b, 255)
		else
			surface.SetDrawColor(col.r, col.g, col.b, PIP_EMPTY_ALPHA)
		end
		surface.DrawTexturedRect(x + (i - 1) * pipPx, y, pipPx, h)
	end
end

-- ============================================================ ROW PANEL
-- One row inside a barter column: item name + quantity on the left, value
-- on the right. Highlights on hover, transfers on click.

-- The displayed amount is the stack's quantity data, not the raw instance
-- count. Reads Amount first (the canonical stacking key), then a "quantity"
-- data value, then the native quantity field, defaulting to 1.
local function itemAmount(it)
	if not it then return 1 end
	local n = it.getData and (tonumber(it:getData("Amount")) or tonumber(it:getData("quantity")))
	if not n and it.getQuantity then n = it:getQuantity() end
	return tonumber(n) or 1
end

-- Effective stack cap, honouring the nwl_stackable_items_infinite convar.
local function effMax(maxstack)
	if NWL and NWL.GetStackLimit then return NWL.GetStackLimit(maxstack) end
	return maxstack
end

-- Whether an item can be stacked/grouped at all. Non-stackable items
-- (maxstack <= 1, PreventStacks, customisable classes, or per-instance
-- custom/equip data) must each occupy their own row — they should never
-- group just because two instances share the same data.
local function isStackableItem(item)
	local cls = nut.item.list[item.uniqueID]
	if not cls or cls.PreventStacks then return false end
	local fns = cls.functions
	if fns and (fns.Custom or fns.CustomAtr) then return false end
	local d = item.data or {}
	if (d.custom and next(d.custom) ~= nil)
		or (d.customW and next(d.customW) ~= nil)
		or d.infused or d.edited or d.equip then
		return false
	end
	local maxstack = effMax(cls.maxstack)
	return maxstack ~= nil and maxstack > 1
end

local ROW = {}
	function ROW:Init()
		self:SetTall(math.Round(28 * uiScale()))
		self:SetMouseInputEnabled(true)
	end

	function ROW:setItem(item, count, themeColor, onPressed, onHovered, stack)
		self.item        = item
		self.stack       = stack or { item }  -- full set of items in this stack
		self.count       = count or 1
		self.themeColor  = themeColor
		self.onPressed   = onPressed
		self.onHovered   = onHovered
		-- Prefer the per-instance custom name (engraved/renamed items
		-- stash it in data.customName) before falling back to getName,
		-- which on most items just returns the localized base name.
		local customName = item.getData and item:getData("customName")
		self.displayName = (customName ~= nil and customName ~= "" and tostring(customName))
			or (item.getName and item:getName()) or item.name or "Unknown"
		self.value       = (item.getPrice and item:getPrice()) or item.price or 0

		-- Displayed amount + weight are summed from the stack's quantity
		-- data (Amount), not the raw instance count.
		self.quantity = 0
		self.weight   = 0
		for _, it in ipairs(self.stack) do
			self.quantity = self.quantity + itemAmount(it)
			self.weight   = self.weight + ((GET_ITEM_WEIGHT and GET_ITEM_WEIGHT(it))
				or (type(it.weight) == "function" and it:weight(it))
				or it.weight or 0)
		end
	end

	function ROW:Paint(w, h)
		local hover = self:IsHovered()
		local col   = self.themeColor or Color(255, 182, 66)

		if hover then
			-- FNV-style: a single thin outline, no fill. Matches the
			-- "selected row" highlight in the reference trade-screen UI.
			surface.SetDrawColor(col)
			surface.DrawOutlinedRect(0, 0, w, h, 1)
		end

		surface.SetFont("nutBarterRow")
		local label = (self.quantity or self.count) > 1
			and string.format("%s (%d)", self.displayName, self.quantity or self.count)
			or self.displayName
		local _, th = surface.GetTextSize(label)
		surface.SetTextColor(col)
		local lpad = math.Round(12 * uiScale())
		surface.SetTextPos(lpad, math.floor((h - th) * 0.5))
		surface.DrawText(label)

		local valStr = tostring(self.value)
		local vw     = surface.GetTextSize(valStr)
		surface.SetTextPos(w - vw - lpad, math.floor((h - th) * 0.5))
		surface.DrawText(valStr)
	end

	function ROW:OnCursorEntered()
		if self.onHovered then self.onHovered(self.item, self.count) end
	end

	function ROW:OnMousePressed(keyCode)
		if keyCode ~= MOUSE_LEFT then return end
		if self.onPressed then self.onPressed(self.item, self.count, self.stack) end
	end
vgui.Register("nutBarterRow", ROW, "DPanel")

-- ============================================================ CATEGORY HEADER
-- Non-interactive divider row that introduces a category group. Renders the
-- category name in uppercase with a thin underline rule.

local HDR = {}
	function HDR:Init()
		self:SetTall(math.Round(26 * uiScale()))
		self:SetMouseInputEnabled(true)
		self:SetCursor("hand")
	end

	function HDR:setCategory(name, themeColor, collapsed)
		self.category   = name or ""
		self.themeColor = themeColor or Color(255, 182, 66)
		self.collapsed  = collapsed and true or false
	end

	-- The owning column wires `onToggle` after construction; clicking
	-- anywhere on the header flips its category's collapsed state.
	function HDR:OnMousePressed(keyCode)
		if keyCode ~= MOUSE_LEFT then return end
		if self.onToggle then self.onToggle() end
	end

	function HDR:Paint(w, h)
		local col   = self.themeColor or Color(255, 182, 66)
		local s     = uiScale()
		local hover = self:IsHovered()

		local lpad     = math.Round(8 * s)
		local chevX    = lpad + math.Round(4 * s)
		local chevY    = math.floor(h * 0.5) - math.Round(2 * s)
		local chevSize = math.Round(4 * s)
		local labelX   = lpad + math.Round(20 * s)

		-- Chevron: down when expanded (items render below), right when
		-- collapsed (items hidden). Same visual language as a tree view.
		if self.collapsed then
			drawChevronRight(chevX, chevY, chevSize, col)
		else
			drawChevronDown(chevX, chevY, chevSize, col)
		end

		-- Thin rule along the bottom edge — brighter on hover so the
		-- whole row reads as interactive.
		surface.SetDrawColor(col.r, col.g, col.b, hover and 180 or 90)
		surface.DrawLine(lpad, h - 2, w - lpad, h - 2)

		-- Label (left of the chevron, vertically centred above the rule).
		surface.SetFont("nutBarterHeader")
		local label = string.upper(self.category)
		local _, th = surface.GetTextSize(label)
		surface.SetTextColor(col.r, col.g, col.b, hover and 255 or 220)
		surface.SetTextPos(labelX, math.floor((h - th - 2) * 0.5))
		surface.DrawText(label)
	end
vgui.Register("nutBarterCategory", HDR, "DPanel")

-- ============================================================ COLUMN PANEL
-- One side of the barter view. Owns its DScrollPanel + the per-row population
-- logic. The owning frame passes in callbacks for hover + transfer.

local COL = {}
	function COL:Init()
		self:DockPadding(0, 0, 0, 0)
		self:SetPaintBackground(false)

		self.scroll = self:Add("DScrollPanel")
		self.scroll:Dock(FILL)
		self.scroll:DockMargin(math.Round(6 * uiScale()), math.Round(8 * uiScale()),
		                      math.Round(6 * uiScale()), math.Round(8 * uiScale()))
		-- Hide the engine VBar; we use a tiny custom indicator instead.
		self.scroll.VBar:SetWide(math.Round(6 * uiScale()))
		self.scroll.VBar.Paint = function() end
		self.scroll.VBar.btnUp.Paint = function() end
		self.scroll.VBar.btnDown.Paint = function() end
		self.scroll.VBar.btnGrip.Paint = function(_, w, h)
			surface.SetDrawColor(self.themeColor or color_white)
			surface.DrawRect(0, 0, w, h)
		end
	end

	function COL:configure(themeColor, onPressed, onHovered)
		self.themeColor = themeColor
		self.onPressed  = onPressed
		self.onHovered  = onHovered
	end

	function COL:setItems(stacks)
		-- Cache so the toggle callback can rebuild without going back to
		-- the parent panel for inventory data.
		self.lastStacks = stacks
		self.collapsed  = self.collapsed or {}
		self.scroll:Clear()

		-- Group stacks by category. Items with no `category` field fall under
		-- "Miscellaneous" so they still get a header rather than dangling.
		local groups = {}
		for _, stack in pairs(stacks) do
			if not stack[1] then continue end
			local cat = stack[1].category or "Miscellaneous"
			groups[cat] = groups[cat] or {}
			groups[cat][#groups[cat] + 1] = stack
		end

		-- Sort categories alphabetically, but push "Miscellaneous" to the
		-- bottom so well-defined gameplay categories surface first.
		local catNames = {}
		for cat in pairs(groups) do catNames[#catNames + 1] = cat end
		table.sort(catNames, function(a, b)
			local aMisc = (a == "Miscellaneous" or a == "Misc")
			local bMisc = (b == "Miscellaneous" or b == "Misc")
			if aMisc ~= bMisc then return not aMisc end
			return a < b
		end)

		local function nameOf(stack)
			return (stack[1].getName and stack[1]:getName()) or stack[1].name or ""
		end

		local s = uiScale()
		local rowPad     = math.Round(2 * s)
		local headerTop  = math.Round(6 * s)  -- gap above each category header
		local headerBot  = math.Round(2 * s)  -- gap below each category header

		for _, cat in ipairs(catNames) do
			local hdr = self.scroll:Add("nutBarterCategory")
			hdr:Dock(TOP)
			hdr:DockMargin(0, headerTop, 0, headerBot)
			hdr:setCategory(cat, self.themeColor, self.collapsed[cat])

			-- Closure captures self + this category so the click flips the
			-- right bucket and triggers a single-column rebuild.
			local owner   = self
			local thisCat = cat
			hdr.onToggle = function()
				owner.collapsed[thisCat] = not owner.collapsed[thisCat]
				owner:setItems(owner.lastStacks)
			end

			if not self.collapsed[cat] then
				local catStacks = groups[cat]
				table.sort(catStacks, function(a, b) return nameOf(a) < nameOf(b) end)

				for _, stack in ipairs(catStacks) do
					local row = self.scroll:Add("nutBarterRow")
					row:Dock(TOP)
					row:DockMargin(0, 0, 0, rowPad)
					row:setItem(stack[1], #stack, self.themeColor, self.onPressed, self.onHovered, stack)
				end
			end
		end
	end
vgui.Register("nutBarterColumn", COL, "DPanel")

-- ============================================================ QUANTITY POPUP
-- Shown when a row with count > 1 is clicked. Player picks an amount via the
-- pip bar (same texture/style as the HP/AP HUD), then confirms with Enter or
-- the OK hint; the owning frame transfers that many items by iterating the
-- stack and firing one transferItem net message per item. Default value is
-- the max — matching how FNV's "transfer all" prompt opens at max.

local QPOPUP = {}
	function QPOPUP:Init()
		-- Per-pip width @ 1080p (× uiScale at layout time). The pip count
		-- caps at floor(maxBarWidth / pipPx); beyond that threshold each pip
		-- represents more than one item.
		self.PIP_WIDTH_BASE = 12
		self.BAR_H_BASE     = 22

		local s = uiScale()
		self:SetSize(math.Round(420 * s), math.Round(200 * s))
		self:MakePopup()
		self:SetTitle("")
		self:ShowCloseButton(false)
		self:SetDraggable(false)
		self:SetKeyboardInputEnabled(true)

		self.themeColor = getThemeColor()
		self.quantity   = 1
		self.maxAmount  = 1

		-- The interactive pip bar lives in its own child panel so the parent
		-- DFrame's mouse semantics don't fight with click+drag on the bar.
		local owner = self
		self.bar = self:Add("DPanel")
		self.bar:SetMouseInputEnabled(true)
		self.bar:SetCursor("hand")
		self.bar.dragging = false
		self.bar.Paint = function(_, w, h)
			local col   = owner.themeColor
			local pips  = owner.pips  or 1
			local pipPx = owner.pipPx or w
			-- One pip per item when the stack fits; otherwise each pip
			-- represents > 1 item but a non-zero quantity always lights at
			-- least one pip.
			local filled
			if pips >= owner.maxAmount then
				filled = owner.quantity
			else
				filled = math.max(1, math.ceil(owner.quantity / owner.maxAmount * pips))
			end
			drawPipBar(0, 0, pipPx, h, filled, pips, col)
		end
		self.bar.OnMousePressed = function(p, key) 
			if key ~= MOUSE_LEFT then return end
			p.dragging = true
			p:MouseCapture(true)
			local mx = p:LocalCursorPos()
			owner:setQuantityFromBarPos(mx, p:GetWide())
		end
		self.bar.OnMouseReleased = function(p, key)
			if key ~= MOUSE_LEFT then return end
			p.dragging = false
			p:MouseCapture(false)
		end
		self.bar.OnCursorMoved = function(p, mx)
			if not p.dragging then return end
			owner:setQuantityFromBarPos(mx, p:GetWide())
		end

		-- Direct-entry mode: click the number readout under the bar to type
		-- a quantity with the number keys. The click target is an invisible
		-- child panel sized to cover the readout in PerformLayout — QPOPUP's
		-- Paint still draws the actual text (with a blinking cursor when
		-- editing).
		self.editing    = false
		self.editBuffer = ""

		self.numberArea = self:Add("DPanel")
		self.numberArea:SetMouseInputEnabled(true)
		self.numberArea:SetCursor("hand")
		self.numberArea:SetPaintBackground(false)
		self.numberArea.Paint = function() end
		self.numberArea.OnMousePressed = function(_, key)
			if key == MOUSE_LEFT then owner:beginEdit() end
		end

		-- Centre last, after every child exists. Center() triggers an
		-- InvalidateLayout, so calling it earlier would run PerformLayout
		-- against a not-yet-built self.bar / self.numberArea.
		self:Center()
	end

	function QPOPUP:beginEdit()
		self.editing    = true
		self.editBuffer = ""
	end

	function QPOPUP:cancelEdit()
		self.editing    = false
		self.editBuffer = ""
	end

	function QPOPUP:commitEdit()
		-- Empty buffer = no-op (just exit edit mode); otherwise setQuantity
		-- clamps to [1, maxAmount] so typing past the max still resolves.
		if self.editBuffer ~= "" then
			local n = tonumber(self.editBuffer)
			if n then self:setQuantity(n) end
		end
		self.editing    = false
		self.editBuffer = ""
	end

	-- Accepts either a number or a function-of-no-args returning a number.
	-- When given a function, the popup polls it every Think tick so other
	-- players draining the source (storage caps / shared stack / player
	-- money) clamps the live max and the current selection in real time.
	function QPOPUP:_applyMax(maxOrFn)
		if type(maxOrFn) == "function" then
			self.getMax    = maxOrFn
			self.maxAmount = math.max(1, tonumber(maxOrFn()) or 1)
		else
			self.getMax    = nil
			self.maxAmount = math.max(1, tonumber(maxOrFn) or 1)
		end
		self.quantity = self.maxAmount
	end

	function QPOPUP:setStack(item, maxOrFn, onConfirm)
		self.item       = item
		self.subtitle   = nil  -- item name takes over
		self:_applyMax(maxOrFn)
		self.onConfirm  = onConfirm
		-- Re-run layout so the pip count and bar width track the new max.
		self:InvalidateLayout(true)
	end

	-- Configure the popup for a caps transfer instead of an item stack.
	-- The subtitle (e.g. "Deposit Caps") replaces the item-name label
	-- under the "How many?" headline; the rest of the popup behaves
	-- identically — bar, drag, E confirm, X cancel.
	function QPOPUP:setCapsTransfer(subtitle, maxOrFn, onConfirm)
		self.item       = nil
		self.subtitle   = subtitle or "Caps"
		self:_applyMax(maxOrFn)
		self.onConfirm  = onConfirm
		self:InvalidateLayout(true)
	end

	-- Live-poll the configured max. If another player drains the source,
	-- clamp the current selection and re-layout so the pip count tracks
	-- the new ceiling; if nothing is left, close the popup outright.
	function QPOPUP:Think()
		if not self.getMax then return end
		local newMax = math.max(0, tonumber(self.getMax()) or 0)
		if newMax <= 0 then
			self:Remove()
			return
		end
		if newMax ~= self.maxAmount then
			self.maxAmount = newMax
			if self.quantity > newMax then self.quantity = newMax end
			self:InvalidateLayout(true)
		end
	end

	function QPOPUP:setQuantity(q)
		self.quantity = math.Clamp(math.Round(q), 1, self.maxAmount)
	end

	-- Map a cursor x (local to the bar) to a quantity. ceil makes the very
	-- first pixel of the first pip resolve to quantity=1, and the math
	-- mirrors the Paint logic so dragging exactly one pip's worth lights
	-- exactly one more pip.
	function QPOPUP:setQuantityFromBarPos(mx, barW)
		if not barW or barW <= 0 then return end
		local perc = math.Clamp(mx / barW, 0, 1)
		self:setQuantity(math.max(1, math.ceil(perc * self.maxAmount)))
	end

	function QPOPUP:PerformLayout(w, h)
		local s     = uiScale()
		local pO    = math.Round(20 * s)
		local barH  = math.Round(self.BAR_H_BASE * s)
		local pipPx = math.max(1, math.Round(self.PIP_WIDTH_BASE * s))

		-- Pip count: one per item up to the width threshold, then cap.
		local maxBarW = w - pO * 2
		local fitPips = math.max(1, math.floor(maxBarW / pipPx))
		local pips    = math.min(self.maxAmount or 1, fitPips)
		local barW    = pips * pipPx

		self.pips  = pips
		self.pipPx = pipPx

		-- Centre the bar horizontally; small stacks no longer stretch
		-- across the whole panel width. Guarded because PerformLayout can
		-- fire during DFrame's own Init chain before our children exist.
		if not IsValid(self.bar) then return end
		self.bar:SetSize(barW, barH)
		self.bar:SetPos(math.floor((w - barW) * 0.5), math.floor(h * 0.5 - barH * 0.5))

		-- Click target for the number readout. Sits directly under the bar,
		-- spans the bar's width — clicking anywhere in this band activates
		-- direct-entry mode. The actual text is drawn in QPOPUP:Paint.
		if IsValid(self.numberArea) then
			surface.SetFont("nutBarterTitle")
			local _, rh = surface.GetTextSize("0")
			local areaH = rh + math.Round(8 * s)
			local areaY = self.bar:GetY() + barH + math.Round(6 * s)
			self.numberArea:SetPos(self.bar:GetX(), areaY)
			self.numberArea:SetSize(barW, areaH)
		end
	end

	function QPOPUP:Paint(w, h)
		local col = self.themeColor
		local s   = uiScale()

		-- Backdrop + bracket frame, matching the main barter view.
		surface.SetDrawColor(5, 5, 15, 235)
		surface.DrawRect(0, 0, w, h)
		drawBracketCorners(0, 0, w, h, col, math.Round(18 * s), 2)

		-- "How many?" headline
		surface.SetFont("nutBarterTitle")
		local title = "How many?"
		local tw, th = surface.GetTextSize(title)
		surface.SetTextColor(col)
		surface.SetTextPos(math.floor((w - tw) * 0.5), math.Round(18 * s))
		surface.DrawText(title)

		-- Subtitle under the headline. Prefer an explicit subtitle (caps
		-- transfer mode) over the item name (stack transfer mode).
		local subLabel
		if self.subtitle then
			subLabel = self.subtitle
		elseif self.item then
			subLabel = (self.item.getName and self.item:getName()) or self.item.name or ""
		end
		if subLabel then
			surface.SetFont("nutBarterHeader")
			local nw = surface.GetTextSize(subLabel)
			surface.SetTextColor(col.r, col.g, col.b, 200)
			surface.SetTextPos(math.floor((w - nw) * 0.5),
			                   math.Round(18 * s) + th + math.Round(4 * s))
			surface.DrawText(subLabel)
		end

		-- Quantity readout below the bar
		-- Quantity readout below the bar. In edit mode the typed buffer
		-- replaces the live value, with a blinking pipe as the cursor.
		local barBot = self.bar:GetY() + self.bar:GetTall()
		surface.SetFont("nutBarterTitle")
		local txt
		if self.editing then
			local buf    = self.editBuffer ~= "" and self.editBuffer or "0"
			local cursor = (CurTime() % 1 < 0.5) and "|" or " "
			txt = string.format("%s%s / %d", buf, cursor, self.maxAmount)
		else
			txt = string.format("%d / %d", self.quantity, self.maxAmount)
		end
		local rw = surface.GetTextSize(txt)
		surface.SetTextColor(col)
		surface.SetTextPos(math.floor((w - rw) * 0.5), barBot + math.Round(10 * s))
		surface.DrawText(txt)

		-- Footer hints. Matches the FNV trade-screen prompt style and the
		-- E/X keybinds used by the surrounding storage UI ([X] Exit on the
		-- main barter view).
		surface.SetFont("nutBarterHint")
		local _, hH = surface.GetTextSize("M")
		local hintY = h - hH - math.Round(14 * s)
		surface.SetTextColor(col)
		local okTxt     = "[E] OK"
		local cancelTxt = "[X] Cancel"
		surface.SetTextPos(math.Round(20 * s), hintY)
		surface.DrawText(okTxt)
		local cw = surface.GetTextSize(cancelTxt)
		surface.SetTextPos(w - cw - math.Round(20 * s), hintY)
		surface.DrawText(cancelTxt)
	end

	function QPOPUP:OnKeyCodePressed(key)
		-- Direct-entry mode: digits feed the buffer, backspace deletes, E /
		-- Enter commits, X / Esc bails. Anything else is ignored so a stray
		-- key doesn't close the popup mid-type.
		if self.editing then
			if key == KEY_E or key == KEY_ENTER or key == KEY_PAD_ENTER then
				self:commitEdit()
			elseif key == KEY_X or key == KEY_ESCAPE then
				self:cancelEdit()
			elseif key == KEY_BACKSPACE then
				self.editBuffer = self.editBuffer:sub(1, -2)
			elseif key >= KEY_0 and key <= KEY_9 then
				-- Cap length so we never overflow the UInt32 net write.
				if #self.editBuffer < 10 then
					self.editBuffer = self.editBuffer .. (key - KEY_0)
				end
			elseif key >= KEY_PAD_0 and key <= KEY_PAD_9 then
				if #self.editBuffer < 10 then
					self.editBuffer = self.editBuffer .. (key - KEY_PAD_0)
				end
			end
			return
		end

		if key == KEY_E then
			self:confirm()
		elseif key == KEY_X then
			self:Remove()
		elseif key == KEY_LEFT then
			local step = input.IsKeyDown(KEY_LSHIFT) and 10 or 1
			self:setQuantity(self.quantity - step)
		elseif key == KEY_RIGHT then
			local step = input.IsKeyDown(KEY_LSHIFT) and 10 or 1
			self:setQuantity(self.quantity + step)
		end
	end

	function QPOPUP:confirm()
		if self.onConfirm then self.onConfirm(self.quantity) end
		self:Remove()
	end
vgui.Register("nutBarterQuantity", QPOPUP, "DFrame")

-- ============================================================ MAIN FRAME

local PANEL = {}
	function PANEL:Init()
		if IsValid(nut.gui.storage) then nut.gui.storage:Remove() end
		nut.gui.storage = self

		self.themeColor = getThemeColor()

		local s = uiScale()
		local w = math.min(ScrW() * 0.78, math.Round(1280 * s))
		local h = math.min(ScrH() * 0.78, math.Round(780  * s))
		self:SetSize(w, h)
		self:Center()
		self:MakePopup()
		self:SetTitle("")
		self:ShowCloseButton(false)
		self:SetDraggable(false)
		self:NoClipping(true)

		-- Layout constants (all scale-derived).
		-- padOuter:    margin from the frame's outer edge to the column brackets
		-- padInner:    horizontal gap between the two columns
		-- padBetween:  vertical gap between the columns and the footer panel
		-- headerH:     title+caps strip inside each column bracket
		-- colStripH:   bottom strip (scroll-down chevron) inside each column
		-- footerH:     separate bracketed info panel below both columns
		self.padOuter   = math.Round(20 * s)
		self.padInner   = math.Round(14 * s)
		self.padBetween = math.Round(12 * s)
		self.headerH    = math.Round(40 * s)
		self.colStripH  = math.Round(28 * s)
		self.footerH    = math.Round(96 * s)
		self.iconSize   = math.Round(64 * s)

		-- Two columns docked to fill the middle, side-by-side. The press
		-- closure forwards count + stack so onItemPressed can decide whether
		-- to transfer immediately or open the quantity popup.
		self.localCol = self:Add("nutBarterColumn")
		self.localCol:configure(self.themeColor,
			function(item, count, stack) self:onItemPressed(item, count, stack) end,
			function(item, count) self:onItemHovered(item, count) end)

		self.storageCol = self:Add("nutBarterColumn")
		self.storageCol:configure(self.themeColor,
			function(item, count, stack) self:onItemPressed(item, count, stack) end,
			function(item, count) self:onItemHovered(item, count) end)
	end

	function PANEL:PerformLayout(w, h)
		local s = uiScale()
		local pO = self.padOuter   or math.Round(20 * s)
		local pI = self.padInner   or math.Round(14 * s)
		local pB = self.padBetween or math.Round(12 * s)
		local headerH   = self.headerH   or math.Round(40 * s)
		local colStripH = self.colStripH or math.Round(28 * s)
		local footerH   = self.footerH   or math.Round(96 * s)

		-- The column brackets span from y=pO down to y=(h - pO - footerH - pB).
		-- Their inner content area sits between headerH (top strip) and the
		-- colStripH (bottom strip with the down-chevron).
		local colW         = math.floor((w - pO * 2 - pI) * 0.5)
		local colBottom    = h - pO - footerH - pB
		local contentY     = pO + headerH
		local contentBot   = colBottom - colStripH
		local contentH     = contentBot - contentY
		local innerPadX    = math.Round(10 * s)

		if IsValid(self.localCol) then
			self.localCol:SetPos(pO + innerPadX, contentY)
			self.localCol:SetSize(colW - innerPadX * 2, contentH)
		end
		if IsValid(self.storageCol) then
			self.storageCol:SetPos(pO + colW + pI + innerPadX, contentY)
			self.storageCol:SetSize(colW - innerPadX * 2, contentH)
		end
	end

	-- Painted manually instead of using child panels so each column's
	-- bracket frame + header/footer rules + chevron indicators all share
	-- one render pass and stay visually aligned. Listing data (titles,
	-- caps, hovered item info) is pulled from self fields each frame.
	function PANEL:Paint(w, h)
		local col = self.themeColor
		local s   = uiScale()

		-- Caps change outside of inventory events (R/T deposit/withdraw),
		-- so refresh them every frame. Cheap: two field reads.
		local char = LocalPlayer():getChar()
		if char and char.getMoney then self.localCaps = char:getMoney() end
		if IsValid(self.storage) then
			local inv = self.storage.getInv and self.storage:getInv()
			self.storageCaps = inv and inv.getData and inv:getData("storCaps", 0) or 0
		end

		-- Dim full-bleed backdrop (we're drawing OVER the world, FO trade
		-- screens have a heavy darkening behind them).
		surface.SetDrawColor(0, 0, 0, 215)
		surface.DrawRect(0, 0, w, h)

		local pO        = self.padOuter
		local pI        = self.padInner
		local pB        = self.padBetween
		local headerH   = self.headerH
		local colStripH = self.colStripH
		local footerH   = self.footerH

		local colW      = math.floor((w - pO * 2 - pI) * 0.5)
		local colY      = pO
		local colBottom = h - pO - footerH - pB
		local colH      = colBottom - colY
		local colX1     = pO
		local colX2     = pO + colW + pI

		local contentY   = colY + headerH
		local contentBot = colBottom - colStripH

		local cornerLen = math.Round(20 * s)
		local rulePad   = math.Round(8 * s)
		local chevSize  = math.Round(7 * s)
		local chevX1    = colX1 + math.Round(22 * s)
		local chevX2    = colX2 + math.Round(22 * s)

		-- ── PER-COLUMN BRACKET FRAMES ───────────────────────────────────
		drawBracketCorners(colX1, colY, colW, colH, col, cornerLen, 2)
		drawBracketCorners(colX2, colY, colW, colH, col, cornerLen, 2)

		-- Titles + caps inside each column's header strip
		surface.SetFont("nutBarterTitle")
		local _, titleH = surface.GetTextSize("M")
		local titleY = colY + math.floor((headerH - titleH) * 0.5)
		drawTitleChip(colX1 + colW * 0.5, titleY, "ITEMS",                          col, "nutBarterTitle")
		drawTitleChip(colX2 + colW * 0.5, titleY, self.storageTitle or "STORAGE",   col, "nutBarterTitle")
		self:drawCaps(colX1, colY, colW, headerH, self.localCaps   or 0, col)
		self:drawCaps(colX2, colY, colW, headerH, self.storageCaps or 0, col)

		-- Rules under headers / above bottom strips, per column
		surface.SetDrawColor(col.r, col.g, col.b, 120)
		surface.DrawLine(colX1 + rulePad, contentY,   colX1 + colW - rulePad, contentY)
		surface.DrawLine(colX2 + rulePad, contentY,   colX2 + colW - rulePad, contentY)
		surface.DrawLine(colX1 + rulePad, contentBot, colX1 + colW - rulePad, contentBot)
		surface.DrawLine(colX2 + rulePad, contentBot, colX2 + colW - rulePad, contentBot)

		-- Scroll chevrons: up at top-left of header, down at bottom-left of bottom strip
		local upY   = colY + math.floor(headerH * 0.5)
		local downY = contentBot + math.floor(colStripH * 0.5)
		drawChevronUp(chevX1,   upY,   chevSize, col)
		drawChevronUp(chevX2,   upY,   chevSize, col)
		drawChevronDown(chevX1, downY, chevSize, col)
		drawChevronDown(chevX2, downY, chevSize, col)

		-- ── FOOTER BRACKET ──────────────────────────────────────────────
		local footerY = colBottom + pB
		local footerX = pO
		local footerW = w - pO * 2
		drawBracketCorners(footerX, footerY, footerW, footerH, col, cornerLen, 2)

		-- Hovered item icon on the left of the footer
		local iconX = footerX + math.Round(14 * s)
		local iconY = footerY + math.floor((footerH - self.iconSize) * 0.5)

		if self.hoveredItem then
			local mdl = (self.hoveredItem.getModel and self.hoveredItem:getModel()) or self.hoveredItem.model
			if mdl then
				local iconMat = "spawnicons/"..string.gsub(string.gsub(mdl, "%.mdl$", ".png"), "^models/", "")
				local tex = Material(iconMat)
				if tex and not tex:IsError() then
					surface.SetDrawColor(255, 255, 255)
					surface.SetMaterial(tex)
					surface.DrawTexturedRect(iconX, iconY, self.iconSize, self.iconSize)
				end
			end

			-- WG / VAL stacked to the right of the icon (FNV-style stat block).
			-- A second column to the right adds DMG / AMMO / SIZE when the
			-- hovered item is a weapon or ammo box. Columns share the same
			-- two-row vertical layout so the two stat blocks read as siblings.
			surface.SetFont("nutBarterValue")
			local _, lh = surface.GetTextSize("M")
			local rowGap = math.Round(6 * s)
			local labelX = iconX + self.iconSize + math.Round(28 * s)
			local labelY = footerY + math.floor((footerH - lh * 2 - rowGap) * 0.5)
			surface.SetTextColor(col)
			surface.SetTextPos(labelX, labelY)
			surface.DrawText(string.format("WG   %.2f", self.hoveredWeight or 0))
			surface.SetTextPos(labelX, labelY + lh + rowGap)
			surface.DrawText(string.format("VAL  %d",  self.hoveredValue  or 0))

			-- Second column: only render rows we actually have data for so
			-- ammo boxes (no DMG) and melee weapons (no SIZE/TYPE) don't
			-- show empty fields. Width is sized off the widest WG/VAL
			-- string so the column starts at a stable offset regardless
			-- of the current values.
			local extras = {}
			if self.hoveredDamage   then extras[#extras + 1] = string.format("DMG  %s", tostring(self.hoveredDamage)) end
			if self.hoveredAmmoSize then extras[#extras + 1] = string.format("SIZE %s", tostring(self.hoveredAmmoSize)) end
			if self.hoveredAmmoType then extras[#extras + 1] = string.format("AMMO %s", tostring(self.hoveredAmmoType)) end
			if #extras > 0 then
				local wgW = surface.GetTextSize(string.format("WG   %.2f", self.hoveredWeight or 0))
				local vlW = surface.GetTextSize(string.format("VAL  %d",  self.hoveredValue  or 0))
				local col2X = labelX + math.max(wgW, vlW) + math.Round(28 * s)
				-- Up to two rows fit at the same height as WG/VAL; a
				-- third (rare: weapon with all three) wraps under the
				-- second column with a tighter line height.
				surface.SetTextPos(col2X, labelY)
				surface.DrawText(extras[1])
				if extras[2] then
					surface.SetTextPos(col2X, labelY + lh + rowGap)
					surface.DrawText(extras[2])
				end
				if extras[3] then
					-- Third row jumps to a third column rather than
					-- overflowing the footer vertically.
					local col3W = math.max(
						surface.GetTextSize(extras[1] or ""),
						surface.GetTextSize(extras[2] or "")
					)
					local col3X = col2X + col3W + math.Round(28 * s)
					surface.SetTextPos(col3X, labelY)
					surface.DrawText(extras[3])
				end
			end
		end

		-- Hints stacked on the right side of the footer
		surface.SetFont("nutBarterHint")
		local hintLines = {
			"Click an item to transfer.",
			"[R] Deposit Caps",
			"[T] Withdraw Caps",
			"[X] Exit",
		}
		local _, hintH = surface.GetTextSize("M")
		local hintLineH = hintH + math.Round(4 * s)
		local hintTotalH = hintLineH * #hintLines
		local hintStartY = footerY + math.floor((footerH - hintTotalH) * 0.5)
		surface.SetTextColor(col)
		for i, line in ipairs(hintLines) do
			local lw = surface.GetTextSize(line)
			surface.SetTextPos(footerX + footerW - lw - math.Round(18 * s),
			                   hintStartY + (i - 1) * hintLineH)
			surface.DrawText(line)
		end
	end

	function PANEL:drawCaps(x, y, w, h, capsVal, col)
		surface.SetFont("nutBarterHeader")
		local txt = string.format("Caps  %d", capsVal)
		local tw, th = surface.GetTextSize(txt)
		surface.SetTextColor(col)
		surface.SetTextPos(x + w - tw - math.Round(10 * uiScale()),
		                   y + math.floor((h - th) * 0.5))
		surface.DrawText(txt)
	end

	-- Group items by stack key. We build the key ourselves rather than
	-- delegating to listinvui's getItemStackKey because that helper hashes
	-- the entire `item.data` table — and storage entities here are typed
	-- `invType = "grid"`, so every item added to storage gets unique x/y
	-- cells assigned. Hashing those would put every transferred round into
	-- its own bucket and break visual merging on the storage side.
	--
	-- So: same shape as listinvui's key (uniqueID + sorted data), but with
	-- the grid-positional fields stripped. `PreventStacks` items get a
	-- per-instance key so they never group, matching the upstream behavior.
	function PANEL:getStacks(inventory)
		local stacks = {}
		for _, item in pairs(inventory:getItems()) do
			-- Stackable items group by uniqueID (different-sized stacks of the
			-- same item share one row). Everything else gets a per-instance
			-- key so non-stackable items (a barbell, etc.) never group.
			local key
			if isStackableItem(item) then
				key = item.uniqueID
			else
				key = item.uniqueID .. "@" .. item:getID()
			end
			stacks[key] = stacks[key] or {}
			table.insert(stacks[key], item)
		end
		return stacks
	end

	function PANEL:populate()
		if not IsValid(self.storage) then return end
		local char = LocalPlayer():getChar()
		if not char then return end
		local localInv = char:getInv()
		local storageInv = self.storage:getInv()
		if not localInv or not storageInv then return end

		self.localCaps   = char.getMoney and char:getMoney() or 0
		self.storageCaps = storageInv.getData and storageInv:getData("storCaps", 0) or 0
		self.localCol:setItems(self:getStacks(localInv))
		self.storageCol:setItems(self:getStacks(storageInv))
	end

	function PANEL:setStorage(storage)
		if IsValid(self.storage) then
			self.storage:RemoveCallOnRemove("BarterStorageView")
		end

		-- Validation copied from the original list-storage panel.
		local bad = not IsValid(storage)
		local character = LocalPlayer():getChar()
		if not bad and not storage:getInv() then bad = true end
		if not character then bad = true
		elseif not character:getInv() then bad = true end
		if bad then return self:Remove() end

		self.storage = storage
		storage:CallOnRemove("BarterStorageView", function()
			if IsValid(self) then self:Remove() end
		end)

		self.storageTitle = string.upper(L(storage:getStorageInfo().name or "Storage"))
		self:SetTitle("")

		-- Hook inventory-change events so the UI refreshes live as items move.
		self:nutListenForInventoryChanges(character:getInv())
		self:nutListenForInventoryChanges(storage:getInv())

		self:populate()
	end

	-- Single click → if the row is a stack of 1, transfer immediately;
	-- otherwise pop the quantity selector. On confirm we iterate the
	-- stack and fire one transferItem net message per item that's still
	-- in the source inventory. Identical items regroup automatically on
	-- the destination side because getStacks() buckets by uniqueID +
	-- significant data.
	function PANEL:onItemPressed(item, count, stack)
		if not item or not item.getID then return end
		stack = stack or { item }

		-- Source/destination are resolved from item.invID. Regular items have
		-- no :getInv() method (only bags do), so relying on that previously
		-- left sourceInvID nil and made every transfer treat the player
		-- inventory as the destination — which is why depositing was capped by
		-- the player's weight instead of the storage's.
		local char       = LocalPlayer():getChar()
		local localInv   = char and char:getInv() or nil
		local storageInv = IsValid(self.storage) and self.storage:getInv() or nil
		local storageID  = storageInv and storageInv.getID and storageInv:getID() or nil

		local sourceInvID = item.invID

		local function isInSource(it)
			if not it or not it.getID then return false end
			local live = nut.item.instances[it:getID()]
			if not live then return false end
			return live.invID == sourceInvID
		end

		-- Destination = the opposite side from where the item currently lives.
		local destInv
		if storageID and sourceInvID == storageID then
			destInv = localInv            -- storage -> player (withdraw)
		else
			destInv = storageInv          -- player -> storage (deposit)
		end

		-- Transferable quantity is Amount-aware (a stack of one instance
		-- carrying Amount=3 counts as 3), summed over instances still in the
		-- source.
		local function sourceQuantity()
			local q = 0
			for _, it in ipairs(stack) do
				if isInSource(it) then q = q + itemAmount(it) end
			end
			return q
		end

		-- A single unit (non-stackable item, or a 1-quantity stack) just
		-- swaps straight across with no popup.
		if sourceQuantity() <= 1 then
			nutStorageBase:transferItem(item:getID())
			return
		end

		-- Popup max = transferable quantity, capped by how much fits under the
		-- destination inventory's carry-weight. Applies both ways: withdrawing
		-- is limited by the player's weight, depositing by the storage's own
		-- weight cap.
		local function available()
			local q = sourceQuantity()
			if destInv and isfunction(destInv.getMaxWeight) and isfunction(destInv.getWeight) then
				local base = (type(item.weight) == "function" and item:weight(item)) or item.weight or 0
				if base > 0 then
					local fit = math.floor((destInv:getMaxWeight() - destInv:getWeight()) / base)
					q = math.min(q, math.max(0, fit))
				end
			end
			return q
		end

		local popup = vgui.Create("nutBarterQuantity")
		popup:setStack(item, available, function(n)
			n = math.floor(tonumber(n) or 0)
			if n <= 0 then return end
			-- Move n units across the stack's instances: transfer whole
			-- instances while they fit under the running remainder, and split
			-- the one that straddles the boundary. Whole-instance transfers
			-- use the server's storage-transaction lock, so chain them with a
			-- short delay; the split path runs immediately and ends the chain.
			local idx = 0
			local function step(remaining)
				if remaining <= 0 then return end
				while idx < #stack do
					idx = idx + 1
					local it = stack[idx]
					if isInSource(it) then
						local amt = itemAmount(it)
						if amt <= remaining then
							nutStorageBase:transferItem(it:getID())
							timer.Simple(0.15, function()
								if IsValid(self) then step(remaining - amt) end
							end)
						else
							net.Start("cyrStorageTransferQuantity")
								net.WriteUInt(it:getID(), 32)
								net.WriteUInt(remaining, 32)
							net.SendToServer()
						end
						return
					end
				end
			end
			step(n)
		end)
	end

	function PANEL:onItemHovered(item, count)
		self.hoveredItem   = item
		self.hoveredCount  = count or 1
		self.hoveredValue  = (item.getPrice and item:getPrice()) or item.price or 0
		self.hoveredWeight = (GET_ITEM_WEIGHT and GET_ITEM_WEIGHT(item))
			or (type(item.weight) == "function" and item:weight(item))
			or item.weight or 0

		-- Extra weapon / ammo stats for the footer stat block. Weapons
		-- carry .dmg keyed by ammo type, .magSize, and .ammo on the
		-- class table; ammo boxes carry per-instance data: "Amount"
		-- (ammo count) and "ammo" (caliber).
		self.hoveredDamage   = nil
		self.hoveredAmmoSize = nil
		self.hoveredAmmoType = nil

		if type(item.dmg) == "table" and item.ammo then
			local d = item.dmg[item.ammo]
			if type(d) == "number" then self.hoveredDamage = d end
			self.hoveredAmmoType = item.ammo
			self.hoveredAmmoSize = item.magSize
		elseif type(item.dmg) == "number" then
			-- Melee weapons store a flat damage number.
			self.hoveredDamage = item.dmg
		end

		if item.getData then
			local amount = item:getData("Amount")
			local ammo   = item:getData("ammo")
			if amount and not self.hoveredAmmoSize then
				self.hoveredAmmoSize = amount
			end
			if ammo and not self.hoveredAmmoType then
				self.hoveredAmmoType = ammo
			end
		end
	end

	-- Inventory event hooks — fire when items get added / removed / changed
	-- on either side; refresh the row lists.
	function PANEL:InventoryItemAdded(item)    self:populate() end
	function PANEL:InventoryItemRemoved(item)  self:populate() end
	function PANEL:InventoryItemDataChanged()  self:populate() end
	function PANEL:InventoryDataChanged()      self:populate() end

	-- X to close, R deposits caps into the storage, T withdraws from it.
	-- Both R/T reuse the nutBarterQuantity popup (with caps mode) so the
	-- player picks an amount the same way they pick a stack quantity.
	function PANEL:OnKeyCodePressed(key)
		if key == KEY_ESCAPE or key == KEY_X then
			self:Remove()
		elseif key == KEY_R then
			self:openCapsDeposit()
		elseif key == KEY_T then
			self:openCapsWithdraw()
		end
	end

	function PANEL:openCapsDeposit()
		-- Re-evaluated each Think tick: if the player spends caps in
		-- another window the deposit max ratchets down with their wallet.
		local maxFn = function()
			local c = LocalPlayer():getChar()
			return (c and c.getMoney and c:getMoney()) or 0
		end
		if maxFn() <= 0 then return end

		local popup = vgui.Create("nutBarterQuantity")
		popup:setCapsTransfer("Deposit Caps", maxFn, function(n)
			if n <= 0 then return end
			net.Start("nutBarterDepositCaps")
				net.WriteUInt(n, 32)
			net.SendToServer()
		end)
	end

	function PANEL:openCapsWithdraw()
		if not IsValid(self.storage) then return end
		local storage = self.storage
		-- Re-evaluated each Think tick: another player withdrawing
		-- caps from this storage clamps our selection live.
		local maxFn = function()
			if not IsValid(storage) then return 0 end
			local inv = storage.getInv and storage:getInv()
			return inv and inv.getData and inv:getData("storCaps", 0) or 0
		end
		if maxFn() <= 0 then return end

		local popup = vgui.Create("nutBarterQuantity")
		popup:setCapsTransfer("Withdraw Caps", maxFn, function(n)
			if n <= 0 then return end
			net.Start("nutBarterWithdrawCaps")
				net.WriteUInt(n, 32)
			net.SendToServer()
		end)
	end

	function PANEL:OnRemove()
		self:nutDeleteInventoryHooks()
		if nutStorageBase and nutStorageBase.exitStorage then
			nutStorageBase:exitStorage()
		end
	end
vgui.Register("nutListStorage", PANEL, "DFrame")

-- ========================================================================
-- StorageOpen hook takeover.
--
-- Reality on this gamemode: fallout/plugins/storage/sh_definitions.lua
-- registers every storage entity with `invType = "grid"`, which means the
-- gamemode's `gridstorage` plugin handles their StorageOpen events and opens
-- its split grid+list UI. The simpleinv `liststorage` plugin's StorageOpen
-- only fires for storages typed "simple", so without intervention the
-- barter UI we just registered would never be shown for any actual storage.
--
-- We don't want to retype every storage definition. Cleaner: hook the
-- StorageOpen event ourselves and unconditionally open the barter view,
-- and yank the existing grid/list plugin handlers so they don't ALSO open
-- their own panels. Both plugin handlers were registered via the standard
-- nutscript `hook.Add(event_name, PLUGIN_TABLE, method)` flow, so removing
-- them by the same identifier (the plugin table) is straightforward.
local function replaceStorageHandlers()
	-- nut.plugin.list keys are the plugins' uniqueIDs (their folder names).
	local toRemove = { "gridstorage", "liststorage" }
	for _, id in ipairs(toRemove) do
		local plugin = nut.plugin and nut.plugin.list and nut.plugin.list[id]
		if plugin then hook.Remove("StorageOpen", plugin) end
	end

	hook.Add("StorageOpen", "CYR_BarterStorageView", function(storage)
		if not IsValid(storage) then return end
		vgui.Create("nutListStorage"):setStorage(storage)
	end)
end
-- _IMPEL fires on InitializedPlugins (or immediately if nut is already
-- loaded), which is the same hook the gridstorage/liststorage handlers were
-- registered through. By the time this file's body has finished executing
-- inside _IMPEL, those handlers are already in the hook table, so removing
-- them here works on the first run.
replaceStorageHandlers()

-- If a storage view was already open when this file reloaded, rebuild it
-- so live-editing the file shows the new layout immediately.
if IsValid(nut.gui.storage) then
	local prev = nut.gui.storage.storage
	nut.gui.storage:Remove()
	if IsValid(prev) then
		vgui.Create("nutListStorage"):setStorage(prev)
	end
end

