local PLUGIN = PLUGIN

local LOOT = {}
LOOT.name = "Drug"
LOOT.desc = "Some sort of drug."
LOOT.model = "models/props_junk/garbage_metalcan002a.mdl"
LOOT.item = "quest_consume"

LOOT.rarity = 0 --really low number so it wont drop

--[[
	buffTbl = {
		attrib = {
			["str"] = 1,
		},
		res = {
			["Fire"] = 1,
		},
		amp = {
			["Fire"] = 1,
		},

		hpMax = 5,
		mpMax = 5,
		apMax = 1,
		evasion = 1,
		accuracy = 1,
		armor = 1,
		critC = 1,
		critM = 1,
		magic = 1,
	}
	
	ap = 1,
	hp = 5,
	mp = 5,
--]]

LOOTGEN:Register(LOOT)