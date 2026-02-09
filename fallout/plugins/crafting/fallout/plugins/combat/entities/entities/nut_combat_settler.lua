ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Settler"
ENT.Category = "NutScript - Combat (Townspeople)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Settler"

ENT.models = {
	"models/gore/neutrals/auxiliary/Civilian Boyd.mdl",
	"models/gore/neutrals/auxiliary/Civilian Frank.mdl",
	"models/gore/neutrals/auxiliary/Civilian Ghoul.mdl",
	"models/gore/neutrals/auxiliary/Civilian Horst.mdl",
	"models/gore/neutrals/auxiliary/Civilian Torv.mdl",
	"models/adi/westernfolk/male_01.mdl",
	"models/adi/westernfolk/male_02.mdl",
	"models/adi/westernfolk/male_03.mdl",
	"models/adi/westernfolk/male_04.mdl",
	"models/adi/westernfolk/male_05.mdl",
	"models/adi/westernfolk/male_06.mdl",
	"models/adi/westernfolk/male_07.mdl",
	"models/adi/westernfolk/male_08.mdl",
	"models/adi/westernfolk/male_09.mdl",
	"models/adi/westernfolk/male_10.mdl",
	"models/old_jimmy/western/cowboy_female2_00.mdl",
	"models/old_jimmy/western/cowboy_female2_01.mdl",
	"models/old_jimmy/western/cowboy_female2_02.mdl",
	"models/old_jimmy/western/cowboy_female2_03.mdl",
	"models/old_jimmy/western/cowboy_female2_04.mdl",
	"models/old_jimmy/western/cowboy_female2_05.mdl",
	"models/old_jimmy/western/cowboy_female3_00.mdl",
	"models/old_jimmy/western/cowboy_female3_01.mdl",
	"models/old_jimmy/western/cowboy_female3_02.mdl",
	"models/old_jimmy/western/cowboy_female3_03.mdl",
	"models/old_jimmy/western/cowboy_female3_04.mdl",
	"models/old_jimmy/western/cowboy_female3_05.mdl",


}
ENT.hp = 100
ENT.dmg = {
	["9mm"] = 25,
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