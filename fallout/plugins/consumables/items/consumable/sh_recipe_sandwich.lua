ITEM.name = "Scavver's Sandwich"
ITEM.desc = "A sandwich made from slices of a dry loaf, tato, cuts of gecko meat, and dried bloodleaves."
ITEM.uniqueID = "food_sandwich"
ITEM.model = "models/foodnhouseholditems/sandwich.mdl"
ITEM.quantity2 = 1
ITEM.price = 5
ITEM.width = 1
ITEM.height = 1

ITEM.permit = "permit_food"

ITEM.hp = 25
ITEM.tags = {
	["Recipe"] = true,
}
ITEM.durationB = 1800 --attribute buff duration

ITEM.buffTbl = {
    attrib = {
		["agi"] = 1,
    },

}