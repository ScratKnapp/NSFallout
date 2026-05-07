ITEM.name = "Hunting Revolver"
ITEM.desc = "A large, double-action revolver with a cylinder holding .45-70 Gov't rounds."
ITEM.model = "models/weapons/tfa_fallout/w_fallout_hunting_revolver.mdl"
ITEM.modelCEnt = "models/halokiller38/fallout/weapons/pistols/bm_huntingrevolver.mdl"

ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(212.87001037598, 176.5, 131),
	ang = Angle(25, 220, 0),
	fov = 3,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Pistol" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 200
ITEM.price = 5000
ITEM.magSize = 5 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = ".45-70 Gov't"
ITEM.critC = 20
ITEM.critM = 0.8

ITEM.IdleAnim = "idle_revolver"
ITEM.WalkAnim = "walk_revolver"
ITEM.RunAnim = "run_revolver"

ITEM.dmg = {
	[".45-70 Gov't"] = 24
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-50,-15,1,0}
ITEM.class = "tfa_trail_carbine"

ITEM.reqStats = {
  ["str"] = 4,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = 0, --this adds to the existing multiplier
		},
}

ITEM.upgradeSlots = {
["Hunting Revolver Match Barrel"] = true,
["Hunting Revolver 6 Shot Cylinder"] = true,

}

ITEM.skillScaleDmg = {
    ["guns"] = 0,
}

ITEM.skillScaleAcc = {
["guns"] = 0.9,
}

ITEM.actions = {	
"doubletap_revolver",
"aimedshot_precision",
"suppressionpistol",

}

ITEM.firearm = true

ITEM.IdleAnim = "idle_revolver"
ITEM.WalkAnim = "walk_revolver"
ITEM.RunAnim = "run_revolver"

ITEM.fireRange = 500

ITEM.AttackSounds = {
	"weapons/fallout_new_vegas/hunting_revolver/wpn_fire_huntingrevolver.wav",
}