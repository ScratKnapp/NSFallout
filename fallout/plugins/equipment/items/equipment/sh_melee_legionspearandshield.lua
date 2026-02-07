ITEM.name = "Legionary Spear and Shield"
ITEM.desc = "A Legionary's spear paired together with a shield."
ITEM.model = "models/props/spear.mdl"
ITEM.width = 3
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(585.28594970703, 464.05227661133, 385.62091064453),
	ang = Angle(25, 220, 0),
	fov = 1.5,
	outline = true,
	outlineColor = Color(16, 255, 0),
}
ITEM.specialSlot = "Primary"
ITEM.category = "Weapon - Melee"
ITEM.durability = 500
ITEM.price = 350
 

ITEM.weight = 1
ITEM.weapondual = false
ITEM.costAP = 1 --how much AP is used when using this weapon normally
ITEM.accuracy = 1 --bonus accuracy, can also go negative. defaults to 0 if not setITEM.costAP = 1 --how much AP is used when using this weapon normally
ITEM.class = "aus_m_spear_poolcue_shielded"

ITEM.dmg = {
	["Slash"] = 20
}

--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-100,-100,-100,1}-- arccw_bo1_makarov
-- arccw_bo1_makarov

ITEM.reqStats = {
  ["str"] = 3,
}

ITEM.skillScaleAcc = {
	["melee"] = 2,}

ITEM.skillScaleDmg = {
["melee"] = 1.5,}

ITEM.actions = {	
"charge",
"stun",
"heavyattack",
"block",
"wideswing",


}

--use this if you want things sto scale off of stats
--[[
ITEM.scaling = { --added to damage calculation
	["stm"] = 0.2,
	["talent"] = 0.2,
}
--]]