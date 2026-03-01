ITEM.name = "N-99 10mm Pistol"
ITEM.desc = "A semi-automatic pistol designed before the Great War, featuring a large frame and a long barrel for the most extreme conditions."
ITEM.model = "models/halokiller38/fallout/weapons/pistols/10mmpistol.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(147.71966552734, 129.60000610352, 92.300003051758),
	ang = Angle(25, 220, 0),
	fov = 2.8,
}

ITEM.specialSlot = {"Sidearm", "Primary"}
ITEM.category = "Weapons"
ITEM.weaponType = "Pistol" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 200
ITEM.price = 250
ITEM.magSize = 12 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.dmg = {
	["10mm"] = 12
}

ITEM.ammo = "10mm"
ITEM.critC = 20
ITEM.critM = 0.5

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-75,-8,1,0}
ITEM.class = "aus_w_10mmpistol"

ITEM.reqStats = {
	["str"] = 2,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = 0, --this adds to the existing multiplier
		},
}

ITEM.upgradeSlots = {
	["10mm Pistol Ext. Magazine"] = true,
	["10mm Pistol Laser Sight"] = true,
	["10mm Pistol Silencer"] = true,
}
ITEM.skillScaleDmg = {
    ["guns"] = 0,
}

ITEM.skillScaleAcc = {
	["guns"] = 1.75,
}
	
ITEM.actions = {
"doubletap_pistol",
"aimedshot_precision",
"suppressionpistol",

}
