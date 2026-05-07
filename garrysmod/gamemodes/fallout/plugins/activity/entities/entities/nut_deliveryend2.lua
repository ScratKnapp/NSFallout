ENT.Type = "anim"
ENT.Base = "nut_activity"
ENT.PrintName = "Mail Recipient"
ENT.Author = ""
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Activities"
ENT.AutomaticFrameAdvance = true

ENT.models = {
	"models/maxib123/mailbox1.mdl",
	"models/maxib123/mailbox2.mdl",
	"models/props_fallout/mailcivbox.mdl",
	"models/props_fallout/mailbox.mdl",
	
}

if (SERVER) then
	function ENT:Initialize()
		local model = self.models[math.random(#self.models)]

		self:SetModel(model)
		self:SetUseType(SIMPLE_USE)
		self:SetMoveType(MOVETYPE_NONE)
		self:DrawShadow(true)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_BBOX)
		
		if(SERVER) then
			self:DropToFloor()
		end
		
		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:EnableGravity(false)
			--physObj:Sleep()
			physObj:EnableCollisions(false)
		end
		
		self:SetCollisionBounds(Vector(-10,-10,0), Vector(10,10,80))
		--self:SetCollisionGroup(COLLISION_GROUP_WORLD)		
		
		for k, v in ipairs(self:GetSequenceList()) do
			if (v:lower():find("idle") and v != "idlenoise") then
				return self:ResetSequence(k)
			end
		end
	end
	
	function ENT:Think()
		if(!self:IsPlayerHolding()) then
			local physObj = self:GetPhysicsObject()
			
			if(IsValid(physObj) and !physObj:IsAsleep()) then
				physObj:Sleep()
			end
		end
	end	
	
	function ENT:Use(activator)
		local char = activator:getChar()
		if(char) then
			local inventory = char:getInv()
			
			local delivery
			for k, v in pairs(inventory:getItems()) do
				if(v.uniqueID == "act_mail") then
					if(v:getData("dID", 0) == self:getNetVar("dID", self.Name)) then
						delivery = v
						break
					end
				end
			end
			
			if(delivery) then
				local pay = math.random(1,3)
				char:giveMoney(pay)
				delivery:remove()
				activator:notify("Mail delivered, you earned " ..nut.currency.get(pay).. ".")
			else
				--activator:notify("You don't have any mail to deliver to this person.")
			end
		end
	end
	
	function ENT:getSaveData()
		local saveData = {}
		saveData.dID = self:getNetVar("dID")
	
		return saveData
	end
else
	function ENT:Draw()
		self:DrawModel()
	end

	ENT.DrawEntityInfo = true
	local toScreen = FindMetaTable("Vector").ToScreen
	local colorAlpha = ColorAlpha
	local drawText = nut.util.drawText
	local configGet = nut.config.get

	function ENT:onDrawEntityInfo(alpha)
		local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)))
		local x, y = position.x, position.y
		local tx, ty = drawText(self:getNetVar("dID", self.Name), x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 2)
	end
end
