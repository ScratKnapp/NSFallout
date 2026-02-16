ITEM.name = "Trail Carbine"
ITEM.desc = "A lever action rifle designed to fire .44 magnum rounds."
ITEM.model = "models/weapons/tfa_fallout/w_fallout_trail_carbine.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(527.14166259766, 456, 332),
	ang = Angle(25, 220, 0),
	fov = 3,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Rifle" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 200
ITEM.price = 750
ITEM.magSize = 8 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = ".44 Magnum"

ITEM.dmg = {
	[".44 Magnum"] = 19
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-10,1,0,-75}
ITEM.class = "tfa_trail_carbine"

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 15, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = 0.4, --this adds to the existing multiplier
		},
}

ITEM.reqStats = {
  ["str"] = 5,
}

ITEM.upgradeSlots = {
["Trail Carbine Scope"] = true,

}

ITEM.skillScaleDmg = {
    ["guns"] = 0,
}

ITEM.skillScaleAcc = {
["guns"] = 2,
}

ITEM.actions = {	
"aimedshot_sniper",
"doubletap_precision",

}
