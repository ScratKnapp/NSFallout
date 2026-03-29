ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Supermutant Overlord"
ENT.Category = "NutScript - Combat (Supermutant)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Supermutant Overlord"

ENT.model = "models/cpthazama/fallout/supermutant_overlord.mdl"
ENT.hp = 400
ENT.dmg = {
	["Laser"] = 40,
}
ENT.accuracy = 160
ENT.evasion = 0

ENT.weapons = {
	"gunshotgun_combatshotgun",
	"gunrifle_chinesear",
	"gunrifle_assaultrifler91",
	"gunrifle_automaticrifle",
	"gunshotgun_riotgun",
	"gunsniper_dkssniperrifle",
	"launcher_missilelauncher",
	"launcher_grenadelauncher",
	"melee2h_bumpersword",
	"melee2h_fireaxe",
}

ENT.armor = {
	["Head"] = 30,
	["Body"] = 30,
	["Left Arm"] = 30,
	["Right Arm"] = 30,
	["Left Leg"] = 30,
	["Right Leg"] = 30,
}

ENT.armorBreak = {
	["Head"] = 5,
	["Body"] = 5,
	["Left Arm"] = 5,
	["Right Arm"] = 5,
	["Left Leg"] = 5,
	["Right Leg"] = 3,
}

--all attributes
ENT.attribs = {
	["str"] = 0,
	["per"] = 0,
	["end"] = 0,
	["cha"] = 1,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 10,

}

ENT.skills = {
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
"overcharge",
"grenade_firebomb",
"charisma1",
"charisma2",
"charisma3",
"charisma4",
"charisma5",
"charisma5accdebuff",
"charisma6",

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