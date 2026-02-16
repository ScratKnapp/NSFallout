ITEM.name = "Wrench"
ITEM.desc = "A sturdy wrench."

ITEM.model = "models/mosi/fallout4/props/weapons/melee/pipewrench.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(256.07733154297, 213.70385742188, 167.97178649902),
	ang = Angle(25, 220, 0),
	fov = 2,
	outline = true,
	outlineColor = Color(16, 255, 0),
}
ITEM.specialSlot = "Sidearm"
ITEM.category = "Weapon - Melee"
ITEM.durability = 500
ITEM.price = 100
 

ITEM.weight = 1
ITEM.weapondual = false
ITEM.dmg = 12 --base damage
ITEM.dmgT = "Blunt" --damage type
ITEM.costAP = 1 --how much AP is used when using this weapon normally
ITEM.accuracy = 1 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.class = "aus_m_wrench"
ITEM.critC = 5

ITEM.dmg = {
	["Blunt"] = 12
}

--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-100,-100,-100,1}
-- arccw_bo1_makarov

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