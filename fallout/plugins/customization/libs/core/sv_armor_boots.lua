local PLUGIN = PLUGIN

local LOOT = {}
LOOT.name = "Boots"
LOOT.desc = "A piece of armor that fits on your feet."
LOOT.model = "models/womensclothing12.mdl"
LOOT.slot = "Feet"
LOOT.item = "quest_equip_21"

LOOT.weight = 2
LOOT.armor = 5

LOOT.rarity = 21

LOOT.scaling = { --added to damage calculation
	["end"] = 1,
	["vitality"] = 1,
}

LOOTGEN:Register(LOOT)