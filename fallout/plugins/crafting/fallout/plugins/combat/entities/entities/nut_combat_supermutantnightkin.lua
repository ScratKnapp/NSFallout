ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Nightkin"
ENT.Category = "NutScript - Combat (Supermutant)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Nightkin"

ENT.model = "models/cpthazama/fallout/supermutant_nightkin.mdl"
ENT.hp = 220
ENT.dmg = {
	["Blunt"] = 35,
}
ENT.accuracy = 10
ENT.evasion = -5

ENT.armor = {
	["Head"] = 18,
	["Body"] = 22,
	["Left Arm"] = 12,
	["Right Arm"] = 12,
	["Left Leg"] = 12,
	["Right Leg"] = 12,
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