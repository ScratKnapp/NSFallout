ITEM.name = "Raider Armor Vest"
ITEM.desc = "An outfit of leather belts, straps and a tire for a shoulderpad, along with a heavyduty quilt."
ITEM.model = "models/fallout/apparel/raiderarmor04.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(270.77575683594, 227.34471130371, 169.05471801758),
	ang = Angle(25, 220, 0),
	fov = 5.0406637362755,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 80
ITEM.durability = 250

ITEM.armor = {
	["Body"] = 6,
}

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor
  ["Kinetic"] = 0,
  ["Energy"] = 0, 
}
ITEM.specialSlot = "Body" --what slot it goes in
ITEM.skill = { --gives the player stats on equip
}