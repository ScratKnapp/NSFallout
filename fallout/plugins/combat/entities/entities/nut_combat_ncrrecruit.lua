ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "NCR Raider"
ENT.Category = "NutScript - Combat (New California Republic)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "NCR Raider"

ENT.model = "models/gore/ncr remake/californian raider/californianraideranton.mdl"
ENT.hp = 100
ENT.dmg = {
	["5.56"] = 30,
}
ENT.accuracy = 10
ENT.evasion = 5

ENT.armor = {
	["Head"] = 10,
	["Body"] = 6,
	["Left Arm"] = 4,
	["Right Arm"] = 4,
	["Left Leg"] = 4,
	["Right Leg"] = 4,
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
	["guns"] = 8,
	["energyweapons"] = 0,
	["melee"] = 8,
	["throwing"] = 5,

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
    "models/gore/ncr remake/californian raider/californianraidertorv.mdl",
    "models/gore/ncr remake/californian raider/californianraiderboone.mdl",
    "models/gore/ncr remake/californian raider/californianraiderboyd.mdl",
    "models/gore/ncr remake/californian raider/californianraiderfrank.mdl",
    "models/gore/ncr remake/californian raider/californianraiderghoul(female).mdl",
    "models/gore/ncr remake/californian raider/californianraiderghoul.mdl",
    "models/gore/ncr remake/californian raider/californianraiderhorst.mdl",
    "models/gore/ncr remake/californian raider/californianraiderjensk.mdl",
    "models/gore/ncr remake/californian raider/californianraiderkingsley.mdl",
    "models/gore/ncr remake/californian raider/californianraidermoore.mdl",
    "models/gore/ncr remake/californian raider/californianraidernils.mdl",
    "models/gore/ncr remake/californian raider/californianraiderwilhem.mdl",
}

function ENT:Initialize()
	self:basicSetup()
end