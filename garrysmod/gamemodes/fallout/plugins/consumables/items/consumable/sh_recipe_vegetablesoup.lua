ITEM.name = "Vegetable Soup"
ITEM.desc = "A stew made of tato, potato, gourd, and silt beans."
ITEM.uniqueID = "food_vegsoup"
ITEM.model = "models/fnv/clutter/food/ratstew01.mdl"
ITEM.quantity2 = 1
ITEM.price = 5
ITEM.width = 1
ITEM.height = 1

ITEM.permit = "permit_food"

ITEM.hp = 25
ITEM.tags = {
	["Recipe"] = true,
}
ITEM.durationB = 1800 --attribute buff duration

ITEM.buffTbl = {
    attrib = {
		["cha"] = 1,
		["int"] = 1,
    },
}