ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Gladiator"
ENT.Category = "NutScript - Combat (Wastelanders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Gladiator"

ENT.models = {
    "models/gore/neutrals/auxiliary/gladiator boyd.mdl",
    "models/gore/neutrals/auxiliary/gladiator frank.mdl",
    "models/gore/neutrals/auxiliary/gladiator ghoul.mdl",
    "models/gore/neutrals/auxiliary/gladiator horst.mdl",
    "models/gore/neutrals/auxiliary/gladiator torv.mdl",
    "models/gore/legion remake/mercenary/gladiator torv.mdl",
    "models/gore/legion remake/mercenary/gladiator horst.mdl",
	"models/gore/legion remake/mercenary/gladiator ghoul.mdl",
	"models/gore/legion remake/mercenary/gladiator frank.mdl",
	"models/gore/legion remake/mercenary/gladiator boyd.mdl",
}

ENT.hp = 125
ENT.accuracy = 14
ENT.evasion = 12

ENT.dmg = {
	["Slash"] = 40
}

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
	["str"] = 6,
	["per"] = 6,
	["end"] = 5,
	["cha"] = 6,
	["int"] = 2,
	["agi"] = 2,
	["luck"] = 4,

}

ENT.skills = {
	["evasion"] = 9,
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