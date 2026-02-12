ITEM.name = "Security Leg Plating"
ITEM.desc = "Leg plating used by most commercial grade security units pre-war. Protects from small calibre bullets and dings."
ITEM.model = "models/maxib123/enclavelockersmall.mdl"
ITEM.height = 1
ITEM.width = 1
ITEM.price = 500
ITEM.durability = 325
ITEM.faction = FACTION_ROBOT -- FACTION_MUTANT or FACTION_ROBOT
ITEM.category = "Equipment - Special"

ITEM.armor = {
	["Right Leg"] = 12,
	["Left Leg"] = 12,
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
