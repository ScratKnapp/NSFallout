ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "War Dog"
ENT.Category = "NutScript - Combat (Tribals)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "War Dog"

ENT.models = {
	"models/gore/subfactions/libertaras_rangerm_01.mdl",
	"models/gore/subfactions/libertaras_rangerf_01.mdl",

}

ENT.weapons = {
	"gunrevolver_huntingrevolver",
	"gunsmg_127smg",
	"gunsniper_dkssniperrifle",
	"gunrifle_infiltrator",
}

ENT.hp = 150
ENT.accuracy = 80
ENT.evasion = 8

ENT.dmg = {
	["Slash"] = 36
}

ENT.armor = {
	["Head"] = 12,
	["Body"] = 12,
	["Left Arm"] = 12,
	["Right Arm"] = 12,
	["Left Leg"] = 12,
	["Right Leg"] = 12,
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
	["str"] = 9,
	["per"] = 6,
	["end"] = 8,
	["cha"] = 2,
	["int"] = 2,
	["agi"] = 0,
	["luck"] = 5,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 15,
	["energyweapons"] = 15,
	["melee"] = 15,
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
	    for k, v in pairs(self:GetBodyGroups()) do
        self:SetBodygroup(v.id, math.random(0, v.num))
    end
end