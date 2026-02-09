ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Princeps Legionary"
ENT.Category = "NutScript - Combat (Caeser's Legion)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Princeps Legionary"

ENT.models = {
	"models/gore/legion remake/prime/princepsfrank.mdl",
	"models/gore/legion remake/prime/princepsfrank02.mdl",
	"models/gore/legion remake/prime/princepsfrank03.mdl",
	"models/gore/legion remake/prime/princepshorst.mdl",
	"models/gore/legion remake/prime/princepshorst02.mdl",
	"models/gore/legion remake/prime/princepshorst03.mdl",
	"models/gore/legion remake/prime/princepstorv.mdl",
	"models/gore/legion remake/prime/princepstorv02.mdl",
	"models/gore/legion remake/prime/princepstorv03.mdl",
}

ENT.hp = 125
ENT.accuracy = 12
ENT.evasion = 6

ENT.dmg = {
	["5.56"] = 40
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
	["guns"] = 10,
	["energyweapons"] = 0,
	["melee"] = 10,
	["throwing"] = 8,

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