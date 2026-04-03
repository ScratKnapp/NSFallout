ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Dallas Chapter Elder"
ENT.Category = "NutScript - Combat (Brotherhood)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Dallas Chapter Elder"


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
    "models/adi/t601_winterized_pm.mdl",


}

ENT.hp = 1000
ENT.dmg = {
	[".308"] = 30,
}
ENT.accuracy = 140
ENT.evasion = 5

ENT.weapons = {
	"gunenergy_gaussrifle",

}

ENT.armor = {
	["Head"] = 40,
	["Body"] = 40,
	["Left Arm"] = 40,
	["Right Arm"] = 40,
	["Left Leg"] = 40,
	["Right Leg"] = 40,
}

ENT.armorBreak = {
	["Head"] = 15,
	["Body"] = 15,
	["Left Arm"] = 15,
	["Right Arm"] = 15,
	["Left Leg"] = 15,
	["Right Leg"] = 15,
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
	["guns"] = 17,
	["energyweapons"] = 0,
	["melee"] = 17,
	["throwing"] = 12,

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