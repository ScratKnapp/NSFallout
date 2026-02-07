ITEM.name = "Super Mutant Reinforced Leather Armguards"
ITEM.desc = "Leather Bindings for Supermutants that help against cuts and impacts. Reinforced and made better by a Wasteland craftsman."
ITEM.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
ITEM.height = 1
ITEM.width = 1
ITEM.price = 75
ITEM.durability = 300
ITEM.faction = FACTION_MUTANT -- FACTION_MUTANT or FACTION_ROBOT
ITEM.category = "Equipment - Special"

ITEM.armor = {
	["Left Arm"] = 6,
	["Right Arm"] = 6,
}

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor, dont touch 
  ["Kinetic"] = 0,
  ["Energy"] = 0,
}
ITEM.specialSlot = "Arms" --what slot it goes in
ITEM.attrib = { --gives the player stats on equip
}
