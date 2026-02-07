ITEM.name = "Cowboy Coffee"
ITEM.desc = "Boiled honey mesquite pods, mixed with a healthy kick of whiskey."
ITEM.uniqueID = "drink_cowboycoffee"
ITEM.model = "models/mosi/fallout4/props/junk/coffeecup.mdl"
ITEM.quantity2 = 1
ITEM.price = 5
ITEM.width = 1
ITEM.height = 1

ITEM.permit = "permit_food"

ITEM.hp = 10
ITEM.durationB = 1800 --attribute buff duration

ITEM.tags = {
	["Recipe"] = true,
}

ITEM.buffTbl = {
    attrib = {
		["per"] = 1,
		["agi"] = 1,
    },
}