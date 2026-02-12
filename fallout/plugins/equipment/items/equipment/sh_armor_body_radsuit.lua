ITEM.name = "Protective Hazard Suit"
ITEM.desc = "A sealed, insulated and padded suit."
ITEM.model = "models/fallout/apparel/radsuit.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(257, 215, 155),
	ang = Angle(25, 220, 0),
	fov = 4,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 300
ITEM.durability = 250

ITEM.armor = {
	["Body"] = 1,
}

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor
  ["Kinetic"] = 0,
  ["Energy"] = 0,
  ["Radiation"] = 95,
}
ITEM.specialSlot = "Body" --what slot it goes in
ITEM.skill = { --gives the player stats on equip
}