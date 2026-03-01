ITEM.name = "12.7mm Pistol"
ITEM.desc = "The Sig-Saur 14mm Autopistol is an old pre-war firearm that has a more powerful round, but is generally an uncommon firearm in the wastes."
ITEM.model = "models/weapons/tfa_fallout/w_fallout_12mm_pistol.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(114.54654693604, 92.199996948242, 70.5),
	ang = Angle(25, 220, 0),
	fov = 3,
}

ITEM.specialSlot = {"Sidearm", "Primary"}
ITEM.category = "Weapons"
ITEM.weaponType = "Pistol" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 200
ITEM.price = 5000
ITEM.magSize = 7 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "12.7mm"
ITEM.critC = 20
ITEM.critM = 0.5

ITEM.dmg = {
	["12.7mm"] = 20
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
ITEM.class = "aus_w_127pistol"

ITEM.reqStats = {
  ["str"] = 4,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = 0, --this adds to the existing multiplier
		},
}

ITEM.upgradeSlots = {
["12.7mm Pistol Silencer"] = true,
}

ITEM.skillScaleDmg = {
    ["guns"] = 0,
}

ITEM.skillScaleAcc = {
["guns"] = 1.75,
}

ITEM.actions = {
"doubletap_pistol",
"aimedshot_precision",
"suppressionpistol",

}
