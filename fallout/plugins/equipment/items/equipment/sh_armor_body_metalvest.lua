ITEM.name = "Metal Vest"
ITEM.desc = "A heavy, crudely fashioned metal vest."
ITEM.model = "models/fallout/apparel/metalarmor.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-200, 0, 0),
	ang = Angle(0, -0, 0),
	fov = 8,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 300
ITEM.durability = 250

ITEM.armor = {
	["Body"] = 14,
}

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor
  ["Kinetic"] = 0,
  ["Energy"] = -5, 
}
ITEM.specialSlot = "Body" --what slot it goes in
ITEM.skill = { --gives the player stats on equip
  ["evasion"] = -2,

}