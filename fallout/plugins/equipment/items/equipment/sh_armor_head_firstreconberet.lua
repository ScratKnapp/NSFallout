ITEM.name = "NCR First Recon Beret"
ITEM.desc = "A red beret given to members of the 1st Reconnaissance Battalion of the NCR."
ITEM.model = "models/fallout/apparel/red_beret.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(85.295570373535, 71.530746459961, 52.177623748779),
	ang = Angle(25, 220, 0),
	fov = 4.3272078289618,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 250
ITEM.durability = 250

ITEM.armor = {
	["Head"] = 5,
}

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor
  ["Kinetic"] = 0,
  ["Energy"] = 0, 
}
ITEM.specialSlot = "Headgear" --what slot it goes in
ITEM.skill = { --gives the player stats on equip
  ["guns"] = 2,

}