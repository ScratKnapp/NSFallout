ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Nightkin"
ENT.Category = "NutScript - Combat (Supermutant)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Nightkin"

ENT.model = "models/cpthazama/fallout/supermutant_nightkin.mdl"
ENT.hp = 250
ENT.dmg = {
	["12 Gauge"] = 45,
}
ENT.accuracy = 20
ENT.evasion = -5

ENT.armor = {
	["Head"] = 20,
	["Body"] = 20,
	["Left Arm"] = 20,
	["Right Arm"] = 20,
	["Left Leg"] = 20,
	["Right Leg"] = 20,
}

ENT.armorBreak = {
	["Head"] = 10,
	["Body"] = 10,
	["Left Arm"] = 10,
	["Right Arm"] = 10,
	["Left Leg"] = 10,
	["Right Leg"] = 10,
}



--all attributes
ENT.attribs = {
	["str"] = 0,
	["per"] = 0,
	["end"] = 0,
	["cha"] = 1,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 10,

}

ENT.skills = {
}

ENT.res = {
}

ENT.actions = {
"charge",
}

ENT.tags = {
	["Biological"] = true,
	["Humanoid"] = true,
	["Living"] = true,
	["Authoriity"] = true,
}

function ENT:Initialize()
	self:basicSetup()
end