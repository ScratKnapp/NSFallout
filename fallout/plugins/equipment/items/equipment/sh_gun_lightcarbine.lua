ITEM.name = "Light Carbine"
ITEM.desc = "A shorned and slim rifle chambered in .38; capable of firing fully automatic."
ITEM.model = "models/bf1/weapons/desert dweller carbine.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-200, -2.5, -1.5),
	ang = Angle(0, -0, 0),
	fov = 10,
	outline = true,
	outlineColor = Color(15, 250, 0),
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Rifle" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 200
ITEM.price = 250
ITEM.magSize = 48 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = ".38"

ITEM.dmg = {
	[".38"] = 16
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-50,0,0,-75}
ITEM.class = "aus_w_piperiflesemi"

ITEM.reqStats = {
  ["str"] = 2,
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
		dmg = -0.2, --this adds to the existing multiplier
		},
}

ITEM.actions = {	
"burstfire_rifle",
"aimedshot_precision",
"suppression1",

}
