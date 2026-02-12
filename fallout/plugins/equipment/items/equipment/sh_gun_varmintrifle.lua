ITEM.name = "Varmint Rifle"
ITEM.desc = "A low powered bolt aciton rifle designed for hunting small game."
ITEM.model = "models/illusion/fwp/w_varmintrifle.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(537.66888427734, 450, 328),
	ang = Angle(25, 220, 0),
	fov = 2,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Rifle" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 900
ITEM.magSize = 5 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = ".22LR"

ITEM.dmg = {
	[".22LR"] = 24
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-10,1,0,-75}
ITEM.class = "aus_w_varmintrifle"

ITEM.reqStats = {
  ["str"] = 2,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = 0.4, --this adds to the existing multiplier
		},
}

ITEM.upgradeSlots = {
["Varmint Rifle Ext. Magazine"] = true,
["Varmint Rifle Night Scope"] = true,
["Varmint Rifle Silencer"] = true,

}

ITEM.skillScaleDmg = {
    ["guns"] = 0.15,
}

ITEM.skillScaleAcc = {
["guns"] = 3,
}

ITEM.actions = {	
"aimedshot_sniper",
"doubletap_precision",

}
