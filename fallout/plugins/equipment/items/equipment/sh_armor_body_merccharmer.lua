ITEM.name = "Merc Charmer Outfit"
ITEM.desc = "A faded suit top and pants with a protective collar."
ITEM.model = "models/thespireroleplay/items/clothes/group018.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-200, 0, 1),
	ang = Angle(0, -0, 0),
	fov = 8,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 30
ITEM.durability = 250

ITEM.armor = {
	["Body"] = 1,
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
  ["speech"] = 2,

}