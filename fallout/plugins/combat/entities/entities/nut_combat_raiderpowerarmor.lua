ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Power Armor Rattler"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Power Armor Rattler"

ENT.model = "models/skipp/powerarmor_raider/powerarmor_raider.mdl"
ENT.hp = 200
ENT.dmg = {
	["Slash"] = 30,
}
ENT.accuracy = 10
ENT.evasion = 5

ENT.armor = {
	["Head"] = 30,
	["Body"] = 30,
	["Left Arm"] = 30,
	["Right Arm"] = 30,
	["Left Leg"] = 30,
	["Right Leg"] = 30,
}

ENT.armorBreak = {
	["Head"] = 40,
	["Body"] = 40,
	["Left Arm"] = 40,
	["Right Arm"] = 40,
	["Left Leg"] = 40,
	["Right Leg"] = 40,
}


--all attributes
ENT.attribs = {
	["str"] = 0,
	["per"] = 0,
	["end"] = 0,
	["cha"] = 2,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 8,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 20,
	["energyweapons"] = 20,
	["melee"] = 20,
	["throwing"] = 20,

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