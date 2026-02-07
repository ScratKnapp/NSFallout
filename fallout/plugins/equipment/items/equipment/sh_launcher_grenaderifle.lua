ITEM.name = "Grenade Rifle"
ITEM.desc = "A break action, single shot explosive rifle that fires 40mm grenades."
ITEM.model = "models/weapons/tfa_fallout/w_fallout_single_grenade_launcher.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(371.12408447266, 308.32189941406, 227.63209533691),
	ang = Angle(25, 220, 0),
	fov = 4,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.durability = 500
ITEM.price = 750
ITEM.magSize = 1 --how many times it can be used before reloading is necessary

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
ITEM.class = "tfa_grenade_rifle"

ITEM.reqStats = {
  ["str"] = 4,
}

ITEM.skillScaleAcc = {
["explosives"] = 2,}

ITEM.actions = {	

}
