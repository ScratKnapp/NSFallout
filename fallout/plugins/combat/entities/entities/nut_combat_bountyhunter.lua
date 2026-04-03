ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Bounty Hunter"
ENT.Category = "NutScript - Combat (Wastelanders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Bounty Hunter"

ENT.models = {
    "models/gore/nomads/mercenarym_01.mdl",
    "models/gore/nomads/mercenarym_02.mdl",
    "models/gore/nomads/mercenarym_03.mdl",
    "models/gore/nomads/mercenarym_04.mdl",
    "models/gore/nomads/nomad_10.mdl",
    "models/gore/nomads/nomad_iconoclast.mdl",
    "models/gore/nomads/mercenaryf_02.mdl",
	"models/gore/nomads/mercenaryf_01.mdl",
	"models/gore/nomads/lightarmor_female.mdl",
	"models/gore/nomads/lightarmor_male.mdl",
	"models/gore/nomads/nomad_kellogm.mdl",
	"models/gore/nomads/nomad_kellogf.mdl",
	"models/gore/nomads/nomad_scavenger.mdl",
	"models/gore/nomads/combatarmor_female.mdl",
	"models/gore/nomads/combatarmor_male.mdl",
    "models/kaesar/falloutnewvegas/sheriff/sheriff.mdl",
    "models/kaesar/falloutnewvegas/sheriff/sherifff.mdl",
    "models/kaesar/falloutnewvegas/merc_grunt/merc_grunt.mdl",
    "models/kaesar/falloutnewvegas/merc_grunt/merc_gruntf.mdl",
    "models/kaesar/falloutnewvegas/reinforced/reinforced.mdl",
    "models/kaesar/falloutnewvegas/wanderer/wanderer.mdl",
    "models/kaesar/falloutnewvegas/wanderer/wandererf.mdl",


}

ENT.hp = 100
ENT.dmg = {
	["5.56"] = 30,
}
ENT.accuracy = 70
ENT.evasion = 5

ENT.weapons = {
	"gunshotgun_caravanshotgun",
	"gunsmg_9mmsmg",
	"gunrevolver_357magnum",
	"gunprecision_cowboyrepeater",
	"gunprecision_trailcarbine",

}

ENT.armor = {
	["Head"] = 25,
	["Body"] = 25,
	["Left Arm"] = 25,
	["Right Arm"] = 25,
	["Left Leg"] = 25,
	["Right Leg"] = 25,
}

ENT.armorBreak = {
	["Head"] = 8,
	["Body"] = 8,
	["Left Arm"] = 8,
	["Right Arm"] = 8,
	["Left Leg"] = 8,
	["Right Leg"] = 8,
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
	["energyweapons"] = 0,
	["melee"] = 9,
	["throwing"] = 6,

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