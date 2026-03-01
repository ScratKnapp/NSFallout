ITEM.name = "Shishkebab"
ITEM.desc = "A katana strapped a fuel canister and nozzle to ignite foes."
ITEM.model = "models/mosi/fallout4/props/weapons/melee/shishkebab.mdl"
ITEM.width = 3
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(392, 320.2614440918, 251),
	ang = Angle(25, 220, 0),
	fov = 3.5,
	outline = true,
	outlineColor = Color(16, 255, 0),
}
ITEM.specialSlot = "Sidearm"
ITEM.category = "Weapon - Melee"
ITEM.durability = 200
ITEM.price = 1000
 

ITEM.weight = 1
ITEM.weapondual = false
ITEM.costAP = 1 --how much AP is used when using this weapon normally
ITEM.accuracy = 1 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.class = "aus_m_shishkebab"

ITEM.dmg = {
	["Fire"] = 30
}

--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-500,-500,-500,1}-- arccw_bo1_makarov

ITEM.reqStats = {
  ["str"] = 4,
}

ITEM.skillScaleAcc = {
["melee"] = 2,
}

ITEM.skillScaleDmg = {
["melee"] = 0.5,
}

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