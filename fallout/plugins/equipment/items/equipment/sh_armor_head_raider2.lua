ITEM.name = "Raider Wastehound Helmet"
ITEM.desc = "A helmet made of several heavy burlap pieces stitched together."
ITEM.model = "models/fallout/apparel/helmetraider03.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(257.98406982422, 216, 158.90414428711),
	ang = Angle(25, 220, 0),
	fov = 2,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 25
ITEM.durability = 250

ITEM.armor = {
	["Head"] = 7,
}

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor
  ["Kinetic"] = 0, 
  ["Energy"] = 0, 
}
ITEM.specialSlot = "Headgear" --what slot it goes in
ITEM.skill = { --gives the player stats on equip
}