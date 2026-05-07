local PLUGIN = PLUGIN
PLUGIN.name = "Gathering"
PLUGIN.author = "La Corporativa"
PLUGIN.desc = "Adds resources and ways to get them."

PLUGIN.spawnedGathers = PLUGIN.spawnedGathers or {}
PLUGIN.gatherPoints = PLUGIN.gatherPoints or {}

nut.config.add("gathering", true, "Whether gathering is active or not.", nil, {
	category = "Gathering"
})

nut.config.add("gDamage", true, "Whether the trees and rocks will deplete from gathering resources from them", nil, {
	category = "Gathering"
})

nut.config.add("gatheringSpawn", 3600, "How much time it will take for a gathering entity to spawn.", nil, {
	data = {min = 1, max = 84600},
	category = "Gathering"
})

nut.config.add("gMaxWorldGather", 100, "Number of gathering entitites the World will have.", nil, {
	data = {min = 1, max = 500},
	category = "Gathering"
})

nut.config.add("lifeDrain", 10, "How much life will be drain from the entities that are being gathered.", nil, {
	category = "Gathering",
	data = {min=1, max=200}
})

nut.config.add("gatherStaminaTime", 1440, "How many seconds to generate 1 stamina.", nil, {
	category = "Gathering",
	data = {min=1, max=2000}
})

nut.config.add("gatherStaminaMax", 10, "The Maximum amount of stamina.", nil, {
	category = "Gathering",
	data = {min=1, max=2000}
})

local gatherItems = {
	["car"] = true,
	["crate"] = true,
	["desk"] = true,
	["dumpster"] = true,
	["filing_cabinet"] = true,
	["locker"] = true,
	
	["plant_bananayucca"] = true,
	["plant_coyotechew"] = true,
	["plant_gourd"] = true,
	["plant_maize"] = true,
	["plant_pintobeans"] = true,
	
	["tree_birch"] = true,
	["vein_iron"] = true,
}

function PLUGIN:UpdateStamina(client, char, add)
	local gatherStaminaMax = nut.config.get("gatherStaminaMax", 10)

	local char = char or client:getChar()
	if(!char) then return {} end

	local gatherData = char:getData("gatherStamina", {})
	
	local last = gatherData.last or 0 --helps check if the server has restarted/crashed
	local stamina = gatherData.stamina or gatherStaminaMax
	
	local day = os.date("%d")
	
	--if it's a new day just give them a refresher
	--technically a bonus for playing at midnight but oh well
	if(last != day) then
		stamina = gatherStaminaMax
	end
	
	local new = math.Clamp(stamina + add, 0, gatherStaminaMax)
	
	gatherData.stamina = new
	gatherData.last = day

	if(stamina != new) then
		char:setData("gatherStamina", gatherData)
	end

	return gatherData
end

if SERVER then
	function PLUGIN:SaveData()
		self:setData(self.gatherPoints)
	end

	function PLUGIN:LoadData()
		pcall(function()
			self.gatherPoints = self:getData()
			self:Initialize()
		end)
	end

	function PLUGIN:Initialize()
		if nut.config.get("gathering") then
			for k, v in pairs(self.gatherPoints) do
				self:setGathering(v)
			end
		end
	end

	local gatherSpawnTime = CurTime()
	function PLUGIN:Think()
	
		local gatherStaminaTime = nut.config.get("gatherStaminaTime", 1440)
		if((self.nextGatherStamina or 0) < CurTime()) then
			self.nextGatherStamina = CurTime() + gatherStaminaTime
		
			local gatherStaminaMax = nut.config.get("gatherStaminaMax", 10)
			for k, client in ipairs(player.GetAll()) do
				local char = client:getChar()
				if(!char) then continue end
			
				PLUGIN:UpdateStamina(client, char, 1)
			end
		end
	
		if nut.config.get("gathering") then
			if((self.nextStamina or 0) < CurTime()) then
				self.nextStamina = CurTime() + 300
				
				for k, client in pairs(player.GetAll()) do
					local char = client:getChar()
					if(char and (char.stamina or 20) < 20) then
						char.stamina = char.stamina + 1
					end
				end
			end

			self:removeInvalidGathers()
			if (#self.spawnedGathers <= nut.config.get("gMaxWorldGather")) then
				if (gatherSpawnTime <= CurTime()) then
					local point = table.Random(self.gatherPoints)
					
					if (!point) then return end

					for _, v in pairs(self.spawnedGathers) do
						if point == v[2] then 
							gatherSpawnTime = gatherSpawnTime + nut.config.get("gatheringSpawn")
							return 
						end
					end

					if #self.spawnedGathers >= nut.config.get("gMaxWorldGather") then return end
					
					self:setGathering(point)
					
					gatherSpawnTime = gatherSpawnTime + nut.config.get("gatheringSpawn")
				end
			end
		end
	end

	function PLUGIN:setGathering(point)
		if(!istable(point[2])) then
			local entity = ents.Create("nut_"..point[2])
			
			if(IsValid(entity)) then
				entity:SetPos(point[1])

				entity:Spawn()
				table.insert(self.spawnedGathers, {entity, point})
			end
		else
			local entity = ents.Create("nut_"..table.Random(point[2]))
			
			if(IsValid(entity))  then
				entity:SetPos(point[1])
				entity:Spawn()
				
				table.insert(self.spawnedGathers, {entity, point})
			end
		end
	end

	function PLUGIN:removeInvalidGathers()
		for k, v in ipairs(self.spawnedGathers) do
			if !IsValid(v[1]) then
				table.remove(self.spawnedGathers, k)
			end
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
	function PLUGIN:CreateCharInfoText(panel, suppress)
		local char = LocalPlayer():getChar()
		if(!char) then return end
	
		--health
		local gather = panel.info:Add("DLabel")
		gather:Dock(TOP)
		gather:SetTall(25)
		gather:SetFont("nutMediumFont")
		gather:SetTextColor(color_white)
		gather:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		gather:DockMargin(0, 10, 0, 0)
	
		panel.gather = gather
	
		local gatherData = char:getData("gatherStamina", {})
	
		local stamina = gatherData.stamina or nut.config.get("gatherStaminaMax", 10)
		if (stamina) then
			panel.gather:SetText("Gathering Stamina: " ..stamina.. ".")
		end
	end
end

nut.command.add("gatherspawnadd", {
	adminOnly = true,
	syntax = "<string entity>",
	onRun = function(client, arguments)
		if (!arguments[1]) then
			return "@lc_noEntity"
		end

		if(gatherItems[string.lower(arguments[1])]) then
			local trace = client:GetEyeTraceNoCursor()
			local hitpos = trace.HitPos + trace.HitNormal*10
			
			table.insert(PLUGIN.gatherPoints, {hitpos, arguments[1]})
			PLUGIN:setGathering(PLUGIN.gatherPoints[#PLUGIN.gatherPoints])
			
			client:notifyLocalized("lc_gatherSpawn")
		else
			client:notify("Invalid entity.")
		end
	end
})

nut.command.add("gatherspawnaddgroup", {
	adminOnly = true,
	syntax = "<string entities>",
	onRun = function(client, arguments)
		if (!arguments[1]) then
			client:notify("No entities specified.")
			return false
		end

		local group = {}
		for k, v in pairs(arguments) do
			if(gatherItems[v]) then
				table.insert(group, v)
			else
				client:notify("Unknown group " ..v.. ".")
				return false
			end
		end
		
		if(#group > 0) then
			local trace = client:GetEyeTraceNoCursor()
			local hitpos = trace.HitPos + trace.HitNormal*10
			
			table.insert(PLUGIN.gatherPoints, {hitpos, group})
			PLUGIN:setGathering(PLUGIN.gatherPoints[#PLUGIN.gatherPoints])
			
			client:notify("Gather group successfully added.")
		end
	end
})

nut.command.add("gatherspawnremove", {
	adminOnly = true,
	syntax = "<number distance>",
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal*5
		local range = arguments[1] or 128
		local count = 0
		for k, v in pairs(PLUGIN.gatherPoints) do
			local distance = v[1]:Distance(hitpos)
			if distance <= tonumber(range) then
				PLUGIN.gatherPoints[k] = nil
				count = count+1
			end
		end
		client:notifyLocalized("lc_removedSpawners", count)
	end
})

nut.command.add("gatherspawndisplay", {
	adminOnly = true,
	onRun = function(client)
		if SERVER then
			netstream.Start(client, "nut_displayGatherSpawnPoints", PLUGIN.gatherPoints)
			client:notifyLocalized("lc_display")
		end
	end
})

--default models that can work for plants (hl2 & css)
--[[
Gathering - plants
	models/props/cs_office/plant01_p1.mdl

	models/props/de_inferno/fountain_bowl_p6.mdl
	models/props/de_inferno/fountain_bowl_p7.mdl
	models/props/de_inferno/fountain_bowl_p8.mdl
	models/props/de_inferno/fountain_bowl_p9.mdl
	models/props/de_inferno/fountain_bowl_p10.mdl

	models/props/de_inferno/largebush01.mdl
	models/props/de_inferno/largebush02.mdl
	models/props/de_inferno/largebush03.mdl
	models/props/de_inferno/largebush04.mdl
	models/props/de_inferno/largebush05.mdl
	models/props/de_inferno/largebush06.mdl

	models/props/de_inferno/potted_plant3_p1.mdl
	models/props/de_inferno/potted_plant2_p1.mdl
	models/props/de_inferno/potted_plant1_p1.mdl

	models/props/de_inferno/claypot03_damage_01.mdl
--]]