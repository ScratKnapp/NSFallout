ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Supermutant"
ENT.Category = "NutScript - Combat (Supermutant)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Supermutant"

ENT.model = "models/cpthazama/fallout/supermutant.mdl"
ENT.hp = 250
ENT.dmg = {
	[".38"] = 18,
}
ENT.accuracy = 70
ENT.evasion = -5


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
	"melee2h_fireaxe",
}

ENT.armor = {
	["Head"] = 5,
	["Body"] = 5,
	["Left Arm"] = 5,
	["Right Arm"] = 5,
	["Left Leg"] = 5,
	["Right Leg"] = 5,
}

ENT.armorBreak = {
	["Head"] = 3,
	["Body"] = 3,
	["Left Arm"] = 3,
	["Right Arm"] = 3,
	["Left Leg"] = 3,
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
	["luck"] = 1,

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