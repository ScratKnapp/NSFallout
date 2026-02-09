ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Cazadore"
ENT.Category = "NutScript - Combat (Mutants and Animals)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Cazadore"

ENT.model = "models/fallout/cazadore.mdl"
ENT.hp = 150
ENT.dmg = {
	["Slash"] = 15,
	["Acid"] = 20
}
ENT.accuracy = 20
ENT.evasion = 20

ENT.armor = {
	["Head"] = 5,
	["Body"] = 5,
	["Left Arm"] = 5,
	["Right Arm"] = 5,
	["Left Leg"] = 5,
	["Right Leg"] = 5,
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
"sting",

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