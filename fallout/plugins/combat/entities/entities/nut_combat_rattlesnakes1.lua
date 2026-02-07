ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Rattlesnakes Outlaw"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Rattlesnakes Outlaw"

ENT.models = {
    "models/gore/rangers/arizona_cowboy.mdl",
    "models/gore/rangers/arizona_cowboy02.mdl",
    "models/gore/rangers/arizona_ranger.mdl",
    "models/gore/rangers/arizona_ranger01.mdl",
    "models/gore/rangers/arizona_rangerf02.mdl",
    "models/gore/rangers/arizona_rangerf03.mdl",
    "models/gore/rangers/arizona_smuggler.mdl",
    "models/gore/rangers/arizona_veteran_ranger02.mdl",
    "models/gore/nomads/lightarmor_male.mdl",
    "models/gore/nomads/lightarmor_female.mdl",
    "models/gore/nomads/mercenarym_02.mdl",
    "models/gore/nomads/mercenarym_01.mdl",
    "models/gore/nomads/mercenarym_03.mdl",
    "models/gore/nomads/mercenarym_04.mdl",
    "models/gore/nomads/mercenaryf_01.mdl",
    "models/gore/nomads/mercenaryf_02.mdl",

}

ENT.hp = 100
ENT.dmg = {
	[".357 Magnum"] = 30,
}
ENT.accuracy = 10
ENT.evasion = 10

ENT.armor = {
	["Head"] = 6,
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
	["luck"] = 4,

}

ENT.skills = {
	["evasion"] = 6,
	["guns"] = 9,
	["energyweapons"] = 9,
	["melee"] = 9,
	["throwing"] = 9,

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