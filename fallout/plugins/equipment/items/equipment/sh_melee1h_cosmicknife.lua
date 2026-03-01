ITEM.name = "Cosmic Combat Knife"
ITEM.desc = "A short blade made with saturnite, intended to never dull or chip, and can stay superheated for hours."
ITEM.model = "models/mosi/fallout4/props/weapons/melee/knife.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(161, 128.92478942871, 100.83079528809),
	ang = Angle(25, 220, 0),
	fov = 3,
	outline = true,
	outlineColor = Color(16, 255, 0),
}
ITEM.specialSlot = "Sidearm"
ITEM.category = "Weapon - Melee"
ITEM.durability = 200
ITEM.price = 100
 

ITEM.weight = 1
ITEM.weapondual = false
ITEM.costAP = 1 --how much AP is used when using this weapon normally
ITEM.accuracy = 1 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.class = "aus_m_knife_combatknife"
ITEM.critC = 5

ITEM.dmg = {
	["Slash"] = 40
}

--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-500,-500,-500,1}-- arccw_bo1_makarov
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
"pommel",

}

--use this if you want things sto scale off of stats
--[[
ITEM.scaling = { --added to damage calculation
	["stm"] = 0.2,
	["talent"] = 0.2,
}
--]]