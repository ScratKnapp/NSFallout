ITEM.name = "Laser RCW"
ITEM.desc = "A rapid firing laser rifle designed to mimic the famous 'Tommy Gun', and even has a drum magazine that is just six capacitors around an electron charge pack."
ITEM.model = "models/halokiller38/fallout/weapons/energy weapons/laserpdw.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(354.89315795898, 306, 218.52262878418),
	ang = Angle(25, 220, 0),
	fov = 3.1,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Energy" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 400
ITEM.magSize = 24 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "Electron Charge Pack"

ITEM.dmg = {
	["Electron Charge Pack"] = 12
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-75,-20,0,1}
ITEM.class = "aus_w_rcw"

ITEM.reqStats = {
  ["str"] = 3,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.3, --this adds to the existing multiplier
		},
}

ITEM.upgradeSlots = {
["Laser RCW Recycler"] = true,

}

ITEM.skillScaleDmg = {
    ["energy"] = 0,
}

ITEM.skillScaleAcc = {
["energy"] = 2.5,
}

ITEM.actions = {	
"burstfire_smg",

}
