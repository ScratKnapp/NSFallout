ITEM.name = "Weight Reduction Kit"
ITEM.desc = "A set of replacement fabrics and tools to reduce the overall weight of armor and clothing."
ITEM.uniqueID = "armorup_evasion"
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
  ["Kinetic"] = -2.5,
  ["Energy"] = 0, 
}
ITEM.skill = { --gives the player stats on equip
  ["evasion"] = 2.5,

}
