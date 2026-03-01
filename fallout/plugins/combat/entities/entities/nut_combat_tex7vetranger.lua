ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Veteran Ranger"
ENT.Category = "NutScript - Combat (Texans)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Veteran Ranger"


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
    "models/gore/ncr/desertrangerm.mdl",
	"models/gore/ncr/desert_rangerf.mdl",

}


ENT.hp = 150
ENT.dmg = {
	[".308"] = 30,
}
ENT.accuracy = 50
ENT.evasion = 5

ENT.armor = {
	["Head"] = 25,
	["Body"] = 25,
	["Left Arm"] = 25,
	["Right Arm"] = 25,
	["Left Leg"] = 25,
	["Right Leg"] = 25,
}

ENT.armorBreak = {
	["Head"] = 20,
	["Body"] = 20,
	["Left Arm"] = 20,
	["Right Arm"] = 20,
	["Left Leg"] = 20,
	["Right Leg"] = 20,
}

--all attributes
ENT.attribs = {
	["str"] = 0,
	["per"] = 0,
	["end"] = 0,
	["cha"] = 2,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 6,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 20,
	["energyweapons"] = 0,
	["melee"] = 20,
	["throwing"] = 15,

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