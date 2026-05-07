ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Deathclaw"
ENT.Category = "NutScript - Combat (Mutants and Animals)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Deathclaw"

ENT.model = "models/fallout/deathclaw.mdl"
ENT.hp = 1000
ENT.dmg = {
	["Slash"] = 50,
}
ENT.accuracy = 140
ENT.evasion = 0

ENT.armor = {
	["Head"] = 20,
	["Body"] = 20,
	["Left Arm"] = 20,
	["Right Arm"] = 20,
	["Left Leg"] = 20,
	["Right Leg"] = 20,
}

ENT.armorBreak = {
	["Head"] = 50,
	["Body"] = 50,
	["Left Arm"] = 50,
	["Right Arm"] = 50,
	["Left Leg"] = 50,
	["Right Leg"] = 50,
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