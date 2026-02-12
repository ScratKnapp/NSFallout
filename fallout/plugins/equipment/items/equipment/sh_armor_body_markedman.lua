ITEM.name = "Marked Vest"
ITEM.desc = "A tattered mash of NCR breastplate, legion padding, and old pieces and parts."
ITEM.model = "models/thespireroleplay/items/clothes/group057.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-200, 0, 1),
	ang = Angle(0, -0, 0),
	fov = 8,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 400
ITEM.durability = 250

ITEM.armor = {
	["Body"] = 15,
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