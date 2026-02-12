ITEM.name = "Super Mutant Combat Armor Armguards MK2"
ITEM.desc = "Heavily reinforced armguards. Expensive and durable. Can stop a few bullets and attacks to the arms. Upsized for a Super Mutant."
ITEM.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
ITEM.height = 1
ITEM.width = 1
ITEM.price = 3500
ITEM.durability = 375
ITEM.faction = FACTION_MUTANT -- FACTION_MUTANT or FACTION_ROBOT
ITEM.category = "Equipment - Special"

ITEM.armor = {
	["Left Arm"] = 15,
	["Right Arm"] = 15,
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
