ITEM.name = "Flamer"
ITEM.desc = "A short range, bulky flamethrower that projects a stream of ignited flammable fuel."
ITEM.model = "models/fallout/weapons/w_flamergo.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(550.61932373047, 504.96734619141, 345.90026855469),
	ang = Angle(25, 220, 0),
	fov = 5,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.durability = 600
ITEM.price = 5000
ITEM.magSize = 100 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "Flamer Fuel"

ITEM.dmg = {
	["Flamer Fuel"] = 14
}

ITEM.multi = 5 --how many hits it does, dont need to put it here if it's just 1
ITEM.radius = 85 --dont put this here unless you want it to be AOE
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-999,-999,15,25}
ITEM.class = "tfa_grenade_rifle"


ITEM.reqStats = {
  ["str"] = 3,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.25, --this adds to the existing multiplier
		},
}

ITEM.skillScaleAcc = {
["energy"] = 2
}

ITEM.skillScaleDmg = {
    ["energy"] = 0.1,
}

ITEM.actions = {	

}
