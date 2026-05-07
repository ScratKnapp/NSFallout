ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Gambler"
ENT.Category = "NutScript - Combat (Wastelanders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Gambler"

ENT.models = {
	"models/kaesar/falloutnewvegas/veras/verasf.mdl",
	"models/kaesar/falloutnewvegas/veras/veras.mdl",
	"models/kaesar/falloutnewvegas/tenpennys/tenpennysf.mdl",
	"models/kaesar/falloutnewvegas/tenpennys/tenpennys.mdl",
	"models/kaesar/falloutnewvegas/dapper/dapper.mdl",
	"models/kaesar/falloutnewvegas/dapper/dapperf.mdl",
	"models/kaesar/falloutnewvegas/dirtyprewar/dirtyprewar.mdl",
	"models/kaesar/falloutnewvegas/dirtyprewar/dirtyprewarf.mdl",
	"models/kaesar/falloutnewvegas/shabby/shabbyf.mdl",
	"models/kaesar/falloutnewvegas/shabby/shabby.mdl",


}
ENT.hp = 100
ENT.dmg = {
	["9mm"] = 25,
}
ENT.accuracy = 55
ENT.evasion = 3

ENT.armor = {
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
	["cha"] = 4,
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

}

ENT.res = {
}

ENT.actions = {
"dodge",
"charge",
"burstfire_smg",
"runngun",
"burstfire_rifle",
"suppression1",
"doubletap_pistol",
"doubletap_precision",
"aimedshot_precision",
"grenade_firebomb",

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