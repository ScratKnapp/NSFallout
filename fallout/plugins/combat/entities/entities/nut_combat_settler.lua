ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Settler"
ENT.Category = "NutScript - Combat (Wastelanders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Settler"

ENT.models = {
	"models/kaesar/falloutnewvegas/brahmin/brahmin.mdl",
	"models/kaesar/falloutnewvegas/brahmin/brahminf.mdl",
	"models/kaesar/falloutnewvegas/merc_grunt/merc_grunt.mdl",
	"models/kaesar/falloutnewvegas/merc_grunt/merc_gruntf.mdl",
	"models/kaesar/falloutnewvegas/powder/powder.mdl",
	"models/kaesar/falloutnewvegas/powder/powderf.mdl",
	"models/kaesar/falloutnewvegas/robcojumpsuit/robcojumpsuit.mdl",
	"models/kaesar/falloutnewvegas/robcojumpsuit/robcojumpsuitf.mdl",
	"models/kaesar/falloutnewvegas/settler/settler.mdl",
	"models/kaesar/falloutnewvegas/settler/settlerf.mdl",
	"models/kaesar/falloutnewvegas/slaverag/slaverag.mdl",
	"models/kaesar/falloutnewvegas/slaverag/slaveragf.mdl",
	"models/kaesar/falloutnewvegas/wanderer/wanderer.mdl",
	"models/kaesar/falloutnewvegas/wanderer/wandererf.mdl",
	"models/thespireroleplay/humans/group060/male_14.mdl",
	"models/thespireroleplay/humans/group061/female_11.mdl",
	"models/thespireroleplay/humans/group061/male_18.mdl",
	"models/thespireroleplay/humans/group060/female_05.mdl",
	"models/kaesar/falloutnewvegas/caravaneer/caravaneer.mdl",
	"models/kaesar/falloutnewvegas/caravaneer/caravaneerf.mdl",
	"models/kaesar/falloutnewvegas/dirtyprewar/dirtyprewar.mdl",
	"models/kaesar/falloutnewvegas/fieldhand/fieldhand.mdl",
	"models/kaesar/falloutnewvegas/fieldhand/fieldhandf.mdl",



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