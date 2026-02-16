ITEM.name = "Spiked Board"
ITEM.desc = "A wooden board with nails driven through the end."
ITEM.model = "models/mosi/fallout4/props/weapons/melee/board.mdl"
ITEM.width = 3
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(554.14208984375, 450.98037719727, 352.94116210938),
	ang = Angle(25, 220, 0),
	fov = 2,
	outline = true,
	outlineColor = Color(16, 255, 0),
}
ITEM.specialSlot = "Primary"
ITEM.category = "Weapon - Melee"
ITEM.durability = 500
ITEM.price = 50

ITEM.weight = 1
ITEM.weapondual = false
ITEM.costAP = 1 --how much AP is used when using this weapon normally
ITEM.accuracy = 1 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.class = "aus_m_board_spiked"

ITEM.dmg = {
	["Slash"] = 16
}

--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-100,-100,-100,1}-- arccw_bo1_makarov

ITEM.reqStats = {
  ["str"] = 1,
}

ITEM.skillScaleAcc = {
["melee"] = 2,}

ITEM.skillScaleDmg = {
["melee"] = 1.5,}

ITEM.actions = {	
"charge",
"wideswing",
"heavyattack",

}

--use this if you want things sto scale off of stats
--[[
ITEM.scaling = { --added to damage calculation
	["stm"] = 0.2,
	["talent"] = 0.2,
}
--]]