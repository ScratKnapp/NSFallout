ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Forager Ant Soldier"
ENT.Category = "NutScript - Combat (Mutants and Animals)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Ant Soldier"

ENT.model = "models/fallout/giantant.mdl"
ENT.hp = 80
ENT.dmg = {
	["Slash"] = 20,
}
ENT.accuracy = 65
ENT.evasion = 10
ENT.modelScale = 0.8

ENT.armor = {
	["Head"] = 5,
	["Body"] = 5,
	["Left Arm"] = 5,
	["Right Arm"] = 5,
	["Left Leg"] = 5,
	["Right Leg"] = 5,
}

--the amount of hits the part can take before armor is broken (reduced to 0)
ENT.armorBreak = {
	["Head"] = 15,
	["Body"] = 15,
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
	["cha"] = 0,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 0,

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