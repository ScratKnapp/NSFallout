ITEM.name = "Rusty Robot Arm Plating"
ITEM.desc = "Rusted scrap metal plating for robots, usually used for commercial and cheap robots pre-war. Dug out of a scrap-pile."
ITEM.model = "models/maxib123/enclavelockersmall.mdl"
ITEM.height = 1
ITEM.width = 1
ITEM.price = 100
ITEM.durability = 250
ITEM.faction = FACTION_ROBOT -- FACTION_MUTANT or FACTION_ROBOT
ITEM.category = "Equipment - Special"

ITEM.armor = {
	["Left Arm"] = 8,
	["Right Arm"] = 8,
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
