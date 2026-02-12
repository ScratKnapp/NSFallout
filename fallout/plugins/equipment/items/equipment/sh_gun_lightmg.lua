ITEM.name = "Light Machinegun"
ITEM.desc = "Often referred to as 'Lanius' Buzzsaw', this LMG is chambered in 5mm and is produced within Arizona. "
ITEM.model = "models/weapons/battlefield1/parabellum mg14.mdl"
ITEM.width = 5
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(382.71774291992, 335.33892822266, 238.89999389648),
	ang = Angle(25, 220, 0),
	fov = 4,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "LMG" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 1500
ITEM.magSize = 60 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "5mm"

ITEM.dmg = {
	["5mm"] = 20
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-25,0,0,-75}ITEM.class = "aus_w_assaultrifle"

ITEM.reqStats = {
  ["str"] = 6,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.35, --this adds to the existing multiplier
		},
}

ITEM.upgradeSlots = {
["LMG Drum"] = true,
["LMG Heavy Barrel"] = true,
["LMG Scope"] = true,

}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.3, --this adds to the existing multiplier
		},
}

ITEM.skillScaleDmg = {
    ["guns"] = 0.15,
}

ITEM.skillScaleAcc = {
["guns"] = 1.5,
}

ITEM.actions = {	
"burstfire_lmg",
"suppression",
"aimedshot_precision",


}
