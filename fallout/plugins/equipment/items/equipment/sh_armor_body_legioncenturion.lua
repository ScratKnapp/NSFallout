ITEM.name = "Legion Centurion Armor"
ITEM.desc = "A set of legion armor composed of pieces taken from defeated opponents, between combat armor, supermutant armor, and even a piece of power armor."
ITEM.model = "models/thespireroleplay/items/clothes/group106.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-200, 0, 1),
	ang = Angle(0, -0, 0),
	fov = 8,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 4000
ITEM.durability = 250

ITEM.armor = {
	["Body"] = 25,
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