ITEM.name = "Laser Revolver"
ITEM.desc = "A modified .357 frame with an energy cell wired up to fire bolts."
ITEM.model = "models/illusion/fwp/w_laserpistol.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-156.86274719238, 4, 1.5),
	ang = Angle(0, -0, 0),
	fov = 9,
	outline = true,
	outlineColor = Color(15, 250, 0),
}

ITEM.specialSlot = {"Sidearm", "Primary"}
ITEM.category = "Weapons"
ITEM.weaponType = "Energy" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 400
ITEM.magSize = 6 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "Energy Cell"

ITEM.dmg = {
	["Energy Cell"] = 21
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
ITEM.class = "tfa_laser_revolver"

ITEM.upgradeSlots = {
["Laser Revolver Combat Sight"] = true,
["Laser Revolver Focus Optic"] = true,
["Laser Revolver Recycler"] = true,

}

ITEM.reqStats = {
  ["str"] = 1,
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
