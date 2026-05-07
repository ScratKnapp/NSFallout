local PLUGIN = PLUGIN

PLUGIN.name = "Activities"
PLUGIN.author = "Chancer"
PLUGIN.desc = "Adds some activities that people can do."

PLUGIN.actPoints = PLUGIN.actPoints or {}

local gatherItems = {
	["nut_deliveryend"] = true,
	["nut_deliverystart"] = true,
	["nut_bath"] = true,
	["nut_bed"] = true,
	["nut_bed_2"] = true,
	["nut_bed_3"] = true,
	["nut_bed_4"] = true,
	["nut_shrine"] = true,
	["nut_warrior1"] = true,
	["nut_warrior2"] = true,
	["nut_warrior3"] = true,
	["nut_hunting"] = true,
}

if SERVER then
	function PLUGIN:SaveData()
		self.actPoints = {}
	
		for k, v in pairs(ents.GetAll()) do
			if(!IsValid(v)) then continue end
			
			if(gatherItems[v:GetClass()]) then
				table.insert(self.actPoints, {v:GetPos(), v:GetAngles(), v:GetClass(), (v.getSaveData and v:getSaveData())})
			elseif(v:getNetVar("nutPlanted")) then
				table.insert(self.actPoints, {v:GetPos(), v:GetAngles(), v:GetClass(), (v.getSaveData and v:getSaveData())})
			end
		end
		
		self:setData(self.actPoints)
	end
	
	function PLUGIN:PlayerSpawnSENT(client, entity)
		if(gatherItems[entity]) then
			self:SaveData()
		end
	end

	function PLUGIN:LoadData()
		self.actPoints = self:getData()
		self:Initialize()
	end

	function PLUGIN:Initialize()
		for k, v in pairs(self.actPoints) do
			self:setGathering(v)
		end
	end

	function PLUGIN:setGathering(point)
		local entity = ents.Create(point[3])
		if(IsValid(entity)) then
			entity:SetPos(point[1])
			entity:SetAngles(point[2])
			
			for k, v in pairs(point[4] or {}) do
				entity:setNetVar(k, v)
			end
			
			if(entity.onLoaded) then
				entity:onLoaded()
			end
			
			entity:Spawn()
		else
			table.RemoveByValue(self.actPoints, point)
		end
	end
end

netstream.Hook("nut_displayGatherSpawnPoints", function(data)
	for k, v in pairs(data) do
		local emitter = ParticleEmitter(v[1])
		local smoke = emitter:Add("sprites/glow04_noz", v[1])
		smoke:SetVelocity(Vector(0, 0, 1))
		smoke:SetDieTime(15)
		smoke:SetStartAlpha(255)
		smoke:SetEndAlpha(255)
		smoke:SetStartSize(64)
		smoke:SetEndSize(64)
		smoke:SetColor(255,0,0)
		smoke:SetAirResistance(300)
	end
end)

if(CLIENT) then
	surface.CreateFont("nutEntDesc", {
		font = "Segoe UI",
		size = math.max(ScreenScale(7), 17),
		weight = 200
	})
end