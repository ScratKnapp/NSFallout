ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Dog (Coyote)"
ENT.Category = "NutScript - Combat (Mutants and Animals)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Dog (Coyote)"

ENT.model = "models/fallout/coyote.mdl"
ENT.hp = 60
ENT.dmg = {
	["Slash"] = 20,
}
ENT.accuracy = 10
ENT.evasion = 10

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
	["luck"] = 1,

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