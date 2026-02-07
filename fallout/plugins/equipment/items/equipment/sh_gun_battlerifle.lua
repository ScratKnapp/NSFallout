ITEM.name = "Battle Rifle"
ITEM.desc = "A gas operated, semi automatic rifle chambered in .308."
ITEM.model = "models/halokiller38/fallout/weapons/rifles/thismachine.mdl"
ITEM.width = 4
ITEM.height = 2

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Rifle" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 500
ITEM.price = 1000
ITEM.magSize = 8 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = ".308"

ITEM.dmg = {
	[".308"] = 40
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
ITEM.class = "tfa_battle_rifle"

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = 0.4, --this adds to the existing headshot multiplier
	},
}

ITEM.reqStats = {
  ["str"] = 5,
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