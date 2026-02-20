ITEM.name = "Legion Veteran Manica"
ITEM.desc = "An aluminum helmet, facewrap and goggles."
ITEM.model = "models/fallout/apparel/legionhelmetbase_go.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(148.92472839355, 124.18300628662, 96.747131347656),
	ang = Angle(25, 220, 0),
	fov = 4.5707355562219,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 250
ITEM.durability = 250

ITEM.armor = 18

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