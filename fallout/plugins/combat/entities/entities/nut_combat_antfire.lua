ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Fire Ant"
ENT.Category = "NutScript - Combat (Mutants and Animals)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Fire Ant"

ENT.model = "models/fallout/giantant.mdl"
ENT.hp = 100
ENT.dmg = {
	["Fire"] = 25,
}
ENT.accuracy = 10
ENT.evasion = 10

ENT.armor = {
	["Head"] = 10,
	["Body"] = 10,
	["Left Arm"] = 10,
	["Right Arm"] = 10,
	["Left Leg"] = 10,
	["Right Leg"] = 10,
}

--the amount of hits the part can take before armor is broken (reduced to 0)
ENT.armorBreak = {
	["Head"] = 2,
	["Body"] = 2,
	["Left Arm"] = 2,
	["Right Arm"] = 2,
	["Left Leg"] = 2,
	["Right Leg"] = 2,
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