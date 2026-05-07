ITEM.name = "Wasteland Tequila"
ITEM.desc = "An eastern cocktail with a tart and sweet taste."
ITEM.uniqueID = "drink_wastertequila"
ITEM.model = "models/mosi/fallout4/props/alcohol/warebrew.mdl"
ITEM.quantity2 = 1
ITEM.price = 5
ITEM.width = 1
ITEM.height = 1

ITEM.permit = "permit_food"

ITEM.hp = 0
ITEM.durationB = 1800 --attribute buff duration

ITEM.tags = {
	["Recipe"] = true,
}

ITEM.buffTbl = {
    attrib = {
		["end"] = 1,
		["cha"] = 2,
    },

}