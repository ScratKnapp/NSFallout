AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Caps"
ENT.Category = "NutScript"
ENT.Spawnable = false

if (SERVER) then
	function ENT:Initialize()
		self:SetModel(nut.config.get("moneyModel","models/mosi/fallout4/props/junk/bottlecaptin.mdl"))
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(true)
			physObj:Wake()
		else
			local min, max = Vector(-15, -15, -15), Vector(15, 15, 15)

			self:PhysicsInitBox(min, max)
			self:SetCollisionBounds(min, max)
		end
	end

	function ENT:Use(activator)
		if (self.client and self.charID) then
			local char = activator:getChar()
			
			if (char) then
				if (self.charID != char:getID() and self.client == activator) then
					activator:notifyLocalized("logged")
					
					return false
				end
			end
		end
		
		if (hook.Run("OnPickupMoney", activator, self) != false) then
			self:EmitSound("ui_items_bottlecaps_up_01.wav", 75, math.random(95,105))
			self:Remove()
		end
	end
else
	ENT.DrawEntityInfo = true

	local toScreen = FindMetaTable("Vector").ToScreen
	local colorAlpha = ColorAlpha
	local drawText = nut.util.drawText
	local configGet = nut.config.get

	function ENT:onDrawEntityInfo(alpha)
		local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)))
		local x, y = position.x, position.y

		drawText(nut.currency.get(self.getAmount(self)), x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)
	end
end

function ENT:setAmount(amount)
	self:setNetVar("amount", amount)
end

function ENT:getAmount(amount)
	return self:getNetVar("amount", 0)
end