ITEM.name = "Brahmin Meat Pie"
ITEM.desc = "A meat pie with a somewhat sweet pastry dough, filled with a savory gravy, carrots, tato, and diced brahmin filling."
ITEM.uniqueID = "food_meatpie"
ITEM.model = "models/foodnhouseholditems/pie.mdl"
ITEM.quantity2 = 1
ITEM.price = 5
ITEM.width = 1
ITEM.height = 1

ITEM.permit = "permit_food"

ITEM.hp = 15
ITEM.durationB = 1800 --attribute buff duration

ITEM.tags = {
	["Recipe"] = true,
}

ITEM.buffTbl = {
    attrib = {
		["str"] = 2,
    },

}