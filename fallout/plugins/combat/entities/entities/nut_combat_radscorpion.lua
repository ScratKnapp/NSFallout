ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Radscorpion"
ENT.Category = "NutScript - Combat (Mutants and Animals)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Radscorpion"

ENT.model = "models/fallout/radscorpion.mdl"
ENT.hp = 300
ENT.dmg = {
	["Slash"] = 30,
	["Acid"] = 10
}
ENT.accuracy = 10
ENT.evasion = 10

ENT.armor = {
	["Head"] = 15,
	["Body"] = 15,
	["Left Arm"] = 15,
	["Right Arm"] = 15,
	["Left Leg"] = 15,
	["Right Leg"] = 15,
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