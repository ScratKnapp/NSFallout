ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "NCR Captain"
ENT.Category = "NutScript - Combat (New California Republic)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "NCR Captain"

ENT.model = "models/gore/ncr remake/ncr/officerkingsley.mdl"
ENT.hp = 100
ENT.dmg = {
	["5.56"] = 32,
}
ENT.accuracy = 10
ENT.evasion = 5

ENT.armor = {
	["Head"] = 15,
	["Body"] = 15,
	["Left Arm"] = 12,
	["Right Arm"] = 12,
	["Left Leg"] = 12,
	["Right Leg"] = 12,
}

--all attributes
ENT.attribs = {
	["str"] = 0,
	["per"] = 0,
	["end"] = 0,
	["cha"] = 2,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 5,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 15,
	["energyweapons"] = 0,
	["melee"] = 12,
	["throwing"] = 8,

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
    "models/gore/ncr remake/ncr/officeranton.mdl",
    "models/gore/ncr remake/ncr/officerboone.mdl",
    "models/gore/ncr remake/ncr/officerboyd.mdl",
    "models/gore/ncr remake/ncr/officerfrank.mdl",
    "models/gore/ncr remake/ncr/officerghoul(female).mdl",
    "models/gore/ncr remake/ncr/officerghoul.mdl",
    "models/gore/ncr remake/ncr/officerhorst.mdl",
    "models/gore/ncr remake/ncr/officerjensk.mdl",
    "models/gore/ncr remake/ncr/officermoore.mdl",
    "models/gore/ncr remake/ncr/officernils.mdl",
    "models/gore/ncr remake/ncr/officertorv.mdl",
    "models/gore/ncr remake/ncr/officerwilhem.mdl",
}

function ENT:Initialize()
	self:basicSetup()
end