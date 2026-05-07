ITEM.name = "Reinforced Leather Legguard"
ITEM.desc = "Reinforced leather shin guard that mitigate damage to your arm."
ITEM.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
ITEM.height = 1
ITEM.width = 1
ITEM.price = 50
ITEM.durability = 5

ITEM.armor = 10

ITEM.reqStats = {
  ["str"] = 2,
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