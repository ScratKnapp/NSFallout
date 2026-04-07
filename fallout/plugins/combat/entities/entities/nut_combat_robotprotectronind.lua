ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Industrial Protectron"
ENT.Category = "NutScript - Combat (Robots)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Industrial Protectron"

ENT.model = "models/fallout/protectron_factory.mdl"
ENT.hp = 150
ENT.dmg = {
	["Nails"] = 25,
}
ENT.accuracy = 80
ENT.evasion = 0

ENT.armor = {
	["Head"] = 10,
	["Body"] = 10,
	["Left Arm"] = 10,
	["Right Arm"] = 10,
	["Left Leg"] = 10,
	["Right Leg"] = 10,
}

ENT.armorBreak = {
	["Head"] = 5,
	["Body"] = 5,
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