ITEM.name = "Wasteland Slam"
ITEM.desc = "A hearty breakfast, fit for any chosen sole wandering courier, with two fried deathclaw eggs, a set of bighorner bacon and a cut of Brahmin ribeye with some pickled peppers to the side."
ITEM.uniqueID = "food_wastelandslam"
ITEM.model = "models/foodnhouseholditems/pancake.mdl"
ITEM.quantity2 = 1
ITEM.price = 5
ITEM.width = 1
ITEM.height = 1

ITEM.permit = "permit_food"

ITEM.hp = 50
ITEM.tags = {
	["Recipe"] = true,
}
ITEM.durationB = 1800 --attribute buff duration


ITEM.buffTbl = {
    attrib = {
		["str"] = 2,
		["agi"] = 2,
    },
}