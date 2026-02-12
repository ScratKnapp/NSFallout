ITEM.name = "Combat Armor Mk2 Reinforced"
ITEM.desc = "An armor vest fashioned together with scrap metal, spikes, and bits and pieces."
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
ITEM.price = 4000
ITEM.durability = 250

ITEM.armor = {
	["Body"] = 27,
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