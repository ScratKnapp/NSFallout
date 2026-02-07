ITEM.name = "Potent Fortune Flower"
ITEM.prefix = "Purple"
ITEM.desc = "A purple herb, it has alchemical uses."
ITEM.uniqueID = "herb_purple_rare"
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
			["Pierce"] = -5,
			["Slash"] = -5,
			["Blunt"] = -5,
		},
		
		critC = 4,
		critM = 0.1,
	}	
}