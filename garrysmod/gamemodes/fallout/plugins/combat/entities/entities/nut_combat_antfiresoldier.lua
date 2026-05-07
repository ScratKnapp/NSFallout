ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Fire Ant Soldier"
ENT.Category = "NutScript - Combat (Mutants and Animals)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Fire Ant Soldier"

ENT.model = "models/fallout/giantant.mdl"
ENT.hp = 90
ENT.dmg = {
	["Slash"] = 25,
}
ENT.accuracy = 75
ENT.evasion = 10
ENT.modelScale = 1

ENT.armor = {
	["Head"] = 10,
	["Body"] = 10,
	["Left Arm"] = 10,
	["Right Arm"] = 10,
	["Left Leg"] = 10,
	["Right Leg"] = 10,
}

--the amount of hits the part can take before armor is broken (reduced to 0)
ENT.armorBreak = {
	["Head"] = 20,
	["Body"] = 20,
	["Left Arm"] = 20,
	["Right Arm"] = 20,
	["Left Leg"] = 20,
	["Right Leg"] = 20,
}

--all attributes
ENT.attribs = {
	["str"] = 0,
	["per"] = 0,
	["end"] = 0,
	["cha"] = 0,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 0,

}

ENT.skills = {
	["evasion"] = 0,
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
    self:SetSkin(1)

end