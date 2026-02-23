ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Bandidos Lieutenant"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Bandidos Lieutenant"

ENT.models = {
    "models/gore/nomads/nomad_metal_armor.mdl",


}

ENT.hp = 150
ENT.dmg = {
	[".45 Auto"] = 25,
}
ENT.accuracy = 40
ENT.evasion = 14

ENT.armor = {
	["Head"] = 20,
	["Body"] = 20,
	["Left Arm"] = 20,
	["Right Arm"] = 20,
	["Left Leg"] = 20,
	["Right Leg"] = 20,
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
	["luck"] = 6,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 16,
	["energyweapons"] = 12,
	["melee"] = 12,
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
"grenade_firebomb",

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