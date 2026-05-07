ITEM.name = "Potent Lapisnare"
ITEM.prefix = "Blue"
ITEM.desc = "A blue herb, it has alchemical uses."
ITEM.uniqueID = "herb_blue_rare"
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.material = "models/XQM/WoodPlankTexture"

ITEM.maxstack = 3

ITEM.tags = {
	["Alchemical"] = true,
	["Herb"] = true,
}

ITEM.craft = {
	mp = 10,

	buffTbl = {
		res = {
			["Water"] = 8,
			["Cold"] = 8,
		},
		
		mpMax = 4,
	}	
}