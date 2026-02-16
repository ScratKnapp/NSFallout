ITEM.name = "Atomic Fist"
ITEM.desc = "A prototype powerfist intended for military use, made with an internalized servo system powered by a micro-fusion pack within. Punch with Nuclear Power."
ITEM.model = "models/models/bos/saturnitefist.mdl"
ITEM.width = 2
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(295, 242.12812805176, 186),
	ang = Angle(25, 220, 0),
	fov = 3,
	outline = true,
	outlineColor = Color(16, 255, 0),
}
ITEM.specialSlot = "Sidearm"
ITEM.category = "Weapon - Melee"
ITEM.durability = 200
ITEM.price = 200
 

ITEM.weight = 1
ITEM.weapondual = false
ITEM.costAP = 1 --how much AP is used when using this weapon normally
ITEM.accuracy = 1 --bonus accuracy, can also go negative. defaults to 0 if not setITEM.costAP = 1 --how much AP is used when using this weapon normally
ITEM.class = "aus_m_fists_powerfist"

ITEM.dmg = {
	["Blunt"] = 25
}

--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-100,-100,-100,1}-- arccw_bo1_makarov

ITEM.reqStats = {
  ["str"] = 4,
}

ITEM.skillScaleAcc = {
	["unarmed"] = 2,}

ITEM.skillScaleDmg = {
    ["unarmed"] = 0.8,}


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