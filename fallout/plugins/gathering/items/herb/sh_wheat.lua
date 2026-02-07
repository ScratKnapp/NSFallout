ITEM.name = "Wheat Grains"
ITEM.prefix = "Wheat"
ITEM.desc = "Grain harvested from a wheat plant, can be used to make bread."
ITEM.uniqueID = "herb_wheat"
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.material = "models/XQM/WoodPlankTexture"

ITEM.maxstack = 3

ITEM.tags = {
	["Alchemical"] = true,
	["Herb"] = true,
}

ITEM.craft = {
	hp = 3,
	
	buffTbl = {
		res = {
			["Disease"] = 2,
		},
	}	
}