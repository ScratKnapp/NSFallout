ITEM.name = "Jumpsuit"
ITEM.desc = "A civilian use, generic engineer jumpsuit."
ITEM.model = "models/thespireroleplay/items/clothes/group006.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(264.48916625977, 222, 163.5),
	ang = Angle(25, 220, 0),
	fov = 4.5,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 25
ITEM.durability = 200

ITEM.armor = 0

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor
  ["Kinetic"] = 0,
  ["Energy"] = 0, 
}
ITEM.specialSlot = "Body" --what slot it goes in
ITEM.skill = { --gives the player stats on equip
  ["repair"] = 5,

}