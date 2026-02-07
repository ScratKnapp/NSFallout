ITEM.name = "Riot Gear"
ITEM.desc = "An advanced design of specialized combat armor for the US Marine Corps and select Law Enforcement agencies."
ITEM.model = "models/fallout/apparel/combatranger.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(233.8180847168, 196.19665527344, 142.330078125),
	ang = Angle(25, 220, 0),
	fov = 4.8980843846201,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 5000
ITEM.durability = 250

ITEM.armor = {
	["Body"] = 30,
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