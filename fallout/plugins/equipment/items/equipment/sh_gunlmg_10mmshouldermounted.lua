ITEM.name = "Shoulder Mounted Machinegun"
ITEM.desc = "A reconfigured mini-gun to be supported over the shoulder, chambered in 10mm."
ITEM.model = "models/halokiller38/fallout/weapons/heavy weapons/shouldermountedmg.mdl"
ITEM.width = 6
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(450.82968139648, 380.5, 270),
	ang = Angle(25, 220, 0),
	fov = 4.4,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "LMG" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 600
ITEM.price = 4000
ITEM.magSize = 60 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false

ITEM.dmg = {
	["10mm"] = 12
}

ITEM.ammo = "10mm"

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-15,0,0,-25}
ITEM.class = "aus_w_smmg"

ITEM.reqStats = {
  ["str"] = 5,
}

ITEM.skillScaleDmg = {
    ["guns"] = 0,
}

ITEM.skillScaleAcc = {
["guns"] = 1.5,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.35, --this adds to the existing multiplier
		},
}

ITEM.actions = {
"burstfire_lmg",	
"suppression",
"aimedshot_precision",

}
