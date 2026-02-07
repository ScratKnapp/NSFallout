ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Mercenary"
ENT.Category = "NutScript - Combat (Wastelanders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Mercenary"

ENT.models = {
    "models/gore/nomads/mercenarym_01.mdl",
    "models/gore/nomads/mercenarym_02.mdl",
    "models/gore/nomads/mercenarym_03.mdl",
    "models/gore/nomads/mercenarym_04.mdl",
    "models/gore/nomads/nomad_10.mdl",
    "models/gore/nomads/nomad_iconoclast.mdl",
    "models/gore/nomads/mercenaryf_02.mdl",
	"models/gore/nomads/mercenaryf_01.mdl",
	"models/gore/nomads/lightarmor_female.mdl",
	"models/gore/nomads/lightarmor_male.mdl",
	"models/gore/nomads/nomad_kellogm.mdl",
	"models/gore/nomads/nomad_kellogf.mdl",
	"models/gore/nomads/nomad_scavenger.mdl",
	"models/gore/nomads/combatarmor_female.mdl",
	"models/gore/nomads/combatarmor_male.mdl",


}

ENT.hp = 100
ENT.dmg = {
	["5.56"] = 30,
}
ENT.accuracy = 10
ENT.evasion = 5

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
	["evasion"] = 6,
	["guns"] = 9,
	["energyweapons"] = 0,
	["melee"] = 9,
	["throwing"] = 6,

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