ITEM.name = "Legion Centurion Manica"
ITEM.desc = "Steel forged helmet in the design of old Roman galea helmet."
ITEM.model = "models/fallout/apparel/centurionhelmet_go.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(234.72770690918, 197.38557434082, 153.60202026367),
	ang = Angle(25, 220, 0),
	fov = 4.9036579393495,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 2500
ITEM.durability = 250

ITEM.armor = 20

ITEM.upgradeSlots = {
["Inserts"] = true,

}

ITEM.res = { --percentage based armor
  ["Kinetic"] = 0,
  ["Energy"] = 0, 
}
ITEM.specialSlot = "Headgear" --what slot it goes in
ITEM.skill = { --gives the player stats on equip
}