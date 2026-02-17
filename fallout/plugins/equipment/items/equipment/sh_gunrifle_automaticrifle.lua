ITEM.name = "Automatic Rifle"
ITEM.desc = "A rare pre-war, air cooled automatic rifle from the United States."
ITEM.model = "models/halokiller38/fallout/weapons/heavy weapons/automaticrifle.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(569.84381103516, 500, 352),
	ang = Angle(25, 220, 0),
	fov = 2.8,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "LMG" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 400
ITEM.price = 1500
ITEM.magSize = 20 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = ".308"

ITEM.dmg = {
	[".308"] = 21
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-25,0,0,-75}
ITEM.class = "aus_w_bar"

ITEM.reqStats = {
  ["str"] = 7,
}

ITEM.upgradeSlots = {
["Auto Rifle Upgraded Internals"] = true,

}

ITEM.skillScaleDmg = {
    ["guns"] = 0,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.3, --this adds to the existing multiplier
		},
}

ITEM.skillScaleAcc = {
["guns"] = 1.35,
}


ITEM.actions = {	
"burstfire_lmg",
"suppression",
"aimedshot_precision",

}
