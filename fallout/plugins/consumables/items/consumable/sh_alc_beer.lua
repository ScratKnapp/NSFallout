ITEM.name = "Gwinnet Dead Red Stout"
ITEM.desc = "A glass bottle filled with an east coast stout with a bitter chocolatey taste."
ITEM.uniqueID = "alc_beer"
ITEM.model = "models/mosi/fallout4/props/alcohol/beer.mdl"
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

ITEM.hp = 3
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
    evasion = -4,

}