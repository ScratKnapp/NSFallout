ITEM.name = "St. George Winery Merlot"
ITEM.desc = "A glass bottle filled with a dry, earthy wine."
ITEM.uniqueID = "alc_champagne"
ITEM.model = "models/mosi/fallout4/props/alcohol/wine.mdl"
ITEM.quantity2 = 1
ITEM.price = 12
ITEM.width = 1
ITEM.height = 1
ITEM.sound = "npc/barnacle/barnacle_gulp1.wav"
ITEM.color = Color(139,69,19)

ITEM.container = "j_empty_wine"
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
     ["cha"] = 1,
     ["int"] = -1,
	},

    evasion = -2,
    accuracy = -2,

}