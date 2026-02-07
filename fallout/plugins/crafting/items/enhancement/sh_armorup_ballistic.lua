ITEM.name = "Kevlar Inserts"
ITEM.desc = "A set of custom inserts to be applied to, or inserted into clothing and armor to help protect from physical/ballistic based damage."
ITEM.uniqueID = "armorup_ballistic"
ITEM.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
ITEM.flag = "v"
ITEM.category = "Upgrades"
ITEM.width = 1
ITEM.height = 1
ITEM.maxstack = 1

ITEM.slot = "Inserts"

ITEM.combiner = true
ITEM.armorOnly = true

ITEM.armor = 0 --DT based armor (FOR REF COMBAT MK2 (THE BEST ARMOR) HAS 15 ARMOR)
ITEM.res = { --percentage based armor (FOR REF COMBAT MK2 (THE BEST ARMOR) HAS 15 RES OF BOTH)
  ["Kinetic"] = 3,
  ["Energy"] = 0, 
}
ITEM.attrib = { --gives the player stats on equip
}