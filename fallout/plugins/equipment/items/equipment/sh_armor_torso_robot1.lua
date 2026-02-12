ITEM.name = "Rusty Damaged Chassis Plating."
ITEM.desc = "Cheap and damaged plating that belonged to commercial robots. Dug out of a scrap pile."
ITEM.model = "models/maxib123/enclavelockersmall.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
pos = Vector(-200, 0, 1),
ang = Angle(0, -0, 0),
fov = 8,
outline = true,
outlineColor = Color(15, 250, 0),
}
ITEM.price = 100
ITEM.durability = 250
ITEM.faction = FACTION_ROBOT -- FACTION_MUTANT or FACTION_ROBOT
ITEM.category = "Equipment - Special"

ITEM.armor = {
	["Body"] = 10,
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
