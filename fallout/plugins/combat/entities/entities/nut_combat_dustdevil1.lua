ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Dust Devil Scavenger"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Dust Devil Scavenger"

ENT.models = {
	"models/player/h&h/classic/leatherarmor/male01.mdl",
	"models/player/h&h/classic/leatherarmor/lightweight/male01.mdl",
	"models/player/h&h/classic/leatherarmor/reinforced/male01.mdl",

}
ENT.hp = 100
ENT.accuracy = 30
ENT.evasion = 8

ENT.dmg = {
	["Slash"] = 20
}

ENT.armor = {
	["Head"] = 20,
	["Body"] = 20,
	["Left Arm"] = 20,
	["Right Arm"] = 20,
	["Left Leg"] = 20,
	["Right Leg"] = 20,
}


ENT.armorBreak = {
	["Head"] = 4,
	["Body"] = 4,
	["Left Arm"] = 4,
	["Right Arm"] = 4,
	["Left Leg"] = 4,
	["Right Leg"] = 4,
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