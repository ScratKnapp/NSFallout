ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Yao Guai"
ENT.Category = "NutScript - Combat (Mutants and Animals)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Yao Guai"

ENT.model = "models/fallout/yaoguai.mdl"
ENT.hp = 1000
ENT.dmg = {
	["Slash"] = 45,
}
ENT.accuracy = 40
ENT.evasion = 0

ENT.armor = {
	["Head"] = 0,
	["Body"] = 0,
	["Left Arm"] = 0,
	["Right Arm"] = 0,
	["Left Leg"] = 0,
	["Right Leg"] = 0,
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