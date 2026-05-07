ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Nightkin"
ENT.Category = "NutScript - Combat (Supermutant)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Nightkin"

ENT.model = "models/cpthazama/fallout/supermutant_nightkin.mdl"
ENT.hp = 450
ENT.dmg = {
	["12 Gauge"] = 45,
}
ENT.accuracy = 140
ENT.evasion = -5

ENT.weapons = {
	"gunshotgun_combatshotgun",
	"gunrifle_chinesear",
	"gunrifle_assaultrifler91",
	"gunrifle_automaticrifle",
	"gunshotgun_riotgun",
	"gunsniper_dkssniperrifle",
	"launcher_missilelauncher",
	"launcher_grenadelauncher",
	"melee2h_bumpersword",
	"melee2h_fireaxe",
}

ENT.armor = {
	["Head"] = 20,
	["Body"] = 20,
	["Left Arm"] = 20,
	["Right Arm"] = 20,
	["Left Leg"] = 20,
	["Right Leg"] = 20,
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
	["cha"] = 1,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 10,

}

ENT.skills = {
}

ENT.res = {
}

ENT.actions = {
"charge",
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