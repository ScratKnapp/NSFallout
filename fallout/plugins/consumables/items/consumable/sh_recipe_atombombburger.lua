ITEM.name = "Atom Bomb Burger"
ITEM.desc = "The glory of American culinary advancements, reborn. A loaf of toasted bread, with a large prime deathclaw patty, covered in a thin melted Brahmin cheese, slices of bighorner bacon, one slice of tato, and strips of jalapeno pepper on top. Often paired with Nuka-Cola, for the taste of pre-war greatness."
ITEM.uniqueID = "food_burger"
ITEM.model = "models/foodnhouseholditems/burgergtasa.mdl"
ITEM.quantity2 = 1
ITEM.price = 250
ITEM.width = 1
ITEM.height = 1

ITEM.permit = "permit_food"

ITEM.hp = 5
ITEM.durationB = 1800 --attribute buff duration

ITEM.tags = {
	["Recipe"] = true,
}

ITEM.buffTbl = {
	attrib = {
		["str"] = 1,
		["per"] = 1,
		["end"] = 1,
		["agi"] = 1,
	},
	res = {
		["Kinetic"] = 10,
    },
	amp = {
		["Kinetic"] = 10,
	},
}