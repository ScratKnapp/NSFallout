ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Black Khans Veteran"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Black Khans Veteran"

ENT.model = "models/gore/nomads/nomadm_04.mdl"
ENT.hp = 100
ENT.dmg = {
	[".357 Magnum"] = 35,
}
ENT.accuracy = 10
ENT.evasion = 5

ENT.armor = {
	["Head"] = 8,
	["Body"] = 10,
	["Left Arm"] = 6,
	["Right Arm"] = 6,
	["Left Leg"] = 6,
	["Right Leg"] = 6,
}

--all attributes
ENT.attribs = {
	["str"] = 0,
	["per"] = 0,
	["end"] = 0,
	["cha"] = 2,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 6,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 13,
	["energyweapons"] = 13,
	["melee"] = 13,
	["throwing"] = 13,

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