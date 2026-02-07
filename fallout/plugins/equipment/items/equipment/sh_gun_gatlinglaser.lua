ITEM.name = "L30P Gatling Laser"
ITEM.desc = "A large platform consisting of four AER9 barrels that fire pulses through two lenses."
ITEM.model = "models/weapons/gatlinglaser/w_fallout_gatling_laser.mdl"
ITEM.width = 6
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(402.15960693359, 346.09780883789, 255.43316650391),
	ang = Angle(25, 220, 0),
	fov = 5.5691352826321,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Energy" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 1000
ITEM.price = 5000
ITEM.magSize = 240 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "Electron Charge Pack"

ITEM.dmg = {
	["Electron Charge Pack"] = 25
}

ITEM.multi = 5 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-25,0,0,-75}
ITEM.class = "aus_w_gatlinglaser"

ITEM.reqStats = {
  ["str"] = 7,
}

ITEM.skillScaleDmg = {
    ["energy"] = 0.2,
}

ITEM.skillScaleAcc = {
["energy"] = 1.5,
}

ITEM.actions = {	
"suppression",


}
