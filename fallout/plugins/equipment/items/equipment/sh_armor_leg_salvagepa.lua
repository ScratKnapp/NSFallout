ITEM.name = "Salvaged Power Armor Greaves"
ITEM.desc = "Heavy power armor greaves that have had joints removed and plates lightened."
ITEM.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
ITEM.height = 1
ITEM.width = 1
ITEM.price = 2500
ITEM.durability = 20

ITEM.armor = 30
ITEM.evasion = -20

ITEM.reqStats = {
  ["str"] = 8,
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