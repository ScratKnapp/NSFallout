ITEM.name = "9mm SMG"
ITEM.desc = "A small submachinegun developed to utilize stamped and cheaper metals in the post-war wastes, based on the M3 Submachine Gun."
ITEM.model = "models/khrcw2/doipack/w_m3greasegun.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(218.58047485352, 190.19999694824, 135.69999694824),
	ang = Angle(25, 220, 0),
	fov = 2.6,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "SMG" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 400
ITEM.magSize = 30 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "9mm"
ITEM.critC = 15

ITEM.dmg = {
	["9mm"] = 15
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
ITEM.class = "aus_w_9mmsmg"

ITEM.reqStats = {
  ["str"] = 1,
}

ITEM.skillScaleDmg = {
    ["guns"] = 0.15,
}

ITEM.upgradeSlots = {
["9mm SMG Drum"] = true,
["9mm SMG Light Bolt"] = true,

}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.3, --this adds to the existing multiplier
		},
}

ITEM.skillScaleAcc = {
["guns"] = 1.5,
}

ITEM.actions = {	
"burstfire_smg",
"runngun",
"suppression1",

}
