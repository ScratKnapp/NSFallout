nut.command.add("charsetskill", {
	adminOnly = true,
	syntax = "<string charname> <string skillname> <number level>",
	onRun = function(client, arguments)
		local skillName = arguments[2]
		if (!skillName) then
			return L("invalidArg", client, 2)
		end

		local skillNumber = arguments[3]
		skillNumber = tonumber(skillNumber)
		if (!skillNumber or !isnumber(skillNumber)) then
			return L("invalidArg", client, 3)
		end

		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target)) then
			local char = target:getChar()
			if (char) then
				for k, v in pairs(nut.skills.list) do
					if (nut.util.stringMatches(L(v.name, client), skillName) or nut.util.stringMatches(k, skillName)) then
						char:setSkill(k, skillNumber)
						client:notifyLocalized("skillSet", target:Name(), L(v.name, client), skillNumber)

						return
					end
				end
			end
		end
	end
})

nut.command.add("charaddskill", {
	adminOnly = true,
	syntax = "<string charname> <string skillname> <number level>",
	onRun = function(client, arguments)
		local skillName = arguments[2]
		if (!skillName) then
			return L("invalidArg", client, 2)
		end

		local skillNumber = arguments[3]
		skillNumber = tonumber(skillNumber)
		if (!skillNumber or !isnumber(skillNumber)) then
			return L("invalidArg", client, 3)
		end

		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target)) then
			local char = target:getChar()
			if (char) then
				for k, v in pairs(nut.skills.list) do
					if (nut.util.stringMatches(L(v.name, client), skillName) or nut.util.stringMatches(k, skillName)) then
						char:updateSkill(k, skillNumber)
						client:notifyLocalized("skillUpdate", target:Name(), L(v.name, client), skilNumber)

						return
					end
				end
			end
		end
	end
})