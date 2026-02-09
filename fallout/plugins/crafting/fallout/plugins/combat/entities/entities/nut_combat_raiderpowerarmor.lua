ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Legion Deserter Gladiator"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Legion Deserter Gladiator"

ENT.model = "models/gore/subfactions/gladiator_otho.mdl"
ENT.hp = 150
ENT.dmg = {
	["Slash"] = 30,
}
ENT.accuracy = 10
ENT.evasion = 5

ENT.armor = {
	["Head"] = 20,
	["Body"] = 8,
	["Left Arm"] = 4,
	["Right Arm"] = 4,
	["Left Leg"] = 4,
	["Right Leg"] = 4,
}

--all attributes
ENT.attribs = {
	["str"] = 0,
	["per"] = 0,
	["end"] = 0,
	["cha"] = 2,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 8,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 20,
	["energyweapons"] = 20,
	["melee"] = 20,
	["throwing"] = 20,

}

ENT.res = {
}

ENT.actions = {
"dodge",
"charge",
"burstfire_rifle",
"doubletap_pistol",
"aimedshot_precision",

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