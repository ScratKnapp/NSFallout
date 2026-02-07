ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Legion Vexillarius"
ENT.Category = "NutScript - Combat (Caeser's Legion)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Legion Vexillarius"

ENT.models = {
    "models/gore/legion remake/prime/VexillariusFrank.mdl",
    "models/gore/legion remake/prime/VexillariusFrank02.mdl",
    "models/gore/legion remake/prime/VexillariusFrank03.mdl",
    "models/gore/legion remake/prime/VexillariusHorst.mdl",
    "models/gore/legion remake/prime/VexillariusHorst02.mdl",
    "models/gore/legion remake/prime/VexillariusHorst03.mdl",
    "models/gore/legion remake/prime/VexillariusTorv.mdl",
    "models/gore/legion remake/prime/VexillariusTorv02.mdl",
    "models/gore/legion remake/prime/VexillariusTorv03.mdl",
}

ENT.hp = 125
ENT.accuracy = 16
ENT.evasion = 5

ENT.dmg = {
	[".308"] = 45
}

ENT.armor = {
	["Head"] = 20,
	["Body"] = 20,
	["Left Arm"] = 15,
	["Right Arm"] = 15,
	["Left Leg"] = 15,
	["Right Leg"] = 15,
}

--all attributes
ENT.attribs = {
	["str"] = 6,
	["per"] = 7,
	["end"] = 6,
	["cha"] = 10,
	["int"] = 3,
	["agi"] = 0,
	["luck"] = 6,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 17,
	["energyweapons"] = 0,
	["melee"] = 17,
	["throwing"] = 12,

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