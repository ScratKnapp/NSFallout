ITEM.name = "AK-112 Assault Rifle"
ITEM.desc = "A foreign pre-war rifle designed to utilize 5mm."
ITEM.model = "models/props/ak112.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(537.82238769531, 450, 326.79998779297),
	ang = Angle(25, 220, 0),
	fov = 2.4,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Rifle" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 400
ITEM.price = 100
ITEM.magSize = 20 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "5mm"

ITEM.dmg = {
	["5mm"] = 13
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
ITEM.class = "aus_w_hmar"

ITEM.reqStats = {
  ["str"] = 2,
}

ITEM.skillScaleDmg = {
    ["guns"] = 0,
}

ITEM.upgradeSlots = {
["AK112 Custom Bolt"] = true,
["AK112 Rifle Scope"] = true,
["AK112 Rifle Receiver"] = true,

}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.3, --this adds to the existing multiplier
		},
}

ITEM.skillScaleAcc = {
["guns"] = 1.35,
}


ITEM.actions = {	
"burstfire_rifle",
"aimedshot_precision",
"suppression1",

}
