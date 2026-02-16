ITEM.name = "Mantis Gauntlet"
ITEM.desc = "A gauntlet made from a severed giant mantis foreleg, reinforced with metal bars and leather straps."
ITEM.model = "models/halokiller38/fallout/weapons/melee/mantisgauntlet.mdl"
ITEM.width = 2
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(256, 208.02418518066, 158),
	ang = Angle(25, 220, 0),
	fov = 3,
	outline = true,
	outlineColor = Color(16, 255, 0),
}
ITEM.specialSlot = "Sidearm"
ITEM.category = "Weapon - Melee"
ITEM.durability = 200
ITEM.price = 250
 

ITEM.weight = 1
ITEM.weapondual = false
ITEM.costAP = 1 --how much AP is used when using this weapon normally
ITEM.accuracy = 1 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.class = "aus_m_fists_deathclawgauntlet"

ITEM.dmg = {
	["Slash"] = 8
}

--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-100,-100,-100,1}-- arccw_bo1_makarov
-- arccw_bo1_makarov

ITEM.reqStats = {
  ["str"] = 2,
}

ITEM.skillScaleAcc = {
["unarmed"] = 3,}

ITEM.skillScaleDmg = {
["unarmed"] = 0.65,}

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