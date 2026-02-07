local PLUGIN = PLUGIN

for attribID, v in pairs(nut.attribs.list) do
	nut.command.add(v.name or attribID, {
		syntax = "<nothing>",
		onRun = function(client, arguments)
			local char = client:getChar()
		
			local d20 = math.random(1,20)
			local skill = char:getAttrib(attribID, 0)

			local roll = d20+skill*0.5
			
			local critText = ""
			local crit = client:rollCrit()
			if(crit) then
				roll = roll * crit
				
				critText = " (Crit!)"
			end
			
			roll = math.Round(roll)
			
			local name = v.name or attribID--nut.attribs.list[attribID].name

			if(nut.plugin.list["chatboxextra"]) then
				nut.plugin.list["chatboxextra"]:ChatboxSend(client, "skillcheck", client:Name().. " rolls " ..roll..critText.. " for " ..name.. ".")
			else
				nut.chat.send(client, "skillcheck", "rolls " ..roll.. " for " ..name.. ".")
			end
		end
	})
end