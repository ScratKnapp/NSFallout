ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Supermutant Skirmisher"
ENT.Category = "NutScript - Combat (Supermutant)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Supermutant Skirmisher"

ENT.model = "models/cpthazama/fallout/supermutant_light.mdl"
ENT.hp = 120
ENT.dmg = 22
ENT.dmgT = ".45 Auto"
ENT.dmg = {
	[".45 Auto"] = 22,
}
ENT.accuracy = 10
ENT.evasion = -5

ENT.armor = {
	["Head"] = 3,
	["Body"] = 10,
	["Left Arm"] = 6,
	["Right Arm"] = 6,
	["Left Leg"] = 6,
	["Right Leg"] = 6,
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