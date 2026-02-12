ITEM.name = "Armored Vault Suit"
ITEM.desc = "An insulated vault suit modified with padding."
ITEM.model = "models/fallout/apparel/vaultsuit.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-200, 0, 0),
	ang = Angle(0, -0, 0),
	fov = 7.6470588235294,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 150
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