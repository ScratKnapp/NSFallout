ITEM.name = "Stealth Suit Mk2 Helmet"
ITEM.desc = "A protective helmet that works alongside the Stealth Suit MK2 and its automated personality to help monitor battlefield conditions and regulate the wearer's status."
ITEM.model = "models/fallout/apparel/stealthsuithelm.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
pos = Vector(138.3452911377, 116.09999847412, 91),
ang = Angle(25, 220, 0),
fov = 4,
outline = true,
outlineColor = Color(15, 250, 0),
}
ITEM.price = 50
ITEM.durability = 9

ITEM.armor = 15

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor, dont touch 
  ["Kinetic"] = 0,
  ["Energy"] = 0, 
}
ITEM.specialSlot = "Headgear" --what slot it goes in
ITEM.skill = { --gives the player stats on equip
  ["stealth"] = 5,

}