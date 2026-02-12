ITEM.name = "Security CPU Housing Unit."
ITEM.desc = "A large metal housing unit that covers the robots sensitive CPU and optical sensors. Able to deflect a bullet or stop a swing."
ITEM.model = "models/maxib123/enclavelockersmall.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
pos = Vector(138.3452911377, 116.09999847412, 91),
ang = Angle(25, 220, 0),
fov = 4,
outline = true,
outlineColor = Color(15, 250, 0),
}
ITEM.price = 500
ITEM.durability = 300
ITEM.faction = FACTION_ROBOT -- FACTION_MUTANT or FACTION_ROBOT
ITEM.category = "Equipment - Special"

ITEM.armor = {
	["Head"] = 12,
}

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