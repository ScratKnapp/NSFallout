ITEM.name = "Laser Musket"
ITEM.desc = "A homemade laser rifle of electronic parts mounted on a wooden rifle stock."
ITEM.model = "models/illusion/fwp/w_lasermusket.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-200, 8, 0),
	ang = Angle(0, -0, 0),
	fov = 15,
	outline = true,
	outlineColor = Color(15, 250, 0),
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Energy" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 200
ITEM.price = 20
ITEM.magSize = 1 --how many times it can be used before reloading is necessary

ITEM.weight = 6
ITEM.weapondual = false
ITEM.ammo = "Microfusion Cell"

ITEM.dmg = {
	["Microfusion Cell"] = 25
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-15,1,0,-75}
ITEM.class = "aus_w_lasermusket"

ITEM.reqStats = {
  ["str"] = 2,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.25, --this adds to the existing multiplier
		},
}

ITEM.upgradeSlots = {
	["Laser Musket 2 Shot Capacitor"] = true,
	["Laser Musket Scope"] = true,
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
