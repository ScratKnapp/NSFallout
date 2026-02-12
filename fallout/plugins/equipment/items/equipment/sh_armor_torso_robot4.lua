ITEM.name = "Military Grade Chassis Plating"
ITEM.desc = "Combat plating used by military grade robots. Able to take medium calibre bullets and impacts without issue. Male version."
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
ITEM.price = 2500
ITEM.durability = 325
ITEM.faction = FACTION_ROBOT -- FACTION_MUTANT or FACTION_ROBOT
ITEM.category = "Equipment - Special"

ITEM.armor = {
	["Body"] = 16,
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