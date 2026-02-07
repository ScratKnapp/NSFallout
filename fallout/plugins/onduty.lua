local PLUGIN = PLUGIN
PLUGIN.name = "On Duty"
PLUGIN.author = " "
PLUGIN.desc = "Flag and commands for police officers to become on/off duty."

nut.flag.add("N", "Flag for being a member of the police force.")

nut.command.add("onduty", {
    syntax = "",
    onRun = function(client, arguments)
		local char = client:getChar()
	
		if(char:hasFlags("N")) then
			local faction = char:getFaction()
			
			if(faction != FACTION_AETHERSTONE) then
				char:setData("offDuty", char:getFaction())
			
				char:setFaction(FACTION_AETHERSTONE)
				
				client:notify("You are now on duty.")
			else
				client:notify("You are already on duty.")
			end
		else
			client:notify("You do not have the flag for this.")
		end
    end
})

nut.command.add("offduty", {
    syntax = "",
    onRun = function(client, arguments)
        local char = client:getChar()
	
		if(char:hasFlags("N")) then
			local faction = char:getFaction()
			
			if(faction == FACTION_AETHERSTONE) then
				local offDuty = char:getData("offDuty", FACTION_CIV)

				char:setFaction(offDuty)
				
				char:setData("offDuty", nil)
				
				client:notify("You are now off duty.")
			else
				client:notify("You are not on duty.")
			end
		else
			client:notify("You do not have the flag for this.")
		end
    end
})