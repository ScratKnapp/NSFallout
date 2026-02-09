ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Legion Hastatus"
ENT.Category = "NutScript - Combat (Caeser's Legion)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Legion Hastatus"

ENT.models = {
	"models/gore/legion remake/recruit/hastatus frank01.mdl",
	"models/gore/legion remake/recruit/hastatus frank02.mdl",
	"models/gore/legion remake/recruit/hastatus frank03.mdl",
	"models/gore/legion remake/recruit/hastatus frank04.mdl",
	"models/gore/legion remake/recruit/hastatus horst01.mdl",
	"models/gore/legion remake/recruit/hastatus horst02.mdl",
	"models/gore/legion remake/recruit/hastatus horst03.mdl",
	"models/gore/legion remake/recruit/hastatus horst04.mdl",
	"models/gore/legion remake/recruit/hastatus torv01.mdl",
	"models/gore/legion remake/recruit/hastatus torv02.mdl",
	"models/gore/legion remake/recruit/hastatus torv03.mdl",
	"models/gore/legion remake/recruit/hastatus torv04.mdl",
}

ENT.hp = 100
ENT.accuracy = 12
ENT.evasion = 10

ENT.dmg = {
	["Slash"] = 36
}

ENT.armor = {
	["Head"] = 10,
	["Body"] = 12,
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
	["cha"] = 5,
	["int"] = 2,
	["agi"] = 0,
	["luck"] = 4,

}

ENT.skills = {
	["evasion"] = 6,
	["guns"] = 9,
	["energyweapons"] = 0,
	["melee"] = 9,
	["throwing"] = 7,

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