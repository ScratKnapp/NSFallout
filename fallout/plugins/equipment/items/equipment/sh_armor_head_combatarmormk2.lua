ITEM.name = "Combat Armor Mk2 Helmet"
ITEM.desc = "Advanced combat armor helmet of pre-war design that is highly protective."
ITEM.model = "models/fallout/apparel/mark1combathelmet.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(115.32581329346, 96.300003051758, 76),
	ang = Angle(25.39999961853, 220, 0),
	fov = 4.4434826723139,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 3500
ITEM.durability = 250

ITEM.armor = {
	["Head"] = 20,
}

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor
  ["Kinetic"] = 0,
  ["Energy"] = 0, 
}
ITEM.specialSlot = "Headgear" --what slot it goes in
ITEM.skill = { --gives the player stats on equip
}