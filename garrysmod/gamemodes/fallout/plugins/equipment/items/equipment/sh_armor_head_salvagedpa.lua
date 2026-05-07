ITEM.name = "Salvaged Power Armor Helmet"
ITEM.desc = "A power armor helmet that has had a lot of the wiring and components removed, and the padding lightened to make it wearable."
ITEM.model = "models/fallout/apparel/t60pahelmetgo.mdl"
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
ITEM.durability = 20

ITEM.armor = 30

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor, dont touch 
  ["Kinetic"] = 0,
  ["Energy"] = 0, 
}

ITEM.specialSlot = "Headgear" --what slot it goes in
ITEM.skill = { --gives the player stats on equip
}