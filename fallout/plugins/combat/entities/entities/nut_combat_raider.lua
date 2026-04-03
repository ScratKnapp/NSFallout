ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Rattler"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Rattler"

ENT.models = {
    "models/gore/nomads/nomadm_05.mdl",
	"models/gore/nomads/nomadm_06.mdl",
	"models/gore/nomads/nomadm_09.mdl",
	"models/gore/nomads/nomadm_07.mdl",
	"models/gore/nomads/nomadm_03.mdl",
	"models/gore/nomads/nomadm_04.mdl",
	"models/gore/nomads/nomadm_02.mdl",
	"models/gore/nomads/nomadm_01.mdl",
	"models/gore/nomads/nomadf_02.mdl",
	"models/gore/nomads/nomadf_01.mdl",
}

ENT.hp = 100
ENT.dmg = {
	["9mm"] = 25,
}
ENT.accuracy = 50
ENT.evasion = 5

ENT.weapons = {
	"gunpistol_9mmpistol",
	"gunpistol_10mmpistol",
	"gunpistol_22lrpistol",
	"gunrevolver_32revolver",
	"gunpistol_chinesepistol",
	"gunprecision_varmintrifle",
	"gunshotgun_caravanshotgun",
	"gunshotgun_singleshotgun",
	"gunsmg_9mmsmg",
	"gunsmg_22lrsmg",
	"melee1h_combatknife",
	"melee1h_leadpipe",
	"melee1h_machete",
	"gunenergy_lasermusket",
	"gunenergy_laserpistol",
	"gunsmg_10mmsmg",
}

ENT.armor = {
	["Head"] = 0,
	["Body"] = 0,
	["Left Arm"] = 0,
	["Right Arm"] = 0,
	["Left Leg"] = 0,
	["Right Leg"] = 0,
}

ENT.armorBreak = {
	["Head"] = 0,
	["Body"] = 0,
	["Left Arm"] = 0,
	["Right Arm"] = 0,
	["Left Leg"] = 0,
	["Right Leg"] = 0,
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
	["energyweapons"] = 8,
	["melee"] = 8,
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

function ENT:Initialize()
	self:basicSetup()
	    for k, v in pairs(self:GetBodyGroups()) do
        self:SetBodygroup(v.id, math.random(0, v.num))
    end
end