ITEM.name = "NCR Trooper Fatigues"
ITEM.desc = "A standard issue set of fatigues, pants, and boots."
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
ITEM.price = 80
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
}