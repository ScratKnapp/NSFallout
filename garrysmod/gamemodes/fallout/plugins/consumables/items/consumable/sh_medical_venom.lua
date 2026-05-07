ITEM.name = "Venom"
ITEM.desc = "It's venom."
ITEM.uniqueID = "medical_venom"
ITEM.model = "models/mosi/fnv/props/health/healingpowder.mdl"
ITEM.quantity2 = 1
ITEM.price = 5
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Medical"

--this will remove any buffs with this listed as the effect
ITEM.buffTbl = {
	name = "Envenomated",
	effect = "venom",
	duration = 8,
	dmg = 8,
	dmgT = "Venom",
	strength = 1,

	debuff = true,
}

ITEM.permit = "permit_medical"

ITEM.stomach = false