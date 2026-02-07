ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Legion Explorer"
ENT.Category = "NutScript - Combat (Caeser's Legion)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Legion Explorer"

ENT.models = {
	"models/gore/legion remake/recruit/explorertorv.mdl",
	"models/gore/legion remake/recruit/explorerhorst.mdl",
	"models/gore/legion remake/recruit/explorerfrank.mdl",
}

ENT.hp = 100
ENT.accuracy = 15
ENT.evasion = 5

ENT.dmg = {
	[".308"] = 40
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
	["cha"] = 6,
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