ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Mirelurk King"
ENT.Category = "NutScript - Combat (Mutants and Animals)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Mirelurk"

ENT.model = "models/fallout/mirelurkking.mdl"
ENT.hp = 200
ENT.dmg = {
	["Sonic"] = 40,
}
ENT.accuracy = 10
ENT.evasion = 10

ENT.armor = {
	["Head"] = 10,
	["Body"] = 16,
	["Left Arm"] = 16,
	["Right Arm"] = 16,
	["Left Leg"] = 16,
	["Right Leg"] = 16,
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