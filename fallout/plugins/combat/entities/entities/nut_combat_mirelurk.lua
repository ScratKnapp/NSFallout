ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Mirelurk"
ENT.Category = "NutScript - Combat (Mutants and Animals)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Mirelurk"

ENT.model = "models/fallout/mirelurk.mdl"
ENT.hp = 100
ENT.dmg = {
	["Slash"] = 25,
}
ENT.accuracy = 10
ENT.evasion = 10

ENT.armor = {
	["Head"] = 3,
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
	["cha"] = 5,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 5,

}

ENT.skills = {
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