ITEM.name = "Legion Recruit Helmet"
ITEM.desc = "A leather cap and facewrap."
ITEM.model = "models/fallout/apparel/legionbandana_go.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(160.21110534668, 133.95512390137, 103.36936187744),
	ang = Angle(25, 220, 0),
	fov = 4.6132100680746,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 50
ITEM.durability = 250

ITEM.armor = 12

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