ITEM.name = "Merc Veteran Reinforced"
ITEM.desc = "A blue leather jacket with re-bar shoulder arches and bracelets, along with a few war medals, a rebreather/gas mask of some kind hanging around the neck."
ITEM.model = "models/thespireroleplay/items/clothes/group019.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-200, 0, 0),
	ang = Angle(0, -0, 0),
	fov = 8,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 150
ITEM.durability = 250

ITEM.armor = 10

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor
  ["Kinetic"] = 0,
  ["Energy"] = 0, 
}
ITEM.specialSlot = "Body" --what slot it goes in
ITEM.skill = { --gives the player stats on equip
  ["guns"] = 2,

}