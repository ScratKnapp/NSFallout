ITEM.name = "Assault Carbine"
ITEM.desc = "A pre-war rifle with a high firerate, issued to paratroopers prior to the Great War."
ITEM.model = "models/halokiller38/fallout/weapons/assaultrifles/assaultcarbine.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(299.25143432617, 262.39999389648, 187),
	ang = Angle(25, 220, 0),
	fov = 3.1,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Rifle" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 400
ITEM.price = 8000
ITEM.magSize = 30 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "5mm"

ITEM.dmg = {
	["5mm"] = 19
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-25,1,0,-75}
ITEM.class = "aus_w_assaultcarbine"

ITEM.reqStats = {
  ["str"] = 5,
}

ITEM.upgradeSlots = {
["A.C. Extended Magazine"] = true,
["A.C. Forged Receiver"] = true,
["A.C. Light Bolt"] = true,

}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.3, --this adds to the existing multiplier
		},
}

ITEM.skillScaleDmg = {
    ["guns"] = 0,
}

ITEM.skillScaleAcc = {
["guns"] = 1.35,
}


ITEM.actions = {	
"burstfire_rifle",
"aimedshot_precision",
"suppression1",

}
