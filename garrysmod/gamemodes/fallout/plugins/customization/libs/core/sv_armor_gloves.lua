local PLUGIN = PLUGIN

local LOOT = {}
LOOT.name = "Gloves"
LOOT.desc = "A piece of armor that fits on your hands."
LOOT.model = "models/womensclothing5.mdl"
LOOT.slot = "Hands"
LOOT.item = "quest_equip_21"

LOOT.weight = 1.5
LOOT.armor = 4

LOOT.rarity = 20

LOOT.scaling = { --added to damage calculation
	["end"] = 1,
	["vitality"] = 1,
}

LOOTGEN:Register(LOOT)