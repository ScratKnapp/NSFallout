ITEM.name = "Raider Sadist Vest"
ITEM.desc = "A mostly revealing outfit of leather belts and corsage, dark pants with spiked pads and a single belt over the shoulder."
ITEM.model = "models/fallout/apparel/raiderarmor02.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(257.80465698242, 215.4372253418, 160.65202331543),
	ang = Angle(25, 220, 0),
	fov = 4.9902156725605,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 70
ITEM.durability = 250

ITEM.armor = 6

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