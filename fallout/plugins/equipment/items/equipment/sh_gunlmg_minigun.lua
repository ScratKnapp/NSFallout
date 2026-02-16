ITEM.name = "CZ75 Minigun"
ITEM.desc = "It's a minigun."
ITEM.model = "models/halokiller38/fallout/weapons/heavy weapons/minigun.mdl"
ITEM.width = 5
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(602.68328857422, 534.4912109375, 354),
	ang = Angle(25, 220, 0),
	fov = 3,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "LMG" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 5000
ITEM.magSize = 240 --how many times it can be used before reloading is necessary

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
ITEM.range = {-75,0,0,-50}
ITEM.class = "aus_w_minigun"

ITEM.skillScaleDmg = {
    ["guns"] = 0.15,
}

ITEM.reqStats = {
  ["str"] = 8,
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
"minigun",
"aimedshot_precision",
"suppression1",

}
