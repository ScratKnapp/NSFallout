ITEM.name = "Legion Praetor Armor"
ITEM.desc = "A set of treated and fashioned legion armor with forged plating and pads, as well as a short red cape and cowl.."
ITEM.model = "models/thespireroleplay/items/clothes/group106.mdl"
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
ITEM.durability = 18

ITEM.armor = 23
ITEM.evasion = -30

ITEM.reqStats = {
  ["str"] = 6,
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