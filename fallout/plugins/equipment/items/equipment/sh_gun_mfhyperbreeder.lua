ITEM.name = "MF Hyperbreeder Alpha"
ITEM.desc = "A second generation self-charging energy rifle. Essentially a more advanced and compact version of the Recharger Rifle."
ITEM.model = "models/fallout/fonv/rechargerpistol/w_fallout_fhyperbreeder.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(325.12915039063, 280.08489990234, 202.33157348633),
	ang = Angle(25, 220, 0),
	fov = 3.5,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Energy" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 800
ITEM.price = 2000

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "Microfusion Cell"

ITEM.dmg = {
	["Microfusion Cell"] = 26
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 0 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-15,1,0,-75}
ITEM.class = "tfa_laser_rifle"

ITEM.reqStats = {
  ["str"] = 3,
}

ITEM.upgradeSlots = {

}

ITEM.durability = 800

ITEM.skillScaleDmg = {
    ["energy"] = 0.1,
}

ITEM.skillScaleAcc = {
["energy"] = 2,
}

ITEM.actions = {	


}
