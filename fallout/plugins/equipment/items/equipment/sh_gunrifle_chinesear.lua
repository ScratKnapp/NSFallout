ITEM.name = "Type 93 Assault Rifle"
ITEM.desc = "A general purpose 5.56 rifle which features ease of disassembly and maintenance, but a lower fire rate than most rifles."
ITEM.model = "models/halokiller38/fallout/weapons/assaultrifles/chineseassaultrifle.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(474.17114257813, 410, 291),
	ang = Angle(25, 220, 0),
	fov = 2.7,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Rifle" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 1200
ITEM.magSize = 30 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "5.56"

ITEM.dmg = {
	["5.56"] = 25
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
ITEM.class = "aus_w_chinesear"

ITEM.reqStats = {
  ["str"] = 4,
}

ITEM.skillScaleDmg = {
    ["guns"] = 0.15,
}

ITEM.skillScaleAcc = {
["guns"] = 1.5,
}
ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.3, --this adds to the existing multiplier
		},
}

ITEM.actions = {	
"burstfire_rifle",
"aimedshot_precision",
"suppression1",

}
