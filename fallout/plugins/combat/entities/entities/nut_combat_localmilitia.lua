ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Local Militia"
ENT.Category = "NutScript - Combat (Townspeople)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Local Militia"

ENT.models = {
    "models/player/h&h/western/deputy/female02.mdl",
    "models/player/h&h/western/deputy/ghoul01.mdl",
    "models/player/h&h/western/deputy/male01.mdl",
    "models/player/h&h/western/sheriff/ghoul01.mdl",
    "models/player/h&h/western/sheriff/male01.mdl",
    "models/player/h&h/western/wastelander01/female02.mdl",
    "models/player/h&h/western/wastelander01/ghoul01.mdl",
    "models/player/h&h/western/sheriff/male01.mdl",
    "models/thespireroleplay/humans/group052/male_01g.mdl",
    "models/thespireroleplay/humans/group052/female_01g.mdl",
    "models/thespireroleplay/humans/group052/female_10.mdl",
    "models/thespireroleplay/humans/group052/male_15.mdl",
    "models/thespireroleplay/humans/group052/male_10.mdl",


}

ENT.hp = 100
ENT.dmg = {
	[".357 Magnum"] = 28,
}
ENT.accuracy = 10
ENT.evasion = 8

ENT.armor = {
	["Head"] = 0,
	["Body"] = 20,
	["Left Arm"] = 20,
	["Right Arm"] = 20,
	["Left Leg"] = 20,
	["Right Leg"] = 20,
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
	["str"] = 0,
	["per"] = 0,
	["end"] = 0,
	["cha"] = 2,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 4,

}

ENT.skills = {
	["evasion"] = 6,
	["guns"] = 9,
	["energyweapons"] = 0,
	["melee"] = 9,
	["throwing"] = 6,

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