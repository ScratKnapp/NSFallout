ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Spore Carrier"
ENT.Category = "NutScript - Combat (Mutants and Animals)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Spore Carrier"

ENT.model = "models/fallout/sporecarrier.mdl"
ENT.hp = 100
ENT.dmg = {
	["Blunt"] = 25,
	["Acid"] = 10,
}
ENT.accuracy = 20
ENT.evasion = 5

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
	["cha"] = 5,
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