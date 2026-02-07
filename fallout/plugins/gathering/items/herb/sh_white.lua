ITEM.name = "Ghostroot"
ITEM.prefix = "White"
ITEM.desc = "A white herb, it has alchemical uses."
ITEM.uniqueID = "herb_white"
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
			["Poison"] = 5,
			["Disease"] = 5,
			["Fire"] = 2,
			["Lightning"] = 2,
			["Water"] = 2,
			["Cold"] = 2,
		},
	}	
}