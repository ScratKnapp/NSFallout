ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "NCR Combat Medic"
ENT.Category = "NutScript - Combat (New California Republic)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "NCR Combat Medic"

ENT.model = "models/gore/ncr remake/ncr/medicanton.mdl"
ENT.hp = 100
ENT.dmg = {
	["5.56"] = 30,
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
	["throwing"] = 7,
  	["medicine"] = 30,

}

ENT.res = {
}

ENT.actions = {
"dodge",
"charge",
"burstfire_rifle",
"doubletap_pistol",
"aimedshot_precision",
"med_aid",

}

ENT.tags = {
	["Biological"] = true,
	["Humanoid"] = true,
	["Living"] = true,
	["Authoriity"] = true,
}

ENT.models = {
    "models/gore/ncr remake/ncr/medicboone.mdl",
    "models/gore/ncr remake/ncr/medicboyd.mdl",
    "models/gore/ncr remake/ncr/medicfrank.mdl",
    "models/gore/ncr remake/ncr/medicghoul(female).mdl",
    "models/gore/ncr remake/ncr/medicghoul.mdl",
    "models/gore/ncr remake/ncr/medichorst.mdl",
    "models/gore/ncr remake/ncr/medicjensk.mdl",
    "models/gore/ncr remake/ncr/medickingsley.mdl",
    "models/gore/ncr remake/ncr/medicmoore.mdl",
    "models/gore/ncr remake/ncr/medicnils.mdl",
    "models/gore/ncr remake/ncr/medictorv.mdl",
    "models/gore/ncr remake/ncr/medicwilhem.mdl",
}

function ENT:Initialize()
	self:basicSetup()
end