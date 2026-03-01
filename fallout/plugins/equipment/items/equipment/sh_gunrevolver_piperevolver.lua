ITEM.name = "Pipe Revolver"
ITEM.desc = "A junk .38 revolver made from spare parts."
ITEM.model = "models/illusion/fwp/w_piperevolver.mdl"
ITEM.width = 2
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(537.66888427734, 449, 327),
	ang = Angle(25, 220, 0),
	fov = 1.5,
	outline = true,
	outlineColor = Color(15, 250, 0),
}

ITEM.specialSlot = {"Sidearm", "Primary"}
ITEM.category = "Weapons"
ITEM.weaponType = "Pistol" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 100
ITEM.price = 175
ITEM.magSize = 6 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = ".38"
ITEM.critC = 12
ITEM.critM = 0.5

ITEM.dmg = {
	[".38"] = 7
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-75,-50,0,0}
ITEM.class = "aus_w_piperevolver"

ITEM.reqStats = {
  ["str"] = 1,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = 0, --this adds to the existing multiplier
		},
}

ITEM.skillScaleDmg = {
    ["guns"] = 0,
}

ITEM.skillScaleAcc = {
["guns"] = 1.75,
}

ITEM.actions = {	
"doubletap_revolver",
"aimedshot_precision",
"suppressionpistol",

}
