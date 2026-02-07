ITEM.name = "Silkleaf"
ITEM.prefix = "Silkleaf"
ITEM.desc = "A pink herb, it has alchemical uses."
ITEM.uniqueID = "herb_pink"
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
			["Slash"] = -2.5,
			["Sleep"] = -2.5,
			["Charm"] = 5,
			["Pain"] = 3,
			["Blunt"] = 3,
		},
		
		evasion = 2.5,
	}	
}