ITEM.name = "Leather Kneepad"
ITEM.desc = "Leather kneepad that mitigate damage to your leg."
ITEM.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
ITEM.height = 1
ITEM.width = 1
ITEM.price = 50
ITEM.durability = 3

ITEM.armor = 7

ITEM.reqStats = {
  ["str"] = 1,
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