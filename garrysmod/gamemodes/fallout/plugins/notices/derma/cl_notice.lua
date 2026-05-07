local PANEL = {}
	local gradient = nut.util.getMaterial("vgui/gradient-d")
	local hudMessage = Material("fonvui/hud/hud_message_seperator_right.png")

	function PANEL:Init()
		self:SetSize(243, 128)
		self:SetContentAlignment(5)
		self:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self:SetFont("nutNoticeFont")
		self:SetTextColor(color_white)
		self:SetDrawOnTop(true)
	end

	function PANEL:Paint(w, h)
		--nut.util.drawBlur(self, 3, 2)
		
		surface.SetDrawColor(0, 43, 0, 160)
		surface.DrawRect(0, 0, w, h*0.75)

		surface.SetDrawColor(0, 238, 0, 255)
		surface.SetMaterial(hudMessage)
		surface.DrawTexturedRect(0, 0, w, h)

		local text = self.text
		
		local lines = nut.util.wrapText(text, w-100, "nutNoticeFont")

		local posX = 26
		local posY = 18

		for k, v in pairs(lines) do
			surface.SetFont("nutNoticeFont")
		
			local textX, textY = surface.GetTextSize(v)
		
			--surface.SetDrawColor(0, 43, 0, 160)
			--surface.DrawRect(posX, posY, textX+8, textY)
		
			--surface.SetTextColor(0, 238, 0, 255)
			surface.SetTextColor(0, 238, 0, 255)
			surface.SetTextPos(posX, posY) 
			surface.DrawText(v)
			
			posY = posY + textY
		end
	end
	
	function PANEL:Think()
		if(self:GetText() != "") then
			self.text = self:GetText()
			self:SetText("")
		end
	end
vgui.Register("nutNotice", PANEL, "DLabel")
