ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Legion Assassin"
ENT.Category = "NutScript - Combat (Caeser's Legion)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Legion Assassin"

ENT.models = {
	"models/gore/legion remake/veteran/assassinfrank.mdl",
	"models/gore/legion remake/veteran/assassinhorst.mdl",
	"models/gore/legion remake/veteran/assassintorv.mdl",
}

ENT.hp = 150
ENT.accuracy = 22
ENT.evasion = 6

ENT.dmg = {
	[".308"] = 60
}

ENT.armor = {
	["Head"] = 10,
	["Body"] = 6,
	["Left Arm"] = 4,
	["Right Arm"] = 4,
	["Left Leg"] = 4,
	["Right Leg"] = 4,
}

--all attributes
ENT.attribs = {
	["str"] = 5,
	["per"] = 5,
	["end"] = 5,
	["cha"] = 2,
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