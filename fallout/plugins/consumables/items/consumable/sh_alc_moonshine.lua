ITEM.name = "Benny's Best Moonshine"
ITEM.desc = "A repurposed bottle of Rooster's Rum filled with moonshine."
ITEM.uniqueID = "alc_moonshine"
ITEM.model = "models/mosi/fallout4/props/alcohol/moonshine.mdl"
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

    evasion = -4,
    accuracy = -4,

}