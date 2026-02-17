ITEM.name = "Marksman Carbine"
ITEM.desc = "A highly modified assault carbine, equipped with a 2x magnification scope and modified stock."
ITEM.model = "models/halokiller38/fallout/weapons/assaultrifles/marksmancarbine.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(298.39404296875, 259, 185.5),
	ang = Angle(25, 220, 0),
	fov = 4,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Rifle" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 200
ITEM.price = 1500
ITEM.magSize = 20 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "5.56"

ITEM.dmg = {
	["5.56"] = 23
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
ITEM.class = "aus_w_marksmancarbine"

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 15, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = 0.5, --this adds to the existing multiplier
	},
}

ITEM.upgradeSlots = {
["Marksman Carbine Barrel"] = true,
["Marksman Carbine Rifling"] = true,
["Marksman Carbine Bolt"] = true,

}

ITEM.reqStats = {
  ["str"] = 4,
}

ITEM.skillScaleDmg = {
    ["guns"] = 0.15,
}

ITEM.skillScaleAcc = {
["guns"] = 3.5,
}

ITEM.actions = {	
"aimedshot_sniper",
"doubletap_precision",

}
