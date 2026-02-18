ITEM.name = "NCR Ranger Combat Armor"
ITEM.desc = "An armored pre-war riot armor vest repurposed for NCR rangers."
ITEM.model = "models/thespireroleplay/items/combatranger_go.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(177.21347045898, 148.60562133789, 107),
	ang = Angle(25, 220, 0),
	fov = 4.6802378562107,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 4000
ITEM.durability = 250

ITEM.armor = 25

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