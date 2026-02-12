ITEM.name = "Legion Vexillarius Armor"
ITEM.desc = "A modified set of veteran armor with added lining and padding, as well as metal plates to the torso and a legion flag banner."
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
ITEM.price = 2000
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