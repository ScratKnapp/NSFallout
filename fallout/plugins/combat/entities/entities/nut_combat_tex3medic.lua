ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Provisional Medic"
ENT.Category = "NutScript - Combat (New California Republic)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Provisional Medic"

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
    "models/ntr/trooper/medic/damwar.mdl",
	"models/ntr/trooper/medic/female02.mdl",
	"models/ntr/trooper/medic/male01.mdl",

}

ENT.hp = 110
ENT.dmg = {
	["5.56"] = 18,
}
ENT.accuracy = 15
ENT.evasion = 5

ENT.armor = {
	["Head"] = 15,
	["Body"] = 15,
	["Left Arm"] = 15,
	["Right Arm"] = 15,
	["Left Leg"] = 15,
	["Right Leg"] = 15,
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
	["evasion"] = 6,
	["guns"] = 9,
	["energyweapons"] = 0,
	["melee"] = 9,
	["throwing"] = 7,
  	["medicine"] = 30,

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
"med_aid",
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