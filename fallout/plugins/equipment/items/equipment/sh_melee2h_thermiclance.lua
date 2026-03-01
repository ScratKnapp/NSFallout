ITEM.name = "Thermic Lance"
ITEM.desc = "A long heavy-duty metalworking tool."
ITEM.model = "models/halokiller38/fallout/weapons/melee/thermiclance.mdl"
ITEM.width = 3
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(418, 336.39877319336, 271),
	ang = Angle(25, 220, 0),
	fov = 2,
	outline = true,
	outlineColor = Color(16, 255, 0),
}
ITEM.specialSlot = "Primary"
ITEM.category = "Weapon - Melee"
ITEM.durability = 400
ITEM.price = 2000
 

ITEM.weight = 1
ITEM.weapondual = false
ITEM.costAP = 1 --how much AP is used when using this weapon normally
ITEM.accuracy = 1 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.class = "aus_m_twohanded_sledgehammer"

ITEM.dmg = {
	["Fire"] = 25
}

--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-500,-500,-500,1}-- arccw_bo1_makarov
ITEM.multi = 3 --how many hits it does, dont need to put it here if it's just 1

ITEM.reqStats = {
  ["str"] = 3,
}

ITEM.skillScaleAcc = {
["melee"] = 2,
}

ITEM.skillScaleDmg = {
["melee"] = 0.35,
}

ITEM.actions = {	
"charge",
"wideswing",

}

--use this if you want things sto scale off of stats
--[[
ITEM.scaling = { --added to damage calculation
	["stm"] = 0.2,
	["talent"] = 0.2,
}
--]]