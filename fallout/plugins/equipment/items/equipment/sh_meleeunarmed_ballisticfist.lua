ITEM.name = "Ballistic Fist"
ITEM.desc = "A dark colored gauntlet with a wrist-mounted shotgun and pressure plate over the knuckles."
ITEM.model = "models/halokiller38/fallout/weapons/melee/ballisticfist.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(295, 242.12812805176, 186),
	ang = Angle(25, 220, 0),
	fov = 3,
	outline = true,
	outlineColor = Color(16, 255, 0),
}
ITEM.specialSlot = "Sidearm"
ITEM.category = "Weapon - Melee"
ITEM.durability = 200
ITEM.price = 200
 

ITEM.weight = 1
ITEM.weapondual = false
ITEM.costAP = 1 --how much AP is used when using this weapon normally
ITEM.accuracy = 1 --bonus accuracy, can also go negative. defaults to 0 if not setITEM.costAP = 1 --how much AP is used when using this weapon normally
ITEM.class = "aus_m_fists_powerfist"

ITEM.dmg = {
	["Blunt"] = 16
}

--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-100,-100,-100,1}-- arccw_bo1_makarov

ITEM.partMod = {
	["Head"] = { --only affects this spot
		accuracy = 0, --this is added
		accuracyMult = 0, --this is a multiplier
		dmg = -0.4, --this adds to the existing multiplier
		},
}

ITEM.reqStats = {
  ["str"] = 3,
}

ITEM.skillScaleAcc = {
["unarmed"] = 3,}

ITEM.skillScaleDmg = {
["unarmed"] = 0.75,}

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