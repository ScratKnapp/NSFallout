ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Rattlesnakes Lieutenant"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Rattlesnakes Lieutenant"

ENT.models = {
    "models/gore/nomads/nomad_metal_armor.mdl",


}

ENT.hp = 250
ENT.dmg = 35
ENT.dmgT = ".45 Auto"
ENT.dmg = {
	["Fire"] = 25,
}
ENT.accuracy = 20
ENT.evasion = 14

ENT.armor = {
	["Head"] = 14,
	["Body"] = 18,
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