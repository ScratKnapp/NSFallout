ITEM.name = "Slasher"
ITEM.desc = "A highly addictive wasteland mix of med-x and psycho."
ITEM.model = "models/mosi/fnv/props/health/chems/psycho.mdl"
ITEM.uniqueID = "drug_slasher"
ITEM.quantity2 = 1
ITEM.price = 0
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Drugs"
 
ITEM.stomach = false
 
ITEM.permit = "permit_drug"
 
ITEM.duration = 1800
 
ITEM.buffTbl = {
	res = {
    ["Energy"] = 25,
	["Kinetic"] = 25,
    },
	amp = {
	["Energy"] = 15,
	["Kinetic"] = 15,
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