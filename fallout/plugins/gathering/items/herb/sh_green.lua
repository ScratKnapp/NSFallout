ITEM.name = "Viridi"
ITEM.prefix = "Green"
ITEM.desc = "A green herb, it has alchemical uses."
ITEM.uniqueID = "herb_green"
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.material = "models/XQM/WoodPlankTexture"

ITEM.maxstack = 3

ITEM.tags = {
	["Alchemical"] = true,
	["Herb"] = true,
}

ITEM.craft = {
	hp = -3,

	buffTbl = {
		hpMax = -2,
	}	
}