ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Black Khans Boss"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Black Khans Boss"

ENT.model = "models/gore/nomads/nomadm_armored.mdl"
ENT.hp = 100
ENT.dmg = {
	["12 Gauge"] = 35,
}
ENT.accuracy = 10
ENT.evasion = 5

ENT.armor = {
	["Head"] = 10,
	["Body"] = 12,
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
	["cha"] = 2,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 6,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 18,
	["energyweapons"] = 18,
	["melee"] = 18,
	["throwing"] = 18,

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