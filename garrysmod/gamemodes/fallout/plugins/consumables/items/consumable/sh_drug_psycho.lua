ITEM.name = "Cruentus"
ITEM.desc = "A concoction formed by Gladiators of Flagstaff to give them victory, the Cruentus is part hallucinogen part steroid, a unrivaled remedy for fast violent gory action."
ITEM.model = "models/fnv/clutter/food/desertsalad.mdl"
ITEM.uniqueID = "drug_psycho"
ITEM.quantity2 = 1
ITEM.price = 0
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Drugs"
 
ITEM.stomach = false
 
ITEM.permit = "permit_drug"
 
ITEM.duration = 1800
 
ITEM.buffTbl = {
	amp = {
		["Energy"] = 25,
		["Kinetic"] = 25,
	},
}

ITEM.effect = {
	colorMod = {
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = 0,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = 0.2,
		["$pp_colour_contrast"] = 1,
		["$pp_colour_colour"] = 3,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0.1,
		["$pp_colour_mulb"] = 0
	},
	
	duration = 60,
}