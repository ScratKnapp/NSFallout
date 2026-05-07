ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Ghoul Stalker"
ENT.Category = "NutScript - Combat (Ghoul)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Ghoul Stalker"

ENT.model = "models/fallout/ghoularmored.mdl"
ENT.hp = 200
ENT.dmg = {
	["Blunt"] = 30,
}
ENT.accuracy = 100
ENT.evasion = 25


ENT.armor = {
	["Head"] = 0,
	["Body"] = 20,
	["Left Arm"] = 0,
	["Right Arm"] = 0,
	["Left Leg"] = 0,
	["Right Leg"] = 0,
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