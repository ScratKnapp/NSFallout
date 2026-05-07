ITEM.name = "Plate Covering"
ITEM.desc = "A set of raw scrap metal pieces welded together to be placed over armor, as additional protection."
ITEM.uniqueID = "armorup_scrap"
ITEM.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
ITEM.flag = "v"
ITEM.category = "Upgrades"
ITEM.width = 1
ITEM.height = 1
ITEM.maxstack = 1

ITEM.slot = "Inserts"

ITEM.combiner = true
ITEM.armorOnly = true

ITEM.armor = 4 --DT based armor (FOR REF COMBAT MK2 (THE BEST ARMOR) HAS 15 ARMOR)
ITEM.res = { --percentage based armor (FOR REF COMBAT MK2 (THE BEST ARMOR) HAS 15 RES OF BOTH)
  ["Kinetic"] = 0,
  ["Energy"] = -2, 
}
ITEM.attrib = { --gives the player stats on equip
}