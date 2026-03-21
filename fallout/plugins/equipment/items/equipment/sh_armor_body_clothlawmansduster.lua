ITEM.name = "Lawman's Duster"
ITEM.desc = "A long leather duster favored by lawmen in remote places."
ITEM.model = "models/thespireroleplay/items/clothes/group015.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-200, 0, 1),
	ang = Angle(0, -0, 0),
	fov = 8,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 40
ITEM.durability = 200

ITEM.armor = 2

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor
  ["Kinetic"] = 0,
  ["Energy"] = 0, 
}
ITEM.specialSlot = "Body" --what slot it goes in
