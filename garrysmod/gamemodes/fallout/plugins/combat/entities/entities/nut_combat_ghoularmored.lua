ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Armored Ghoul"
ENT.Category = "NutScript - Combat (Ghoul)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Armored Ghoul"

ENT.model = "models/fallout/ghoulferal_vaultarmor.mdl"
ENT.hp = 75
ENT.dmg = {
	["Blunt"] = 20,
}
ENT.accuracy = 70
ENT.evasion = 15

ENT.armor = {
	["Head"] = 15,
	["Body"] = 15,
	["Left Arm"] = 15,
	["Right Arm"] = 15,
	["Left Leg"] = 15,
	["Right Leg"] = 15,
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
	["luck"] = 9,

}

ENT.skills = {
}

ENT.res = {
}

ENT.actions = {
"charge",
"dodge",

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