ITEM.name = "Fire Mancus Water"
ITEM.desc = " Illegal in Most Legion Territories, yet the sweetly alcohol restores woes in the coldest of desert nights, best hope your Centurion overlooks such contraband."
ITEM.model = "models/fnv/clutter/liquorbottles/whiskeybottle01.mdl "
ITEM.uniqueID = "drug_hydra"
ITEM.quantity2 = 1
ITEM.price = 0
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Drugs"
 
ITEM.stomach = false
 
ITEM.permit = "permit_drug"

ITEM.hp = 25
ITEM.duration = 1800
 
ITEM.buffTbl = {
	attrib = {
	 ["str"] = 2,
	 ["end"] = 2,
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