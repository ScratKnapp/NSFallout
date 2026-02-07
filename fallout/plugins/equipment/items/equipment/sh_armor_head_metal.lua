ITEM.name = "Metal Helmet"
ITEM.desc = "A metal helmet."
ITEM.model = "models/fallout/apparel/helmetmetalarmor.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(147.84457397461, 123.80672454834, 95.21964263916),
	ang = Angle(25, 220, 0),
	fov = 4.5661462380343,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 250
ITEM.durability = 250

ITEM.armor = {
	["Head"] = 8,
}

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor
  ["Kinetic"] = 0,
  ["Energy"] = -3, 
}
ITEM.specialSlot = "Headgear" --what slot it goes in
ITEM.skill = { --gives the player stats on equip
}