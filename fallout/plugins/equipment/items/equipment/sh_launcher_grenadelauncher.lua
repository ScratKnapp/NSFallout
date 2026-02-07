ITEM.name = "Grenade Launcher"
ITEM.desc = "A pump action 40mm launcher that fires from a tubular magazine."
ITEM.model = "models/weapons/tfa_fallout/w_fallout_grenade_launcher.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(421.26440429688, 355.13348388672, 256.05023193359),
	ang = Angle(25, 220, 0),
	fov = 5,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.durability = 500
ITEM.price = 750
ITEM.magSize = 4 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "40mm Grenade"

ITEM.dmg = {
	["Explosion"] = 55
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.radius = 100 --dont put this here unless you want it to be AOE
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-50,-8,0,0} 
ITEM.class = "tfa_grenade_launcher"


ITEM.reqStats = {
  ["str"] = 5,
}

ITEM.skillScaleAcc = {
["explosives"] = 2,}

ITEM.actions = {	

}
