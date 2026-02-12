ITEM.name = "Refurbished Chassis Plating"
ITEM.desc = "Restored plating that belonged to commercial robots. Able to take a few nicks and dings."
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
ITEM.price = 200
ITEM.durability = 275
ITEM.faction = FACTION_ROBOT -- FACTION_MUTANT or FACTION_ROBOT
ITEM.category = "Equipment - Special"

ITEM.armor = {
	["Body"] = 12,
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