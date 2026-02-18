ITEM.name = "Raider Iconoclast Helmet"
ITEM.desc = "A set of sealed cap, mining helmet, and rebreather."
ITEM.model = "models/fallout/apparel/minerhelmetgo.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(164.28433227539, 140, 104.41752624512),
	ang = Angle(25, 220, 0),
	fov = 3,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 75
ITEM.durability = 250

ITEM.armor = 10

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