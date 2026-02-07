ITEM.name = "Cotton"
ITEM.prefix = "Cotton"
ITEM.desc = "A soft, fluffy staple fiber that grows in a boll."
ITEM.uniqueID = "herb_cotton"
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.material = "models/XQM/WoodPlankTexture"

ITEM.maxstack = 3

ITEM.tags = {
	["Alchemical"] = true,
	["Herb"] = true,
}

ITEM.craft = {
	hp = 3,
	
	buffTbl = {
		res = {
			["Fire"] = -2,
			["Cold"] = 4,
		},
	}	
}