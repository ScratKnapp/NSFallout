ITEM.name = "Tire Iron Axe"
ITEM.desc = "A tire iron with a long, flag piece of metal to turn it into a rusty axe."
ITEM.model = "models/mosi/fallout4/props/weapons/melee/tireiron.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(240.51947021484, 198.01290893555, 152.5052947998),
	ang = Angle(25, 220, 0),
	fov = 4.8,
	outline = true,
	outlineColor = Color(16, 255, 0),
}
ITEM.specialSlot = "Sidearm"
ITEM.category = "Weapon - Melee"
ITEM.durability = 200
ITEM.price = 40
 

ITEM.weight = 1
ITEM.weapondual = false
ITEM.costAP = 1 --how much AP is used when using this weapon normally
ITEM.accuracy = 1 --bonus accuracy, can also go negative. defaults to 0 if not set
ITEM.class = "aus_m_tireiron_axe"

ITEM.dmg = {
	["Slash"] = 13
}

--long, medium, close
--the number in here determines the affects on accuracy at that range 
-- -1 in the first spot will reduce accuracy at long range by 1
-- 1 in the last spot will increase accuracy at close range by 1
ITEM.range = {-500,-500,-500,1}-- arccw_bo1_makarov

ITEM.reqStats = {
  ["str"] = 2,
}

ITEM.skillScaleAcc = {
["melee"] = 2,
}

ITEM.skillScaleDmg = {
["melee"] = 0.35,}

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