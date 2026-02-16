ITEM.name = "Sledgehammer"
ITEM.desc = "A large hammer meant for demolishing."
ITEM.model = "models/mosi/fallout4/props/weapons/melee/sledgehammer.mdl"
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
ITEM.durability = 200
ITEM.price = 350
 

ITEM.weight = 1
ITEM.weapondual = false
ITEM.costAP = 1 --how much AP is used when using this weapon normally
ITEM.accuracy = 1 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.class = "aus_m_twohanded_sledgehammer"

ITEM.dmg = {
	["Blunt"] = 25
}

--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-100,-100,-100,1}-- arccw_bo1_makarov

ITEM.reqStats = {
  ["str"] = 3,
}

ITEM.skillScaleAcc = {
["melee"] = 2,
}

ITEM.skillScaleDmg = {
["melee"] = 0.45,
}

ITEM.actions = {	
"charge",
"heavyattack",
"wideswing",

}

--use this if you want things sto scale off of stats
--[[
ITEM.scaling = { --added to damage calculation
	["stm"] = 0.2,
	["talent"] = 0.2,
}
--]]