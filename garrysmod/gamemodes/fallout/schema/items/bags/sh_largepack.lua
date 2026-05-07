local INVENTORY_TYPE_ID = "grid"

ITEM.name = "Large Backpack"
ITEM.desc = "A large backpack that allows you to carry more things."
ITEM.model = "models/vex/fallout76/backpacks/atx_backpack_surplussack.mdl"
ITEM.width = 3
ITEM.height = 3
ITEM.invWidth = 7
ITEM.invHeight = 7
ITEM.category = "Storage"
ITEM.flag = "v"
ITEM.price = 100
ITEM.uniqueID = "largepack"

ITEM.isBag = true

ITEM.iconCam = {
	pos = Vector(0, 200, 11),
	ang = Angle(0, 270, 0),
	fov = 7,
}

--this is used to make checking for other backpacks in the inventory a little less more efficient
ITEM.otherBags = {
	smallpack = true,
	mediumpack = true,
	largepack = true,
	pack_alice = true,
	pack_enhanced = true,
	stor_suitcase = true,
	stor_briefcase = true
}