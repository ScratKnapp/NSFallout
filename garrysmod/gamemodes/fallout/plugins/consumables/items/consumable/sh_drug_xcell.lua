ITEM.name = "X-Cell"
ITEM.desc = "A prototype general performance enhancer that leaked into the black market before the great war."
ITEM.model = "models/mosi/fallout4/props/aid/xcell.mdl"
ITEM.uniqueID = "drug_xcell"
ITEM.quantity2 = 1
ITEM.price = 600
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Drugs"
 
ITEM.stomach = false
 
ITEM.permit = "permit_drug"
 
ITEM.duration = 600
 
ITEM.buffTbl = {
	attrib = {
		["str"] = 2,
		["per"] = 2,
		["end"] = 2,
		["cha"] = 2,
		["int"] = 2,
		["agi"] = 2,
		["luck"] = 2,
	},
	evasion = 5,
	accuracy = 5,
}

ITEM.effect = {
	sharpen = {
		contrast = 1,
		dist = 1
	},
	
	duration = 60,
}