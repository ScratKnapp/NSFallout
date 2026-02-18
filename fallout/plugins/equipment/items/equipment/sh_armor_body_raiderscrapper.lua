ITEM.name = "Raider Scrapper Vest"
ITEM.desc = "An armor vest fashioned together with scrap metal, spikes, and bits and pieces."
ITEM.model = "models/fallout/apparel/raiderarmor01.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(271.25958251953, 231, 189),
	ang = Angle(28, 220, 0),
	fov = 4,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 60
ITEM.durability = 250

ITEM.armor = 5

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