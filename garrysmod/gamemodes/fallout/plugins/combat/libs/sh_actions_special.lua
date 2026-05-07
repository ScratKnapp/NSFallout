local PLUGIN = PLUGIN

for attribID, v in pairs(nut.attribs.list) do
	nut.command.add(v.name or attribID, {
		syntax = "<number bonus>",
		onRun = function(client, arguments)
			local char = client:getChar()
		
			local d20 = math.random(1,20)
			local attrib = char:getSkill(attribID, 0)

			local roll = d20+attrib*0.5
			
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
			
			local name = nut.attribs.list[attribID].name

			if(!crit) then 
				crit = 1
			end

			local rollText = "rolls " ..d20*crit.. " + " ..math.Round(attrib*0.5*crit) .. " Stat Bonus "..critText..((bonus and (" + Bonus Of " ..bonus.. " ")) or " ").. " = " ..roll.. " for " ..name.. "."

			if(nut.plugin.list["chatboxextra"]) then
				nut.plugin.list["chatboxextra"]:ChatboxSend(client, "skillcheck", client:Name().. " " ..rollText)
			else
				nut.chat.send(client, "skillcheck", rollText)
			end
		end
	})
end