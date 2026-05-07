local PLUGIN = PLUGIN

local LOOT = {}
LOOT.name = "Armored Hat"
LOOT.desc = "A hat for your head."
LOOT.model = "models/skyrim/helmet_merchant_argonian.mdl"
LOOT.slot = "Head"
LOOT.item = "quest_equip_11"

LOOT.weight = 1
LOOT.armor = 2.5

LOOT.rarity = 25

LOOT.scaling = { --added to damage calculation
	["end"] = 1,
	["vitality"] = 1,
}

LOOTGEN:Register(LOOT)