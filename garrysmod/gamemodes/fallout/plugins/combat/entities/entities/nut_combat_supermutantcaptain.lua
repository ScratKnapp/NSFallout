ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Supermutant Captain"
ENT.Category = "NutScript - Combat (Supermutant)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Supermutant Captain"

ENT.model = "models/cpthazama/fallout/supermutant_captain.mdl"
ENT.hp = 350
ENT.dmg = {
	["5.56"] = 30,
}
ENT.accuracy = 120
ENT.evasion = -5

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
	["Head"] = 20,
	["Body"] = 20,
	["Left Arm"] = 20,
	["Right Arm"] = 20,
	["Left Leg"] = 20,
	["Right Leg"] = 20,
}

ENT.armorBreak = {
	["Head"] = 4,
	["Body"] = 4,
	["Left Arm"] = 4,
	["Right Arm"] = 4,
	["Left Leg"] = 4,
	["Right Leg"] = 4,
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