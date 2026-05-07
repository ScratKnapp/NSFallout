local PLUGIN = PLUGIN
PLUGIN.name = "Cyberpsychosis"
PLUGIN.author = "Chancer"
PLUGIN.desc = "This is what happens when you cyber."

NSCYBERNETICS = NSCYBERNETICS or {}

--[[
	NSCYBERNETICS = {
		[charID] = {
		
		}
	}
--]]

if (SERVER) then
	function PLUGIN:PlayerLoadedChar(client)
		NSCYBERNETICS[client] = {}
	
		--this is handled by the equip function now
		--[[
		local char = client:getChar()
		local inventory = char:getInv()
		for k, v in pairs(inventory:getItems()) do
			if(v:getData("equip") and v:getData("psy", v.psy)) then
				if(!NSCYBERNETICS[client]) then
					NSCYBERNETICS[client] = {} --make the table if it doesn't exist
				end
				
				NSCYBERNETICS[client][#NSCYBERNETICS[client] + 1] = v --add it to the table
			end
		end
		--]]
	end

	function PLUGIN:PlayerDisconnected(client)
		NSCYBERNETICS[client] = nil
	end

	function PLUGIN:Think()
		if((self.nextCheck or 0) < CurTime()) then
			self.nextCheck = CurTime() + 43200
			
			for client, parts in pairs(NSCYBERNETICS) do
				if(!IsValid(client)) then continue end
				
				local char = client:getChar()
				if(char) then
					local chance = 0
				
					for k, v in pairs(parts) do
						if(v:getData("equip")) then
							chance = chance + (v:getData("psy", v.psy) or 0)
						else
							parts[k] = nil
						end
					end
					
					--ignore the medicated
					if(char:getVar("cybermed", 0) > CurTime()) then --they're protected for now
						continue
					end
					
					--ignore droids
					if(char:getFaction() == FACTION_DROID) then
						continue
					end
					
					--this is done in kind of a stupid way but it works i guess
					local roll = math.Rand(0, 100) 
					if(roll < chance) then --rolls to see if they get it
						client:giveDisease("cyberpsychosis")
					end
				end
			end
		end
	end
end