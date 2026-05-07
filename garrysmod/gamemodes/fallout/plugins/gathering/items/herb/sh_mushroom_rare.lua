ITEM.name = "Rare Mushroom"
ITEM.prefix = "Mushroom"
ITEM.desc = "A rare-looking mushroom."
ITEM.uniqueID = "herb_mushroom_rare"
ITEM.model = "models/models/fallout/vault22mushrooms03.mdl"

ITEM.tags = {
	["Ingredient"] = true,
	["Alchemical"] = true,
	["Herb"] = true,
}

ITEM.craft = {
	buffTbl = {
		res = {
			["Slash"] = -2,
			["Blunt"] = 7,
		},
		
		armor = 12,
	}	
}