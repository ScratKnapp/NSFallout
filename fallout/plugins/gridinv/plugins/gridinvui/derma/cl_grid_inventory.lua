local PLUGIN = PLUGIN

local PANEL = {}

--[[
local PADDING = 2
local BORDER = 32
local WEIGHT_PANEL_HEIGHT = 32
local HEADER_FIX = 100
local BORDER_FIX_H = 9 + PADDING
--]]

local PADDING = 2
local BORDER = 15
local WEIGHT_PANEL_HEIGHT = 32
local HEADER_FIX = 47
local BORDER_FIX_H = 9 + PADDING

local SHADOW_COLOR = Color(0, 0, 0, 100)

local inventoryBackground = Material("fonvui/inventory.png")
local inventoryHeader = Material("fonvui/inventoryheader.png")

function PANEL:Init()
	self:MakePopup()

	self:SetPaintShadow(false)
	self:SetBackgroundBlur(false)
	self:SetPaintBorderEnabled(false)
	self:ShowCloseButton(false)
	
	self:SetTitle("")
	self:DockPadding(BORDER,HEADER_FIX,BORDER,BORDER)
	
	self.creationTime = CurTime()
	
	self.content = self:Add("nutGridInventoryPanel")
	self.content:Dock(FILL)
	self.content:setGridSize(1, 1)
end

function PANEL:Paint(w,h)
	local alpha = 255--math.random(0, 255)

	local timeSince = CurTime() - self.creationTime
	if(timeSince < 0.4) then
		alpha = 0
	elseif(timeSince < 1) then
		alpha = math.random(1,255)
	end

	surface.SetDrawColor(50, 50, 50, math.min(alpha, 100))
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(255, 255, 255, alpha)
	surface.SetMaterial(inventoryBackground)
	surface.DrawTexturedRect(0, 0, w, h)
	
	surface.SetDrawColor(255, 255, 255, alpha)
	surface.SetMaterial(inventoryHeader)
	surface.DrawTexturedRect(0, 0, 195, 38)
end

function PANEL:setInventory(inventory)
	self.gridW, self.gridH = inventory:getSize()
	
	local sizeX = self.gridW*(NS_ICON_SIZE + PADDING) + BORDER*2
	local sizeY = self.gridH*(NS_ICON_SIZE + PADDING) + HEADER_FIX + BORDER
	local scaleMultX = (sizeX/886)
	local scaleMultY = (sizeY/524)
	
	local HEADER2 = (HEADER_FIX + BORDER) * scaleMultY
	local BORDERX = BORDER * scaleMultX
	local BORDERY = BORDER * scaleMultY
	self:DockPadding(BORDERX,HEADER2,BORDERX,BORDERY)
	
	self:SetSize(
		self.gridW * (NS_ICON_SIZE + PADDING) + BORDERX*2,
		self.gridH * (NS_ICON_SIZE + PADDING) + HEADER2 + BORDERY
	)
	self:InvalidateLayout(true)

	self.content:setGridSize(self.gridW, self.gridH)
	self.content:setInventory(inventory)
	self.content.InventoryDeleted = function(content, deletedInventory)
		if (deletedInventory == inventory) then
			self:InventoryDeleted()
		end
	end
end

function PANEL:InventoryDeleted()
	self:Remove()
end

function PANEL:Center()
	local parent = self:GetParent()
	local centerX, centerY = ScrW() * 0.5, ScrH() * 0.5
	
	self:SetPos(
		centerX - (self:GetWide() * 0.5),
		centerY - (self:GetTall() * 0.5)
	)
end

vgui.Register("nutGridInventory", PANEL, "nutInventory")
