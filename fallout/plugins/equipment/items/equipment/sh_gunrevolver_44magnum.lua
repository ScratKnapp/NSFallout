ITEM.name = ".44 Magnum"
ITEM.desc = "A .44 magnum double-action revolver with a swing out cylinder."
ITEM.model = "models/weapons/tfa_fallout/w_fallout_44_magnum.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(172.68255615234, 141, 104),
	ang = Angle(25, 220, 0),
	fov = 2.7,
}

ITEM.specialSlot = {"Sidearm", "Primary"}
ITEM.category = "Weapons"
ITEM.weaponType = "Pistol" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 200
ITEM.price = 400
ITEM.magSize = 6 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = ".44 Magnum"
ITEM.critC = 20

ITEM.dmg = {
	[".44 Magnum"] = 18
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
ITEM.class = "aus_w_44magnum"

ITEM.reqStats = {
  ["str"] = 3,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = 0, --this adds to the existing multiplier
		},
}

ITEM.upgradeSlots = {
[".44 Revolver Heavy Frame"] = true,
[".44 Revolver Scope"] = true,

}

ITEM.skillScaleDmg = {
    ["guns"] = 0,
}

ITEM.skillScaleAcc = {
["guns"] = 1.5,
}

ITEM.actions = {
"doubletap_revolver",
"aimedshot_precision",
"suppressionpistol",

}
