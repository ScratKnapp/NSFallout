ITEM.name = "Molerat Stew"
ITEM.desc = "A stew made of mole rat meat and vegetables, simple and seasoned enough to mask the pungent taste of mole rat."
ITEM.uniqueID = "food_moleratstew"
ITEM.model = "models/fnv/clutter/food/ratstew01.mdl"
ITEM.quantity2 = 1
ITEM.price = 5
ITEM.width = 1
ITEM.height = 1

ITEM.permit = "permit_food"

ITEM.hp = 15
ITEM.tags = {
	["Recipe"] = true,
}
ITEM.durationB = 1800 --attribute buff duration

ITEM.buffTbl = {
    attrib = {
		["end"] = 1,
    },
    accuracy = 5,
}