ITEM.name = "Plasma Defender"
ITEM.desc = "An advanced prototype plasma pistol designed to fire plasma at a higher rate of fire with less spread than other plasma pistols."
ITEM.model = "models/halokiller38/fallout/weapons/plasma weapons/plasmadefender.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(195.35748291016, 173.5, 120.93379974365),
	ang = Angle(25, 220, 0),
	fov = 2.8,
}

ITEM.specialSlot = {"Sidearm", "Primary"}
ITEM.category = "Weapons"
ITEM.weaponType = "Energy" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 2500
ITEM.magSize = 16 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "Energy Cell"

ITEM.dmg = {
	["Energy Cell"] = 30
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-75,-20,0,0}
ITEM.class = "aus_w_plasmapistol"

ITEM.reqStats = {
  ["str"] = 2,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.25, --this adds to the existing multiplier
		},
}


ITEM.upgradeSlots = {


}

ITEM.skillScaleDmg = {
    ["energy"] = 0.3,
}

ITEM.skillScaleAcc = {
["energy"] = 2.5,
}

ITEM.actions = {	
"overcharge",


}
