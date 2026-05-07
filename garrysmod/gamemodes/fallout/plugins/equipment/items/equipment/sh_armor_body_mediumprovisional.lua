ITEM.name = "Provisional Combat Armor Vest"
ITEM.desc = "A Texan set of combat armor copying the association design, meant to be easier and cheaper to produce."
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