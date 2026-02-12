ITEM.name = "Police Vest"
ITEM.desc = "An old pre-war police vest."
ITEM.model = "models/fallout/apparel/vaultsecurity.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(296.31988525391, 250.18536376953, 188.31330871582),
	ang = Angle(25, 220, 0),
	fov = 5.1441522421453,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 200
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