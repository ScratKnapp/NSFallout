local PLUGIN = PLUGIN

-- Get ent's PAC3 Parts.
function ENT:getParts()
	if (!pac) then return end
	
	return self:getNetVar("parts", {})
end

if (SERVER) then
	function ENT:addPart(uid, item)
		if (!pac) then
			ErrorNoHalt("NO PAC3!\n")
		return end
		
		local curParts = self:getParts()

		-- wear the parts.
		netstream.Start(player.GetAll(), "partWear", self, uid)
		curParts[uid] = true

		self:setNetVar("parts", curParts)
	end
	
	function ENT:removePart(uid)
		if (!pac) then return end
		
		local curParts = self:getParts()

		-- remove the parts.
		netstream.Start(player.GetAll(), "partRemove", self, uid)
		curParts[uid] = nil

		self:setNetVar("parts", curParts)
	end

	function ENT:resetParts()
		if (!pac) then return end
		
		netstream.Start(player.GetAll(), "partReset", self, self:getParts())
		self:setNetVar("parts", {})
	end

	--[[
	function PLUGIN:PlayerLoadedChar(client, curChar, prevChar)
		-- If player is changing the char and the character ID is differs from the current char ID.
		if (prevChar and curChar:getID() != prevChar:getID()) then
			client:resetParts()
		end

		-- After resetting all PAC3 outfits, wear all equipped PAC3 outfits.
		if (curChar) then
			local inv = curChar:getInv()
			for k, v in pairs(inv:getItems()) do
				if (v:getData("equip") == true and v.pacData) then
					client:addPart(v.uniqueID, v)
				end
			end
		end
	end
	--]]
else
	--[[
	netstream.Hook("updatePAC", function()
		if (!pac) then return end

		for k, v in ipairs(player.GetAll()) do
			local char = v:getChar()

			if (char) then
				local parts = client:getParts()

				for pacKey, pacValue in pairs(parts) do
					if (nut.pac.list[pacKey]) then
						v:AttachPACPart(nut.pac.list[pacKey])
					end
				end
			end
		end
	end)
	--]]

	netstream.Hook("partWear", function(wearer, outfitID)
		if (!pac) then return end
		
		if (!wearer.pac_owner) then
			pac.SetupENT(wearer)
		end
		
		local itemTable = nut.item.list[outfitID]
		local newPac = nut.pac.list[outfitID]

		if (nut.pac.list[outfitID]) then
			if (itemTable and itemTable.pacAdjust) then
				newPac = table.Copy(nut.pac.list[outfitID])
				newPac = itemTable:pacAdjust(newPac, wearer)
			end
	
			wearer:AttachPACPart(newPac)
		end
	end)

	netstream.Hook("partRemove", function(wearer, outfitID)
		if (!pac) then return end
		
		if (!wearer.pac_owner) then
			pac.SetupENT(wearer)
		end

		if (nut.pac.list[outfitID]) then
			wearer:RemovePACPart(nut.pac.list[outfitID])
		end
	end)

	netstream.Hook("partReset", function(wearer, outfitList)
		for k, v in pairs(outfitList) do
			wearer:RemovePACPart(nut.pac.list[k])
		end
	end)
end