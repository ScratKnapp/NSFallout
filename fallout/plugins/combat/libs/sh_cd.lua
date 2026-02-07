local PLUGIN = PLUGIN

local playerMeta = FindMetaTable("Player")

PLUGIN.helperFuncs = PLUGIN.helperFuncs or {}

--gets all cooldowns
--function playerMeta:getCooldowns()
PLUGIN.helperFuncs["getCooldowns"] = function(self)
	local char = self:getChar()
	
	if(char) then
		return (char.cooldowns or {})
	else
		return {}
	end
end

--adds a cooldown to a player
--function playerMeta:addCooldown(action, duration)
PLUGIN.helperFuncs["addCooldown"] = function(self, action, duration, weapon)
	local weaponID = weapon or ""
	local actionID = action..weaponID

	local cooldowns = self:getCooldowns()
	cooldowns[actionID] = {duration = duration, weapon = weapon}
	
	local char = self:getChar()
	char.cooldowns = cooldowns

	PLUGIN:cdNetworkAll(self, actionID, duration, weapon)
end

--removes a cooldown from a player
--function playerMeta:removeCooldown(action)
PLUGIN.helperFuncs["removeCooldown"] = function(self, action)
	local cooldowns = self:getCooldowns()
	
	local char = self:getChar()
	char.cooldowns = cooldowns
	
	cooldowns[action] = nil

	PLUGIN:cdNetworkAll(self, action)
end

--clears all of a player's cooldowns
--function playerMeta:clearCooldowns()
PLUGIN.helperFuncs["clearCooldowns"] = function(self)
	local char = self:getChar()
	char.cooldowns = nil
end

if(SERVER) then
	PLUGIN.networkQueueCD = {}

	function PLUGIN:cdNetworkAll(entity, action, duration, weapon)
		PLUGIN.networkQueueCD = PLUGIN.networkQueueCD or {}
		
		local tempTbl = {
			entity = entity, 
			action = action, 
			duration = duration,
			weapon = weapon,
		}
		
		table.insert(PLUGIN.networkQueueCD, tempTbl)
	end

	function PLUGIN:cdThink()
		if((self.nextNetworkCD or 0) > CurTime()) then return end
		self.nextNetworkCD = CurTime() + 1

		if(table.IsEmpty(PLUGIN.networkQueueCD)) then return end

		for k, client in ipairs(player.GetAll()) do
			local netCD = PLUGIN.networkQueueCD[1]
			netstream.Start(client, "cooldownNetworkAll", netCD.entity, netCD.action, netCD.duration, netCD.weapon)
		end
		
		table.remove(PLUGIN.networkQueueCD, 1)
	end
else
	netstream.Hook("cooldownNetwork", function(data)
		local client = LocalPlayer()
		client:getChar().cooldowns = util.JSONToTable(data)
	end)
	
	netstream.Hook("cooldownNetworkAll", function(entity, action, duration, weapon)
		if(IsValid(entity) and entity.getCooldowns) then
			local char = entity:getChar()
			if(char) then
				char.cooldowns = entity:getCooldowns()

				if(duration) then
					char.cooldowns[action] = {duration = duration, weapon = weapon}
				else
					char.cooldowns[action] = nil
				end
			end
		end
	end)
end

hook.Add("nut_ActionInterrupt", "nut_cdInterrupt", function(action, attacker, weapon)
	if(!action) then return false end
	if(!action.uid) then return false end
	
	local cooldowns = attacker:getCooldowns()
	if(cooldowns) then
		local cooldown = cooldowns[action.uid]
		if(!cooldown) then
			local weapon = action.weapon
			if(weapon) then
				--weapon given actions on cd
				--done this way so each weapon has its own cds
				cooldown = cooldowns[action.uid..weapon]
				if(cooldown) then
					return (action.name or "Action").. "  is on Cooldown."
				end
			end
		else
			--non weapon given action on cd
			return (action.name or "Action").. "  is on Cooldown."
		end
	end
end)