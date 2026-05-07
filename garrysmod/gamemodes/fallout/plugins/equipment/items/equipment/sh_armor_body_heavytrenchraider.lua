ITEM.name = "Trench Raider Armor"
ITEM.desc = "A set of heavy steel plates layered over leather padding to provide the heaviest amount of armor plating possible outside of flat out power armor."
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
ITEM.durability = 28

ITEM.armor = 30
ITEM.evasion = -35

ITEM.reqStats = {
  ["str"] = 7,
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