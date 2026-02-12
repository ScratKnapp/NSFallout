ITEM.name = "Bolt-Action Pipe Rifle"
ITEM.desc = "A junk .38 rifle made from spare parts."
ITEM.model = "models/illusion/fwp/w_pipebolt.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-200, 0, 1.2999999523163),
	ang = Angle(0, -0, 0),
	fov = 8.4,
	outline = true,
	outlineColor = Color(15, 250, 0),
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Rifle" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 200
ITEM.price = 200
ITEM.magSize = 6 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = ".38"

ITEM.dmg = {
	[".38"] = 15
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
ITEM.class = "aus_w_pipebolt"

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = 0.25, --this adds to the existing multiplier
	},
}

ITEM.reqStats = {
  ["str"] = 2,
}

ITEM.skillScaleDmg = {
    ["guns"] = 0.15,
}

ITEM.skillScaleAcc = {
["guns"] = 3,
}

ITEM.actions = {	
"aimedshot_sniper",
"doubletap_precision",

}
