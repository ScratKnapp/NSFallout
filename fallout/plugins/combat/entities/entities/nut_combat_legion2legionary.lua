ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Legionary"
ENT.Category = "NutScript - Combat (Lanius' Cohort)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Legionary"

ENT.StepData = {
	0.25,
	0.75,
}

ENT.FootstepSounds = {
	"npc/footsteps/hardboot_generic1.wav",
	"npc/footsteps/hardboot_generic2.wav",
	"npc/footsteps/hardboot_generic3.wav",
	"npc/footsteps/hardboot_generic4.wav",
	"npc/footsteps/hardboot_generic5.wav",
	"npc/footsteps/hardboot_generic6.wav",
}

ENT.models = {
	"models/gore/we_are_legion/prime_legionarynew_pm.mdl",

}

ENT.hp = 110
ENT.accuracy = 10
ENT.evasion = 5

ENT.weapons = {
	"melee1h_machete",
	"melee2h_tribalspear",
	"gunpistol_9mmpistol",
	"gunpistol_10mmpistol",
	"gunrevolver_32revolver",
	"gunsmg_9mmsmg",
	"gunshotgun_leveractionshotgun",
	"gunprecision_varmintrifle",
	"gunprecision_cowboyrepeater",

}

ENT.dmg = {
	["Slash"] = 12
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
	["cha"] = 0,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 0,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 0,
	["energyweapons"] = 0,
	["melee"] = 0,
	["throwing"] = 0,

}

ENT.res = {
}

ENT.actions = {
"dodge",
"charge",
"stun",
"pommel",
"burstfire_smg",
"runngun",
"burstfire_rifle",
"suppression1",
"doubletap_pistol",
"doubletap_precision",
"aimedshot_precision",
"throwing_spear",

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