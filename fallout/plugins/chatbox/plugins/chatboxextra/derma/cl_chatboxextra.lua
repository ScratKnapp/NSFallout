local PANEL = {}
	function PANEL:Init()
		if(IsValid(nut.gui.chat2)) then 
			nut.gui.chat2:Remove()
		end
	
		local nutChat = nut.gui.chat
		
		local border = 32
		local scrW, scrH = ScrW(), ScrH()
		local w, h = nutChat:GetSize()
		local posX, posY = nutChat:GetPos()

		nut.gui.chat2 = self

		self:SetSize(w, h*0.75)
		self:SetPos(nutChat:GetPos())
		self:MoveAbove(nutChat, 8)

		self.open = true

		self.arguments = {}

		self.scroll = self:Add("DScrollPanel")
		self.scroll:SetPos(4, 31)
		self.scroll:SetSize(w - 8, h*0.75 - 66)
		self.scroll:GetVBar():SetWide(0)
		self.scroll.Paint = function(this, w, h)
			if(self.open and nutChat and nutChat.active) then
				surface.SetDrawColor(0, 0, 0, 255)
				surface.DrawRect(0, 0, w, h)
			end
		end
		
		self.toggle = self:Add("DButton")
		self.toggle:SetPos(0, 0)
		self.toggle:SetSize(64, 24)
		self.toggle:SetText("Combat")
		self.toggle.DoClick = function()
			if(self.open) then
				self.open = false
			else
				self.open = true
			end
		end
		self.toggle.Paint = function(this, w, h)
			if(nutChat and nutChat.active) then
				surface.SetDrawColor(0, 0, 0, 255)
				surface.DrawRect(0, 0, w, h)
			else
				surface.SetDrawColor(0, 0, 0, 10)
				surface.DrawRect(0, 0, w, h)
			end
		end

		self.lastY = 0

		self.list = {}
	end

	function PANEL:Paint(w, h)
	
	end

	local function OnDrawText(text, font, x, y, color, alignX, alignY, alpha)

	end

	function PANEL:addText(...)
		local text = "<font=nutChatFont>"
		local text2 = "<font=nutChatFont>"

		if (CHAT_CLASS) then
			text = "<font="..(CHAT_CLASS.font or "nutChatFont")..">"
			text2 = "<font="..(CHAT_CLASS.font or "nutChatFont")..">"
		end
		
		for k, v in ipairs({...}) do
			if (type(v) == "IMaterial") then
				local ttx = v:GetName()
				text = text.."<img="..ttx..","..v:Width().."x"..v:Height()..">"
				text2 = text2.."<img="..ttx..","..v:Width().."x"..v:Height()..">"
			elseif (IsColor(v) and v.r and v.g and v.b) then
				text = text.."<color="..v.r..","..v.g..","..v.b..">"
				text2 = text2.."<color=0,0,0>"
			elseif (type(v) == "Player") then
				local color = team.GetColor(v:Team())

				text = text.."<color="..color.r..","..color.g..","..color.b..">"..v:Name():gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("#", "\226\128\139#")
				text2 = text2.."<color=0,0,0>"..v:Name():gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("#", "\226\128\139#")
			else
				text = text..tostring(v):gsub("<", "&lt;"):gsub(">", "&gt;")
				text2 = text2..tostring(v):gsub("<", "&lt;"):gsub(">", "&gt;")
				
				text = text:gsub("%b**", function(value)
					local inner = value:sub(2, -2)

					if (inner:find("%S")) then
						return "<font=nutChatFontItalics>"..value:sub(2, -2).."</font>"
					end
				end)
				
				text2 = text2:gsub("%b**", function(value)
					local inner = value:sub(2, -2)

					if (inner:find("%S")) then
						return "<font=nutChatFontItalics>"..value:sub(2, -2).."</font>"
					end
				end)
			end
		end

		text = text.."</font>"
		text2 = text2.."</font>"

		local panel = self.scroll:Add("nutMarkupPanel")
		panel:SetWide(self:GetWide() - 8)
		panel:setMarkup(text, OnDrawText, text2)
		panel.start = CurTime() + 15
		panel.finish = panel.start + 20
		panel.Think = function(this)
			if(nut.gui.chat and nut.gui.chat.active) then
				this:SetAlpha(255)
			elseif (self.open) then
				--this:SetAlpha(255)
				this:SetAlpha((1 - math.TimeFraction(this.start, this.finish, CurTime())) * 255)
			else
				this:SetAlpha(0)
			end
		end

		self.list[#self.list + 1] = panel

		local class = CHAT_CLASS or "ic"

		if(CHAT_CLASS and CHAT_CLASS.textEdit) then --custom chat text nonsense it's neat
			CHAT_CLASS.textEdit(text, self, panel)
		else
			panel:SetPos(8, self.lastY)

			self.lastY = self.lastY + panel:GetTall()
			
			local scrollPos = self.scroll:GetVBar():GetScroll()
			local scrollHeight = self.scroll:GetTall()
			local canvasHeight = self.scroll:GetCanvas():GetTall()
			
			-- Don't scroll down if we are scrolled up.
			if(canvasHeight - scrollPos <= scrollHeight) then
				self.scroll:ScrollToChild(panel)
			end
		end

		return panel:IsVisible()
	end

	function PANEL:Think()

	end
vgui.Register("nutChatBox2", PANEL, "DPanel")
