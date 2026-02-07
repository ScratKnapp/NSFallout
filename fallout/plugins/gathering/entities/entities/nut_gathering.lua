local PLUGIN = PLUGIN

ENT.Type = "anim"
ENT.PrintName = "Gathering Base"
ENT.Author = ""
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.Category = "Gathering"

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.harvestMsg = "Scavenge with [E]"

ENT.models = {
	"models/props_foliage/tree_dead01.mdl"
}

if (SERVER) then
	function ENT:SpawnFunction( ply, tr, ClassName )

		if ( !tr.Hit ) then return end

		local SpawnPos = tr.HitPos + tr.HitNormal * 10
		local SpawnAng = ply:EyeAngles()
		SpawnAng.p = 0
		SpawnAng.y = SpawnAng.y + 180

		local ent = ents.Create( ClassName )
		ent:SetCreator( ply )
		ent:SetPos( SpawnPos )
		ent:SetAngles( SpawnAng )
		ent:Spawn()
		ent:Activate()

		ent:DropToFloor()

		return ent

	end

	function ENT:Initialize()
		local model = self.models[math.random(#self.models)]
		self:SetModel(model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		
		self:SetHealth(150)
		
		if(self.spawnAdjustUp) then
			local pos = self:GetPos()
			pos = pos + Vector(0,0,self.spawnAdjustUp)
			
			self:SetPos(pos)
		end
		
		if(self.gatherAmt) then
			if(istable(self.gatherAmt)) then
				self.gathers = math.random(self.gatherAmt[1],self.gatherAmt[2])
			else
				self.gathers = self.gatherAmt
			end
		end
		
		self:SetAngles(Angle(0,math.random(0,360),0))
		
		local physicsObject = self:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			if(self.unfreezeOnSpawn) then
				physicsObject:EnableMotion(true)
				physicsObject:Wake()
			else
				physicsObject:EnableMotion(false)
				physicsObject:Sleep()
			end
		end
		
		if(self.collisionGroup) then
			self:SetCollisionGroup(self.collisionGroup)
		end
	end
	
	local function GetWeightedRandomKey(items)
		local sum = 0
		
		for _, rarity in pairs(items) do
			sum = sum + (rarity or 1)
		end
		
		local select = math.random() * sum

		for item, rarity in pairs(items) do
			select = select - (rarity or 1)
			if select < 0 then 
				return item
			end
		end
	end

	function ENT:Use(activator)
		if(self.plant) then
			if(self.growth) then
				if(self.growth < 5) then
					activator:notify("The plant is not grown enough yet.")
					
					return false
				end
			end
			
			local char = activator:getChar()
			if(char) then
				local gatherData = PLUGIN:UpdateStamina(activator)

				local stamina = gatherData.stamina
				if(stamina < 1) then
					activator:notify("You are out of stamina, and cannot scavenge any more for now.")
				
					return false
				else
					stamina = stamina - 1
					gatherData.stamina = stamina
					gatherData.lastTime = CurTime()
					
					char:setData("gather", gatherData)
				end
			end
			
			local oldPos = activator:GetPos()
			activator:Freeze(true)
			
			--this timer here protects the player in case the enemy gets removed
			timer.Simple(2.5, function()
				if(IsValid(activator)) then
					activator:Freeze(false)
				end
			end)
			
			activator:setAction("Scavenging...", 2.5, function()
				if(IsValid(self)) then
					if(self.xpGain) then
						activator:addXP(self.xpGain, true)
					end

					local char = activator:getChar()
					local inventory = char:getInv()
					
					local gather = GetWeightedRandomKey(self.resources or {})
					
					inventory:addSmart(gather, 1, self:GetPos())

					--activator:notify(nut.item.list[gather].name.. " gathered.")
					
					if(self.harvestSound) then
						self:EmitSound(self.harvestSound)
					else
						self:EmitSound("physics/metal/weapon_impact_soft" ..math.random(1,3).. ".wav", 65, 125)
					end
					
					self.gathers = (self.gathers or 1) - 1
					
					if(self.gathers < 1) then
						self:Remove()
					end
				end
			end)
		end
	end
	
	function ENT:Think()
		if(self.growth and self.growth < 5) then --for planted things
			if((self.nextGrow or 0) < CurTime()) then
				self.nextGrow = CurTime() + (self.growthTime or 600)
				
				self.growth = self.growth + 1
				
				self:SetModelScale(self.growth * 0.2)
			end
		end
	end
	
	function ENT:OnTakeDamage( dmginfo )
		if(!self.plant) then
			if(!dmginfo:IsDamageType(DMG_BURN) and !dmginfo:IsDamageType(DMG_BULLET) and !dmginfo:IsDamageType(DMG_BLAST) and dmginfo:GetDamage() > 10) then
				local gather = GetWeightedRandomKey(self.resources)
			
				nut.item.spawn(gather, dmginfo:GetDamagePosition())
				
				if (nut.config.get("gDamage")) then
					self:SetHealth(self:Health() - nut.config.get("lifeDrain"))
					if(self:Health() < 0) then
						self:Remove()
					end
				end
			elseif(dmginfo:IsDamageType(DMG_BLAST)) then --if they blow it up, destroy it entirely.
				local gather = GetWeightedRandomKey(self.resources)
				
				for i = 1, math.random(4,6) do
					nut.item.spawn(gather, self:GetPos() + self:GetUp() * 40)
				end
					
				self:Remove()
			end
		end
	end
	
	function ENT:getSaveData()
		local saveData = {}
		saveData.nutPlanted = self:getNetVar("nutPlanted")
	
		return saveData
	end
	
	function ENT:onLoaded()
		self.growth = 0
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
