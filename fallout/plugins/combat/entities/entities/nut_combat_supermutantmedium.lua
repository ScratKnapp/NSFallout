ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Supermutant Brute"
ENT.Category = "NutScript - Combat (Supermutant)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Supermutant Brute"

ENT.model = "models/cpthazama/fallout/supermutant_medium.mdl"
ENT.hp = 340
ENT.dmg = {
	["5.56"] = 35,
}
ENT.accuracy = 70
ENT.evasion = -5

ENT.weapons = {
	"gunpistol_45pistol",
	"gunpistol_10mmpistol",
	"gunprecision_cowboyrepeater",
	"gunrevolver_357magnum",
	"gunrifle_combatrifle",
	"gunshotgun_huntingshotgun",
	"gunsmg_45smg",
	"gunsniper_huntingrifle",
	"gunenergy_laserrifle",
	"gunenergy_laserrcw",
	"gunsmg_10mmsmg",
}

ENT.armor = {
	["Head"] = 15,
	["Body"] = 15,
	["Left Arm"] = 15,
	["Right Arm"] = 15,
	["Left Leg"] = 15,
	["Right Leg"] = 15,
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
	["luck"] = 5,

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