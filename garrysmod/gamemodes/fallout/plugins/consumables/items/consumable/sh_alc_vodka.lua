ITEM.name = "Surkov Import"
ITEM.desc = "A bottle of pre-war vodka made of glowing resin instead of potatoes."
ITEM.uniqueID = "alc_vodka"
ITEM.model = "models/mosi/fallout4/props/alcohol/vodka.mdl"
ITEM.quantity2 = 1
ITEM.price = 15
ITEM.width = 1
ITEM.height = 1
ITEM.sound = "npc/barnacle/barnacle_gulp1.wav"
ITEM.color = Color(139,69,19)

ITEM.container = "j_empty_vodka"
ITEM.containerMdl = true

ITEM.flag = "v"
ITEM.permit = "permit_alcohol"

ITEM.hp = 3
ITEM.durationB = 1800 --attribute buff duration

ITEM.tags = {
	["Drink"] = true,
	["Alcohol"] = true,
	["Ingredient"] = true,
}

ITEM.buffTbl = {
    attrib = {
		["str"] = 2,
		["int"] = -1,
	},
    evasion = -4,
}