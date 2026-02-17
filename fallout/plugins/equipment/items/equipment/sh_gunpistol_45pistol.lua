ITEM.name = ".45 Auto Pistol"
ITEM.desc = "A single action, semi-automatic handgun."
ITEM.model = "models/halokiller38/fallout/weapons/pistols/45pistol.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(126.00150299072, 109.5, 79),
	ang = Angle(25, 220, 0),
	fov = 2.6,
}

ITEM.specialSlot = {"Sidearm", "Primary"}
ITEM.category = "Weapons"
ITEM.weaponType = "Pistol" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 200
ITEM.price = 250
ITEM.magSize = 8 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = ".45 Auto"
ITEM.critC = 20
ITEM.critM = 0.5

ITEM.dmg = {
	[".45 Auto"] = 12
}

ITEM.reqStats = {
  ["str"] = 2,
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
ITEM.class = "aus_w_45pistol"

ITEM.upgradeSlots = {
[".45 AP HD Slide"] = true,
[".45 AP Silencer"] = true,

}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = 0, --this adds to the existing multiplier
		},
}

ITEM.skillScaleDmg = {
["guns"] = 0,
}

ITEM.skillScaleAcc = {
["guns"] = 1.5,
}

ITEM.actions = {
"doubletap_pistol",
"aimedshot_precision",
"suppressionpistol",

}
