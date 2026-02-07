ITEM.name = "Reinforced Combat Armor"
ITEM.desc = "An reinforced vest of pre-war designed combat armor."
ITEM.model = "models/thespireroleplay/items/clothes/group012.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-200, 0, 1),
	ang = Angle(0, -0, 0),
	fov = 8,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 2000
ITEM.durability = 250

ITEM.armor = {
	["Body"] = 20,
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