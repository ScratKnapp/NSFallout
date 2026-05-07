local PLUGIN = PLUGIN

--grok is this real

PLUGIN.AITree = {}

--the weights on where NPCs target which body parts
--higher number, high chance to decide to target it
PLUGIN.partChance = {
	["Body"] = 20,
	["Head"] = 4,
	["Left Arm"] = 8,
	["Right Arm"] = 8,
	["Left Leg"] = 8,
	["Right Leg"] = 8,
}

--gets the actions that can be used by the entity in auto turn based combat
PLUGIN.helperFuncs["getTurnAIActions"] = function(self, id)
	if(self.combat) then
		return self.actionsAI or self.actions or {}
	else
		return {}
	end
end

function PLUGIN:FindMovePosition(entity, target, distance)
	local destination
	local range = entity:getFireRange()
	
	local distance = distance or range*0.7

	--one ap circle (squared)
	local circle = 400
	local circleSqr = circle*circle

	local entityPos = entity:GetPos()
	local targetPos = target:GetPos()

	local direction = (targetPos - entityPos):GetNormalized()

	--where we would ideally like to be
	destination = targetPos - direction*distance

	if(entityPos:DistToSqr(destination) > circleSqr) then
		--if we cannot get right in front of them, then just move towards them
		destination = entity:GetPos() + direction*circle
	end

	return destination
end

function PLUGIN:GetClosestTarget(entity, targets)
	local pos = entity:GetPos()
	local closest
	local closestDist = math.huge
	
	for k, v in pairs(targets) do
		local dist = pos:DistToSqr(v:GetPos())
		if(closestDist > dist) then
			closest = v
			closestDist = dist
		end
	end

	return closest
end

--whether or not the npc can see the supplied position (I didnt make this)
function PLUGIN:CanSeePos(pos1, pos2, filter, fraction)
	local trace = {}
	trace.start = pos1
	trace.endpos = pos2
	trace.filter = filter
	trace.mask = MASK_SOLID + CONTENTS_GRATE
	local tr = util.TraceLine(trace)
	
	if(tr.Fraction >= (fraction or 1)) then
		return true
	end
	
	return false
end

function PLUGIN:CheckLOS(entity, target)
	return PLUGIN:CanSeePos(entity:EyePos(), target:WorldSpaceCenter(), {entity, target}, 0.9)
end

local function WeightedRandom(items)
	local sum = 0
	
	for part, chance in pairs(items) do
		sum = sum + (chance or 1)
	end

	local select = math.random() * sum

	for part, chance in pairs(items) do
		select = select - (chance or 1)
		if select < 0 then 
			return part 
		end
	end
end

function PLUGIN:ChooseAttack(entity, target, delay)
	if(!PLUGIN:CheckLOS(entity, target)) then return end --if you cant see them, dont attack them

	--queued movement action
	entity:queueActionAfter(delay or 0, function()
		if(entity.loco) then
			--makes sure the NPC is facing the target
			entity.loco:FaceTowards(target:GetPos())
			entity.loco:FaceTowards(target:GetPos())
			entity.loco:FaceTowards(target:GetPos())
		end
	
		local range = entity:getFireRange()
		range = range^2
	
		local dist = entity:GetPos():DistToSqr(target:GetPos())
	
		local cooldowns = entity:getCooldowns()
		local actions = entity:getTurnAIActions()
		
		local possible = {}
		for _, actionID in pairs(actions) do
			local action = ACTS.actions[actionID]
		
			if(cooldowns[actionID]) then continue end --cds
			
			local range2 = (action.range and action.range^2) or range
			local rangeMin2 = (action.rangeMin and action.rangeMin^2) or -1
			--cheaper to compare squared distance than normal distance

			if(range2 < dist) then continue end --range
			if(rangeMin2 > dist) then continue end --minimum range

			if(action) then
				possible[#possible+1] = PLUGIN:actionFormat(action)
			end
		end
		
		--basic attack
		if(dist <= range) then
			possible[#possible+1] = {
				action = {
					name = "Attack",
				}
			}
		end

		local action = table.Random(possible)

		if(action) then
			local data = {}
			data.start = entity:EyePos()
			data.endpos = target:GetPos()
			data.filter = {entity}
			local trace = util.TraceLine(data)
			trace.Entity = target --just make this easier i guess

			local actionTbl = (action.uid and ACTS.actions[action.uid]) or {}
		
			local part = WeightedRandom(PLUGIN.partChance)
		
			local data = {
				attacker = entity,
				trace = trace,
				partString = part,
				--weapon = weapon,
				action = action,
				actionTbl = actionTbl,
			}
		
			entity:Attack(target, actionTbl)
			PLUGIN:attackStart(entity, data)
		end
	end)
end

PLUGIN.AITree["none"] = {
	name = "None",
	turnProcess = function(entity, turnData)
	end,
}

PLUGIN.AITree["simple"] = {
	name = "Simple",
	turnProcess = function(entity, turnData)
		if(!entity.combat) then return end
		if(!turnData) then return end

		local ourTeam = entity:getTurnTeam()
		
		local enemies = {}
		for target, teamName in pairs(turnData.entities) do
			if(!IsValid(target)) then continue end
			
			if(teamName == ourTeam) then continue end --no same team
			--may make an exception for if they have buffs or something
			if(target:GetMoveType() == MOVETYPE_NOCLIP) then continue end --no noclipping admins
			
			enemies[#enemies+1] = target
		end

		local target = PLUGIN:GetClosestTarget(entity, enemies)

		--replace with a function that better determines where to move
		if(IsValid(target)) then
			local movePos, delay = PLUGIN:FindMovePosition(entity, target)
		
			local distToSqr = entity:GetPos():DistToSqr(movePos)
			local delay = 0
			if(distToSqr > 25) then
				delay = entity:movementStart(movePos)
			end

			PLUGIN:ChooseAttack(entity, target, delay)
		end
	end,
}

PLUGIN.AITree["ranged"] = {
	name = "Ranged",
	turnProcess = function(entity, turnData)
		if(!entity.combat) then return end
		if(!turnData) then return end

		local ourTeam = entity:getTurnTeam()
		
		local enemies = {}
		for target, teamName in pairs(turnData.entities) do
			if(!IsValid(target)) then continue end
			
			if(teamName == ourTeam) then continue end --no same team
			--may make an exception for if they have buffs or something
			if(target:GetMoveType() == MOVETYPE_NOCLIP) then continue end --no noclipping admins
			
			enemies[#enemies+1] = target
		end

		local target = PLUGIN:GetClosestTarget(entity, enemies)

		--replace with a function that better determines where to move
		if(IsValid(target)) then
			local movePos, delay = PLUGIN:FindMovePosition(entity, target, entity:getFireRange())
		
			local delay = entity:movementStart(movePos)

			PLUGIN:ChooseAttack(entity, target, delay)
		end
	end,
}

PLUGIN.AITree["nomove"] = {
	name = "Hold Position",
	turnProcess = function(entity, turnData)
		if(!entity.combat) then return end
		if(!turnData) then return end

		local ourTeam = entity:getTurnTeam()
		
		local enemies = {}
		for target, teamName in pairs(turnData.entities) do
			if(!IsValid(target)) then continue end
			
			if(teamName == ourTeam) then continue end --no same team
			--may make an exception for if they have buffs or something
			if(target:GetMoveType() == MOVETYPE_NOCLIP) then continue end --no noclipping admins
			
			enemies[#enemies+1] = target
		end

		local target = table.Random(enemies)

		--replace with a function that better determines where to move
		if(IsValid(target)) then
			local movePos = PLUGIN:FindMovePosition(entity, target)

			PLUGIN:ChooseAttack(entity, target)
		end
	end,
}