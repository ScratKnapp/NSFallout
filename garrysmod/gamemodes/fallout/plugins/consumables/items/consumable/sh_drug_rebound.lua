ITEM.name = "Rebound"
ITEM.desc = "A metal hip flask filled with vials and filled with liquid, that is mixed and then injected on the spot."
ITEM.model = "models/mosi/fnv/props/health/chems/rebound.mdl"
ITEM.uniqueID = "drug_rebound"
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
 	 ["per"] = 1,
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