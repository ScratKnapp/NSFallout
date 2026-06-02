ITEM.name = "Daddy-O"
ITEM.desc = "A small syringe with two vials of bright orange liquid, favored by intellectuals."
ITEM.model = "models/mosi/fallout4/props/aid/daddyo.mdl"
ITEM.uniqueID = "drug_daddyo"
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
 	 ["per"] = 1,
	 ["cha"] = -2,
	},
}


ITEM.effect = {
	colorMod = {
		["$pp_colour_addr"] = 0.,
		["$pp_colour_addg"] = 0,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = 0,
		["$pp_colour_contrast"] = 1,
		["$pp_colour_colour"] = 1.3,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0
	},
	
	sharpen = {
		contrast = 1,
		dist = 1
	},
	
	duration = 60,
}