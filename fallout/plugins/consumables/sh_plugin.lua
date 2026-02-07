local PLUGIN = PLUGIN
PLUGIN.name = "Consumables"
PLUGIN.author = ""
PLUGIN.desc = "Consume"
--PLUGIN.hungrySeconds = 60000 -- A player can stand up 300 seconds without any foods

nut.util.include("cl_vgui.lua")

local playerMeta = FindMetaTable("Player")
local entityMeta = FindMetaTable("Entity")

if (SERVER) then
	--loads player's addictions and effects
	function PLUGIN:getAddict(client)
		local char = client:getChar()
		if(char) then
			local charAddict = char:getData("addict", {})
			
			local addictEffects = {}
			
			for uniqueID, addictAmt in pairs(charAddict) do
				local itemTable = nut.item.list[uniqueID]
				if(itemTable) then
					local addictData = itemTable.addictData
					local addictAmt = charAddict[uniqueID]
					local addictMax = itemTable.addictMax
					
					if(addictData) then
						--at most will reduce cd to half
						local cdMult = 1 - (addictAmt/(addictMax*2))
					
						local cd = addictData.baseCD * cdMult
						
						local symptoms = {}
						
						if(addictData.symptoms) then
							for threshold, symptomTbl in pairs(addictData.symptoms) do 
								if(addictAmt >= threshold) then
									for _, symptom in pairs(symptomTbl) do
										symptoms[#symptoms+1] = symptom
									end
								end
							end
						end
						
						addictEffects[#addictEffects+1] = {
							id = uniqueID,
							cd = cd,
							symptoms = symptoms,
						}
						
						--reduce addiction level by one point
						charAddict[uniqueID] = charAddict[uniqueID] - 1
						
						if(charAddict[uniqueID] < 1) then
							charAddict[uniqueID] = nil
						end
					end
				else
					addictData[uniqueID] = nil
				end
			end
			
			--handles afflictions and their multipliers for addictions
			char:setData("addict", charAddict)
			
			return addictEffects
		end
	end
	
	function PLUGIN:Think()
		if((self.nextThink or 0) < CurTime()) then
			self.nextThink = CurTime() + 1200
	
			for _, client in pairs(player.GetAll()) do
				if(!IsValid(client) or !client:getChar()) then continue end
			
				local char = client:getChar()
				local charID = char:getID()
			
				local addict = PLUGIN:getAddict(client)
				
				for _, addictData in pairs(addict) do
					if(!client.addictCDs) then 
						--this table handles cooldowns for addiction prints
						client.addictCDs = {}
					end
					
					if((client.addictCDs[addictData.id] or 0) < CurTime()) then
						if(addictData.symptoms and !table.IsEmpty(addictData.symptoms)) then
							local ranSymptom = table.Random(addictData.symptoms)

							--prevents all the addicts from suddenly /me at once
							timer.Simple(math.random(0, 600), function()
								local curChar = client:getChar()
								
								--make sure they didnt swap characters
								if(curChar and charID == curChar:getID()) then
									nut.chat.send(client, "me", ranSymptom.. ".")
								end
							end)
						end
					end
				end
			end
		end
	end
else

end

function PLUGIN:PrePlayerLoadedChar(client, character, currentChar)
	character:setData("stomach", 0)
end

nut.command.add("charstomachempty", {
	adminOnly = true,
	syntax = "<string name>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then
			local char = target:getChar()
			char:setData("stomach", 0)
			
			client:notify(target:Name().. "'s stomach emptied.")
		end
	end
})