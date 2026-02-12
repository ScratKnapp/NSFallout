ITEM.name = "Tribal Raiding Armor"
ITEM.desc = "A tribal vest of leather and hide. "
ITEM.model = "models/fallout/apparel/raiderarmor03.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(267.06045532227, 223.65573120117, 166.77540588379),
	ang = Angle(25, 220, 0),
	fov = 3,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 90
ITEM.durability = 250

ITEM.armor = {
	["Body"] = 5,
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