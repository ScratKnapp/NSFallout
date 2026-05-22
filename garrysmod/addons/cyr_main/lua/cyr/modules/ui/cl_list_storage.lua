-- Fallout-style barter UI for the simple-inventory storage transfer.
--
-- Lives in cyr_main (not the simpleinv plugin) so iterating on the UI
-- doesn't require touching the gamemode and the panel registration is
-- available client-side regardless of which gamemode plugin opens it.
-- Loaded via `includeModule("ui", "list_storage")` in lua/autorun/init.lua.
--
-- Two columns (player + storage), each with a header bar carrying the title
-- and caps count, a scrollable list of item rows (name + quantity, value on
-- the right), and a shared bottom info bar showing the hovered item's icon,
-- weight contribution, and value. Click any row to transfer the item across.
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
	surface.CreateFont("nutBarterTitle",  { font = "Roboto",  size = math.Round(26 * s), weight = 600, antialias = true })
	surface.CreateFont("nutBarterHeader", { font = "Roboto",  size = math.Round(22 * s), weight = 500, antialias = true })
	surface.CreateFont("nutBarterRow",    { font = "Roboto",  size = math.Round(20 * s), weight = 400, antialias = true })
	surface.CreateFont("nutBarterHint",   { font = "Roboto",  size = math.Round(18 * s), weight = 400, antialias = true })
	surface.CreateFont("nutBarterValue",  { font = "Roboto",  size = math.Round(20 * s), weight = 600, antialias = true })
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

-- ============================================================ ROW PANEL
-- One row inside a barter column: item name + quantity on the left, value
-- on the right. Highlights on hover, transfers on click.

local ROW = {}
	function ROW:Init()
		self:SetTall(math.Round(28 * uiScale()))
		self:SetMouseInputEnabled(true)
	end

	function ROW:setItem(item, count, themeColor, onPressed, onHovered)
		self.item        = item
		self.count       = count or 1
		self.themeColor  = themeColor
		self.onPressed   = onPressed
		self.onHovered   = onHovered
		self.displayName = (item.getName and item:getName()) or item.name or "Unknown"
		self.value       = (item.getPrice and item:getPrice()) or item.price or 0
		self.weight      = GET_ITEM_WEIGHT and GET_ITEM_WEIGHT(item)
			or (type(item.weight) == "function" and item:weight(item))
			or item.weight or 1
	end

	function ROW:Paint(w, h)
		local hover = self:IsHovered()
		local col   = self.themeColor or Color(255, 182, 66)

		if hover then
			-- highlight box: filled corners, fuller outline
			surface.SetDrawColor(col.r, col.g, col.b, 40)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(col)
			surface.DrawOutlinedRect(0, 0, w, h, 1)
		end

		surface.SetFont("nutBarterRow")
		local label = self.count > 1
			and string.format("%s (%d)", self.displayName, self.count)
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
		if self.onPressed then self.onPressed(self.item) end
	end
vgui.Register("nutBarterRow", ROW, "DPanel")

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
		self.scroll:Clear()
		-- `stacks` is a map of stackKey → array-of-items; render one row per
		-- stack. Sort alphabetically for predictable ordering.
		local sorted = {}
		for _, stack in pairs(stacks) do
			if stack[1] then sorted[#sorted + 1] = stack end
		end
		table.sort(sorted, function(a, b)
			local na = (a[1].getName and a[1]:getName()) or a[1].name or ""
			local nb = (b[1].getName and b[1]:getName()) or b[1].name or ""
			return na < nb
		end)
		local rowPad = math.Round(2 * uiScale())
		for _, stack in ipairs(sorted) do
			local row = self.scroll:Add("nutBarterRow")
			row:Dock(TOP)
			row:DockMargin(0, 0, 0, rowPad)
			row:setItem(stack[1], #stack, self.themeColor, self.onPressed, self.onHovered)
		end
	end
vgui.Register("nutBarterColumn", COL, "DPanel")

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
		self.padOuter   = math.Round(20 * s)
		self.padInner   = math.Round(14 * s)
		self.headerH    = math.Round(48 * s)
		self.footerH    = math.Round(96 * s)
		self.iconSize   = math.Round(64 * s)

		-- Two columns docked to fill the middle, side-by-side.
		self.localCol = self:Add("nutBarterColumn")
		self.localCol:configure(self.themeColor,
			function(item) self:onItemPressed(item) end,
			function(item, count) self:onItemHovered(item, count) end)

		self.storageCol = self:Add("nutBarterColumn")
		self.storageCol:configure(self.themeColor,
			function(item) self:onItemPressed(item) end,
			function(item, count) self:onItemHovered(item, count) end)
	end

	function PANEL:PerformLayout(w, h)
		local pO = self.padOuter or math.Round(20 * uiScale())
		local pI = self.padInner or math.Round(14 * uiScale())
		local headerH = self.headerH or math.Round(48 * uiScale())
		local footerH = self.footerH or math.Round(96 * uiScale())

		local contentY = pO + headerH
		local contentH = h - contentY - footerH - pO
		local colW     = math.floor((w - pO * 2 - pI) * 0.5)

		if IsValid(self.localCol) then
			self.localCol:SetPos(pO, contentY)
			self.localCol:SetSize(colW, contentH)
		end
		if IsValid(self.storageCol) then
			self.storageCol:SetPos(pO + colW + pI, contentY)
			self.storageCol:SetSize(colW, contentH)
		end
	end

	-- Painted manually instead of using child panels so the bracket frame
	-- + header rules + footer rule all share one render pass and look
	-- cohesive. Listing data (titles, caps, hovered item info) is pulled
	-- from self fields each frame.
	function PANEL:Paint(w, h)
		local col = self.themeColor

		-- Dim full-bleed backdrop (we're drawing OVER the world, FO trade
		-- screens have a heavy darkening behind them).
		surface.SetDrawColor(0, 0, 0, 215)
		surface.DrawRect(0, 0, w, h)

		-- Outer bracket frame
		drawBracketCorners(0, 0, w, h, col, math.Round(22 * uiScale()), 2)

		-- ── HEADERS (titles + caps), one per column
		local pO = self.padOuter
		local headerH = self.headerH
		local pI = self.padInner
		local colW = math.floor((w - pO * 2 - pI) * 0.5)
		local headerY = pO

		surface.SetFont("nutBarterTitle")
		local _, titleH = surface.GetTextSize("M")
		local titleY = headerY + math.floor((headerH - titleH) * 0.5)

		-- Local (player) header
		local lx = pO
		drawTitleChip(lx + colW * 0.5, titleY, "ITEMS", col, "nutBarterTitle")
		self:drawCaps(lx, headerY, colW, headerH, self.localCaps or 0, col)

		-- Storage header
		local sx = pO + colW + pI
		drawTitleChip(sx + colW * 0.5, titleY, self.storageTitle or "STORAGE", col, "nutBarterTitle")
		self:drawCaps(sx, headerY, colW, headerH, self.storageCaps or 0, col)

		-- Rule under headers
		surface.SetDrawColor(col.r, col.g, col.b, 120)
		surface.DrawLine(pO + math.Round(8 * uiScale()), headerY + headerH,
		                 w - pO - math.Round(8 * uiScale()), headerY + headerH)

		-- ── FOOTER: icon + weight/value + accept/exit hints
		local footerY = h - pO - self.footerH
		surface.SetDrawColor(col.r, col.g, col.b, 120)
		surface.DrawLine(pO + math.Round(8 * uiScale()), footerY,
		                 w - pO - math.Round(8 * uiScale()), footerY)

		if self.hoveredItem then
			-- Item icon (model spawn-icon material). Falls back gracefully
			-- if the icon material isn't loaded yet.
			local mdl = (self.hoveredItem.getModel and self.hoveredItem:getModel()) or self.hoveredItem.model
			if mdl then
				local iconMat = "spawnicons/"..string.gsub(string.gsub(mdl, "%.mdl$", ".png"), "^models/", "")
				surface.SetDrawColor(255, 255, 255)
				local tex = Material(iconMat)
				if tex and not tex:IsError() then
					surface.SetMaterial(tex)
					surface.DrawTexturedRect(
						pO + math.Round(8 * uiScale()),
						footerY + math.floor((self.footerH - self.iconSize) * 0.5),
						self.iconSize, self.iconSize)
				end
			end

			-- WG / VAL labels, centred horizontally
			surface.SetFont("nutBarterValue")
			local wgText  = string.format("WG  %.2f", self.hoveredWeight or 0)
			local valText = string.format("VAL  %d",  self.hoveredValue  or 0)
			local wgW   = surface.GetTextSize(wgText)
			local valW  = surface.GetTextSize(valText)
			local _, lh = surface.GetTextSize("M")
			local cx = pO + self.iconSize + math.Round(40 * uiScale())
			local labelY = footerY + math.floor((self.footerH - lh) * 0.5)
			surface.SetTextColor(col)
			surface.SetTextPos(cx, labelY)
			surface.DrawText(wgText)
			surface.SetTextPos(cx + wgW + math.Round(48 * uiScale()), labelY)
			surface.DrawText(valText)
		end

		-- Hints (right side of footer)
		surface.SetFont("nutBarterHint")
		local hintLines = { "Click an item to transfer.", "[X] Exit" }
		local _, hintH = surface.GetTextSize("M")
		local hintLineH = hintH + math.Round(4 * uiScale())
		surface.SetTextColor(col)
		for i, line in ipairs(hintLines) do
			local lw = surface.GetTextSize(line)
			surface.SetTextPos(w - pO - lw - math.Round(8 * uiScale()),
			                   footerY + math.Round(20 * uiScale()) + (i - 1) * hintLineH)
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

	-- Group items in an inventory by stack key (uniqueID + significant data),
	-- using the same logic the existing list-inv plugin uses for stacking.
	-- Falls back to a uniqueID-only key if the plugin helper is missing.
	function PANEL:getStacks(inventory)
		local plugin = nut.plugin and nut.plugin.list and nut.plugin.list.listinvui
		if plugin and plugin.getItemStacks then
			return plugin:getItemStacks(inventory)
		end
		local stacks = {}
		for _, item in pairs(inventory:getItems()) do
			local key = item.uniqueID
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
		self.storageCaps = 0  -- containers don't carry caps; leave at 0
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

	function PANEL:onItemPressed(item)
		if not item then return end
		if not item.getID then return end
		nutStorageBase:transferItem(item:getID())
	end

	function PANEL:onItemHovered(item, count)
		self.hoveredItem   = item
		self.hoveredCount  = count or 1
		self.hoveredValue  = (item.getPrice and item:getPrice()) or item.price or 0
		self.hoveredWeight = (GET_ITEM_WEIGHT and GET_ITEM_WEIGHT(item))
			or (type(item.weight) == "function" and item:weight(item))
			or item.weight or 1
	end

	-- Inventory event hooks — fire when items get added / removed / changed
	-- on either side; refresh the row lists.
	function PANEL:InventoryItemAdded(item)    self:populate() end
	function PANEL:InventoryItemRemoved(item)  self:populate() end
	function PANEL:InventoryItemDataChanged()  self:populate() end
	function PANEL:InventoryDataChanged()      self:populate() end

	-- Esc / X to close (NutScript expects DFrame's standard close path).
	function PANEL:OnKeyCodePressed(key)
		if key == KEY_ESCAPE or key == KEY_X then
			self:Remove()
		end
	end

	function PANEL:OnRemove()
		self:nutDeleteInventoryHooks()
		if nutStorageBase and nutStorageBase.exitStorage then
			nutStorageBase:exitStorage()
		end
	end
vgui.Register("nutListStorage", PANEL, "DFrame")

-- If a storage view was already open when this file reloaded, rebuild it
-- so live-editing the file shows the new layout immediately.
if IsValid(nut.gui.storage) then
	local prev = nut.gui.storage.storage
	nut.gui.storage:Remove()
	if IsValid(prev) then
		vgui.Create("nutListStorage"):setStorage(prev)
	end
end
