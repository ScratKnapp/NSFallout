ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Dust Devil Captain"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Dust Devil Captain"

ENT.models = {
	"models/player/h&h/classic/metalarmor/male01.mdl",

}
ENT.hp = 125
ENT.accuracy = 40
ENT.evasion = 8

ENT.weapons = {
	"gunpistol_45pistol",
	"gunpistol_10mmpistol",
	"gunprecision_cowboyrepeater",
	"gunrevolver_357magnum",
	"gunrifle_combatrifle",
	"gunshotgun_huntingshotgun",
	"gunsmg_45smg",
	"gunsniper_huntingrifle",
	"gunenergy_laserrifle",
	"gunenergy_laserrcw",
	"gunsmg_10mmsmg",
}

ENT.dmg = {
	["Slash"] = 20
}

ENT.armor = {
	["Head"] = 30,
	["Body"] = 30,
	["Left Arm"] = 30,
	["Right Arm"] = 30,
	["Left Leg"] = 30,
	["Right Leg"] = 30,
}


ENT.armorBreak = {
	["Head"] = 5,
	["Body"] = 5,
	["Left Arm"] = 5,
	["Right Arm"] = 5,
	["Left Leg"] = 5,
	["Right Leg"] = 5,
}

--all attributes
ENT.attribs = {
	["str"] = 6,
	["per"] = 6,
	["end"] = 5,
	["cha"] = 2,
	["int"] = 2,
	["agi"] = 0,
	["luck"] = 4,

}

ENT.skills = {
	["evasion"] = 6,
	["guns"] = 9,
	["energyweapons"] = 9,
	["melee"] = 9,
	["throwing"] = 9,

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