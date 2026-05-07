ITEM.name = "Infiltrator Armor"
ITEM.desc = "A set of Recon Armor from the pre-war days, likely given to an elite scout."
ITEM.model = "models/fallout/apparel/bosunderarmor.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(259.92752075195, 216, 157),
	ang = Angle(25, 220, 0),
	fov = 4.9992674099035,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 3000
ITEM.durability = 10

ITEM.armor = 14
ITEM.reqStats = {
  ["str"] = 3,
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
  ["Evasion"] = 10,
}