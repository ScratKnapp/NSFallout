ITEM.name = "Potent Ghostroot"
ITEM.prefix = "White"
ITEM.desc = "A white herb, it has alchemical uses."
ITEM.uniqueID = "herb_white_rare"
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
			["Poison"] = 8,
			["Disease"] = 8,
			["Fire"] = 4,
			["Lightning"] = 4,
			["Water"] = 4,
			["Cold"] = 4,
		},
	}	
}