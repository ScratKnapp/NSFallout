ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Ghoul Stalker"
ENT.Category = "NutScript - Combat (Ghoul)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Ghoul Stalker"

ENT.model = "models/fallout/ghoularmored.mdl"
ENT.hp = 100
ENT.dmg = {
	["Blunt"] = 25,
}
ENT.accuracy = 18
ENT.evasion = 15


ENT.armor = {
	["Head"] = 2,
	["Body"] = 18,
	["Left Arm"] = 18,
	["Right Arm"] = 18,
	["Left Leg"] = 18,
	["Right Leg"] = 18,
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