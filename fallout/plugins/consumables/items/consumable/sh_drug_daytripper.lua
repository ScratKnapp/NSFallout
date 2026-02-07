ITEM.name = "Udatana-Iga"
ITEM.desc = "Used to make the day go by Yavapai Brahmin Herders, developed in the aftermath of Legion Conquest as a looked-down upon concoction for its perceived usefulness and idle-mindedness effect on its user, favoured by Shamans and Cult of Mars for specific religious ceremonies."
ITEM.model = "models/fnv/clutter/junk/nv/xanderroot.mdl"
ITEM.uniqueID = "drug_daytripper"
ITEM.quantity2 = 1
ITEM.price = 0
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Drugs (Common)"
 
ITEM.stomach = false
 
ITEM.permit = "permit_underground"
 
ITEM.duration = 1800
 
ITEM.buffTbl = {
	attrib = {
	 ["str"] = -1,
 	 ["per"] = -1,
	 ["luck"] = 3,
	},
}

ITEM.effect = {
	colorMod = {
		["$pp_colour_addr"] = 0.1,
		["$pp_colour_addg"] = 0,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = -0.25,
		["$pp_colour_contrast"] = 1.25,
		["$pp_colour_colour"] = 1,
		["$pp_colour_mulr"] = 0.5,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0
	},
	
	duration = 60,
}