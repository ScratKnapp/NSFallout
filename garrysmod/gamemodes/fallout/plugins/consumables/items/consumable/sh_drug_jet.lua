ITEM.name = "Sudor Stercus"
ITEM.desc = "The most addictive and common of the herbal drugs, the Sudor Stercus imbues the user with a temporary cheap high and makes them sweat profusely, even in the coldest of nights as well as other involuntary side effects, with the ingredients of Sudor Stercus changing from Shaman to Maker imbuing it with a feared reputation for the most down and out of the Legion territories."
ITEM.model = "models/bf1/gadgets/adrenaline syringe.mdl"
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