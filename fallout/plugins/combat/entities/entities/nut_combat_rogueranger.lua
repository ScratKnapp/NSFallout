ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Rogue Desert Ranger"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Rogue Desert Ranger"

ENT.model = "models/gore/rangers/arizona_veteran_ranger.mdl"
ENT.hp = 150
ENT.accuracy = 16
ENT.evasion = 12

ENT.dmg = {
	[".308"] = 26
}

ENT.armor = {
	["Head"] = 15,
	["Body"] = 18,
	["Left Arm"] = 14,
	["Right Arm"] = 14,
	["Left Leg"] = 14,
	["Right Leg"] = 14,
}

--all attributes
ENT.attribs = {
	["str"] = 6,
	["per"] = 7,
	["end"] = 6,
	["cha"] = 8,
	["int"] = 2,
	["agi"] = 0,
	["luck"] = 8,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 20,
	["energyweapons"] = 20,
	["melee"] = 20,
	["throwing"] = 20,

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