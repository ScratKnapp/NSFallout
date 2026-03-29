ITEM.name = "Trench Raider Legguards"
ITEM.desc = "Heavy plate metal armor that protects the stretch of the leg from heavy calibers."
ITEM.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
ITEM.height = 1
ITEM.width = 1
ITEM.price = 2500
ITEM.durability = 10

ITEM.armor = 20
ITEM.evasion = -10

ITEM.reqStats = {
  ["str"] = 6,
}
ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor
  ["Kinetic"] = 0,
  ["Energy"] = 0, 
}
ITEM.specialSlot = "Legs" --what slot it goes in
ITEM.attrib = { --gives the player stats on equip
}