ITEM.name = ".22LR Pistol"
ITEM.desc = "A small handgun with an integrated suppressor that takes .22LR ammunition."
ITEM.model = "models/halokiller38/fallout/weapons/pistols/silenced22pistol.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(109.32968139648, 95.897354125977, 68),
	ang = Angle(25, 220, 0),
	fov = 3.3,
}

ITEM.specialSlot = {"Sidearm", "Primary"}
ITEM.category = "Weapons"
ITEM.weaponType = "Pistol" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 200
ITEM.price = 25
ITEM.magSize = 16 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = ".22LR"
ITEM.critC = 20

ITEM.dmg = {
	[".22LR"] = 6
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-75,-20,1,0}
ITEM.class = "tfa_22mm_pistol"

ITEM.reqStats = {
  ["str"] = 1,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.3, --this adds to the existing multiplier
		},
}

ITEM.skillScaleDmg = {
    ["guns"] = 0,
}

ITEM.skillScaleAcc = {
	["guns"] = 2,
}

ITEM.actions = {	
	"doubletap_pistol",
	"aimedshot_precision",
	"suppressionpistol",
}
