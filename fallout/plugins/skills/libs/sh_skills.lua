nut.skills = nut.skills or {}
nut.skills.list = nut.skills.list or {}

local function createSkillCheck(skillID, commandName)
	nut.command.add(commandName or skillID, {
		syntax = "<number bonus>",
		onRun = function(client, arguments)
			local char = client:getChar()
		
			local d20 = math.random(1,20)
			local skill = char:getSkill(skillID, 0)

			local roll = d20+skill*0.5
			
			local critText = ""
			local crit = client:rollCrit()
			if(crit) then
				roll = roll * crit
				
				critText = " (Crit!)"
			end
			
			roll = math.Round(roll)
			
			local bonus = tonumber(arguments[1])
			if(bonus) then
				roll = roll + bonus
			end
			
			local name = nut.skills.list[skillID].name

			if(!crit) then 
				crit = 1
			end

			local rollText = "rolls " ..d20*crit.. " + " ..math.Round(skill*0.5*crit)..critText..((bonus and (" + " ..bonus.. " ")) or " ").. "(" ..roll.. ") for " ..name.. "."

			if(nut.plugin.list["chatboxextra"]) then
				nut.plugin.list["chatboxextra"]:ChatboxSend(client, "skillcheck", client:Name().. " " ..rollText)
			else
				nut.chat.send(client, "skillcheck", rollText)
			end
		end
	})
end

function nut.skills.loadFromDir(directory)
	for k, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
		local niceName = v:sub(4, -5)

		SKILL = nut.skills.list[niceName] or {}
			if (PLUGIN) then
				SKILL.plugin = PLUGIN.uniqueID
			end

			nut.util.include(directory.."/"..v)

			SKILL.name = SKILL.name or "Unknown"
			SKILL.desc = SKILL.desc or "No description availalble."

			createSkillCheck(niceName, SKILL.checkName)

			nut.skills.list[niceName] = SKILL
		SKILL = nil
	end
end

function nut.skills.setup(client)
	local character = client:getChar()

	if (character) then
		for k, v in pairs(nut.skills.list) do
			if (v.onSetup) then
				v:onSetup(client, character:getSkill(k, 0))
			end
		end
	end
end

-- Add updating of skills to the character metatable.
do
	local charMeta = nut.meta.character

	if (SERVER) then
		function charMeta:updateSkill(key, value)
			local skill = nut.skills.list[key]

			if (skill) then
				local skills = self:getSkills()
				local client = self:getPlayer()

				skills[key] = math.min((skills[key] or 0) + value, skill.maxValue or nut.config.get("maxSkills", 20))

				if (IsValid(client)) then
					netstream.Start(client, "skill", self:getID(), key, skills[key])

					if (skill.setup) then
						skill.setup(skill[key])
					end
				end
			end

			hook.Run("OnCharSkillUpdated", client, self, key, value)
		end

		function charMeta:setSkill(key, value, noBonus)
			local skill = nut.skills.list[key]

			if (skill) then
				local skills = self:getSkills()
				local client = self:getPlayer()

				skills[key] = value

				if (IsValid(client)) then
					netstream.Start(client, "skill", self:getID(), key, skills[key])

					if (skill.setup) then
						skill.setup(skills[key])
					end
				end
			end

			hook.Run("OnCharSkillUpdated", client, self, key, value)
		end

		function charMeta:addSkillBoost(boostID, skillID, boostAmount)
			local boosts = self:getVar("skillBoosts", {})

			boosts[skillID] = boosts[skillID] or {}
			boosts[skillID][boostID] = boostAmount

			hook.Run("OnCharSkillBoosted", self:getPlayer(), self, skillID, boostID, boostAmount)

			return self:setVar("skillBoosts", boosts, nil, self:getPlayer())
		end

		function charMeta:removeSkillBoost(boostID, skillID)
			local boosts = self:getVar("skillBoosts", {})

			boosts[skillID] = boosts[skillID] or {}
			boosts[skillID][boostID] = nil

			hook.Run("OnCharSkillBoosted", self:getPlayer(), self, skillID, boostID, true)

			return self:setVar("skillBoosts", boosts, nil, self:getPlayer())
		end
	else
		netstream.Hook("skill", function(id, key, value)
			local character = nut.char.loaded[id]

			if (character) then
				character:getSkills()[key] = value
			end
		end)
	end

	function charMeta:getSkillBoost(skillID)
		local boosts = self:getBoosts()

		return boosts[skillID]
	end

	function charMeta:getSkillBoosts()
		return self:getVar("skillBoosts", {})
	end

	function charMeta:getSpecialBonus(key)
		local skillTbl = nut.skills.list[key] or {}
		local specialBonus = skillTbl.specialBonus
		
		local bonus = 0
	
		for attribID, bonusMult in pairs(specialBonus) do
			local attribTbl = nut.attribs.list[attribID]
			if(!attribTbl) then continue end
		
			local attribSkillMult = attribTbl.skillBonus
			if(!attribSkillMult) then continue end
		
			--character's current attributes
			local attrib = self:getAttrib(attribID, 0)

			bonus = bonus + attrib*bonusMult*attribSkillMult[attribID]

			--skill = math.min(skill + bonus, nut.config.get("maxSkills", 20))
		end
		
		bonus = math.Round(bonus)
		
		return bonus
	end

	function charMeta:getSkill(key, default, noSpecial)
		local skill = self:getSkills()[key] or default or 0
		local boosts = self:getSkillBoosts()[key]

		if (boosts) then
			for k, v in pairs(boosts) do
				skill = skill + v
			end
		end
		
		local skillTbl = nut.skills.list[key] or {}
		
		if(!noSpecial) then
			local specialBonus = skillTbl.specialBonus
			if(specialBonus) then
				local bonus = self:getSpecialBonus(key)
				skill = math.min(skill + bonus, nut.config.get("maxSkills", 20))
			
				--[[
				for attribID, bonusMult in pairs(specialBonus) do
					local attribTbl = nut.attribs.list[attribID]
					if(!attribTbl) then continue end
				
					local attribSkillMult = attribTbl.skillBonus
					if(!attribSkillMult) then continue end
				
					--character's current attributes
					local attrib = self:getAttrib(attribID, 0)

					local bonus = attrib*bonusMult*attribSkillMult[attribID]
				end
				--]]
			end
		end

		return skill
	end
end

hook.Add("DoPluginIncludes", "nutSkillsLib", function(path)
	nut.skills.loadFromDir(path.."/skills")
end)
