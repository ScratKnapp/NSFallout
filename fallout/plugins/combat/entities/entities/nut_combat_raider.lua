ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Rattler"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Rattler"

ENT.models = {
	"models/gore/nomads/nomadf_01.mdl",
	"models/gore/nomads/nomadf_02.mdl",
	"models/gore/nomads/nomadm_01.mdl",
	"models/gore/nomads/nomadm_02.mdl",
	"models/gore/nomads/nomadm_03.mdl",
	"models/gore/nomads/nomadm_05.mdl",
  	"models/gore/nomads/nomadm_06.mdl",
	"models/gore/nomads/nomadm_07.mdl",
	"models/gore/nomads/nomadm_09.mdl",

}
ENT.hp = 100
ENT.dmg = {
	["9mm"] = 25,
}
ENT.accuracy = 10
ENT.evasion = 5

ENT.armor = {
	["Head"] = 0,
	["Body"] = 0,
	["Left Arm"] = 0,
	["Right Arm"] = 0,
	["Left Leg"] = 0,
	["Right Leg"] = 0,
}

ENT.armorBreak = {
	["Head"] = 0,
	["Body"] = 0,
	["Left Arm"] = 0,
	["Right Arm"] = 0,
	["Left Leg"] = 0,
	["Right Leg"] = 0,
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
	["energyweapons"] = 8,
	["melee"] = 8,
	["throwing"] = 8,

}

ENT.res = {
}

ENT.actions = {
"dodge",
"charge",
"burstfire_rifle",
"doubletap_pistol",
"aimedshot_precision",

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