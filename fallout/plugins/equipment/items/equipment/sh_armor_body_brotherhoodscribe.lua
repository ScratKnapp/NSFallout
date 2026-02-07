ITEM.name = "Brotherhood Scribe Outfit"
ITEM.desc = "A long robe with a thick belt around the midsection."
ITEM.model = "models/thespireroleplay/items/clothes/group102.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-200, 0, 1),
	ang = Angle(0, -0, 0),
	fov = 8,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 120
ITEM.durability = 250

ITEM.armor = {
	["Body"] = 5,
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
  ["science"] = 2,

}