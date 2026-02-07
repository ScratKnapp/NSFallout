ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Rancher"
ENT.Category = "NutScript - Combat (Townspeople)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Rancher"

ENT.models = {
	"models/player/h&h/western/wastelander03/male01.mdl",
	"models/player/h&h/western/wastelander03/ghoul01.mdl",
	"models/old_jimmy/western/cowboy_female3_05.mdl",
	"models/old_jimmy/western/cowboy_female3_04.mdl",
	"models/old_jimmy/western/cowboy_female2_03.mdl",
	"models/old_jimmy/western/cowboy_female2_03.mdl",
	"models/old_jimmy/western/cowboy_female2_00.mdl",
	"models/old_jimmy/western/cowboy_male3_01.mdl",

}
ENT.hp = 100
ENT.dmg = {
	["Slash"] = 5,
}
ENT.accuracy = 3
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
end