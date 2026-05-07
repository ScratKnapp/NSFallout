ITEM.name = "Mentats"
ITEM.desc = "A box of chalky red tablets that improve memory-related function and processes."
ITEM.model = "models/mosi/fallout4/props/aid/mentats.mdl"
ITEM.uniqueID = "drug_mentats"
ITEM.quantity2 = 1
ITEM.price = 0
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Drugs"
 
ITEM.stomach = false
 
ITEM.permit = "permit_drug"
 
ITEM.buffTbl = {
	attrib = {
	 ["int"] = 2,
	},

}

ITEM.duration = 1800

ITEM.effect = {
	colorMod = {
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = 0,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = 0.1,
		["$pp_colour_contrast"] = 2,
		["$pp_colour_colour"] = 2,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0
	},
	
	duration = 60,
}