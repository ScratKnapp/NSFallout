ITEM.name = "Recon Armor Mk2"
ITEM.desc = "An advanced vacuum sealed asbestos jumpsuit with a protective metal vest and padding."
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
ITEM.durability = 250

ITEM.armor = {
	["Body"] = 24,
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