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
ENT.accuracy = 70
ENT.evasion = 10


ENT.weapons = {
	"gunpistol_9mmpistol",
	"gunpistol_10mmpistol",
	"gunpistol_22lrpistol",
	"gunrevolver_32revolver",
	"gunpistol_chinesepistol",
	"gunprecision_varmintrifle",
	"gunshotgun_caravanshotgun",
	"gunshotgun_singleshotgun",
	"gunsmg_9mmsmg",
	"gunsmg_22lrsmg",
	"melee1h_combatknife",
	"melee1h_leadpipe",
	"melee1h_machete",
	"gunenergy_lasermusket",
	"gunenergy_laserpistol",
	"gunsmg_10mmsmg",
}

ENT.armor = {
	["Head"] = 10,
	["Body"] = 10,
	["Left Arm"] = 10,
	["Right Arm"] = 10,
	["Left Leg"] = 10,
	["Right Leg"] = 10,
}

ENT.armorBreak = {
	["Head"] = 2,
	["Body"] = 2,
	["Left Arm"] = 2,
	["Right Arm"] = 2,
	["Left Leg"] = 2,
	["Right Leg"] = 2,
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
	    for k, v in pairs(self:GetBodyGroups()) do
        self:SetBodygroup(v.id, math.random(0, v.num))
    end
end