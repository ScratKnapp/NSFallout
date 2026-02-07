ITEM.name = "Hunting Shotgun"
ITEM.desc = "A bottom-loading pump-action shotrgun built for greater range and power."
ITEM.model = "models/halokiller38/fallout/weapons/shotguns/huntingshotgun.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(433.84024047852, 382, 267.92807006836),
	ang = Angle(25, 220, 0),
	fov = 3.3,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Shotgun" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 650
ITEM.magSize = 5 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "12 Gauge"

ITEM.dmg = {
	["12 Gauge"] = 8
}

ITEM.multi = 7 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-75,0,1,-15}
ITEM.class = "aus_w_huntingshotgun"

ITEM.reqStats = {
  ["str"] = 3,
}

ITEM.upgradeSlots = {
["Hunting Shotgun Long Tube"] = true,
["Hunting Shotgun Choke"] = true,

}

ITEM.skillScaleDmg = {
    ["guns"] = 0.2,
}

ITEM.skillScaleAcc = {
	["guns"] = 1.9,}
	
ITEM.actions = {	
"slug2",
"aimedshot_shotgun",
"suppressionshotgun",
"runngun",

}
