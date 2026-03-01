ITEM.name = "Checkpoint Carbine"
ITEM.desc = "A heavily modified, gas-operated rifle with a short barrel and ring supports around the barrel cover."
ITEM.model = "models/illusion/fwp/w_servicerifle.mdl"
ITEM.width = 4
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(343.3603515625, 293, 215.5),
	ang = Angle(25, 220, 0),
	fov = 3,
}

ITEM.specialSlot = "Primary"
ITEM.category = "Weapons"
ITEM.weaponType = "Rifle" -- Unarmed, Pistol, Rifle, Sniper, SMG, Shotgun, LMG, Energy, Melee
ITEM.durability = 200
ITEM.price = 2000
ITEM.magSize = 20 --how many times it can be used before reloading is necessary

ITEM.weight = 1
ITEM.weapondual = false
ITEM.ammo = "12.7mm"

ITEM.dmg = {
	["12.7mm"] = 22
}

ITEM.multi = 1 --how many hits it does, dont need to put it here if it's just 1
ITEM.ammoUse = 1 --how much ammo it should use per shot, will default to 0 if not set
ITEM.accuracy = 0 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.costAP = 1 --how much AP is used when using this weapon normally
--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-10,1,0,-50}
ITEM.class = "tfa_service_rifle_12.7"

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 15, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = 0.4, --this adds to the existing multiplier
		},
}

ITEM.reqStats = {
  ["str"] = 6,
}

ITEM.upgradeSlots = {
["Service Rifle Upgraded Barrel"] = true,
["Service Rifle Forged Receiver"] = true,
["Service Rifle Scope"] = true,

}

ITEM.skillScaleDmg = {
    ["guns"] = 0,
}

ITEM.skillScaleAcc = {
["guns"] = 2,
}

ITEM.actions = {	
"aimedshot_precision",
"doubletap_precision",


}
