ITEM.name = "Brass Knuckles"
ITEM.desc = "A hard knuckle grip to protect your hand and make your punches hurt more."
ITEM.model = "models/halokiller38/fallout/weapons/melee/brassknuckles.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(117.5, 95.381629943848, 73.300003051758),
	ang = Angle(25, 220, 0),
	fov = 4,
	outline = true,
	outlineColor = Color(16, 255, 0),
}
ITEM.specialSlot = "Sidearm"
ITEM.category = "Weapon - Melee"
ITEM.durability = 200
ITEM.price = 25
 

ITEM.weight = 1
ITEM.weapondual = false

ITEM.dmg = {
	["Blunt"] = 4
}

ITEM.costAP = 1 --how much AP is used when using this weapon normally
ITEM.accuracy = 1 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.class = "aus_m_fists_boxingglove"
ITEM.salvage = {
	["cloth"] = 2,
	["leather"] = 2,
}

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.3, --this adds to the existing multiplier
		},
}

--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-500,-500,-500,1}-- arccw_bo1_makarov

ITEM.reqStats = {
  ["str"] = 1,
}

ITEM.skillScaleAcc = {
["unarmed"] = 3,}

ITEM.skillScaleDmg = {
["unarmed"] = 0.6,}

ITEM.actions = {	
"tackle",
"sweep",
"bodyslam",
"combo",

}

--use this if you want things sto scale off of stats
--[[
ITEM.scaling = { --added to damage calculation
	["stm"] = 0.2,
	["talent"] = 0.2,
}
--]]