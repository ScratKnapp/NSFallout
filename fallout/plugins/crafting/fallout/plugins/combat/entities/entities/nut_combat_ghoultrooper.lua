ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Ghoul Trooper"
ENT.Category = "NutScript - Combat (Ghoul)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Ghoul Trooper"

ENT.model = "models/fallout/ghoulferal.mdl"
ENT.hp = 100
ENT.dmg = {
	["Blunt"] = 20,
}
ENT.accuracy = 10
ENT.evasion = 10

ENT.armor = {
	["Head"] = 2,
	["Body"] = 10,
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
	["cha"] = 1,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 8,

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