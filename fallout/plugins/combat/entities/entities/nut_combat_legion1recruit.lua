ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Legion Recruit"
ENT.Category = "NutScript - Combat (Lanius' Cohort)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Legion Recruit"

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
	"models/gore/we_are_legion/explorer_pm.mdl",

}

ENT.hp = 100
ENT.accuracy = 5
ENT.evasion = 5

ENT.dmg = {
	["Slash"] = 12
}

ENT.armor = {
	["Head"] = 5,
	["Body"] = 5,
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