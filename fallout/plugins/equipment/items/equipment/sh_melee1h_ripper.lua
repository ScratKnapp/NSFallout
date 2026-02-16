ITEM.name = "Ripper"
ITEM.desc = "A handheld, self powered, militarized chainsaw."
ITEM.model = "models/halokiller38/fallout/weapons/melee/ripper.mdl"
ITEM.width = 3
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(413, 329.48767089844, 260.5),
	ang = Angle(25, 220, 0),
	fov = 3,
	outline = true,
	outlineColor = Color(16, 255, 0),
}
ITEM.specialSlot = "Sidearm"
ITEM.category = "Weapon - Melee"
ITEM.durability = 400
ITEM.price = 500
 

ITEM.weight = 1
ITEM.weapondual = false
ITEM.costAP = 1 --how much AP is used when using this weapon normally
ITEM.accuracy = 1 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.class = "aus_m_chineseofficersword"

ITEM.dmg = {
	["Electric"] = 15
}
ITEM.multi = 3 --how many hits it does, dont need to put it here if it's just 1

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