ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Dust Devil Captain"
ENT.Category = "NutScript - Combat (Raiders)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Dust Devil Captain"

ENT.models = {
	"models/player/h&h/bos/lancer/male01.mdl",

}
ENT.hp = 125
ENT.accuracy = 90
ENT.evasion = 8

ENT.weapons = {
	"gunpistol_45pistol",
	"gunpistol_10mmpistol",
	"gunprecision_cowboyrepeater",
	"gunrevolver_357magnum",
	"gunrifle_combatrifle",
	"gunshotgun_huntingshotgun",
	"gunsmg_45smg",
	"gunsniper_huntingrifle",
	"gunenergy_laserrifle",
	"gunenergy_laserrcw",
	"gunsmg_10mmsmg",
}

ENT.dmg = {
	["Slash"] = 20
}

ENT.armor = {
	["Head"] = 10,
	["Body"] = 10,
	["Left Arm"] = 10,
	["Right Arm"] = 10,
	["Left Leg"] = 10,
	["Right Leg"] = 10,
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
 
	"vj_fallout/human/maleadult03/fie_normaltocombat01.wav",
	"vj_fallout/human/maleadult03/fie_normaltocombat02.wav",
	"vj_fallout/human/maleadult03/fie_normaltocombat03.wav",
	"vj_fallout/human/maleadult03/fiend_attack01.wav",
	"vj_fallout/human/maleadult03/fiend_attack02.wav",
	"vj_fallout/human/maleadult03/fiend_attack03.wav",
	"vj_fallout/human/maleadult03/fiend_deathresponse01.wav",
	"vj_fallout/human/maleadult03/fiend_deathresponse02.wav",
	"vj_fallout/human/maleadult03/fiend_deathresponse04.wav",
	"vj_fallout/human/maleadult03/fiend_deathresponse05.wav",
	"vj_fallout/human/maleadult03/fiend_deathresponse06.wav",
	
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
    
    for k, v in pairs(self:GetBodyGroups()) do
        self:SetBodygroup(v.id, math.random(0, v.num))
    end
end