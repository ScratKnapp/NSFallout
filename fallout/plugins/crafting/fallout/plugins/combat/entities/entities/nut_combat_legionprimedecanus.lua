ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Princeps Legion Decanus"
ENT.Category = "NutScript - Combat (Caeser's Legion)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Princeps Legion Decanus"

ENT.models = {
	"models/gore/legion remake/prime/princepsdecanusfrank.mdl",
	"models/gore/legion remake/prime/princepsdecanusfrank02.mdl",
	"models/gore/legion remake/prime/princepsdecanusfrank03.mdl",
	"models/gore/legion remake/prime/princepsdecanushorst.mdl",
	"models/gore/legion remake/prime/princepsdecanushorst02.mdl",
	"models/gore/legion remake/prime/princepsdecanushorst03.mdl",
	"models/gore/legion remake/prime/princepsdecanustorv.mdl",
	"models/gore/legion remake/prime/princepsdecanustorv02.mdl",
	"models/gore/legion remake/prime/princepsdecanustorv03.mdl",
}

ENT.hp = 125
ENT.accuracy = 14
ENT.evasion = 8

ENT.dmg = {
	["Slash"] = 40
}

ENT.armor = {
	["Head"] = 15,
	["Body"] = 15,
	["Left Arm"] = 12,
	["Right Arm"] = 12,
	["Left Leg"] = 12,
	["Right Leg"] = 12,
}

--all attributes
ENT.attribs = {
	["str"] = 6,
	["per"] = 7,
	["end"] = 5,
	["cha"] = 2,
	["int"] = 3,
	["agi"] = 0,
	["luck"] = 5,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 15,
	["energyweapons"] = 0,
	["melee"] = 12,
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