ITEM.name = "Ranger Patrol Armor Vest"
ITEM.desc = "A newly produced set of combat armor issued to Texan Rangers."
ITEM.model = "models/thespireroleplay/items/clothes/group054.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(232.82006835938, 196.6298828125, 142),
	ang = Angle(25, 220, 0),
	fov = 4,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 1500
ITEM.durability = 12

ITEM.armor = 18
ITEM.reqStats = {
  ["str"] = 5,
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