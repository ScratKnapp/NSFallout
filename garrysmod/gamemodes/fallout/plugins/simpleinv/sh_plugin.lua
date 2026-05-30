PLUGIN.name = "Simple Inv"
PLUGIN.author = "Cheesenut"
PLUGIN.desc = "Adds a simple inventory type."

nut.util.include("sh_simple_inv.lua")
nut.util.include("sv_migrate.lua")

local INVENTORY_TYPE_ID = "simple"
PLUGIN.INVENTORY_TYPE_ID = INVENTORY_TYPE_ID

function PLUGIN:GetDefaultInventoryType(character)
	return INVENTORY_TYPE_ID
end

-- Carry weight = FalloutStartCarryWeight + (Strength * FalloutStrCarryWeight).
-- Changing either config recomputes every online character's cap immediately.
local function recalcAllCarryWeights()
	for _, client in ipairs(player.GetAll()) do
		local char = client:getChar()
		if (char and char.CalculateMaxCarryWeight) then
			char:CalculateMaxCarryWeight()
		end
	end
end

nut.config.add("FalloutStartCarryWeight", 90, "Base carry weight every character has before Strength is added.", function(old, new)
	recalcAllCarryWeights()
end, {
	data = {min = 0, max = 100000},
	category = "Inventory"
})

nut.config.add("FalloutStrCarryWeight", 10, "Carry weight granted per point of Strength.", function(old, new)
	recalcAllCarryWeights()
end, {
	data = {min = 0, max = 100000},
	category = "Inventory"
})

if (SERVER) then
	-- Recompute when Strength changes (setAttrib/updateAttrib both fire this I hope?).
	function PLUGIN:OnCharAttribUpdated(client, character, attribID, value)
		if (attribID == "str" and character and character.CalculateMaxCarryWeight) then
			character:CalculateMaxCarryWeight()
		end
	end

	-- Recompute when a player swaps into a character.
	function PLUGIN:PlayerLoadedChar(client, character)
		if (character and character.CalculateMaxCarryWeight) then
			character:CalculateMaxCarryWeight()
		end
	end
end
