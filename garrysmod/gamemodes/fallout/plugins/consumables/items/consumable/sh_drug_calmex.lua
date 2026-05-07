ITEM.name = "Usgaya"
ITEM.desc = "A Cherokee origin herb, used by the Cherokee traditionally for the preparation and mourning process of funerals, its popularity grew out of Legion trade caravans and was brought to the wider Arizona as a herb to calm the persons self in battle."
ITEM.model = "models/fnv/clutter/food/nv_wastelandomelette.mdl"
ITEM.uniqueID = "drug_calmex"
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
 	 ["per"] = 2,
	 ["agi"] = 1,
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