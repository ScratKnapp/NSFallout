ITEM.name = "NCR Ranger Combat Helmet"
ITEM.desc = "The NCR's iconic pre-war helmet design accompanied by facemask and visor."
ITEM.model = "models/fallout/apparel/combatrangerhelmet.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(132.39237976074, 112.95805358887, 87.059074401855),
	ang = Angle(25, 220, 0),
	fov = 4.5148041699427,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 2500
ITEM.durability = 250

ITEM.armor = {
	["Head"] = 22,
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