ITEM.name = "Soviet Shotgun"
ITEM.desc = "A powerful pump-action shotgun of Soviet origin."
ITEM.model = "models/weapons/w_coldwar_ks23.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(336.43524169922, 268.90838623047, 199),
	ang = Angle(25, 220, 0),
	fov = 3.4,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Shotgun" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 750
ITEM.magSize = 4 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "12 Gauge"

ITEM.dmg = {
	["12 Gauge"] = 11
}

ITEM.multi = 6 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-75,-10,0,0}
ITEM.class = "tfa_riot_shotgun"

ITEM.reqStats = {
  ["str"] = 5,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.35, --this adds to the existing multiplier
		},
}

ITEM.skillScaleDmg = {
    ["guns"] = 0,
}

ITEM.skillScaleAcc = {
["guns"] = 1.5,}

ITEM.actions = {	
"slug4",
"aimedshot_shotgun",
"suppressionshotgun",
"runngunshotgun",

}