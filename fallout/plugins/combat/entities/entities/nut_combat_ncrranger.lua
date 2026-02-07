ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "NCR Ranger"
ENT.Category = "NutScript - Combat (New California Republic)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "NCR Ranger"

ENT.model = "models/gore/ncr remake/desert ranger/drboyd.mdl"
ENT.hp = 100
ENT.dmg = {
	[".308"] = 45,
}
ENT.accuracy = 10
ENT.evasion = 5

ENT.armor = {
	["Head"] = 20,
	["Body"] = 20,
	["Left Arm"] = 15,
	["Right Arm"] = 15,
	["Left Leg"] = 15,
	["Right Leg"] = 15,
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
	["guns"] = 17,
	["energyweapons"] = 0,
	["melee"] = 17,
	["throwing"] = 12,

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

ENT.models = {
    "models/gore/ncr remake/desert ranger/dranton.mdl",
    "models/gore/ncr remake/desert ranger/drboone.mdl",
    "models/gore/ncr remake/desert ranger/drfrank.mdl",
    "models/gore/ncr remake/desert ranger/drghoul(female).mdl",
    "models/gore/ncr remake/desert ranger/drghoul.mdl",
    "models/gore/ncr remake/desert ranger/drhorst.mdl",
    "models/gore/ncr remake/desert ranger/drjensk.mdl",
    "models/gore/ncr remake/desert ranger/drkingsley.mdl",
    "models/gore/ncr remake/desert ranger/drmoore.mdl",
    "models/gore/ncr remake/desert ranger/drnils.mdl",
    "models/gore/ncr remake/desert ranger/drtorv.mdl",
    "models/gore/ncr remake/desert ranger/drwilhem.mdl",
}

function ENT:Initialize()
	self:basicSetup()
end