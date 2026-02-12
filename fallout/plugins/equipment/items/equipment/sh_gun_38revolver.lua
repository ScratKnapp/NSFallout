ITEM.name = ".38 Police Special"
ITEM.desc = "A .38 revolver issued to police departments before the Great War."
ITEM.model = "models/halokiller38/fallout/weapons/pistols/policepistol.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(119.26746368408, 103, 73.424003601074),
	ang = Angle(25, 220, 0),
	fov = 3,
}

ITEM.specialSlot = {"Sidearm", "Primary"}
ITEM.category = "Weapons"
ITEM.weaponType = "Pistol" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 400
ITEM.magSize = 6 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = ".38"
ITEM.critC = 20

ITEM.dmg = {
	["38"] = 16
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
ITEM.class = "tfa_police_pistol"

ITEM.reqStats = {
  ["str"] = 1,
}

ITEM.skillScaleDmg = {
    ["guns"] = 0.15,
}

ITEM.skillScaleAcc = {
["guns"] = 1.5,
}

ITEM.actions = {
"doubletap_revolver",
"aimedshot_precision",
"suppressionpistol",

}
