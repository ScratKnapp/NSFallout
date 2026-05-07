ITEM.name = "Cigarette Pack"
ITEM.desc = "A pack of old nicotine sticks."
ITEM.model = "models/mosi/fallout4/props/junk/cigarettecarton.mdl"
ITEM.uniqueID = "drug_cigarettes"
ITEM.quantity2 = 10
ITEM.price = 30
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Drugs"

ITEM.stomach = false

ITEM.permit = "permit_drug"

ITEM.duration = 1800
ITEM.hp = 0
 
ITEM.buffTbl = {
	attrib = {
	 ["cha"] = 1,
	},

}

ITEM.effect = {
	sharpen = {
		contrast = 1,
		dist = 1
	},
	
	duration = 60,
}