ITEM.name = "Jet"
ITEM.desc = "An small inhaler and canister filled with a highly addictive aerosol mixed chem."
ITEM.model = "models/mosi/fallout4/props/aid/jet.mdl"
ITEM.uniqueID = "drug_jet"
ITEM.quantity2 = 1
ITEM.price = 0
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Drugs"

ITEM.stomach = false
 
ITEM.permit = "permit_drug"
 
ITEM.buffTbl = {
	attrib = {
	 ["agi"] = 2,
	},
	evasion = 3,
}

ITEM.duration = 1800

ITEM.effect = {
	sharpen = {
		contrast = 1,
		dist = 1
	},
	
	duration = 60,
}