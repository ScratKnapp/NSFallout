ITEM.name = "Combat Rifle"
ITEM.desc = "An older, pre-war designed rifle that is chambered in .45 ACP. A popular automatic rifle in Arizona."
ITEM.model = "models/bf1/weapons/winchester model 1907.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-200, 5, 0),
	ang = Angle(0, -0, 0),
	fov = 7.5,
	outline = true,
	outlineColor = Color(15, 250, 0),
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Rifle" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 700
ITEM.magSize = 20 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = ".45 Auto"

ITEM.dmg = {
	[".45 Auto"] = 22
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
ITEM.class = "aus_w_combatrifle"

ITEM.reqStats = {
  ["str"] = 3,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.2, --this adds to the existing multiplier
		},
}

ITEM.skillScaleDmg = {
    ["guns"] = 0.15,
}

ITEM.skillScaleAcc = {
["guns"] = 1.5,
}

ITEM.actions = {	
"burstfire_rifle",
"aimedshot_precision",
"suppression1",

}
