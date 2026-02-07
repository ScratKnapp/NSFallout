ITEM.name = "Doctor's Bag"
ITEM.desc = "A bag full of instruments and chems commonly used for treating stabilized injuries and wounds. Comes with a set of instructions for those who need it.\nFirst Aid: +10HP*Medicine Modifier."
ITEM.model = "models/maxib123/doctorsbag.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.specialSlot = "Primary"
ITEM.category = "Weapon - Medical"
ITEM.durability = 500
ITEM.price = 500
 
ITEM.weight = 1
ITEM.weapondual = false

ITEM.skillScaleDmg = {
	["medicine"] = 0.15,
}

ITEM.skillScaleAcc = {
	["medicine"] = 1,
}

ITEM.actions = {	
	"med_aid",
}
