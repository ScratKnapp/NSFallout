ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Example Man"
ENT.Category = "NutScript - Combat (Example)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Jim"

ENT.models = {
    "models/player/odessa.mdl",
}

ENT.WalkAnim = "walk_all"
ENT.RunAnim = "run_all_01"

ENT.hp = 100
ENT.dmg = {
	["9mm"] = 25,
}
ENT.accuracy = 50
ENT.evasion = 5

ENT.weapons = {
	"gunpistol_9mmpistol",
	"gunrifle_ak112",
	"gunshotgun_caravanshotgun",
	"gunsmg_5mmsmg",
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
	["cha"] = 2,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 4,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 8,
	["energyweapons"] = 8,
	["melee"] = 8,
	["throwing"] = 8,

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

--if some sounds or too loud or you want to fuck with them, uncomment and use this
--[[
ENT.SoundPitch = {50, 70}
ENT.SoundVolume = 1
--]]

--the actions the AI will use automatically during a fight
--left blank since weapons will give actions to it
--if you add stuff like dodge or block it may just spam it
ENT.actionsAI = {
}

--the range at which the CEnt will do its actions
--overwritten by weapons if ITEM.fireRange is set in the weapon file
ENT.fireRange = 80

--sound the footsteps make each step
ENT.FootstepSounds = {
	"npc/footsteps/hardboot_generic1.wav",
	"npc/footsteps/hardboot_generic2.wav",
	"npc/footsteps/hardboot_generic3.wav",
	"npc/footsteps/hardboot_generic4.wav",
	"npc/footsteps/hardboot_generic5.wav",
	"npc/footsteps/hardboot_generic6.wav",
}

--sound plays when the CEnt does an action
--weapon attack sounds will overwrite these if they are set
ENT.AttackSounds = {
	"vo/npc/male01/likethat.wav",
	"vo/npc/male01/evenodds.wav",
	"weapons/ar2/fire1.wav",
}

--sound plays when the CEnt is moving
ENT.IdleSounds = {
	"vo/npc/male01/answer32.wav",
	"vo/npc/male01/answer33.wav",
	"vo/npc/male01/answer34.wav",
	"vo/npc/male01/answer35.wav",
	"vo/npc/male01/answer36.wav",
	"vo/npc/male01/answer37.wav",
	"vo/npc/male01/answer38.wav",
	"vo/npc/male01/answer39.wav",
	"vo/npc/male01/question16.wav",
}

--sounds plays when CEnt dies
ENT.DeathSounds = {
	"vo/coast/odessa/male01/nlo_cubdeath01.wav",
	"vo/coast/odessa/male01/nlo_cubdeath02.wav",
	"ambient/voices/m_scream1.wav",
}

--sound plays when the CEnt is attacked
ENT.PainSounds = {
	"vo/npc/male01/pain01.wav",
	"vo/npc/male01/pain02.wav",
	"vo/npc/male01/pain03.wav",
	"vo/npc/male01/pain04.wav",
	"vo/npc/male01/pain05.wav",
	"vo/npc/male01/pain06.wav",
	"vo/npc/male01/pain07.wav",
	"vo/npc/male01/pain08.wav",
	"vo/npc/male01/pain09.wav",
	"vo/npc/male01/help01.wav",
}

--sound plays when the CEnt hits another target
--usually used for things like gunshots
ENT.HitSounds = {
	"vo/npc/male01/pain01.wav",
	"vo/npc/male01/pain02.wav",
	"vo/npc/male01/pain03.wav",
	"vo/npc/male01/pain04.wav",
	"vo/npc/male01/pain05.wav",
	"vo/npc/male01/pain06.wav",
	"vo/npc/male01/pain07.wav",
	"vo/npc/male01/pain08.wav",
	"vo/npc/male01/pain09.wav",
	"vo/npc/male01/help01.wav",
}