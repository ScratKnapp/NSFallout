ITEM.name = "Sawn Off Shotgun"
ITEM.desc = "A sawn off shotgun designed to fire 12 gauge shells."
ITEM.model = "models/halokiller38/fallout/weapons/shotguns/sawedoffshotgun.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(463.44296264648, 403, 284.81991577148),
	ang = Angle(25, 220, 0),
	fov = 2.7,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Shotgun" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 750
ITEM.magSize = 2 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "12 Gauge"

ITEM.dmg = {
	["12 Gauge"] = 7
}

ITEM.multi = 8 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-75,0,1,-15}
ITEM.class = "tfa_lever_action_shotgun"

ITEM.reqStats = {
  ["str"] = 3,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.35, --this adds to the existing multiplier
		},
}

ITEM.skillScaleDmg = {
    ["guns"] = 0.2,
}

ITEM.skillScaleAcc = {
["guns"] = 1.9,
}

ITEM.actions = {	
"slug2",
"aimedshot_shotgun",
"suppressionshotgun",
"runngunshotgun",

}
