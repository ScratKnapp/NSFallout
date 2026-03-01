ITEM.name = "LAER"
ITEM.desc = "An advanced energy based rifle prototype that has an extremely high damage output."
ITEM.model = "models/fallout/fonv/laer/w_fallout_laer.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(325.12915039063, 280.08489990234, 202.33157348633),
	ang = Angle(25, 220, 0),
	fov = 3.5,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Energy" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 200
ITEM.price = 5000
ITEM.magSize = 20 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "Microfusion Cell"

ITEM.dmg = {
	["Microfusion Cell"] = 35
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-15,1,0,-75}
ITEM.class = "tfa_laer"

ITEM.reqStats = {
  ["str"] = 4,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.25, --this adds to the existing multiplier
		},
}

ITEM.upgradeSlots = {
["Laser Rifle Focus Optics"] = true,
["Laser Rifle Scope"] = true,

}


ITEM.skillScaleDmg = {
    ["energy"] = 0,
}

ITEM.skillScaleAcc = {
["energy"] = 2.5,
}

ITEM.actions = {	
"overcharge",


}
