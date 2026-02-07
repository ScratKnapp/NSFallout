ITEM.name = "Cuttus"
ITEM.desc = "A Supplemental Herbal used by the most violent of Tribals for a enraged sense of violence, deranging them to use their slashing weapons to be most effective."
ITEM.model = "models/mosi/fallout4/props/food/deathclawsouffle.mdl"
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