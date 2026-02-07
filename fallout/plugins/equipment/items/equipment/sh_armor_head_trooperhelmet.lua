ITEM.name = "NCR Trooper Helmet"
ITEM.desc = "Standard issue NCR Pith helmet."
ITEM.model = "models/fallout/apparel/trooperhelm.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(138.3452911377, 116.09999847412, 91),
	ang = Angle(25, 220, 0),
	fov = 4,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 250
ITEM.durability = 250

ITEM.armor = {
	["Head"] = 8,
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
}