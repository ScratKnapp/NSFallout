ITEM.name = "Vault Security Vest"
ITEM.desc = "An old Vault-Tec issued, lightweight security guard vest."
ITEM.model = "models/fallout/apparel/vaultsecurity.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(-200, 0, 0),
	ang = Angle(0, -0, 0),
	fov = 10,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 250
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