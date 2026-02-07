local PLUGIN = PLUGIN

local LOOT = {}
LOOT.name = "Armor"
LOOT.desc = "A piece of armor that fits on your chest."
LOOT.model = "models/womensclothing6.mdl"
LOOT.slot = "Torso"
LOOT.item = "quest_equip_22"

LOOT.weight = 5
LOOT.armor = 10

LOOT.rarity = 20

LOOT.scaling = { --added to damage calculation
	["end"] = 1,
	["vitality"] = 1,
}

LOOTGEN:Register(LOOT)