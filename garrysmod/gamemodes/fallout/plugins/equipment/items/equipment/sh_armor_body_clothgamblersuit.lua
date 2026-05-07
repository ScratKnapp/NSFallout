ITEM.name = "Gambler's Suit"
ITEM.desc = "A clean pressed three piece suit."
ITEM.model = "models/thespireroleplay/items/clothes/group001.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(236.03044128418, 198.07153320313, 143),
	ang = Angle(25, 220, 0),
	fov = 4.2,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 80
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
ITEM.attrib = { --gives the player stats on equip
  ["luck"] = 1,

}