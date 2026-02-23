ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Wastelander"
ENT.Category = "NutScript - Combat (Wastelanders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Wastelander"

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


}
ENT.hp = 100
ENT.dmg = {
	["Slash"] = 5,
}
ENT.accuracy = 1
ENT.evasion = 1

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
"grenade_frag",

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