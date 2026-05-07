local PLUGIN = PLUGIN

--for traits that are given when hitting certain attribute thresholds (non boosted)

--for now they will be preset since we only have a few of these
--a more dynamic system could be made if necessary
PLUGIN.attribTraits = {
	["str"] = "str_1",
	["per"] = "per_1",
	["end"] = "end_1",
	["cha"] = "cha_1",
	["int"] = "int_1",
	["agi"] = "agi_1",
	["luck"] = "luck_1",
}

function PLUGIN:OnCharAttribUpdated(client, char, attribID, value)
	if(!client) then
		client = char:getPlayer()
	end
	
	local traitID = PLUGIN.attribTraits[attribID]
	
	if(value <= 1) then
		if(!client:hasTrait(traitID)) then
			client:giveTrait(traitID, char)
		end
	else
		if(client:hasTrait(traitID)) then
			client:removeTrait(traitID, char)
		end
	end
end