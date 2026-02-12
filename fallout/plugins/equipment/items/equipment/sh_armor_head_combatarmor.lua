ITEM.name = "Combat Armor Helmet"
ITEM.desc = "Combat armor helmet reproduced often in the wasteland."
ITEM.model = "models/fallout/apparel/combatarmorhelmet.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(123.16376495361, 103.34420013428, 74.970642089844),
	ang = Angle(25, 220, 0),
	fov = 4.4730550198259,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 1500
ITEM.durability = 250

ITEM.armor = {
	["Head"] = 17,
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