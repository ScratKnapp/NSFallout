ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Legion Vexillarius"
ENT.Category = "NutScript - Combat (Lanius' Cohort)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Legion Vexillarius"

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
	"models/gore/we_are_legion/vexillarius_new.mdl",

}

ENT.hp = 150
ENT.accuracy = 100
ENT.evasion = 15

ENT.weapons = {
	"gunrevolver_357magnum",
	"gunprecision_trailcarbine",
	"gunsniper_huntingrifle",

}

ENT.dmg = {
	["Slash"] = 18
}

ENT.armor = {
	["Head"] = 18,
	["Body"] = 18,
	["Left Arm"] = 18,
	["Right Arm"] = 18,
	["Left Leg"] = 18,
	["Right Leg"] = 18,
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