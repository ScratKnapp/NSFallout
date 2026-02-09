ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Legion Sagitarius"
ENT.Category = "NutScript - Combat (Caeser's Legion)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Legion Sagitarius"

ENT.models = {
	"models/gore/legion remake/prime/saggitariusfrank.mdl",
	"models/gore/legion remake/prime/saggitariusfrank02.mdl",
	"models/gore/legion remake/prime/saggitariusfrank03.mdl",
	"models/gore/legion remake/prime/saggitariushorst.mdl",
	"models/gore/legion remake/prime/saggitariushorst02.mdl",
	"models/gore/legion remake/prime/saggitariushorst03.mdl",
	"models/gore/legion remake/prime/saggitariustorv.mdl",
	"models/gore/legion remake/prime/saggitariustorv02.mdl",
	"models/gore/legion remake/prime/saggitariustorv03.mdl",
}

ENT.hp = 125
ENT.accuracy = 18
ENT.evasion = 5

ENT.dmg = {
	[".308"] = 45
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
	["per"] = 7,
	["end"] = 5,
	["cha"] = 8,
	["int"] = 2,
	["agi"] = 0,
	["luck"] = 4,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 8,
	["energyweapons"] = 0,
	["melee"] = 8,
	["throwing"] = 5,

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