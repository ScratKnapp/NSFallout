ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Rattlesnakes Enforcer"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Rattlesnakes Enforcer"

ENT.models = {
    "models/gore/nomads/nomadm_armored.mdl",
	"models/gore/nomads/nomadm_09.mdl",
	"models/gore/nomads/nomadm_04.mdl",
	"models/gore/nomads/mercenary_armored.mdl",
  	"models/gore/nomads/nomadm_01.mdl",
	"models/gore/nomads/mercenaryf_armored.mdl",

}

ENT.hp = 100
ENT.dmg = 32
ENT.dmgT = "12 Gauge"
ENT.dmg = {
	["Fire"] = 25,
}
ENT.accuracy = 15
ENT.evasion = 12

ENT.armor = {
	["Head"] = 10,
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
	["cha"] = 2,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 4,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 14,
	["energyweapons"] = 14,
	["melee"] = 14,
	["throwing"] = 14,

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