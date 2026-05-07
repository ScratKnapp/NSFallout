local PANEL = {}
	--local background = Material("newlight/cpui_sample_mainpanel.png")
	--local detail = Material("newlight/cpui_sample_detail1.png")
	--local logo = Material("newlight/cpui_sample_logo_arint.png")
	--local banner = Material("newlight/cpui_sample_menubanner.png")
	--local glow = Material("newlight/cpui_sample_text_layerglow.png")
	
	local blurMat = nut.util.getMaterial("pp/blurscreen")
	
	local alpha = 80
	
	-- this scuff is to make sure it scales by resolution
	local scalingX = ScrW() / 2560
	local scalingY = ScrH() / 1440

	function PANEL:Init()
		if (IsValid(nut.gui.menuBox)) then
			nut.gui.menuBox:Remove()
		end

		nut.gui.menuBox = self

		local blur = vgui.Create("DPanel")
		blur:SetSize(ScrW(),ScrH())
		blur.Paint = function(this, w, h)
			surface.SetMaterial(blurMat)
			surface.SetDrawColor(255, 255, 255)

			local x, y = this:LocalToScreen(0, 0)

			for i = -(passes or 0.2), 1, 0.2 do
				-- Do things to the blur material to make it blurry.
				blurMat:SetFloat("$blur", i * 5)
				blurMat:Recompute()

				-- Draw the blur material over the screen.
				render.UpdateScreenEffectTexture()
				surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
			end
		end
		
		self.blur = blur

		self:SetSize(518*scalingX, 569*scalingY)
		self:SetPos(ScrW()*0.1, ScrH()*0.3)
		self:SetTitle("")
		self:MakePopup()
		self:ShowCloseButton(false)
		self:SetPaintShadow(false)
		self:SetBackgroundBlur(false)
		self:SetPaintBorderEnabled(false)
		
		self:SetAlpha(0)

		self.creationTime = CurTime()
		
		local function paintTab(tab, w, h)
			local text = tab.name
			local alpha = 255--math.random(0, 255)
		
			local timeSince = CurTime() - tab.creationTime
			if(timeSince < 0.4) then
				alpha = 0
			elseif(timeSince < 1) then
				alpha = math.random(1,255)
			end

			local x = 16 * scalingX
			local y = 11 * scalingY
			
			local textColor = Color(0, 238, 0, alpha)
			
			if(tab:IsHovered()) then
				textColor = Color(0, 255, 0, 255)
			end
			
			draw.DrawText(text, "nutMenuButtonLightFont", x, y, textColor)
		end

		surface.SetFont("nutMenuButtonLightFont")
		local w, h = surface.GetTextSize("FALLOUT")

		local header = self:Add("DLabel")
		header.creationTime = CurTime()
		header.name = "FALLOUT"
		header:SetSize(self:GetWide(), 0)
		header:SetText("")
		header:SetPos(64 * scalingX, 24 * scalingY)
		header:SetTextColor(Color(250, 250, 250))
		header:SetFont("nutMenuButtonLightFont")
		header:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		header:SizeToContentsX()
		header:SetWide(w + 32)
		header:SetTall(h + 16)
		header.Paint = paintTab
		
		self:AlphaTo(255, 0.25, 0, function()
			self:createButtons()
		end)
	end

	function PANEL:OnKeyCodePressed(key)
		self.noAnchor = CurTime() + .5

		if (key == KEY_TAB or key == KEY_F1) then
			self:remove()
		end
	end

	function PANEL:Think()
		local key = input.IsKeyDown(KEY_F1) or input.IsKeyDown(KEY_TAB)
		if (key and (self.noAnchor or CurTime()+.4) < CurTime() and self.anchorMode == true) then
			self.anchorMode = false
			--surface.PlaySound(SOUND_F1_MENU_UNANCHOR)
		end
	end

	function PANEL:Paint(w, h)
		surface.SetDrawColor(0, 0, 0, 50)
		surface.DrawRect(0, 0, w, h)
		
		surface.SetDrawColor(255, 255, 255, 255)
		
		--panel art
		--[[
		surface.SetMaterial(background)
		surface.DrawTexturedRect(0, 0, w, h)
		--]]
		
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, 0, w, h)

		--detail
		--[[
		surface.SetMaterial(detail)
		surface.DrawTexturedRect(0, 0, w, h)
		--]]
		
		--logo
		--[[
		surface.SetMaterial(logo)
		surface.DrawTexturedRect(0, 0, w, h)
		--]]
		
		--banner
		--[[
		surface.SetMaterial(banner)
		surface.DrawTexturedRect(0, 0, w, h)
		--]]
		
		--glow
		local timeSince = CurTime() - self.creationTime
		if(timeSince < 0.4) then
			alpha = 0
		elseif(timeSince < 1) then
			alpha = math.random(1,255)
		else
			alpha = 255
		end
		
		surface.SetDrawColor(0, 47, 0, alpha)
		--surface.SetMaterial(glow)
		surface.DrawRect(0, 0, w, h)
		
		surface.SetDrawColor(0, 238, 0, 255)
		surface.DrawOutlinedRect(0, 0, w, h, 2)
	end

	local buttons = {
		["CHARACTERS"] = function(panel, button)
			if (IsValid(panel)) then
				panel:Remove()
			end
			
			vgui.Create("nutCharacter")
		end,
		["INVENTORY"] = function(panel, button)
			if (IsValid(panel)) then
				panel:Remove()
			end
		
			local nutMenu = vgui.Create("nutMenu")
			nutMenu:setActiveTab("Equipment")
		end,
		--[[
		["CYBERNET"] = function(panel, button)
			print("CYBERNET", panel)
		end,
		--]]
		["SETTINGS"] = function(panel, button)
			if (IsValid(panel)) then
				panel:Remove()
			end
			
			vgui.Create("nutSettings")
		end,
	}

	function PANEL:createButtons()
		local function paintTab(tab, w, h)
			local text = tab.name
			local alpha = 255--math.random(0, 255)
		
			local timeSince = CurTime() - tab.creationTime
			if(timeSince < 0.4) then
				alpha = 0
			elseif(timeSince < 1) then
				alpha = math.random(1,255)
			end

			local x = 16 * scalingX
			local y = 11 * scalingY
			
			local textColor = Color(0, 238, 0, alpha)
			
			if(tab:IsHovered()) then
				textColor = Color(0, 255, 0, 255)
			end
			
			draw.DrawText(text, "nutMenuButtonLightFont", x, y, textColor)
		end

		for categoryName, categoryFunc in pairs(buttons) do
			surface.SetFont("nutMenuButtonLightFont")
			local w, h = surface.GetTextSize(categoryName)

			local tab = self:Add("DButton")
			if(!self.nextPosY) then
				self.nextPosY = 146 * scalingY
			else
				self.nextPosY = self.nextPosY + h + 20
			end
		
			tab.creationTime = CurTime()
			tab.name = categoryName
			tab:SetSize(self:GetWide(), 0)
			tab:SetText("")
			tab:SetPos(64 * scalingX, self.nextPosY)
			tab:SetTextColor(Color(250, 250, 250))
			tab:SetFont("nutMenuButtonLightFont")
			tab:SetExpensiveShadow(1, Color(0, 0, 0, 150))
			tab:SizeToContentsX()
			tab:SetWide(w + 32)
			tab:SetTall(h + 16)
			tab.Paint = paintTab
			tab.DoClick = function(this)
				categoryFunc(self, this)
			end
		end
	end

	function PANEL:setActiveTab(key)
		--[[
		if (IsValid(self.tabList[key])) then
			self.tabList[key]:DoClick()
		end
		--]]
	end

	function PANEL:OnRemove()
		if(IsValid(self.blur)) then
			self.blur:Remove()
		end
	end

	function PANEL:remove()
		--[[
		CloseDermaMenus()
		--]]

		if (!self.closing) then
			self:AlphaTo(0, 0.25, 0, function()
				self:Remove()
			end)
			self.closing = true
		end
	end
vgui.Register("nutMenuBox", PANEL, "DFrame")

if (IsValid(nut.gui.menuBox)) then
	vgui.Create("nutMenuBox")
end