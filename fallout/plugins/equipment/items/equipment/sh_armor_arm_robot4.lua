ITEM.name = "Military Grade Arm Plating"
ITEM.desc = "Reinforced metal plating used in most military robot models. Durable and resilient to most bullets and heavier impacts."
ITEM.model = "models/maxib123/enclavelockersmall.mdl"
ITEM.height = 1
ITEM.width = 1
ITEM.price = 2500
ITEM.durability = 350
ITEM.faction = FACTION_ROBOT -- FACTION_MUTANT or FACTION_ROBOT
ITEM.category = "Equipment - Special"

ITEM.armor = {
	["Left Arm"] = 14,
	["Right Arm"] = 14,
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
