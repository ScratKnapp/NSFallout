ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "NCR Sergeant"
ENT.Category = "NutScript - Combat (New California Republic)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "NCR Sergeant"

ENT.model = "models/gore/ncr remake/ncr/trooperanton.mdl"
ENT.hp = 100
ENT.dmg = {
	["5.56"] = 30,
}
ENT.accuracy = 10
ENT.evasion = 5

ENT.armor = {
	["Head"] = 12,
	["Body"] = 14,
	["Left Arm"] = 10,
	["Right Arm"] = 10,
	["Left Leg"] = 10,
	["Right Leg"] = 10,
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
	["evasion"] = 0,
	["guns"] = 10,
	["energyweapons"] = 0,
	["melee"] = 10,
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
    "models/gore/ncr remake/ncr/trooperboone.mdl",
    "models/gore/ncr remake/ncr/trooperboyd.mdl",
    "models/gore/ncr remake/ncr/trooperfrank.mdl",
    "models/gore/ncr remake/ncr/trooperghoul(female).mdl",
    "models/gore/ncr remake/ncr/trooperghoul.mdl",
    "models/gore/ncr remake/ncr/trooperhorst.mdl",
    "models/gore/ncr remake/ncr/trooperjensk.mdl",
    "models/gore/ncr remake/ncr/trooperkingsley.mdl",
    "models/gore/ncr remake/ncr/troopermoore.mdl",
    "models/gore/ncr remake/ncr/troopernils.mdl",
    "models/gore/ncr remake/ncr/troopertorv.mdl",
    "models/gore/ncr remake/ncr/trooperwilhem.mdl",
}

function ENT:Initialize()
	self:basicSetup()
end