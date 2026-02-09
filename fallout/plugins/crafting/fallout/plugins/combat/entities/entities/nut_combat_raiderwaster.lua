ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Legion Deserter"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Legion Deserter"

ENT.models = {
	"models/gore/subfactions/legion_nomad13.mdl",
	"models/gore/subfactions/legion_nomad14.mdl",
	"models/gore/subfactions/legion_nomad15.mdl",
	"models/gore/subfactions/legion_nomad20.mdl",
	"models/gore/subfactions/legion_nomad38.mdl",
	"models/gore/subfactions/legion_nomad39.mdl",

}
ENT.hp = 100
ENT.dmg = {
	["Slash"] = 25,
}
ENT.accuracy = 10
ENT.evasion = 5

ENT.armor = {
	["Head"] = 5,
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
	["luck"] = 6,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 10,
	["energyweapons"] = 10,
	["melee"] = 10,
	["throwing"] = 10,

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