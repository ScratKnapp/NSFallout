ITEM.name = "R91 Assault Rifle"
ITEM.desc = "A pre-war series of rifles that served as the national guard's standard issue rifle."
ITEM.model = "models/halokiller38/fallout/weapons/assaultrifles/r91assaultrifle.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(457.16708374023, 396, 282.54205322266),
	ang = Angle(25, 220, 0),
	fov = 2.6,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Rifle" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 1400
ITEM.magSize = 24 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "5.56"

ITEM.dmg = {
	["5.56"] = 24
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-25,1,0,-75}
ITEM.class = "aus_w_r91"

ITEM.reqStats = {
  ["str"] = 4,
}

ITEM.skillScaleDmg = {
    ["guns"] = 0.15,
}

ITEM.upgradeSlots = {
["R91 Scope"] = true,
["R91 Heavy Barrel"] = true,

}

ITEM.skillScaleAcc = {
["guns"] = 1.5,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.25, --this adds to the existing multiplier
		},
}

ITEM.actions = {	
"burstfire_rifle",
"aimedshot_precision",
"suppression1",

}
