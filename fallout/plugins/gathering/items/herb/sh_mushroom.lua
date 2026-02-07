ITEM.name = "Common Mushroom"
ITEM.prefix = "Mushroom"
ITEM.desc = "A regular-looking mushroom."
ITEM.uniqueID = "herb_mushroom"
ITEM.model = "models/models/fallout/vault22mushrooms02.mdl"

ITEM.tags = {
	["Ingredient"] = true,
	["Alchemical"] = true,
	["Herb"] = true,
}

ITEM.craft = {
	buffTbl = {
		res = {
			["Slash"] = -1.5,
			["Blunt"] = 4,
		},
		
		armor = 5,
	}	
}