ITEM.name = "Farseers' Sprout"
ITEM.prefix = "Orange"
ITEM.desc = "An orange herb, it has alchemical uses."
ITEM.uniqueID = "herb_orange"
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
			["Pierce"] = 2,
			["Slash"] = -5,
			["Blunt"] = -5,
		},
		
		evasion = 2,
		accuracy = 5,
	}	
}