ITEM.name = "Sugarcane"
ITEM.prefix = "Sugar"
ITEM.desc = "A soft, fluffy staple fiber that grows in a boll."
ITEM.uniqueID = "herb_sugar"
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.material = "models/XQM/WoodPlankTexture"

ITEM.maxstack = 3

ITEM.tags = {
	["Alchemical"] = true,
	["Herb"] = true,
}

ITEM.craft = {
	hp = 1,

	buffTbl = {
		res = {
			["Stun"] = 1,
			["Slow"] = 2,
		},
		
		evasion = 1,
	},

	attrib = {
		["stm"] = 0.2,
	}
}