local PANEL = {}

function PANEL:Init()
	self.size = NS_ICON_SIZE
	
	local parent = self:GetParent()
	
	if(IsValid(parent)) then 
		self.creationTime = parent.creationTime
	end
end

function PANEL:setIconSize(size)
	self.size = size
end

function PANEL:setItem(item)
	self.Icon:SetSize(
		self.size * (item.width or 1),
		self.size * (item.height or 1)
	)
	self.Icon:InvalidateLayout(true)
	self:setItemType(item:getID())
	self:centerIcon()
end

function PANEL:centerIcon(w, h)
	w = w or self:GetWide()
	h = h or self:GetTall()

	local iconW, iconH = self.Icon:GetSize()
	self.Icon:SetPos((w - iconW) * 0.5, (h - iconH) * 0.5)
end

function PANEL:PaintBehind(w, h)
	local alpha = 255--math.random(0, 255)

	local parent = self:GetParent()
	if(IsValid(parent) and parent.creationTime) then
		local timeSince = CurTime() - parent.creationTime
		if(timeSince < 0.4) then
			alpha = 0
		elseif(timeSince < 1) then
			alpha = math.random(1,255)
		end
	end

	surface.SetDrawColor(0, 0, 15, math.min(alpha, 150))
	surface.DrawRect(0, 0, w, h)
	surface.DrawOutlinedRect(0, 0, w, h)
end

function PANEL:PerformLayout(w, h)
	self:centerIcon(w, h)
end

vgui.Register("nutGridInvItem", PANEL, "nutItemIcon")
