ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Mosswalker Warden"
ENT.Category = "NutScript - Combat (Tribals)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Mosswalker Warden"

ENT.models = {
    "models/player/h&h/tribal/male01.mdl",

}

ENT.weapons = {
	"gunrevolver_huntingrevolver",
	"gunsmg_127smg",
	"gunsniper_dkssniperrifle",
	"gunrifle_infiltrator",
}

ENT.hp = 150
ENT.accuracy = 80
ENT.evasion = 8

ENT.dmg = {
	["Slash"] = 36
}

ENT.armor = {
	["Head"] = 12,
	["Body"] = 12,
	["Left Arm"] = 12,
	["Right Arm"] = 12,
	["Left Leg"] = 12,
	["Right Leg"] = 12,
}

ENT.armorBreak = {
	["Head"] = 3,
	["Body"] = 3,
	["Left Arm"] = 3,
	["Right Arm"] = 3,
	["Left Leg"] = 3,
	["Right Leg"] = 3,
}

--all attributes
ENT.attribs = {
	["str"] = 9,
	["per"] = 6,
	["end"] = 8,
	["cha"] = 2,
	["int"] = 2,
	["agi"] = 0,
	["luck"] = 5,

}

ENT.skills = {
	["evasion"] = 0,
	["guns"] = 15,
	["energyweapons"] = 15,
	["melee"] = 15,
	["throwing"] = 15,

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

"vj_fallout/human/maleadult04/vnellisgen_assault_0017510e_1.wav",
"vj_fallout/human/maleadult04/vnellisgen_assault_00176ee8_1.wav",
"vj_fallout/human/maleadult04/vnellisgen_deathresponse_001751c4_1.wav",
"vj_fallout/human/maleadult04/vnellisgen_steal_0017520d_1.wav",
"vj_fallout/human/maleadult04/genericadultcombat_attack_001751e8_1.wav",
"vj_fallout/human/maleadult04/genericadultcombat_attack_001751e9_1.wav",

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