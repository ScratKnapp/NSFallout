ITEM.name = "Radramen"
ITEM.desc = "A bowl of boiled noodles with slices of Brahmin meat, shredded and softened xander root, and salted cuts of cave fungus. For the most discerning of tastes, and popular on the west coast."
ITEM.uniqueID = "food_radramen"
ITEM.model = "models/fnv/clutter/food/ramen01.mdl"
ITEM.quantity2 = 1
ITEM.price = 5
ITEM.width = 1
ITEM.height = 1

ITEM.permit = "permit_food"

ITEM.hp = 40
ITEM.tags = {
	["Recipe"] = true,
}
ITEM.durationB = 1800 --attribute buff duration

ITEM.buffTbl = {
    attrib = {
		["per"] = 2,
		["int"] = 1,
		["agi"] = 1,
    },
    res = {
		["Energy"] = 10,
    },
    amp = {
		["Energy"] = 10,
    },

}