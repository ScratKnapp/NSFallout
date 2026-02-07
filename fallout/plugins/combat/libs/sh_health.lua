local PLUGIN = PLUGIN

PLUGIN.helperFuncs = PLUGIN.helperFuncs or {}

--this is so the stuff shows up in admin ESP
function PLUGIN:PlayerLoadout(client)
	client:SetMaxHealth(math.max(client:getMaxHP(), 100))
	client:SetHealth(math.max(client:getMaxHP(), 100))
	client:setHP(client:getMaxHP())
end

if(SERVER) then
	--just use a negative value to subtract
	--function playerMeta:addHP(amount)
	PLUGIN.helperFuncs["addHP"] = function(self, amount)
		local new = math.Clamp(self:getHP() + amount, -1000, self:getMaxHP())
		
		new = math.Round(new, 2)
		
		self:setHP(new)
		
		return new
	end
	
	--sets to exactly the supplied value
	PLUGIN.helperFuncs["setHP"] = function(self, amount)
		self:setNetVar("hp", amount)
		
		self:SetMaxHealth(self:getMaxHP())
	end
	
	--sets to exactly the supplied value
	PLUGIN.helperFuncs["setMaxHP"] = function(self, amount)
		self:setNetVar("hpMax", amount)
	end
end

--function playerMeta:getHP()
PLUGIN.helperFuncs["getHP"] = function(self)
	return self:getNetVar("hp", self:getMaxHP())
end

--function playerMeta:getMaxHP()
PLUGIN.helperFuncs["getMaxHP"] = function(self, noStats)
	local char = self:getChar()
		
	local maxHP = self:getNetVar("hpMax", self.hp or 100)
	if(char and !noStats) then
		local endurance = char:getAttrib("end", 0)

		maxHP = maxHP + endurance*3
		
		local str = char:getAttrib("str", 0)
		maxHP = maxHP + str
		
		if(self:hasTrait("lifegiver")) then
			maxHP = maxHP + 30
		end
	end
	
	maxHP = maxHP + self:getBuffAttribute("hpMax") + self:getBuffAttribute("maxHP")

	maxHP = math.Round(maxHP, 3)

	return maxHP
end

nut.command.add("charsethp", {
	adminOnly = true,
	syntax = "<string target> <number value>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("No target specified")
			return false
		end
	
		if(!arguments[2]) then
			client:notify("No HP specified")
			return false
		end
	
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then	
			local new = math.Clamp(tonumber(arguments[2]), 0, target:getMaxHP())
			target:setHP(new)
			
			client:notify("Health is now " ..target:getHP().. ".")
		end
	end
})

nut.command.add("charaddhp", {
	adminOnly = true,
	syntax = "<string target> <number health>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("No target specified")
			return false
		end
		
		if(!arguments[2]) then
			client:notify("No amount specified")
			return false
		end
	
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then	
			target:addHP(tonumber(arguments[2]))

			client:notify("Health is now " ..target:getHP().. ".")
		end
	end
})

nut.command.add("charrestore", {
	adminOnly = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("No target specified")
			return false
		end
	
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then	
			target:setHP(target:getMaxHP())
			
			client:notify("Health successfully restored.")
		end
	end
})

nut.command.add("charrestoreall", {
	adminOnly = true,
	syntax = "<none>",
	onRun = function(client, arguments)
		local count = 0
	
		for k, target in pairs(player.GetAll()) do
			if(IsValid(target) and target:getChar()) then	
				target:setHP(target:getMaxHP())

				count = count + 1
			end
		end
		
		client:notify(count.. " players successfully restored.")
	end
})


nut.command.add("centhpadd", {
	adminOnly = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
		local addHP = tonumber(arguments[1])
		if(!addHP) then
			client:notify("Specify an HP Amount.")
			return false
		end
	
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			local newHP = entity:getHP()+addHP
		
			entity:SetHealth(newHP)
			entity:setHP(newHP)
			
			client:notify("CEnt health set to " ..newHP.. ".")
		end
	end
})

nut.command.add("centrestore", {
	adminOnly = true,
	onRun = function(client, arguments)	
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			entity:setNetVar("hp", entity:getMaxHP())
			--entity:setNetVar("mp", entity:getMaxMP())
			
			client:notify("CEnt restored.")
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centrestoreall", {
	adminOnly = true,
	onRun = function(client, arguments)
		local count = 0
		for k, entity in pairs(ents.GetAll()) do
			if (IsValid(entity) and entity.combat) then
				entity:setNetVar("hp", entity:getMaxHP())
				--entity:setNetVar("mp", entity:getMaxMP())
				
				count = count + 1
			end
		end
		
		client:notify(count.. " CEnts restored.")
	end
})
