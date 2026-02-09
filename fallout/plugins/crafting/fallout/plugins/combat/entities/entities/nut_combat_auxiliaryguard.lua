ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Auxiliary"
ENT.Category = "NutScript - Combat (Townspeople)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Auxiliary"

ENT.models = {
    "models/gore/neutrals/auxiliary/Auxiliary Torv.mdl",
    "models/gore/neutrals/auxiliary/Auxiliary Horst.mdl",
    "models/gore/neutrals/auxiliary/Auxiliary Ghoul.mdl",
    "models/gore/neutrals/auxiliary/Auxiliary Frank.mdl",
    "models/gore/neutrals/auxiliary/Auxiliary Boyd.mdl",
}

ENT.hp = 100
ENT.dmg = {
	[".357"] = 30,
}
ENT.accuracy = 10
ENT.evasion = 5

ENT.armor = {
	["Head"] = 10,
	["Body"] = 14,
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
	["cha"] = 2,
	["int"] = 0,
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