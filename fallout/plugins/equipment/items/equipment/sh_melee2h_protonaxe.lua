ITEM.name = "Proton Axe"
ITEM.desc = "A weapon that resembles a futuristic war-axe with a glowing blue blade of electrical energy at its head and two capacitors on the other side, which share the same blue electric current."
ITEM.model = "models/weapons/tfa_fallout/w_fallout_proton_axe.mdl"
ITEM.width = 3
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(15, 200, -4),
	ang = Angle(0, 270, 0),
	fov = 4,
	outline = true,
	outlineColor = Color(90, 90, 90),
}
ITEM.specialSlot = "Primary"
ITEM.category = "Weapon - Melee"
ITEM.durability = 500
ITEM.price = 500
 

ITEM.weight = 1
ITEM.weapondual = false
ITEM.costAP = 1 --how much AP is used when using this weapon normally
ITEM.accuracy = 1 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.class = "aus_m_twohanded_grognakaxe"

ITEM.dmg = {
	["Slash"] = 55
}

--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-100,-100,-100,1}-- arccw_bo1_makarov

ITEM.reqStats = {
  ["str"] = 5,
}

ITEM.skillScaleAcc = {
	["melee"] = 2,}

ITEM.skillScaleDmg = {
["melee"] = 1.5,}

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