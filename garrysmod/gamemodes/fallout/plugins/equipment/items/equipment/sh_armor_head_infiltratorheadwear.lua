ITEM.name = "Infiltrator Headgear"
ITEM.desc = "A set of headgear issued to pre-war scouts of the 1st Texas Cavalry."
ITEM.model = "models/fallout/fallouthhh/operator/fo4operatorgoggles2.mdl"
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
ITEM.durability = 200

ITEM.armor = 0

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor, dont touch 
  ["Kinetic"] = 0,
  ["Energy"] = 0, 
}
ITEM.specialSlot = "Headgear" --what slot it goes in
ITEM.skill = { --gives the player stats on equip
  ["evasion"] = 10,
}