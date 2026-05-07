ITEM.name = "Provisional Kneepads"
ITEM.desc = "Leather kneepad to be placed over standard Texan fatigues."
ITEM.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
ITEM.height = 1
ITEM.width = 1
ITEM.price = 250
ITEM.durability = 5

ITEM.armor = 12

ITEM.reqStats = {
  ["str"] = 4,
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