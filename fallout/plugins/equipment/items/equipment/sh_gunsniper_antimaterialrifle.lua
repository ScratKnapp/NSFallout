ITEM.name = "Anti-Material Rifle"
ITEM.desc = "A bolt-action, high caliber precision weapon intended for hard targets."
ITEM.model = "models/halokiller38/fallout/weapons/sniperrifles/antimaterielrifle.mdl"
ITEM.width = 6
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(529.37188720703, 467, 327.5),
	ang = Angle(25, 220, 0),
	fov = 4,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Sniper" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 5000
ITEM.magSize = 8 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = ".50 MG"

ITEM.dmg = {
	[".50 MG"] = 115
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-10,0,-8,-75}
ITEM.class = "aus_w_amr"

ITEM.reqStats = {
  ["str"] = 7,
}

ITEM.upgradeSlots = {
["Anti-Mat CF Parts"] = true,
["Anti-Mat Custom Bolt"] = true,
["Anti-Mat Suppressor"] = true,

}

ITEM.skillScaleDmg = {
    ["guns"] = 0.15,
}

ITEM.skillScaleAcc = {
["guns"] = 1.5,
}

ITEM.actions = {	
"aimedshot_sniper",

}
