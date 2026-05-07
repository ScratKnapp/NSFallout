local PLUGIN = PLUGIN

local LOOT = {}
LOOT.name = "Helmet"
LOOT.desc = "A helmet that protects your head."
LOOT.model = "models/skyrim/helmet_studded_argonian.mdl"
LOOT.slot = "Head"
LOOT.item = "quest_equip_11"

LOOT.weight = 2
LOOT.armor = 5

LOOT.rarity = 20

LOOT.scaling = { --added to damage calculation
	["end"] = 1,
	["vitality"] = 1,
}

LOOTGEN:Register(LOOT)