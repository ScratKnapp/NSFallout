ITEM.name = "Combat Armor Mk2"
ITEM.desc = "A set of pre-war body armor designed for the US Army, reinforced with heavier, more protective armor padding."
ITEM.model = "models/thespireroleplay/items/clothes/group053.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-200, 0, 1),
	ang = Angle(0, -0, 0),
	fov = 8,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 4000
ITEM.durability = 13

ITEM.armor = 22
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