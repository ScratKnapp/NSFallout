local PLUGIN = PLUGIN

local LOOT = {}
LOOT.name = "Pants"
LOOT.desc = "A piece of armor that fits on your legs."
LOOT.model = "models/womensclothing10.mdl"
LOOT.slot = "Legs"
LOOT.item = "quest_equip_22"

LOOT.weight = 3
LOOT.armor = 8

LOOT.rarity = 20

LOOT.scaling = { --added to damage calculation
	["end"] = 1,
	["vitality"] = 1,
}

LOOTGEN:Register(LOOT)