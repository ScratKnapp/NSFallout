ITEM.name = "Nailer"
ITEM.desc = "The top rated, number one H&H Power Tool."
ITEM.model = "models/halokiller38/fallout/weapons/misc/nailer.mdl"
ITEM.width = 3
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(245.61967468262, 218, 153),
	ang = Angle(25, 220, 0),
	fov = 3.3,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "SMG" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 100
ITEM.magSize = 50 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "Nails"
ITEM.critC = 5

ITEM.dmg = {
	["Nails"] = 5
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
ITEM.class = "aus_w_22_smg"

ITEM.reqStats = {
  ["str"] = 2,
}

ITEM.upgradeSlots = {
[".22 SMG Expanded Drum"] = true,

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
["guns"] = 1.2,
}

ITEM.actions = {	
"burstfire_smg",
"runngun",
"suppression1",

}
