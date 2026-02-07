ITEM.name = "10mm SMG"
ITEM.desc = "A fully automatic submachine gun that is intended for use with a single hand."
ITEM.model = "models/halokiller38/fallout/weapons/smgs/10mmsmg.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(192.21549987793, 168, 120.59999847412),
	ang = Angle(25, 220, 0),
	fov = 2.7,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "SMG" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 600
ITEM.magSize = 30 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.dmg = {
	["10mm"] = 17
}
ITEM.ammo = "10mm"
ITEM.critC = 15

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-75,-30,0,1}
ITEM.class = "aus_w_10mmsmg"

ITEM.reqStats = {
  ["str"] = 2,
}

ITEM.upgradeSlots = {
["10mm SMG Extended Mag"] = true,
["10mm SMG Recoil Compensator"] = true,
["10mm SMG Upgraded Barrel"] = true,

}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.35, --this adds to the existing multiplier
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
