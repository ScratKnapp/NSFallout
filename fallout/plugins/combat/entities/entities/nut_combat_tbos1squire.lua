ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Dallas Chapter Squire"
ENT.Category = "NutScript - Combat (Brotherhood)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Dallas Chapter Squire"

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
    "models/player/h&h/bos/tactics_metalarmor/male01.mdl",


}

ENT.hp = 175
ENT.dmg = {
	["5.56"] = 20,
}
ENT.accuracy = 85
ENT.evasion = 5

ENT.weapons = {
	"gunenergy_laserrifle",
	"gunenergy_laserrcw",
	"gunenergy_plasmadefender",
	"gunenergy_rechargerrifle",
	"gunrifle_automaticrifle",
	"gunsniper_dkssniperrifle",

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
	["Head"] = 5,
	["Body"] = 5,
	["Left Arm"] = 5,
	["Right Arm"] = 5,
	["Left Leg"] = 5,
	["Right Leg"] = 5,
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
	["guns"] = 10,
	["energyweapons"] = 0,
	["melee"] = 10,
	["throwing"] = 8,

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