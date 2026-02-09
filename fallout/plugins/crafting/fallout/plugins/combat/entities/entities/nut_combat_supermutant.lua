ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Supermutant"
ENT.Category = "NutScript - Combat (Supermutant)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Supermutant"

ENT.model = "models/cpthazama/fallout/supermutant.mdl"
ENT.hp = 120
ENT.dmg = {
	[".38"] = 18,
}
ENT.accuracy = 15
ENT.evasion = -5

ENT.armor = {
	["Head"] = 3,
	["Body"] = 3,
	["Left Arm"] = 3,
	["Right Arm"] = 3,
	["Left Leg"] = 3,
	["Right Leg"] = 3,
}

--all attributes
ENT.attribs = {
	["str"] = 0,
	["per"] = 0,
	["end"] = 0,
	["cha"] = 1,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 1,

}

ENT.skills = {
}

ENT.res = {
}

ENT.actions = {
"burstfire_rifle",

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