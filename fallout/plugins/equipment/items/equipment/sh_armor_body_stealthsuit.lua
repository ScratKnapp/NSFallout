ITEM.name = "Stealth Suit MK.II"
ITEM.desc = "A cutting edge infiltration suit that comes with an automated control system and adapts to the wearer."
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
ITEM.durability = 250

ITEM.armor = 15

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor
  ["Kinetic"] = 0,
  ["Energy"] = 0, 
}
ITEM.specialSlot = "Body" --what slot it goes in
ITEM.skill = { --gives the player stats on equip
  ["evasion"] = 10,

}