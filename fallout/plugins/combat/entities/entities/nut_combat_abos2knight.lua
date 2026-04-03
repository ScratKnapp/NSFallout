ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Alamo Chapter Knight"
ENT.Category = "NutScript - Combat (Brotherhood)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Alamo Chapter Knight"

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
    "models/adi/t601_raider_pm.mdl",

	
}

ENT.hp = 300
ENT.dmg = {
	["5.56"] = 22,
}
ENT.accuracy = 100
ENT.evasion = 5

ENT.weapons = {
	"gunrevolver_44magnum",
	"gunrifle_assaultrifler91",
	"gunshotgun_combatshotgun",

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
	["guns"] = 16,
	["energyweapons"] = 0,
	["melee"] = 15,
	["throwing"] = 10,

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