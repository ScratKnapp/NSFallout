ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Supermutant Brute"
ENT.Category = "NutScript - Combat (Supermutant)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Supermutant Brute"

ENT.model = "models/cpthazama/fallout/supermutant_medium.mdl"
ENT.hp = 120
ENT.dmg = {
	["5.56"] = 35,
}
ENT.accuracy = 10
ENT.evasion = -5

ENT.armor = {
	["Head"] = 12,
	["Body"] = 14,
	["Left Arm"] = 8,
	["Right Arm"] = 8,
	["Left Leg"] = 8,
	["Right Leg"] = 8,
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
}

ENT.res = {
}

ENT.actions = {
"burstfire_rifle",

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