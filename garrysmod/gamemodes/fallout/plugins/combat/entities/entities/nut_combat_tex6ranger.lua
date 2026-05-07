ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Texas Ranger"
ENT.Category = "NutScript - Combat (Texans)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Texas Ranger"


ENT.StepData = {
	0.25,
	0.75,
}

ENT.FootstepSounds = {
	"npc/footsteps/hardboot_generic1.wav",
	"npc/footsteps/hardboot_generic2.wav",
	"npc/footsteps/hardboot_generic3.wav",
	"npc/footsteps/hardboot_generic4.wav",
	"npc/footsteps/hardboot_generic5.wav",
	"npc/footsteps/hardboot_generic6.wav",
}

 ENT.models = {
    "models/gore/ncr remake/desert ranger/dranton.mdl",
	"models/gore/ncr remake/desert ranger/drboone.mdl",
	"models/gore/ncr remake/desert ranger/drboyd.mdl",
	"models/gore/ncr remake/desert ranger/drfrank.mdl",
	"models/gore/ncr remake/desert ranger/drghoul.mdl",
	"models/gore/ncr remake/desert ranger/drjensk.mdl",
	"models/gore/ncr remake/desert ranger/drkingsley.mdl",
	"models/gore/ncr remake/desert ranger/drmoore.mdl",
	"models/gore/ncr remake/desert ranger/drwilhem.mdl",

}

ENT.hp = 140
ENT.dmg = {
	[".308"] = 30,
}
ENT.accuracy = 120
ENT.evasion = 5

ENT.weapons = {
	"gunrevolver_rangersequoia",
	"gunrifle_automaticrifle",
	"gunprecision_brushgun",
	"gunshotgun_riotgun",
	"gunsniper_dkssniperrifle",

}

ENT.armor = {
	["Head"] = 25,
	["Body"] = 25,
	["Left Arm"] = 25,
	["Right Arm"] = 25,
	["Left Leg"] = 25,
	["Right Leg"] = 25,
}

ENT.armorBreak = {
	["Head"] = 8,
	["Body"] = 8,
	["Left Arm"] = 8,
	["Right Arm"] = 8,
	["Left Leg"] = 8,
	["Right Leg"] = 8,
}


--all attributes
ENT.attribs = {
	["str"] = 0,
	["per"] = 0,
	["end"] = 0,
	["cha"] = 2,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 6,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 17,
	["energyweapons"] = 0,
	["melee"] = 17,
	["throwing"] = 12,

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


--if some sounds or too loud or you want to fuck with them, uncomment and use this
--[[
ENT.SoundPitch = {50, 70}
ENT.SoundVolume = 1
--]]

--the actions the AI will use automatically during a fight
--left blank since weapons will give actions to it
--if you add stuff like dodge or block it may just spam it
ENT.actionsAI = {
"dodge",

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
 
	
	"vj_fallout/human/maleadult02/b_attack01.wav",
	"vj_fallout/human/maleadult02/b_attack02.wav",
	"vj_fallout/human/maleadult02/b_attack03.wav",
	"vj_fallout/human/maleadult02/b_attack04.wav",
	"vj_fallout/human/maleadult02/b_attack05.wav",
	"vj_fallout/human/maleadult02/b_attack06.wav",
	"vj_fallout/human/maleadult02/b_attack07.wav",
	"vj_fallout/human/maleadult02/b_attack08.wav",
	"vj_fallout/human/maleadult02/b_attack09.wav",
	"vj_fallout/human/maleadult02/b_attack10.wav",
	"vj_fallout/human/maleadult02/b_attack11.wav",
	"vj_fallout/human/maleadult05/vdialogueg_alerttocombat_001751e3_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_alerttocombat_001751e4_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_alerttocombat_001751e2_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_assault_0017510c_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_assault_0017510b_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_assault_0017510a_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_attack_0014f00e_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_attack_0014f010_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_attack_0014f012_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_attack_001751fa_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_attack_001751fb_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_attack_001751fc_1.wav",
	
	
}

--sound plays when the CEnt is moving
ENT.IdleSounds = {
 	"vj_fallout/human/maleadult02/b_attack01.wav",
	"vj_fallout/human/maleadult02/b_attack02.wav",
	"vj_fallout/human/maleadult02/b_attack03.wav",
	"vj_fallout/human/maleadult02/b_attack04.wav",
	"vj_fallout/human/maleadult02/b_attack05.wav",
	"vj_fallout/human/maleadult02/b_attack06.wav",
	"vj_fallout/human/maleadult02/b_attack07.wav",
	"vj_fallout/human/maleadult02/b_attack08.wav",
	"vj_fallout/human/maleadult02/b_attack09.wav",
	"vj_fallout/human/maleadult02/b_attack10.wav",
	"vj_fallout/human/maleadult02/b_attack11.wav",
	"vj_fallout/human/maleadult05/vdialogueg_alerttocombat_001751e3_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_alerttocombat_001751e4_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_alerttocombat_001751e2_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_assault_0017510c_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_assault_0017510b_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_assault_0017510a_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_attack_0014f00e_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_attack_0014f010_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_attack_0014f012_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_attack_001751fa_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_attack_001751fb_1.wav",
	"vj_fallout/human/maleadult05/vdialogueg_attack_001751fc_1.wav",
}

--sounds plays when CEnt dies
ENT.DeathSounds = {
	"vj_fallout/human/maleadult03/death01.wav",
	"vj_fallout/human/maleadult04/generic_hit_0017523a_1.wav",
	"vj_fallout/human/maleadult04/generic_hit_0017523b_1.wav",
	"vj_fallout/human/maleadult05/generic_hit_0017523c_1.wav",
	"vj_fallout/human/maleadult05/generic_hit_00175238_1.wav",
	"vj_fallout/human/maleadult05/generic_hit_00175239_1.wav",
	"vj_fallout/human/maleadult03/death03.wav",
	"vj_fallout/human/maleadult03/death02.wav",
	}

--sound plays when the CEnt is attacked
ENT.PainSounds = {
	"vj_fallout/human/maleadult04/generic_hit_0017523a_1.wav",
	"vj_fallout/human/maleadult04/generic_hit_0017523b_1.wav",
	"vj_fallout/human/maleadult04/generic_hit_0017523c_1.wav",
	"vj_fallout/human/maleadult03/death03.wav",
	"vj_fallout/human/maleadult03/death02.wav",
	"vj_fallout/human/maleadult08/b_hit04.wav",
	"vj_fallout/human/maleadult08/b_hit05.wav",
	"vj_fallout/human/maleadult08/b_hit06.wav",
	"vj_fallout/human/maleadult08/b_hit07.wav",
	"vj_fallout/human/maleadult08/b_hit01.wav",
	"vj_fallout/human/maleadult08/b_hit02.wav",
}

--sound plays when the CEnt hits another target
--usually used for things like gunshots
ENT.HitSounds = {
	"vj_fallout/human/maleadult04/generic_hit_0017523a_1.wav",
	"vj_fallout/human/maleadult04/generic_hit_0017523b_1.wav",
	"vj_fallout/human/maleadult04/generic_hit_0017523c_1.wav",
	"vj_fallout/human/maleadult03/death03.wav",
	"vj_fallout/human/maleadult03/death02.wav",
	"vj_fallout/human/maleadult08/b_hit04.wav",
	"vj_fallout/human/maleadult08/b_hit05.wav",
	"vj_fallout/human/maleadult08/b_hit06.wav",
	"vj_fallout/human/maleadult08/b_hit07.wav",
	"vj_fallout/human/maleadult08/b_hit01.wav",
	"vj_fallout/human/maleadult08/b_hit02.wav",
}

function ENT:Initialize()
	self:basicSetup()
end