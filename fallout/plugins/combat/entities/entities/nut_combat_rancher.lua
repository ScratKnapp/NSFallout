ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Rancher"
ENT.Category = "NutScript - Combat (Wastelanders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Rancher"

ENT.models = {
	"models/thespireroleplay/humans/group004/female_01.mdl",
	"models/thespireroleplay/humans/group004/female_01g.mdl",
	"models/thespireroleplay/humans/group004/female_02.mdl",
	"models/thespireroleplay/humans/group004/female_03.mdl",
	"models/thespireroleplay/humans/group004/female_04.mdl",
	"models/thespireroleplay/humans/group004/female_05.mdl",
	"models/thespireroleplay/humans/group004/female_06.mdl",
	"models/thespireroleplay/humans/group004/female_07.mdl",
	"models/thespireroleplay/humans/group004/female_08.mdl",
	"models/thespireroleplay/humans/group004/female_09.mdl",
	"models/thespireroleplay/humans/group004/female_10.mdl",
	"models/thespireroleplay/humans/group004/female_11.mdl",
	"models/thespireroleplay/humans/group004/female_12.mdl",
	"models/thespireroleplay/humans/group004/male_01.mdl",
	"models/thespireroleplay/humans/group004/male_01g.mdl",
	"models/thespireroleplay/humans/group004/male_02.mdl",
	"models/thespireroleplay/humans/group004/male_03.mdl",
	"models/thespireroleplay/humans/group004/male_04.mdl",
	"models/thespireroleplay/humans/group004/male_05.mdl",
	"models/thespireroleplay/humans/group004/male_06.mdl",
	"models/thespireroleplay/humans/group004/male_07.mdl",
	"models/thespireroleplay/humans/group004/male_08.mdl",
	"models/thespireroleplay/humans/group004/male_09.mdl",
	"models/thespireroleplay/humans/group004/male_10.mdl",
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
	["Slash"] = 5,
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