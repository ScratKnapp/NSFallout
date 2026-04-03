ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Plainsman Warrior"
ENT.Category = "NutScript - Combat (Tribals)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Plainsman Warrior"

ENT.models = {
	"models/kaesar/falloutnewvegas/whiteleg/whiteleg.mdl",
	"models/kaesar/falloutnewvegas/whiteleg/whitelegf.mdl",
}

ENT.weapons = {
	"melee1h_machete",
	"melee2h_tribalspear",
	"gunpistol_45pistol",
	"gunrevolver_357magnum",
	"gunsmg_45smg",
	"gunsniper_huntingrifle",
	"gunsmg_10mmsmg",
}

ENT.hp = 100
ENT.accuracy = 80
ENT.evasion = 3

ENT.dmg = {
	["Slash"] = 5
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
	["Head"] = 3,
	["Body"] = 3,
	["Left Arm"] = 3,
	["Right Arm"] = 3,
	["Left Leg"] = 3,
	["Right Leg"] = 3,
}

--all attributes
ENT.attribs = {
	["str"] = 0,
	["per"] = 0,
	["end"] = 0,
	["cha"] = 0,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 4,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 5,
	["energyweapons"] = 5,
	["melee"] = 5,
	["throwing"] = 5,
	["medicine"] = 20,

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

function ENT:Initialize()
	self:basicSetup()
	    for k, v in pairs(self:GetBodyGroups()) do
        self:SetBodygroup(v.id, math.random(0, v.num))
    end
end