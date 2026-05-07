ITEM.name = "Deathclaw Omelet"
ITEM.desc = "Beaten deathclaw eggs cooked in a pan with some butter, and folded in half, filled with slices of tato and maize."
ITEM.uniqueID = "food_deathclawomelet"
ITEM.model = "models/mosi/fallout4/props/food/deathclawomelette.mdl"
ITEM.quantity2 = 1
ITEM.price = 5
ITEM.width = 1
ITEM.height = 1

ITEM.permit = "permit_food"

ITEM.hp = 30
ITEM.durationB = 1800 --attribute buff duration

ITEM.tags = {
	["Recipe"] = true,
}

ITEM.buffTbl = {
    attrib = {
		["end"] = 1,
		["luck"] = 1,
    },

}