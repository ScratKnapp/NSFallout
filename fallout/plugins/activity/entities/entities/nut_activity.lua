ENT.Type = "anim"
ENT.PrintName = "Activity Base"
ENT.Author = ""
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.Category = "Activity"

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.models = {
	"models/props_foliage/tree_dead01.mdl"
}

if (SERVER) then
	function ENT:Initialize()
		local model = self.models[math.random(#self.ranModels)]
		self:SetModel(model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		
		self:SetHealth(nut.config.get("treeLife"))
		
		local pos = self:GetPos()
		
		self:SetPos(Vector(pos.X,pos.Y,pos.Z - 10))
		self:SetAngles(Angle(0,math.random(0,360),0))
		
		local physicsObject = self:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:EnableMotion(false)
			physicsObject:Sleep()
		end
	end
	
	function ENT:getSaveData()
		
	end
	
	function ENT:applyBuff(activator, buffTbl, buffName, buffString, buffDuration)
		local client = activator
	
		local char = client:getChar()
		local charID = client:getChar():getID()
		
		for k, v in pairs(buffTbl) do
			char:addBoost(buffName, k, v)
		end
		
		local timerName = buffName..client:EntIndex()
		local duration = buffDuration or 7200
		if(timer.Exists(timerName)) then 
			timer.Adjust(timerName, duration, 5, function()

				if (client and IsValid(client)) then
					local curChar = client:getChar()
					if (curChar and curChar:getID() == charID) then
						client:notify(buffString.. " has worn off.")

						if (buffs) then
							for k, v in pairs(buffs) do
								char:removeBoost(buffName, k)
							end
						end
					end
				end
			end)
		else				
			timer.Create(timerName, duration, 1, function()
				if (client and IsValid(client)) then
					local curChar = client:getChar()
					if (curChar and curChar:getID() == charID) then
						client:notify(buffString.. " has worn off.")

						if (buffs) then
							for k, v in pairs(buffs) do
								char:removeBoost(buffName, k)
							end
						end
					end
				end
			end)
		end
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
		local tx, ty = drawText(self.Name or self.PrintName, x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 2)
		--drawText(self.harvestMsg, ScrW() * 0.5, ScrH() * 0.8, colorAlpha(color_white, alpha), 1, 1, "nutEntDesc", alpha * 0.65)
	end
end
