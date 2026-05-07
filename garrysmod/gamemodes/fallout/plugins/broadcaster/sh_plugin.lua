PLUGIN.name = "Radio"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "You can communicate with other people in distance."

nut.chat.register("broadcast", {
	font = "nutRadioFont",
	onCanSay = function(speaker, text)
		local nearby = ents.FindInSphere(speaker:GetPos(), 100)
		
		local broadcaster
		for k, v in pairs(nearby) do
			if(v:GetClass() == "nut_item") then
				local itemTable = v:getItemTable()
				if(itemTable and itemTable.uniqueID == "broadcaster") then
					broadcaster = true
					break
				end
			end
		end
		
		if(broadcaster) then
			return true
		else
			speaker:notify("You are not near a broadcaster")
			return false
		end
	end,
	onCanHear = function(speaker, listener)
		-- LengthSqr is faster than Length, so just check the squares.
		local range = nut.config.get("chatRange", 280) * 48
		
		local pda = false
		local inventory = listener:getChar():getInv()
		
		if(inventory:hasItem("pda") or inventory:hasItem("monopda")) then
			pda = true
		end
		
		return pda and (speaker:GetPos() - listener:GetPos()):LengthSqr() <= range
	end,
	onChatAdd = function(speaker, text)
		chat.AddText(Color(225, 70, 0), "[BROADCAST]: " ..text)
	end,
	filter = "pda",
	prefix = {"/broadcast"}
})