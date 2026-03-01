ITEM.name = "Forged Shield"
ITEM.desc = "A well made shield forged by a blacksmith and treated for tensile strength. Weighted for shield bashing."
ITEM.model = "models/halokiller38/fallout/weapons/misc/binoculars.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(340, 273.5, 219),
	ang = Angle(25, 220, 0),
	fov = 3.2,
	outline = true,
	outlineColor = Color(16, 255, 0),
}
ITEM.specialSlot = "Primary"
ITEM.category = "Weapon - Melee"
ITEM.durability = 200
ITEM.price = 500
 

ITEM.weight = 1
ITEM.weapondual = false
ITEM.costAP = 1 --how much AP is used when using this weapon normally
ITEM.accuracy = 1 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.class = "aus_m_baseballbat_wood_barbwire"

ITEM.dmg = {
	["Blunt"] = 15
}

--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-500,-500,-500,1}-- arccw_bo1_makarov

ITEM.reqStats = {
  ["str"] = 1,
}

ITEM.reqStats = {
  ["str"] = 1,
}

ITEM.skillScaleAcc = {
["melee"] = 2,}

ITEM.skillScaleDmg = {
["melee"] = 0.3,}

ITEM.actions = {	
"block3",

}

--use this if you want things sto scale off of stats
--[[
ITEM.scaling = { --added to damage calculation
	["stm"] = 0.2,
	["talent"] = 0.2,
}
--]]