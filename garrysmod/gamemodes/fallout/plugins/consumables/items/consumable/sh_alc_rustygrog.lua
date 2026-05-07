ITEM.name = "'Rusty Grog'"
ITEM.desc = "A locally made bottle of strong, distilled alcohol. It tastes, and smells awful."
ITEM.uniqueID = "alc_wine"
ITEM.model = "models/mosi/fallout4/props/junk/bottle03.mdl"
ITEM.quantity2 = 1
ITEM.price = 20
ITEM.width = 1
ITEM.height = 1
ITEM.sound = "npc/barnacle/barnacle_gulp1.wav"
ITEM.color = Color(139,69,19)

ITEM.container = "j_empty_bottle"
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
	res = {
		["Kinetic"] = 10,
    },
	evasion = -4,
    accuracy = -4,

}