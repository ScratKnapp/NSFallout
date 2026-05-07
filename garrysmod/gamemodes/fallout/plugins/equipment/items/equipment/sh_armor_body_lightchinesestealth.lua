ITEM.name = "Chinese Stealth Armor"
ITEM.desc = "A form-fitting, armored set of advanced pre-war stealth armor with a camouflage system embedded."
ITEM.model = "models/fallout/apparel/stealthsuit.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(309.86538696289, 259, 192),
	ang = Angle(25, 220, 0),
	fov = 4,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 7000
ITEM.durability = 9

ITEM.armor = 13
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
  ["Sneak"] = 5,

}