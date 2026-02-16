ITEM.name = "Wattz 3000 Laser Rifle"
ITEM.desc = "The Wattz 3000 is a slow, but more powerful firing laser rifle with more powerful particle diverter to utilize more energy per shot."
ITEM.model = "models/illusion/fwp/w_wattzlasergun.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(550.71850585938, 458, 334.5),
	ang = Angle(25, 220, 0),
	fov = 3,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Energy" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 3500
ITEM.magSize = 12 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "Microfusion Cell"

ITEM.dmg = {
	["Microfusion Cell"] = 45
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-10,0,-5,-75}
ITEM.class = "aus_w_wattzlasergun"

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

ITEM.upgradeSlots = {
["Wattz 3000 Focus Optics"] = true,
["Wattz 3000 Night Scope"] = true,

}

ITEM.skillScaleDmg = {
    ["energy"] = 0.3,
}

ITEM.skillScaleAcc = {
["energy"] = 2.5,
}

ITEM.actions = {	
"overcharge",


}
