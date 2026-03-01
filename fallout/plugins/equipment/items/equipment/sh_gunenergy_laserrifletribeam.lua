ITEM.name = "Tri-Beam Laser Rifle"
ITEM.desc = "The AER14 laser gun is a crystal array housed in titanium to fire energy beams powered by microfusion cells. This version has a modified emitter to fire three beams at once."
ITEM.model = "models/halokiller38/fallout/weapons/energy weapons/tribeamlaserrifle.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(343.83447265625, 295, 215),
	ang = Angle(25, 220, 0),
	fov = 2.9,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Energy" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 600
ITEM.price = 3500
ITEM.magSize = 10 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "Microfusion Cell"

ITEM.dmg = {
	["Microfusion Cell"] = 22
}

ITEM.multi = 3 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-20,0,1,-75}
ITEM.class = "aus_w_tribeam"

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

ITEM.skillScaleDmg = {
    ["energy"] = 0,
}

ITEM.skillScaleAcc = {
["energy"] = 2.5,
}

ITEM.actions = {	
"overcharge",


}
