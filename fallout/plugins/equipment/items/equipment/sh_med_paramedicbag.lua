ITEM.name = "Paramedic's Bag"
ITEM.desc = "A bag full of advanced instruments and chems used for stabilizing those with major and serious injuries. Requires a certain understanding of medicine to use.\nAdvanced Care: +15HP*Medicine Modifier."
ITEM.model = "models/vex/fallout76/backpacks/atx_backpack_firstresponders.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.specialSlot = "Primary"
ITEM.category = "Weapon - Medical"
ITEM.durability = 500
ITEM.price = 500
 
ITEM.weight = 1
ITEM.weapondual = false

ITEM.skillScaleDmg = {
	["medicine"] = 0.5,
}

ITEM.skillScaleAcc = {
	["medicine"] = 1,
}

ITEM.actions = {	
	"med_care",
}
