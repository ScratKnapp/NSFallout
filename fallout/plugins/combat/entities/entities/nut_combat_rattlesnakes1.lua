ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Bandidos Outlaw"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Bandidos Outlaw"

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
	["Head"] = 10,
	["Body"] = 10,
	["Left Arm"] = 10,
	["Right Arm"] = 10,
	["Left Leg"] = 10,
	["Right Leg"] = 10,
}

ENT.armorBreak = {
	["Head"] = 5,
	["Body"] = 5,
	["Left Arm"] = 5,
	["Right Arm"] = 5,
	["Left Leg"] = 5,
	["Right Leg"] = 5,
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
"burstfire_smg",
"runngun",
"burstfire_rifle",
"suppression1",
"doubletap_pistol",
"doubletap_precision",
"aimedshot_precision",
"grenade_firebomb",

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