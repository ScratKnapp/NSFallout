ENT.Type = "anim"
ENT.Base = "nut_factory_base"
ENT.PrintName = "Machine - Cybernetic Repository"
ENT.Author = ""
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Nutscript - Factories"
ENT.AutomaticFrameAdvance = true

ENT.model = "models/props_borealis/bluebarrel001.mdl"
ENT.material = "phoenix_storms/OfficeWindow_1-1"

ENT.itemRate = 30 --item every 15 seconds

ENT.displayName = "Cybernetic Repository"

function ENT:Initialize()
	if(SERVER) then
		local model
		if(self.models) then
			model = self.models[math.random(#self.models)]
		else
			model = self.model
		end

		self:SetModel(model)
		
		if(self.material) then
			self:SetMaterial(self.material)
		end
		
		self:SetUseType(SIMPLE_USE)
		--self:SetMoveType(MOVETYPE_NONE)
		self:DrawShadow(true)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_BBOX)
		
		local physObj = self:GetPhysicsObject()
		
		if (IsValid(physObj)) then
			physObj:EnableMotion(true)
			physObj:EnableGravity(true)
			--physObj:Sleep()
			physObj:EnableCollisions(true)
		end
		
		self.spawnedItems = {}
	end
end

if(SERVER) then
	function ENT:Think()
		--only if the machine is on
		if(self:getNetVar("activated")) then
			if(self:getNetVar("nextItem", 0) < CurTime()) then
				self:setNetVar("nextItem", CurTime() + self.itemRate)
			
				--keeps track of spawned items
				local count = 0
				for k, v in pairs(self.spawnedItems) do
					if(IsValid(v)) then --if it's valid, count it
						count = count + 1
					else -- remove invalid ents from the list
						self.spawnedItems[k] = nil
					end
				end
				
				if(count >= 5) then
					self:setNetVar("activated", false)
					self:EmitSound("ambient/levels/labs/machine_stop1.wav", 75, 150)
					return false
				end
				
				local spawnPos = self:GetPos()+self:GetUp()*32
				
				--spawn an item here
				nut.item.spawn("salvaged_cybernetics", spawnPos, function(item)
					self:EmitSound("ambient/machines/catapult_throw.wav", 75, 50)
					
					self.spawnedItems[item:getID()] = item:getEntity()
				end)
			end
		end
	end

	function ENT:Use(client)
		if(!self:getNetVar("activated")) then --if it's off
			self:setNetVar("activated", true) -- turn on
			self:EmitSound("ambient/machines/machine3.wav", 75, 150)

			client:notify("Machine has been activated.")
		else --if its on
			self:setNetVar("activated", false) --turn off
			self:EmitSound("ambient/levels/labs/machine_stop1.wav", 75, 150)
			
			client:notify("Machine has been deactivated.")
		end
	end
else --client
	ENT.DrawEntityInfo = true
	local toScreen = FindMetaTable("Vector").ToScreen
	local colorAlpha = ColorAlpha
	local drawText = nut.util.drawText
	local configGet = nut.config.get
	local ScrW = ScrW()
	
	function ENT:onDrawEntityInfo(alpha)
		local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)))
		local x, y = position.x, position.y
	
		local status = "OFF"
	
		local activated = self:getNetVar("activated")
		if(activated) then
			status = "ON"

			local progress = ((CurTime() - self:getNetVar("nextItem", -1)) / self.itemRate)+1
			progress = math.min(progress, 1)

			local emptyBarW = ScrW*0.1

			local message = "Producing..."
			if(progress == 1) then
				message = "[ Complete ]"
			end

			nut.bar.draw(x - emptyBarW*0.5, y, emptyBarW, 14, 50, Color(0,0,0))
			nut.bar.draw(x - emptyBarW*0.5, y, emptyBarW, 14, progress, Color(50,225,225))
		end
		
		local tx, ty = drawText(self.displayName, x, y-28, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 2)
		local tx, ty = drawText("The machine is " ..status.. ".", x, y-12, Color(255,255,255), 1, 1, nil, alpha * 2)
	end
end