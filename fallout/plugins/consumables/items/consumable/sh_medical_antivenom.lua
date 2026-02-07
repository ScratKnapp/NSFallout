ITEM.name = "Antivenom"
ITEM.desc = "Stops the effects of venom."
ITEM.uniqueID = "medical_antivenom"
ITEM.model = "models/fnv/clutter/health/antivenombark.mdl"
ITEM.quantity2 = 1
ITEM.price = 5
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Medical"

--this will remove any buffs with this listed as the effect
ITEM.cure = "venom"

ITEM.container = "j_garbage"
ITEM.containerMdl = true
ITEM.containerName = "Empty Antivenom"

ITEM.permit = "permit_medical"

ITEM.stomach = false