ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Supermutant"
ENT.Category = "NutScript - Combat (Supermutant)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Supermutant"

ENT.model = "models/cpthazama/fallout/supermutant.mdl"
ENT.hp = 200
ENT.dmg = {
	[".38"] = 18,
}
ENT.accuracy = 15
ENT.evasion = -5

ENT.armor = {
	["Head"] = 5,
	["Body"] = 5,
	["Left Arm"] = 5,
	["Right Arm"] = 5,
	["Left Leg"] = 5,
	["Right Leg"] = 5,
}

ENT.armorBreak = {
	["Head"] = 10,
	["Body"] = 10,
	["Left Arm"] = 10,
	["Right Arm"] = 10,
	["Left Leg"] = 10,
	["Right Leg"] = 10,
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
}

ENT.res = {
}

ENT.actions = {
"dodge",
"charge",
"burstfire_smg",
"runngun",
"burstfire_rifle",
"suppression1",
"doubletap_pistol",
"doubletap_precision",
"aimedshot_precision",
"grenade_firebomb",

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