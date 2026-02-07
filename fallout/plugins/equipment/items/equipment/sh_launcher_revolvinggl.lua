ITEM.name = "Grenade Machinegun"
ITEM.desc = "A large, bulky, rapid fire 40mm launcher."
ITEM.model = "models/halokiller38/fallout/weapons/heavy weapons/25mmgrndlnchr.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(550.61932373047, 504.96734619141, 345.90026855469),
	ang = Angle(25, 220, 0),
	fov = 5,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.durability = 500
ITEM.price = 750
ITEM.magSize = 30 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "40mm Grenade"

ITEM.dmg = {
	["Explosion"] = 50
}

ITEM.multi = 3 --how many hits it does, dont need to put it here if it's just 1
ITEM.radius = 100 --dont put this here unless you want it to be AOE
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-50,-10,0,0}
ITEM.class = "tfa_grenade_rifle"


ITEM.reqStats = {
  ["str"] = 9,
}

ITEM.skillScaleAcc = {
["explosives"] = 2,}


ITEM.actions = {	

}
