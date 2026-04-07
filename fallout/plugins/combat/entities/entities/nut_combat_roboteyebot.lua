ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Eyebot"
ENT.Category = "NutScript - Combat (Robots)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Eyebot"

ENT.model = "models/fallout/eyebot.mdl"
ENT.hp = 80
ENT.dmg = {
	["Laser"] = 30,
}
ENT.accuracy = 80
ENT.evasion = 0

ENT.armor = {
	["Head"] = 5,
	["Body"] = 5,
	["Left Arm"] = 5,
	["Right Arm"] = 5,
	["Left Leg"] = 5,
	["Right Leg"] = 5,
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
	["luck"] = 5,

}

ENT.skills = {
	["evasion"] = 0,
}

ENT.res = {
  ["Kinetic"] = 50,
  ["Energy"] = -50, 
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