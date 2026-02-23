ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Tribal Warrior"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Tribal Warrior"

ENT.models = {
    "models/gore/neutrals/tribals/tribal boyd.mdl",
	"models/gore/neutrals/tribals/tribal frank.mdl",
    "models/gore/neutrals/tribals/tribal horst.mdl",
	"models/gore/neutrals/tribals/tribal torv.mdl",
    "models/gore/neutrals/tribals/shaman torv.mdl",
	"models/gore/neutrals/tribals/shaman horst.mdl",
    "models/gore/neutrals/tribals/shaman frank.mdl",
	"models/gore/neutrals/tribals/shaman boyd.mdl",

}

ENT.hp = 100
ENT.accuracy = 10
ENT.evasion = 8

ENT.dmg = {
	["Slash"] = 36
}

ENT.armor = {
	["Head"] = 10,
	["Body"] = 10,
	["Left Arm"] = 10,
	["Right Arm"] = 10,
	["Left Leg"] = 10,
	["Right Leg"] = 10,
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
	["str"] = 9,
	["per"] = 6,
	["end"] = 8,
	["cha"] = 2,
	["int"] = 2,
	["agi"] = 0,
	["luck"] = 5,

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