ITEM.name = "Texan Expeditionary Body Armor"
ITEM.desc = "An old set of Brotherhood combat armor made in limited amounts."
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
ITEM.price = 1500
ITEM.durability = 11

ITEM.armor = 16
ITEM.reqStats = {
  ["str"] = 4,
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