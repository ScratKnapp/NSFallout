ITEM.name = "Super Mutant Combat Greaves MK2"
ITEM.desc = "A pair of comfortable pants and uparmored reinforced alloys able to stop a lot of rounds or punishment from other weaponry. Upsized for Super Mutants."
ITEM.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
ITEM.height = 1
ITEM.width = 1
ITEM.price = 3500
ITEM.durability = 375
ITEM.faction = FACTION_MUTANT -- FACTION_MUTANT or FACTION_ROBOT
ITEM.category = "Equipment - Special"

ITEM.armor = {
	["Right Leg"] = 15,
	["Left Leg"] = 15,
}

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor, dont touch 
  ["Kinetic"] = 0,
  ["Energy"] = 0,
}
ITEM.specialSlot = "Legs" --what slot it goes in
ITEM.attrib = { --gives the player stats on equip
}