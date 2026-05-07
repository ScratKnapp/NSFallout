ITEM.name = "Combat Armor Vest"
ITEM.desc = "An advanced set of Combat Armor designed pre-war for the US Army."
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
ITEM.price = 3000
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