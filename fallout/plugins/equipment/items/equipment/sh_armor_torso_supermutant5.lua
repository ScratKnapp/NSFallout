ITEM.name = "Combat Armor MK2 XXXL"
ITEM.desc = "A very expensive yet sturdy piece of combat armor. Reinforced to take a lot of bullets and a strong beating. Upscaled for Super Mutants."
ITEM.model = "models/thespireroleplay/items/clothes/group053.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
pos = Vector(-200, 0, 1),
ang = Angle(0, -0, 0),
fov = 8,
outline = true,
outlineColor = Color(15, 250, 0),
}
ITEM.price = 3500
ITEM.durability = 350
ITEM.faction = FACTION_MUTANT -- FACTION_MUTANT or FACTION_ROBOT
ITEM.category = "Equipment - Special"

ITEM.armor = {
	["Body"] = 15,
}

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor, dont touch 
  ["Kinetic"] = 0,
  ["Energy"] = 0, 
}
ITEM.specialSlot = "Body" --what slot it goes in
ITEM.skill = { --gives the player stats on equip
}