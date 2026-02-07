ITEM.name = "Potent Silkleaf"
ITEM.prefix = "Silkleaf"
ITEM.desc = "A pink herb, it has alchemical uses."
ITEM.uniqueID = "herb_pink_rare"
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.material = "models/XQM/WoodPlankTexture"

ITEM.maxstack = 3

ITEM.tags = {
	["Alchemical"] = true,
	["Herb"] = true,
}

ITEM.craft = {
	buffTbl = {
		res = {
			["Slash"] = -4,
			["Sleep"] = -4,
			["Charm"] = 10,
			["Pain"] = 7,
			["Blunt"] = 6,
		},
		
		evasion = 5,
		accuracy = -2,
	}	
}