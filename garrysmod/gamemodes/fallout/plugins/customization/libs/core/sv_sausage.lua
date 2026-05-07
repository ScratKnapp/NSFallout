local PLUGIN = PLUGIN

local LOOT = {}
LOOT.name = "Sausage"
LOOT.desc = "A meaty sausage."
LOOT.model = "models/props_junk/garbage_metalcan002a.mdl"
LOOT.item = "quest_consume"

LOOT.rarity = 0 --really low number so it wont drop

LOOTGEN:Register(LOOT)