ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "NCR Veteran Ranger"
ENT.Category = "NutScript - Combat (New California Republic)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "NCR Veteran Ranger"

ENT.model = "models/player/falloutnewvegas/ncr/ncr_ranger_playermodel.mdl"
ENT.hp = 100
ENT.dmg = {
	[".308"] = 45,
}
ENT.accuracy = 10
ENT.evasion = 5

ENT.armor = {
	["Head"] = 25,
	["Body"] = 25,
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
	["guns"] = 20,
	["energyweapons"] = 0,
	["melee"] = 20,
	["throwing"] = 15,

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