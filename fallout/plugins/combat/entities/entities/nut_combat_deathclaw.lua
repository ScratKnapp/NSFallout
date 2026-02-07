ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Deathclaw"
ENT.Category = "NutScript - Combat (Mutants and Animals)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Deathclaw"

ENT.model = "models/fallout/deathclaw.mdl"
ENT.hp = 500
ENT.dmg = {
	["Slash"] = 50,
}
ENT.accuracy = 20
ENT.evasion = 8

ENT.armor = {
	["Head"] = 15,
	["Body"] = 20,
	["Left Arm"] = 15,
	["Right Arm"] = 15,
	["Left Leg"] = 15,
	["Right Leg"] = 15,
}

--all attributes
ENT.attribs = {
	["str"] = 0,
	["per"] = 0,
	["end"] = 0,
	["cha"] = 1,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 5,

}

ENT.skills = {
	["evasion"] = 0,
}

ENT.res = {
}

ENT.actions = {
"charge",
"dodge",

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