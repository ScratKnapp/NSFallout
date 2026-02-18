ITEM.name = "Vault Security Helmet"
ITEM.desc = "A Vault-Tec issued security helmet, light and resistant to low calibers."
ITEM.model = "models/fallout/apparel/vaultsecurityhelmet.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(127.14259338379, 107.05124664307, 82.097274780273),
	ang = Angle(25, 220, 0),
	fov = 4.4900239522245,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 250
ITEM.durability = 250

ITEM.armor = 10

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