ITEM.name = "Roaming Trader's Outfit"
ITEM.desc = "A coat lined with pouches to assist with carrying goods."
ITEM.model = "models/fallout/apparel/wastelandmerchant01.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(268.11938476563, 227.43533325195, 167.48776245117),
	ang = Angle(25, 220, 0),
	fov = 5.0309796405892,
	outline = true,
	outlineColor = Color(15, 250, 0),
}
ITEM.price = 80
ITEM.durability = 250

ITEM.armor = {
	["Body"] = 1,
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
  ["speech"] = 2,

}