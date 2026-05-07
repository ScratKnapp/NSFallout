ITEM.name = "Pre-War Clothing"
ITEM.desc = "A set of old pre-war clothing."
ITEM.model = "models/thespireroleplay/items/clothes/group059.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-200, 0, 1),
	ang = Angle(0, -0, 0),
	fov = 8,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 10
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
}