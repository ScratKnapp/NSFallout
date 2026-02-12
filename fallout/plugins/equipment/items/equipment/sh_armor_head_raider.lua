ITEM.name = "Raider Arclight Helmet"
ITEM.desc = "An old welding helmet used by construction workers."
ITEM.model = "models/fallout/apparel/helmetraider02.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(145.63652038574, 122, 85),
	ang = Angle(25, 220, 0),
	fov = 4.5462596622697,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 25
ITEM.durability = 250

ITEM.armor = {
	["Head"] = 6,
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