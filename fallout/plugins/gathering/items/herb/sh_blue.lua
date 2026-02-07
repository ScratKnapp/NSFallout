ITEM.name = "Lapisnare"
ITEM.prefix = "Blue"
ITEM.desc = "A blue herb, it has alchemical uses."
ITEM.uniqueID = "herb_blue"
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.material = "models/XQM/WoodPlankTexture"

ITEM.maxstack = 3

ITEM.tags = {
	["Alchemical"] = true,
	["Herb"] = true,
}

ITEM.craft = {
	mp = 5,

	buffTbl = {
		res = {
			["Water"] = 5,
			["Cold"] = 5,
		},
		
		mpMax = 2,
	}	
}