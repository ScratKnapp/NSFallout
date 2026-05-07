ITEM.name = "Trench Raider Armpad"
ITEM.desc = "Heavy plate metal armor that protects the stretch of the arm from heavy calibers."
ITEM.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
ITEM.height = 1
ITEM.width = 1
ITEM.price = 250
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
ITEM.specialSlot = "Arms" --what slot it goes in
ITEM.attrib = { --gives the player stats on equip
}