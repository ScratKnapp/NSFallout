ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Rattler Veteran"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Black Khans Veteran"

ENT.model = "models/gore/nomads/nomadm_04.mdl"
ENT.hp = 100
ENT.dmg = {
	[".357 Magnum"] = 35,
}
ENT.accuracy = 10
ENT.evasion = 5

ENT.weapons = {
	"gunpistol_45pistol",
	"gunpistol_10mmpistol",
	"gunprecision_cowboyrepeater",
	"gunrevolver_357magnum",
	"gunrifle_combatrifle",
	"gunshotgun_huntingshotgun",
	"gunsmg_45smg",
	"gunsniper_huntingrifle",
	"gunenergy_laserrifle",
	"gunenergy_laserrcw",
	"gunsmg_10mmsmg",
}

ENT.armor = {
	["Head"] = 10,
	["Body"] = 10,
	["Left Arm"] = 10,
	["Right Arm"] = 10,
	["Left Leg"] = 10,
	["Right Leg"] = 10,
}

ENT.armorBreak = {
	["Head"] = 3,
	["Body"] = 3,
	["Left Arm"] = 3,
	["Right Arm"] = 3,
	["Left Leg"] = 3,
	["Right Leg"] = 3,
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
	["guns"] = 13,
	["energyweapons"] = 13,
	["melee"] = 13,
	["throwing"] = 13,

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