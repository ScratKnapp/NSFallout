ENT.Type = "anim"
ENT.Base = "nut_activity"
ENT.PrintName = "Mail Backpack"
ENT.Author = ""
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Activities"

ENT.maxMail = 20

ENT.models = {
	"models/vex/fallout76/backpacks/backpack_postalservice.mdl",
}

if (SERVER) then
	function ENT:Initialize()
		self.mail = self.maxMail
	
		local model = self.models[math.random(#self.models)]
		self:SetModel(model)
		
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		
		local physicsObject = self:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:EnableMotion(false)
			physicsObject:Sleep()
		end
	end
	
	function ENT:Use(activator)
		if(self.mail < 1) then
			activator:notify("There is no mail to deliver right now.")
			return
		end
	
		local char = activator:getChar()
		if(char) then
			local inventory = char:getInv()
			
			local deliveryPoints = ents.FindByClass("nut_deliveryend")
			if(#deliveryPoints < 1) then
				activator:notify("There is no mail to deliver right now.")
				return false
			end
			
			local ranEnd = table.Random(deliveryPoints)
			local ranID
			if(ranEnd) then
				ranID = ranEnd:getNetVar("dID", 0)
			end
			
			local itemObj = nut.item.list["act_mail"]
			local x, y = inventory:findFreePosition(itemObj)
			if(x and y) then
				inventory:add("act_mail", 1, {dID = ranID})
				
				self.mail = self.mail - 1
				activator:notify("Mail obtained.")
				
				nut.log.addRaw(activator:Name().. " has retrieved mail for delivery.")
			else
				activator:notify("You don't have enough room in your inventory.")
			end
		end
	end
	
	function ENT:Think()
		if((self.newBox or 0) < CurTime()) then
			self.newBox = CurTime() + 3600
			
			if(self.mail < self.maxMail) then
				self.mail = self.mail + 2
			end
		end
	end
end