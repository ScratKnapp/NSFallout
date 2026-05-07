local PANEL = {}
	-- this scuff is to make sure it scales by resolution
	local scalingX = ScrW() / 2560
	local scalingY = ScrH() / 1440
	
	local GUIScale = 0.9 --flat multiplier since the image is a little large

	function PANEL:Init()
		--692, 827
		self:SetSize(922*scalingX*GUIScale, 1102*scalingY*GUIScale)
		self:SetTitle("")
		self:MakePopup()
		self:Center()
		self:ShowCloseButton(false)
		self:SetPaintShadow(false)
		self:SetBackgroundBlur(false)
		self:SetPaintBorderEnabled(false)

		self.DoRightClick = function(this)
		end

		self.creationTime = CurTime()
	end

	--[[
	function PANEL:OnKeyCodePressed(key)
		self.noAnchor = CurTime() + .5

		if (key == KEY_TAB or key == KEY_F1) then
			self:remove()
		end
	end
	--]]

	--[[
	function PANEL:Think()
		local key = input.IsKeyDown(KEY_F1) or input.IsKeyDown(KEY_TAB)
		if (key and (self.noAnchor or CurTime()+.4) < CurTime() and self.anchorMode == true) then
			self.anchorMode = false
			--surface.PlaySound(SOUND_F1_MENU_UNANCHOR)
		end
	end
	--]]

	function PANEL:Paint(w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		
		--panel art
		if(self.bodyImage) then
			surface.SetMaterial(self.bodyImage)
			surface.DrawTexturedRect(0, 0, w, h)

			surface.SetDrawColor(47, 152, 86, 50)
			surface.DrawOutlinedRect(8, 0, w-16, h-8, 4)
			
			surface.SetDrawColor(47, 152, 86, 120)
			surface.DrawOutlinedRect(8, 0, w-16, h-8, 2)
		end
		
		--glow
		--[[
		local timeSince = CurTime() - self.creationTime
		if(timeSince < 0.4) then
			alpha = 0
		elseif(timeSince < 1) then
			alpha = math.random(1,255)
		else
			alpha = 255
		end
		
		surface.SetDrawColor(255, 255, 255, alpha)
		surface.SetMaterial(glow)
		surface.DrawTexturedRect(0, 0, w, h)
		--]]
	end

	function PANEL:createButtons(name, material, slots, equipOverride)
		local client = LocalPlayer()
		
		self.name = name
		self.bodyImage = material
		self.slots = slots

		if(self.buttons) then
			for k, v in pairs(self.buttons) do
				if(IsValid(v)) then
					v:Remove()
				end
			end
		end

		self.buttons = {}
		
		for slot, itemID in pairs(equipOverride or client:getEquip()) do
			local slotData = slots[slot]
		
			if(slotData) then
				local item = nut.item.instances[itemID]

				local exIcon
				if(item) then
					exIcon = ikon:getIcon(item.id)
			
					if(!exIcon) then
						exIcon = ikon:getIcon(item.uniqueID)
					end
				end
				
				local tab = self:Add("DButton")
				tab.creationTime = CurTime()
				tab.name = categoryName
				tab:SetText("")
				tab:SetPos(slotData.x * scalingX * GUIScale, slotData.y * scalingY * GUIScale)
				tab:SetTextColor(Color(250, 250, 250))
				tab:SetFont("nutMenuButtonLightFont")
				tab:SetExpensiveShadow(1, Color(0, 0, 0, 150))
				--tab:SizeToContentsX()
				tab:SetWide(64 * scalingX * GUIScale)
				tab:SetTall(64 * scalingY * GUIScale)
				tab.Paint = function(this, w, h)
					if(exIcon) then
						surface.SetMaterial(exIcon)
						
						surface.SetDrawColor(255, 255, 255, 255)
						surface.DrawTexturedRect(0, 0, w, h)
					else
						surface.SetDrawColor(0, 0, 255, 255)
						surface.DrawRect(0, 0, w, h)
					end
				end
				
				tab.DoClick = function(this)

				end
				
				tab.DoRightClick = function(this)
					netstream.Start("nut_unequip_slot", slot, itemID)
					
					this:Remove()
				end
				
				if(item) then
					local customData = item:getData("custom", {})

					local color = customData.color or item.color or nut.config.get("color", Color(255,255,255))
					
					tab.nutToolTip = true
					
					tab:SetTooltip(
						"Item ID: #" ..item.id.. "\n\n" ..
						"<font=nutItemBoldFont>".."<color="..color.r..","..color.g..","..color.b..">"..(item:getName() or "").."</color>".."</font>\n"..
						"<font=nutItemDescFont>"..(item:getDesc() or "")
					)
				end
				
				--[[
				tab.OnCursorEntered = function(this)
					if(tab.itemDesc) then
						tab.itemDesc:Remove()
					end
				
					local parent = tab:GetParent()

					tab.itemDesc = parent:Add("DTextEntry")
					tab.itemDesc:SetSize(320, 100)
					tab.itemDesc:SetText("")
					
					local itemDescPosX = tab:GetX() + tab:GetWide()
					
					if(itemDescPosX > self:GetWide()*0.55) then
						itemDescPosX = tab:GetX() - tab.itemDesc:GetWide()
					end

					tab.itemDesc:SetPos(itemDescPosX, tab:GetY())
					
					function tab.itemDesc:Paint(w, h)
						if(!IsValid(tab)) then return end
					
						--inner box of tooltip
						surface.SetDrawColor(0, 0, 0, 255)
						surface.DrawRect(0, 0, w, h)
					
						--outline of skill desc
						surface.SetDrawColor(255, 255, 255, 255)
						surface.DrawOutlinedRect(0, 0, w, h, 1)
						
						if(item) then
							if(item.name) then
								local itemName = item.name
							
								draw.DrawText(itemName, "DermaDefault", w/2, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
							end
							
							if(item.desc) then
								local descLines = nut.util.wrapText(item.desc, 250, "DermaDefault")
							
								for lineIt, line in pairs(descLines) do
									draw.DrawText(line, "DermaDefault", 5, 4 + 12 * lineIt, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
								end
							end
						end
					end
					
					tab.itemDesc:MoveToFront()
				end
				
				tab.OnCursorExited = function(this)
					if(IsValid(tab.itemDesc)) then
						tab.itemDesc:Remove()
					end
				end
				--]]
				
				self.buttons[#self.buttons+1] = tab
			end
		end
	end
	
	function PANEL:refreshButtons()
		self:createButtons(self.name, self.bodyImage, self.slots, self.equipOverride)
	end

	function PANEL:setActiveTab(key)
	end

	function PANEL:OnRemove()
		if(self.buttons) then
			for k, v in pairs(self.buttons) do
				if(IsValid(v)) then
					v:Remove()
				end
			end
		end
	end

	function PANEL:remove()
		if (!self.closing) then
			self:AlphaTo(0, 0.25, 0, function()
				self:Remove()
			end)
			self.closing = true
		end
	end
vgui.Register("nutSlots", PANEL, "DFrame")