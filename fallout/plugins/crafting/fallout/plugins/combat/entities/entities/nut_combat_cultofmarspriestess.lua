ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Cult of Mars Priestess"
ENT.Category = "NutScript - Combat (Caeser's Legion)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Cult of Mars Priestess"

ENT.models = {
	"models/gore/neutrals/cult of mars/priestess boyd.mdl",
}
ENT.hp = 100
ENT.accuracy = 3
ENT.evasion = 3

ENT.dmg = {
	["Slash"] = 5
}

ENT.armor = {
	["Head"] = 0,
	["Body"] = 0,
	["Left Arm"] = 0,
	["Right Arm"] = 0,
	["Left Leg"] = 0,
	["Right Leg"] = 0,
}

--all attributes
ENT.attribs = {
	["str"] = 4,
	["per"] = 4,
	["end"] = 4,
	["cha"] = 10,
	["int"] = 10,
	["agi"] = 0,
	["luck"] = 4,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 5,
	["energyweapons"] = 5,
	["melee"] = 5,
	["throwing"] = 5,
	["medicine"] = 20,

}

ENT.res = {
}

ENT.actions = {
"dodge",
"charge",
"burstfire_rifle",
"doubletap_pistol",
"aimedshot_precision",
"med_aid",

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