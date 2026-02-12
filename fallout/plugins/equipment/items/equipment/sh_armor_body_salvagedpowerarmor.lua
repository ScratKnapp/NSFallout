ITEM.name = "NCR Salvaged Power Armor"
ITEM.desc = "A set of lightened, modified T-45d power armor which has had the joint servos removed to allow anyone to wear without training."
ITEM.model = "models/fallout/apparel/power_armor.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(314.00857543945, 263, 190),
	ang = Angle(25, 220, 0),
	fov = 4.5,
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
  ["evasion"] = -10,

}