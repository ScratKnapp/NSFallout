ITEM.name = "Walking Cane"
ITEM.desc = "A wooden cane."

ITEM.model = "models/mosi/fallout4/props/weapons/melee/walkingcane.mdl"
ITEM.width = 2
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(387.11880493164, 325.79251098633, 247.03421020508),
	ang = Angle(25, 220, 0),
	fov = 3.8,
	outline = true,
	outlineColor = Color(16, 255, 0),
}
ITEM.specialSlot = "Sidearm"
ITEM.category = "Weapon - Melee"
ITEM.durability = 200
ITEM.price = 75
 

ITEM.weight = 1
ITEM.weapondual = false
ITEM.costAP = 1 --how much AP is used when using this weapon normally
ITEM.accuracy = 1 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.class = "aus_m_walkingcane"
ITEM.critC = 5

ITEM.dmg = {
	["Blunt"] = 12
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