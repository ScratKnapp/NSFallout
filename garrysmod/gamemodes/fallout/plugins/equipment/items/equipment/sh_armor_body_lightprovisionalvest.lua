ITEM.name = "Texan Union Vest"
ITEM.desc = "A set of blue Union fatigues with a standard protective metal breastplate and pauldrons. Adorned with the Texan Flag."
ITEM.model = "models/thespireroleplay/items/clothes/group055.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(236.03044128418, 198.07153320313, 143),
	ang = Angle(25, 220, 0),
	fov = 4.2,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 800
ITEM.durability = 8

ITEM.armor = 12
ITEM.reqStats = {
  ["str"] = 2,
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