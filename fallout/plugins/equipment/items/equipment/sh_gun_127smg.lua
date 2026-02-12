ITEM.name = "12.7mm SMG"
ITEM.desc = "A bulky 12.7mm submachine gun."
ITEM.model = "models/halokiller38/fallout/weapons/smgs/127smg.mdl"
ITEM.width = 3
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(393.24374389648, 333, 240.5),
	ang = Angle(25, 220, 0),
	fov = 2.8,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "SMG" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 600
ITEM.magSize = 20 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "12.7mm"
ITEM.critC = 15

ITEM.dmg = {
	["12.7mm"] = 23
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-75,-30,0,1}
ITEM.class = "aus_w_submachinegun"

ITEM.reqStats = {
  ["str"] = 5,
}

ITEM.upgradeSlots = {

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
"burstfire_smg",
"runngun",
"suppression1",


}
