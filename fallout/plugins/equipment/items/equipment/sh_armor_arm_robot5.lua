ITEM.name = "Prototype Arm Plating"
ITEM.desc = "Heavily reinforced pre-war plating. Expensive and durable. Can withstand a lot of punishment from high caliber munitions and impacts."
ITEM.model = "models/maxib123/enclavelockersmall.mdl"
ITEM.height = 1
ITEM.width = 1
ITEM.price = 5000
ITEM.durability = 375
ITEM.faction = FACTION_ROBOT -- FACTION_MUTANT or FACTION_ROBOT
ITEM.category = "Equipment - Special"

ITEM.armor = 16

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