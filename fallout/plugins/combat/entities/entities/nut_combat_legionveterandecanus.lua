ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Triarii Legion Decanus"
ENT.Category = "NutScript - Combat (Caeser's Legion)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Triarii Legion Decanus"

ENT.models = {
	"models/gore/legion remake/veteran/triariidecanushorst.mdl",
	"models/gore/legion remake/veteran/triariidecanustorv.mdl",
	"models/gore/legion remake/veteran/triariidecanusfrank.mdl",
}

ENT.hp = 150
ENT.accuracy = 15
ENT.evasion = 8

ENT.dmg = {
	["5mm"] = 45
}

ENT.armor = {
	["Head"] = 20,
	["Body"] = 20,
	["Left Arm"] = 17,
	["Right Arm"] = 17,
	["Left Leg"] = 17,
	["Right Leg"] = 17,
}

--all attributes
ENT.attribs = {
	["str"] = 7,
	["per"] = 8,
	["end"] = 6,
	["cha"] = 10,
	["int"] = 4,
	["agi"] = 1,
	["luck"] = 6,

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