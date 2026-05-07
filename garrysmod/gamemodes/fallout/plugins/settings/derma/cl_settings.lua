local PLUGIN = PLUGIN

local PANEL = {}
	function PANEL:Init()
		if (IsValid(nut.gui.settings)) then
			nut.gui.settings:Remove()
		end
		
		nut.gui.settings = self
		
		self.items = {}

		--MAIN PANEL, BODY PARTS
		self:SetSize(ScrW() * 0.4, ScrH() * 0.6)
		self:Center()
		--self:SetPos(ScrW() * 0.1, ScrH() * 0.2)
		self:SetTitle("")
		self:MakePopup()
		--self:ShowCloseButton(false)

		local inner = vgui.Create("DPanel", self)
		inner:Dock(FILL)
		
		self.scroll = vgui.Create("DScrollPanel", inner)
		self.scroll:Dock(FILL)
		self.scroll:SetPaintBackground(true)
		self.scroll:SetBackgroundColor(Color(100,200,100))
		self.scroll:DockMargin(5, 5, 5, 5)
		
		local vBar = self.scroll:GetVBar()
		function vBar:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
		end
		function vBar.btnUp:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
		end
		function vBar.btnDown:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
		end
		function vBar.btnGrip:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
		end
		
		self.Paint = function(panel, w, h)
			--background image
			surface.SetDrawColor(Color(40, 40, 40, 255))
			surface.DrawRect(0, 0, w, h)
		end
		
		hook.Run("SetupQuickMenu", self)
	end
	
	function PANEL:setIcon(char)
		self.icon = char
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

		if (callback) then
			button.DoClick = callback
		end

		self.items[#self.items + 1] = button

		return button
	end
	
	function PANEL:addCheck(text, callback, checked)
		local x, y
		local color

		local button = self:addButton(text, function(panel)
			panel.checked = !panel.checked

			if (callback) then
				callback(panel, panel.checked)
			end
		end)
		button.PaintOver = function(this, w, h)
			x, y = w - 8, h * 0.5

			if (this.checked) then
				color = nut.config.get("color")
			else
				color = color_dark
			end

			draw.SimpleText(self.icon or "F", "nutIconsSmall", x, y, color, 2, 1)
		end
		
		button.checked = checked

		return button
	end
vgui.Register("nutSettings", PANEL, "DFrame")