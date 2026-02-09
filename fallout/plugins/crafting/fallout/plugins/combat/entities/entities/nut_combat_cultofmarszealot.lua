ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Cult of Mars Zealot"
ENT.Category = "NutScript - Combat (Caeser's Legion)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Cult of Mars Zealot"

ENT.models = {
    "models/gore/neutrals/cult of mars/zealot boyd.mdl",
    "models/gore/neutrals/cult of mars/zealot frank.mdl",
    "models/gore/neutrals/cult of mars/zealot horst.mdl",
    "models/gore/neutrals/cult of mars/zealot torv.mdl",
	"models/gore/neutrals/cult of mars/inquisitor torv.mdl",
}

ENT.hp = 125
ENT.accuracy = 12
ENT.evasion = 8

ENT.dmg = {
	["12 Gauge"] = 38
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
	["cha"] = 10,
	["int"] = 2,
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