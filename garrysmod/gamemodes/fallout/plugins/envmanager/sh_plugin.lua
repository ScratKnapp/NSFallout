local PLUGIN = PLUGIN
PLUGIN.name = "Environment Manager"
PLUGIN.author = "Chancer"
PLUGIN.desc = "It does some environmental things."
PLUGIN.thinkTime = 2
PLUGIN.spawnDelay = 1
PLUGIN.spawns = {}

nut.config.add("env_enabled", true, "Whether or not the environmental manager is on.", nil, {
	category = "Environmental Manager"
})

nut.config.add("env_weatherDelay", 600, "Time between each weather event (excluding duration of previous event).", nil, {
	data = {min = 0, max = 84600},
	category = "Environmental Manager"
})

--unused for now
--[[
nut.config.add("env_npcClean", false, "Whether or not to delete npcs when there's no players on.", nil, {
	category = "Environmental Manager"
})

nut.config.add("env_thinkTime", 3600, "Rate at which items may turn into NPCs.", nil, {
	data = {min = 1, max = 84600},
	category = "Environmental Manager"
})

nut.config.add("env_spawnDelay", 5, "How much time there is between the warning the and npc spawn.", nil, {
	data = {min = 1, max = 84600},
	category = "Environmental Manager"
})

nut.config.add("env_maxSpawns", 10, "Max NPCs that are allowed to be created by this plugin at one time.", nil, {
	data = {min = 1, max = 84600},
	category = "Environmental Manager"
})
--]]

--currently unused
local function playerHandle()
	local players = player.GetAll()
	
	for k, v in pairs(players) do
		local char = v:getChar()
	
		if(!char or v:GetMoveType() == MOVETYPE_NOCLIP or v:InVehicle()) then --don't screw with these people
			table.RemoveByValue(players, v)
		end

		if(char) then
			local faction = char:getFaction()
			if(PLUGIN.factions[faction]) then --doesn't mess with certain factions
				table.RemoveByValue(players, v)
			end
		end
	end
	
	--this runs through all legitimate players, and checks if they're near other players.
	--if they are, it ignores them
	--if they are not, then it marks them as "alone"
	--next think, if it detects that they are alone again, it will do things to them.
	--AKA there will be about 2 think times between each random spooky thing for any one player
	--I should think of a more efficient way to tell if someone is alone or not since this may get quite expensive.
	
	for k, v in pairs(players) do
		local nearby = ents.FindInSphere(v:GetPos(), 2000)
		table.RemoveByValue(nearby, v) --removes self

		local friend
		for k2, v2 in pairs(nearby) do
			if(v2:IsPlayer()) then
				v.alone = false
				v2.alone = false
				friend = true
				table.RemoveByValue(players, v2)
			end
		end
		
		if(!friend and v.alone) then
			if(math.random(1,10) < 8) then --higher chance to do a less severe thing
				table.Random(PLUGIN.minorSpooks)(v)
			else --lower chance to do a really annoying thing
				table.Random(PLUGIN.majorSpooks)(v)
			end		
		elseif(!friend and !v.alone) then
			v.alone = true
		end
	end

	--since it just checks a single random player, its a lot less likely to get one when there's many on
end

if SERVER then
	function PLUGIN:Think()
		if(!nut.config.get("env_enabled", false)) then return end		

		if((self.nextThink or 60) < CurTime()) then
			--weather is handled here
			if((self.nextWeather or nut.config.get("env_weatherDelay", 600)) < CurTime()) then
				local duration = PLUGIN:weatherStart()
				
				self.nextWeather = CurTime() + (duration or 0) + nut.config.get("env_weatherDelay", 600)
			end
		end
	end
end

nut.util.include("sh_events.lua")