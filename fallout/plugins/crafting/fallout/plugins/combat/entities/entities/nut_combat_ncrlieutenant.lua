ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "NCR Lieutenant"
ENT.Category = "NutScript - Combat (New California Republic)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "NCR Lieutenant"

ENT.model = "models/gore/ncr remake/ncr/officerkingsley.mdl"
ENT.hp = 100
ENT.dmg = {
	["5.56"] = 30,
}
ENT.accuracy = 10
ENT.evasion = 5

ENT.armor = {
	["Head"] = 18,
	["Body"] = 18,
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
	["guns"] = 16,
	["energyweapons"] = 0,
	["melee"] = 15,
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

ENT.tags = {
	["Biological"] = true,
	["Humanoid"] = true,
	["Living"] = true,
	["Authoriity"] = true,
}

function ENT:Initialize()
	self:basicSetup()
end