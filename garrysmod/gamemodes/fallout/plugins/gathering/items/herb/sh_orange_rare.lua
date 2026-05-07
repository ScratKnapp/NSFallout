ITEM.name = "Potent Farseers' Sprout"
ITEM.prefix = "Orange"
ITEM.desc = "An orange herb, it has alchemical uses."
ITEM.uniqueID = "herb_orange_rare"
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
			["Pierce"] = 5,
			["Slash"] = -6,
			["Blunt"] = -6,
		},
		
		evasion = 4,
		accuracy = 7,
	}	
}