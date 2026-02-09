ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Legion Praetorian"
ENT.Category = "NutScript - Combat (Caeser's Legion)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Legion Praetorian"

ENT.models = {
	"models/gore/legion remake/praetorian/praetorianfrank.mdl",
	"models/gore/legion remake/praetorian/praetorianhorst.mdl",
	"models/gore/legion remake/praetorian/praetoriantorv.mdl",
}
ENT.hp = 200
ENT.accuracy = 20
ENT.evasion = 15

ENT.dmg = {
	["Blunt"] = 60
}

ENT.armor = {
	["Head"] = 25,
	["Body"] = 25,
	["Left Arm"] = 15,
	["Right Arm"] = 15,
	["Left Leg"] = 15,
	["Right Leg"] = 15,
}

--all attributes
ENT.attribs = {
	["str"] = 10,
	["per"] = 10,
	["end"] = 10,
	["cha"] = 10,
	["int"] = 10,
	["agi"] = 10,
	["luck"] = 10,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 20,
	["energyweapons"] = 0,
	["melee"] = 20,
	["throwing"] = 15,

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