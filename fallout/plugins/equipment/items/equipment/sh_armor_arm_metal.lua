ITEM.name = "Metal Armguard"
ITEM.desc = "An iron metal armguard."
ITEM.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
ITEM.height = 1
ITEM.width = 1
ITEM.price = 250
ITEM.durability = 250

ITEM.armor = {
	["Left Arm"] = 8,
	["Right Arm"] = 8,
}

ITEM.upgradeSlots = {
	["Inserts"] = true,
}

ITEM.res = { --percentage based armor
  ["Kinetic"] = 0,
  ["Energy"] = -3, 
}
ITEM.specialSlot = "Arms" --what slot it goes in
ITEM.attrib = { --gives the player stats on equip
}