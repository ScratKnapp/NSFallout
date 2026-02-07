ITEM.name = "Vault Suit"
ITEM.desc = "A fitted jumpsuit for use by Vault dwellers."
ITEM.model = "models/fallout/apparel/vaultsuit.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(264.48916625977, 222, 163.5),
	ang = Angle(25, 220, 0),
	fov = 4.5,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 25
ITEM.durability = 250

ITEM.armor = {
	["Body"] = 0,
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