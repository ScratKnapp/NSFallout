ITEM.name = "Raider Iconoclast Suit"
ITEM.desc = "An insulated suit with leather padding and belts for added protection."
ITEM.model = "models/fallout/apparel/minerarmorgo.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(226.49681091309, 190.05337524414, 138),
	ang = Angle(25, 220, 0),
	fov = 4.2,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 150
ITEM.durability = 250

ITEM.armor = {
	["Body"] = 10,
}

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor
  ["Kinetic"] = 0,
  ["Energy"] = 0, 
}
ITEM.specialSlot = "Body" --what slot it goes in
ITEM.skill = { --gives the player stats on equip
}