ITEM.name = "Hunting Rifle"
ITEM.desc = "A wooden furnished, bolt action .308 rifle."
ITEM.model = "models/weapons/tfa_fallout/w_fallout_hunting_rifle.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(490.01153564453, 423, 299),
	ang = Angle(25, 220, 0),
	fov = 3.5,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Sniper" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 550
ITEM.magSize = 5 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = ".308"

ITEM.dmg = {
	[".308"] = 55
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-15,0,-8,-75}
ITEM.class = "aus_w_huntingrifle"

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = 0.25, --this adds to the existing multiplier
	},
}

ITEM.reqStats = {
  ["str"] = 4,
}

ITEM.upgradeSlots = {
["Hunting Rifle Scope"] = true,
["Hunting Rifle Extended Mag"] = true,
["Hunting Rifle Custom Action"] = true,

}

ITEM.skillScaleDmg = {
    ["guns"] = 0.15,
}

ITEM.skillScaleAcc = {
["guns"] = 2,
}

ITEM.actions = {	
"aimedshot_sniper",

}
