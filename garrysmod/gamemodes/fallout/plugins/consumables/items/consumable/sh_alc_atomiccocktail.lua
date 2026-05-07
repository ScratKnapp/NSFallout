ITEM.name = "Atomic Cocktail"
ITEM.desc = "A novelty drink mixer shaped like a rocket ship, filled with equal parts vodka and Nuka-Cola, and ground mentats."
ITEM.uniqueID = "alc_atomiccocktail"
ITEM.model = "models/fnv/clutter/junk/nvatomiccocktail.mdl"
ITEM.quantity2 = 1
ITEM.price = 8
ITEM.width = 1
ITEM.height = 1
ITEM.sound = "npc/barnacle/barnacle_gulp1.wav"
ITEM.color = Color(139,69,19)

ITEM.container = "j_empty_bottle"
ITEM.containerMdl = true

ITEM.flag = "v"
ITEM.permit = "permit_alcohol"

ITEM.hp = 5
ITEM.durationB = 1800 --attribute buff duration

ITEM.tags = {
	["Drink"] = true,
	["Alcohol"] = true,
	["Ingredient"] = true,
}

ITEM.buffTbl = {
    attrib = {
     ["str"] = 1,
	 ["int"] = -1,
	},
	res = {
		["Energy"] = 25,
    },
	evasion = -4,
}