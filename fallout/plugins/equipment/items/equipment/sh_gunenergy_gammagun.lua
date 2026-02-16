ITEM.name = "Gamma Gun"
ITEM.desc = "A crude radiation based energy pistol with a metal bowl and complex wiring meant to propel bursts of radiation."
ITEM.model = "models/weapons/gammagun.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(127.8874130249, 111.1056137085, 80.955528259277),
	ang = Angle(25, 220, 0),
	fov = 4,
}

ITEM.specialSlot = {"Sidearm", "Primary"}
ITEM.category = "Weapons"
ITEM.weaponType = "Energy" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 2000
ITEM.magSize = 8 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "Energy Cell"

ITEM.dmg = {
	["Radiation"] = 25
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
ITEM.class = "aus_w_laserpistol"

ITEM.upgradeSlots = {
["Laser Pistol Combat Sight"] = true,
["Laser Pistol Focus Optic"] = true,
["Laser Pistol Recycler"] = true,

}

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

ITEM.skillScaleDmg = {
    ["energy"] = 0.3,
}

ITEM.skillScaleAcc = {
["energy"] = 2.5,
}

ITEM.actions = {	
"overcharge",


}
