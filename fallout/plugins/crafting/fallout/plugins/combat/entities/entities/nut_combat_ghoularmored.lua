ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Armored Ghoul"
ENT.Category = "NutScript - Combat (Ghoul)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Armored Ghoul"

ENT.model = "models/fallout/ghoulferal_vaultarmor.mdl"
ENT.hp = 100
ENT.dmg = {
	["Blunt"] = 22,
}
ENT.accuracy = 10
ENT.evasion = 15

ENT.armor = {
	["Head"] = 4,
	["Body"] = 15,
	["Left Arm"] = 8,
	["Right Arm"] = 8,
	["Left Leg"] = 8,
	["Right Leg"] = 8,
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