ITEM.name = "Multiplas Rifle"
ITEM.desc = "A bulky upgraded version of the plasma rifle by Winchester Arms from before the war. It fires three superheated globs of plasma at once."
ITEM.model = "models/fallout/fonv/plasmarifle/w_fallout_plasmarifle.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(414.82809448242, 356.38311767578, 253.63345336914),
	ang = Angle(25, 220, 0),
	fov = 3.5,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Energy" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 3400
ITEM.magSize = 12 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "Microfusion Cell"

ITEM.dmg = {
	["Microfusion Cell"] = 30
}

ITEM.multi = 3 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-15,1,0,-75}
ITEM.class = "aus_w_plasmarifle"

ITEM.reqStats = {
  ["str"] = 3,
}

ITEM.upgradeSlots = {
["Plasma Rifle Mag. Accelerator"] = true,
["Plasma Rifle Scope"] = true,

}

ITEM.skillScaleDmg = {
    ["energyweapons"] = 0.15,
}

ITEM.skillScaleAcc = {
["energy"] = 2,
}

ITEM.actions = {	

}
