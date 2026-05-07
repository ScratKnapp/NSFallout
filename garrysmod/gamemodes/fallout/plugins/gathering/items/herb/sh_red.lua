ITEM.name = "Bloodleaf"
ITEM.prefix = "Red"
ITEM.desc = "A red herb, it has alchemical uses."
ITEM.uniqueID = "herb_red"
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.material = "models/XQM/WoodPlankTexture"

ITEM.maxstack = 3

ITEM.tags = {
	["Alchemical"] = true,
	["Herb"] = true,
}

ITEM.craft = {
	hp = 8,

	buffTbl = {
		res = {
			["Fire"] = 2,
			["Lightning"] = 2,
		},
		
		hpMax = 3,
	}	
}