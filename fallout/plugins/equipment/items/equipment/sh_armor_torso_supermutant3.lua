ITEM.name = "Metal Armor XXXL"
ITEM.desc = "Metal Armor wrapping around the torso. With a few spikes protruding from the shoulder pauldrons. Commonly seen by experienced bounty hunters or mercenaries. Upscaled to fit a Super Mutant."
ITEM.model = "models/fallout/apparel/metalarmor.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
pos = Vector(-200, 0, 1),
ang = Angle(0, -0, 0),
fov = 8,
outline = true,
outlineColor = Color(15, 250, 0),
}
ITEM.price = 150
ITEM.durability = 300
ITEM.faction = FACTION_MUTANT -- FACTION_MUTANT or FACTION_ROBOT
ITEM.category = "Equipment - Special"

ITEM.armor = {
	["Body"] = 9,
}

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor, dont touch 
  ["Kinetic"] = 0,
  ["Energy"] = -10, 
}
ITEM.specialSlot = "Body" --what slot it goes in
ITEM.skill = { --gives the player stats on equip
}
