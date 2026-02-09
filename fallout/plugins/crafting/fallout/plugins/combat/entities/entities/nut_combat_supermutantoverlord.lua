ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Supermutant Overlord"
ENT.Category = "NutScript - Combat (Supermutant)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Supermutant Overlord"

ENT.model = "models/cpthazama/fallout/supermutant_overlord.mdl"
ENT.hp = 320
ENT.dmg = {
	["Laser"] = 40,
}
ENT.accuracy = 20
ENT.evasion = 0

ENT.armor = {
	["Head"] = 22,
	["Body"] = 25,
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
	["cha"] = 1,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 10,

}

ENT.skills = {
}

ENT.res = {
}

ENT.actions = {
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