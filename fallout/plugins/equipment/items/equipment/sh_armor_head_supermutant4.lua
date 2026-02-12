ITEM.name = "Combat Armor Helmet XXXL"
ITEM.desc = "A combat helmet. Made to deflect bullets and absorb swings. Upscaled for a Super Mutant."
ITEM.model = "models/fallout/apparel/combatarmorhelmet.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
pos = Vector(138.3452911377, 116.09999847412, 91),
ang = Angle(25, 220, 0),
fov = 4,
outline = true,
outlineColor = Color(15, 250, 0),
}
ITEM.price = 1500
ITEM.durability = 325
ITEM.faction = FACTION_MUTANT -- FACTION_MUTANT or FACTION_ROBOT
ITEM.category = "Equipment - Special"

ITEM.armor = {
	["Head"] = 14,
}

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor, dont touch 
  ["Kinetic"] = 0,
  ["Energy"] = 0, 
}
ITEM.specialSlot = "Headgear" --what slot it goes in
ITEM.skill = { --gives the player stats on equip
}
