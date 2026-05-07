ITEM.name = "Dunwick's Irish Red"
ITEM.desc = "A glass bottle filled with Irish red ale. It has a red label and a somewhat sweeter taste."
ITEM.uniqueID = "alc_ale"
ITEM.model = "models/mosi/fallout4/props/alcohol/beer.mdl"
ITEM.quantity2 = 1
ITEM.price = 8
ITEM.width = 1
ITEM.height = 1
ITEM.sound = "npc/barnacle/barnacle_gulp1.wav"
ITEM.color = Color(139,69,19)

ITEM.container = "j_empty_beer2"
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