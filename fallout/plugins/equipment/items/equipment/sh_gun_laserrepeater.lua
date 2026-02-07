ITEM.name = "Laser Repeater"
ITEM.desc = "A semi-automatic Laser Rifle with a wooden furniture, kept rather simplistic and basic."
ITEM.model = "models/gun/fallout4/laser_musket.mdl"
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
ITEM.price = 500
ITEM.magSize = 24 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.dmg = {
	["Microfusion Cell"] = 28
}
ITEM.ammo = "Microfusion Cell"

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {0,0,-4,-75}
ITEM.class = "tfa_holo_rifle"

ITEM.reqStats = {
  ["str"] = 2,
}

ITEM.upgradeSlots = {

}

ITEM.skillScaleDmg = {
    ["energy"] = 0.1,
}

ITEM.skillScaleAcc = {
["energy"] = 2,}

ITEM.actions = {	

}