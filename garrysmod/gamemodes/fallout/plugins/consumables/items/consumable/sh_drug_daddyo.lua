ITEM.name = "Ingeniousos"
ITEM.desc = "A herbal mix coveted by the Cult of Mars and for the Elites of the Legion and Tribes, it improves the brain capacities for thoughts and deliberation, famously used by Legates on the eve of battle and Tribal Chiefs for cunning displays."
ITEM.model = "models/fnv/clutter/nvabsinthebottle/nvabsinthebottle.mdl"
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