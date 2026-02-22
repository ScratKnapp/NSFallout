ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Thrasher Survivor"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Thrasher Survivor"

ENT.models = {
	"models/asais10/f3npcs/raiderarmor01_f.mdl",
	"models/asais10/f3npcs/raiderarmor02_f.mdl",
	"models/asais10/f3npcs/raiderarmor03_f.mdl",

}
ENT.hp = 100
ENT.dmg = {
	["Slash"] = 25,
}
ENT.accuracy = 10
ENT.evasion = 5

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
	["cha"] = 2,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 6,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 10,
	["energyweapons"] = 10,
	["melee"] = 10,
	["throwing"] = 10,

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