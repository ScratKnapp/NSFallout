ITEM.name = "Super Mutant Metal Leg Armor"
ITEM.desc = "Metal sheets over a pair of pants. Can stop a round on a lucky day."
ITEM.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
ITEM.height = 1
ITEM.width = 1
ITEM.price = 100
ITEM.durability = 325
ITEM.faction = FACTION_MUTANT -- FACTION_MUTANT or FACTION_ROBOT
ITEM.category = "Equipment - Special"

ITEM.armor = {
	["Right Leg"] = 9,
	["Left Leg"] = 9,
}

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor, dont touch 
  ["Kinetic"] = 0,
  ["Energy"] = -10,
}
ITEM.specialSlot = "Legs" --what slot it goes in
ITEM.attrib = { --gives the player stats on equip
}