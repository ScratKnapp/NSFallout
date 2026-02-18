ITEM.name = "Follower Doctor Coat"
ITEM.desc = "An white lab coat over a white blouse, ordained with a Follower logo on the breast of the coat."
ITEM.model = "models/thespireroleplay/items/clothes/group007.mdl"
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
  ["medicine"] = 5,

}