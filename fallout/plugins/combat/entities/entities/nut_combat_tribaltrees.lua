ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "TREEHUGGERS RENAME"
ENT.Category = "NutScript - Combat (Tribals)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "TREEHUGGERS RENAME"

ENT.models = {
    "models/kaesar/falloutnewvegas/deadhorse/deadhorse.mdl",
    "models/kaesar/falloutnewvegas/deadhorse/deadhorsef.mdl",

}

ENT.hp = 125
ENT.accuracy = 12
ENT.evasion = 8

ENT.dmg = {
	["12 Gauge"] = 38
}

ENT.armor = {
	["Head"] = 10,
	["Body"] = 10,
	["Left Arm"] = 10,
	["Right Arm"] = 10,
	["Left Leg"] = 10,
	["Right Leg"] = 10,
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
	["cha"] = 0,
	["int"] = 2,
	["agi"] = 0,
	["luck"] = 4,

}

ENT.skills = {
	["evasion"] = 6,
	["guns"] = 9,
	["energyweapons"] = 0,
	["melee"] = 9,
	["throwing"] = 6,

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