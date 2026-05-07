ITEM.name = "Potent Bloodleaf"
ITEM.prefix = "Red"
ITEM.desc = "A red herb, it has alchemical uses."
ITEM.uniqueID = "herb_red_rare"
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.material = "models/XQM/WoodPlankTexture"

ITEM.maxstack = 3

ITEM.tags = {
	["Alchemical"] = true,
	["Herb"] = true,
}

ITEM.craft = {
	hp = 16,

	buffTbl = {
		res = {
			["Fire"] = 4,
			["Lightning"] = 4,
		},
		
		hpMax = 6,
	}	
}