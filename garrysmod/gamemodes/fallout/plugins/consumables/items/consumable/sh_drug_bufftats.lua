ITEM.name = "Bufftats"
ITEM.desc = "A pharmaceutical concoction that attempted to sell pills that not only effectively gave one strength, but also affected mental processing power to make you stronger, AND smarter than everyone else."
ITEM.model = "models/mosi/fallout4/props/aid/buffout.mdl"
ITEM.uniqueID = "drug_bufftat"
ITEM.quantity2 = 1
ITEM.price = 0
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Drugs"
 
ITEM.stomach = false
 
ITEM.permit = "permit_drug"
 
ITEM.duration = 1800
 
ITEM.buffTbl = {
	attrib = {
	 ["str"] = 2,
	 ["end"] = 1,
	 ["int"] = 1,
	},
}

ITEM.effect = {
	colorMod = {
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = 0.1,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = 0,
		["$pp_colour_contrast"] = 0.9,
		["$pp_colour_colour"] = 2,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0
	},
	
	duration = 60,
}