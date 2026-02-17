ITEM.name = "DKS-501 Sniper Rifle"
ITEM.desc = "A scoped high powered rifle chambered in .308, with a long weighted barrel."
ITEM.model = "models/halokiller38/fallout/weapons/sniperrifles/sniperrifle.mdl"
ITEM.width = 5
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(443.24276733398, 390.61309814453, 276),
	ang = Angle(25, 220, 0),
	fov = 3.5,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Sniper" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 200
ITEM.price = 2500
ITEM.magSize = 5 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = ".308"

ITEM.dmg = {
	["308"] = 50
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-5,0,-8,-75}
ITEM.class = "aus_w_sniperrifle"

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 20, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = 0.4, --this adds to the existing multiplier
	},
}

ITEM.reqStats = {
  ["str"] = 5,
}

ITEM.upgradeSlots = {
["Sniper Rifle Carbon Fiber Parts"] = true,
["Sniper Rifle Suppressor"] = true,

}

ITEM.skillScaleDmg = {
    ["guns"] = 0,
}

ITEM.skillScaleAcc = {
["guns"] = 2.5,
}

ITEM.actions = {	
"aimedshot_sniper",

}
