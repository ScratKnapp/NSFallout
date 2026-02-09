ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Legion Deserter Scavver"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Legion Deserter Scavver"

ENT.models = {
	"models/gore/legion remake/recruit/deserter boyd.mdl",
	"models/gore/legion remake/recruit/deserter frank.mdl",
	"models/gore/legion remake/recruit/deserter ghoul.mdl",
	"models/gore/legion remake/recruit/deserter horst.mdl",
	"models/gore/legion remake/recruit/deserter torv.mdl",

}
ENT.hp = 100
ENT.accuracy = 10
ENT.evasion = 8

ENT.dmg = {
	["Slash"] = 36
}

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
	["str"] = 6,
	["per"] = 6,
	["end"] = 5,
	["cha"] = 2,
	["int"] = 2,
	["agi"] = 0,
	["luck"] = 4,

}

ENT.skills = {
	["evasion"] = 6,
	["guns"] = 9,
	["energyweapons"] = 9,
	["melee"] = 9,
	["throwing"] = 9,

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