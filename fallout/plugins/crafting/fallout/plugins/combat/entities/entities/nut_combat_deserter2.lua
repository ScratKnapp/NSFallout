ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Legion Deserter Raidmaster"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Legion Deserter Raidmaster"

ENT.models = {
    "models/gore/subfactions/legion_nomad23.mdl",
    "models/gore/subfactions/legion_nomad24.mdl",
    "models/gore/subfactions/legion_nomad25.mdl",

}

ENT.hp = 125
ENT.accuracy = 10
ENT.evasion = 5

ENT.dmg = {
	["5.56"] = 38
}

ENT.armor = {
	["Head"] = 12,
	["Body"] = 14,
	["Left Arm"] = 10,
	["Right Arm"] = 10,
	["Left Leg"] = 10,
	["Right Leg"] = 10,
}

--all attributes
ENT.attribs = {
	["str"] = 6,
	["per"] = 6,
	["end"] = 6,
	["cha"] = 2,
	["int"] = 2,
	["agi"] = 0,
	["luck"] = 6,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 15,
	["energyweapons"] = 15,
	["melee"] = 15,
	["throwing"] = 15,

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