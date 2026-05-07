ITEM.name = "Reinforced Metal Greave"
ITEM.desc = "A reinforced iron metal greave."
ITEM.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
ITEM.height = 1
ITEM.width = 1
ITEM.price = 500
ITEM.durability = 6

ITEM.armor = 15
ITEM.evasion = -8

ITEM.reqStats = {
  ["str"] = 3,
}
ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor
  ["Kinetic"] = 0,
  ["Energy"] = -25, 
}
ITEM.specialSlot = "Legs" --what slot it goes in
ITEM.attrib = { --gives the player stats on equip
}