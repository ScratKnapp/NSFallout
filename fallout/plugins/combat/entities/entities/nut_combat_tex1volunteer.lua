ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Provisional Volunteer"
ENT.Category = "NutScript - Combat (Texans)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Provisional Volunteer"

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
    "models/ntr/trooper/fatigues/male01.mdl",
	"models/ntr/trooper/fatigues/female02.mdl",
	"models/ntr/trooper/fatigues/damwar.mdl",
    "models/ntr/officer/fatigues/damwar.mdl",
	"models/ntr/officer/fatigues/female02.mdl",
	"models/ntr/officer/fatigues/male01.mdl",
}

ENT.hp = 100
ENT.dmg = {
	["5.56"] = 15,
}
ENT.accuracy = 10
ENT.evasion = 1

ENT.armor = {
	["Head"] = 10,
	["Body"] = 10,
	["Left Arm"] = 10,
	["Right Arm"] = 10,
	["Left Leg"] = 10,
	["Right Leg"] = 10,

}

ENT.armorBreak = {
	["Head"] = 10,
	["Body"] = 10,
	["Left Arm"] = 10,
	["Right Arm"] = 10,
	["Left Leg"] = 10,
	["Right Leg"] = 10,
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
	["evasion"] = 0,
	["guns"] = 8,
	["energyweapons"] = 0,
	["melee"] = 8,
	["throwing"] = 5,

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
"grenade_frag",

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