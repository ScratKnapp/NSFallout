ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Bandidos Enforcer"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Bandidos Enforcer"

ENT.models = {
    "models/gore/nomads/nomadm_armored.mdl",
	"models/gore/nomads/nomadm_09.mdl",
	"models/gore/nomads/nomadm_04.mdl",
	"models/gore/nomads/mercenary_armored.mdl",
  	"models/gore/nomads/nomadm_01.mdl",
	"models/gore/nomads/mercenaryf_armored.mdl",

}

ENT.hp = 125
ENT.dmg = {
	["12 Gauge"] = 30,
}
ENT.accuracy = 15
ENT.evasion = 12

ENT.armor = {
	["Head"] = 15,
	["Body"] = 15,
	["Left Arm"] = 15,
	["Right Arm"] = 15,
	["Left Leg"] = 15,
	["Right Leg"] = 15,
}

ENT.armorBreak = {
	["Head"] = 8,
	["Body"] = 8,
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