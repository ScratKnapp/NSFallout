ITEM.name = "Gauss Rifle"
ITEM.desc = "A prototype rifle set with capacitors and wiring to charge and release a 2mm EC charge and launch a projectile at extremely high speed."
ITEM.model = "models/halokiller38/fallout/weapons/energy weapons/gaussrifle.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(437.6240234375, 390.5, 275),
	ang = Angle(25, 220, 0),
	fov = 3,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Sniper" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 5000
ITEM.magSize = 5 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "2mm EC"

ITEM.dmg = {
	["2mm EC"] = 100
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {2,0,-10,-75}
ITEM.class = "aus_w_gauss"

ITEM.reqStats = {
  ["str"] = 4,
}

ITEM.skillScaleDmg = {
    ["guns"] = 0.15,
}

ITEM.skillScaleAcc = {
["guns"] = 1.5,
}

ITEM.actions = {	
"aimedshot_precision",

}
