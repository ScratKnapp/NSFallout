-- 2026 Evi // CYR Framework - Combat Model Definitions
-- Per-creature limb maps for fallout/ models. Registered against NWL.CombatModel.
--
-- Naming convention used here:
--   Bipeds  : Head, Body, Left Arm, Right Arm, Left Leg, Right Leg, Tail
--   Quad    : Head, Body, Front Left Leg, Front Right Leg, Back Left Leg, Back Right Leg, Tail
--   Insects : add Mid Left Leg / Mid Right Leg (and Rear* if extra pairs), Left/Right Wing,
--             Left/Right Antenna, Left/Right Mandible, Stinger
--   Crabs   : Left Pincer / Right Pincer in place of arms

local CM = NWL.CombatModel
if not CM then return end

-- ============================================================
-- Standard biped (sporecarrier, mirelurkking) 
-- ============================================================
CM.RegisterLimbSet("biped_human", {
    ["Head"]      = { bones = {"Bip01 Head"} },
    ["Body"]      = { bones = {"Bip01 Spine", "Bip01 Spine1"} },
    ["Left Arm"]  = { bones = {"Bip01 L UpperArm", "Bip01 L Forearm", "Bip01 L Hand"} },
    ["Right Arm"] = { bones = {"Bip01 R UpperArm", "Bip01 R Forearm", "Bip01 R Hand"} },
    ["Left Leg"]  = { bones = {"Bip01 L Thigh", "Bip01 L Calf", "Bip01 L Foot"} },
    ["Right Leg"] = { bones = {"Bip01 R Thigh", "Bip01 R Calf", "Bip01 R Foot"} },
})
CM.AssignModel({
    "models/fallout/sporecarrier.mdl",
}, "biped_human")

CM.DeriveLimbSet("biped_mirelurkking", "biped_human", {
    override = {
        ["Body"] = { bones = {"Bip01 Spine", "Bip01 Spine1", "Bip01 Spine2"} },
    },
})
CM.AssignModel("models/fallout/mirelurkking.mdl", "biped_mirelurkking")

-- ============================================================
-- Bipedal beasts (deathclaw, yaoguai, nightstalker, mirelurk, mirelurk_hunter)
-- ============================================================
CM.RegisterLimbSet("biped_deathclaw", {
    ["Head"]      = { bones = {"Bip01 Head", "Bip01 Neck", "Bip01 Neck1"} },
    ["Body"]      = { bones = {"Bip01 Spine", "Bip01 Spine1", "Bip01 Spine2"} },
    ["Left Arm"]  = { bones = {"Bip01 L UpperArm", "Bip01 L Forearm", "Bip01 L Hand"} },
    ["Right Arm"] = { bones = {"Bip01 R UpperArm", "Bip01 R Forearm", "Bip01 R Hand"} },
    ["Left Leg"]  = { bones = {"Bip01 L Thigh", "Bip01 L Calf", "Bip01 L Foot"} },
    ["Right Leg"] = { bones = {"Bip01 R Thigh", "Bip01 R Calf", "Bip01 R Foot"} },
    ["Tail"]      = { bones = {"Bip01 Tail", "Bip01 Tail1", "Bip01 Tail2", "Bip01 Tail3"} },
})
CM.AssignModel("models/fallout/deathclaw.mdl", "biped_deathclaw")

CM.RegisterLimbSet("biped_yaoguai", {
    ["Head"]      = { bones = {"Bip01 Head", "Bip01 Head Muzzle", "Bip01 Head Jaw"} },
    ["Body"]      = { bones = {"Bip01 Spine1", "Bip01 Spine2", "Bip01 Spine3"} },
    ["Left Arm"]  = { bones = {"Bip01 L UpperArm", "Bip01 L Forearm", "Bip01 L Hand"} },
    ["Right Arm"] = { bones = {"Bip01 R UpperArm", "Bip01 R Forearm", "Bip01 R Hand"} },
    ["Left Leg"]  = { bones = {"Bip01 L Thigh", "Bip01 L Calf", "Bip01 L Foot"} },
    ["Right Leg"] = { bones = {"Bip01 R Thigh", "Bip01 R Calf", "Bip01 R Foot"} },
    ["Tail"]      = { bones = {"Bip01 Tail"} },
})
CM.AssignModel("models/fallout/yaoguai.mdl", "biped_yaoguai")

-- Nightstalker uses non-standard bone names (no spaces in arm bones)
CM.RegisterLimbSet("biped_nightstalker", {
    ["Head"]      = { bones = {"Bip01 Head"} },
    ["Body"]      = { bones = {"Bip01 Spine3", "Bip01 Spine4", "Bip01 Spine5"} },
    ["Left Arm"]  = { bones = {"Bip01LUpperArm", "Bip01LForearm", "Bip01LHand"} },
    ["Right Arm"] = { bones = {"Bip01RUpperArm", "Bip01RForearm", "Bip01RHand"} },
    ["Left Leg"]  = { bones = {"Bip01LCalf", "Bip01LCalf1", "Bip01LCalf2"} },
    ["Right Leg"] = { bones = {"Bip01RCalf", "Bip01RCalf1", "Bip01RCalf2"} },
    ["Tail"]      = { bones = {"Bip01 Spine0 Tail", "Bip01 Spine0 Tail1", "Bip01 Spine0 Tail2"} },
})
CM.AssignModel("models/fallout/nightstalker.mdl", "biped_nightstalker")

-- Mirelurks: bipedal crab. Arms become pincers.
CM.RegisterLimbSet("biped_mirelurk", {
    ["Head"]        = { bones = {"Bip01 Head"} },
    ["Body"]        = { bones = {"Bip01 Spine", "Bip01 Spine1"} },
    ["Left Pincer"] = { bones = {"Bip01 L UpperArm", "Bip01 L Forearm", "Bip01 L Hand"} },
    ["Right Pincer"]= { bones = {"Bip01 R UpperArm", "Bip01 R Forearm", "Bip01 R Hand"} },
    ["Left Leg"]    = { bones = {"Bip01 L Thigh", "Bip01 L Calf", "Bip01 L Foot"} },
    ["Right Leg"]   = { bones = {"Bip01 R Thigh", "Bip01 R Calf", "Bip01 R Foot"} },
    ["Tail"]        = { bones = {"Bip01 Tail", "Bip01 Tail1"} },
})
CM.AssignModel({
    "models/fallout/mirelurk.mdl",
    "models/fallout/mirelurk_hunter.mdl",
}, "biped_mirelurk")

-- ============================================================
-- Ghouls (feral, reaver, armored variants) - standard human biped, no tail.
-- Neck/Head2 fold into Head; Spine2 into Body.
-- ============================================================
CM.RegisterLimbSet("biped_ghoul", {
    ["Head"]      = { bones = {"Bip01 Head", "Bip01 Head2", "Bip01 Neck"} },
    ["Body"]      = { bones = {"Bip01 Spine", "Bip01 Spine1", "Bip01 Spine2"} },
    ["Left Arm"]  = { bones = {"Bip01 L UpperArm", "Bip01 L Forearm", "Bip01 L Hand"} },
    ["Right Arm"] = { bones = {"Bip01 R UpperArm", "Bip01 R Forearm", "Bip01 R Hand"} },
    ["Left Leg"]  = { bones = {"Bip01 L Thigh", "Bip01 L Calf", "Bip01 L Foot"} },
    ["Right Leg"] = { bones = {"Bip01 R Thigh", "Bip01 R Calf", "Bip01 R Foot"} },
})
CM.AssignModel({
    "models/fallout/ghoulferal.mdl",
    "models/fallout/ghoulferal_vaultarmor.mdl",
    "models/fallout/ghoulferal_jumpsuit.mdl",
    "models/fallout/ghoulferal_mutated.mdl",
    "models/fallout/ghoulreaver.mdl",
    "models/fallout/ghoularmored.mdl",
}, "biped_ghoul")

-- ============================================================
-- Quadrupeds (bighorner, brahmin, coyote, mongrel, dogvicious, molerat, giantrat, gecko)
-- Front legs = upper-body arms, back legs = pelvis-attached thighs.
-- ============================================================
CM.RegisterLimbSet("quad_standard", {
    ["Head"]              = { bones = {"Bip01 Head"} },
    ["Body"]              = { bones = {"Bip01 Spine", "Bip01 Spine1", "Bip01 Spine2"} },
    ["Front Left Leg"]    = { bones = {"Bip01 L UpperArm", "Bip01 L Forearm", "Bip01 L Hand"} },
    ["Front Right Leg"]   = { bones = {"Bip01 R UpperArm", "Bip01 R Forearm", "Bip01 R Hand"} },
    ["Back Left Leg"]     = { bones = {"Bip01 L Thigh", "Bip01 L Calf", "Bip01 L Foot"} },
    ["Back Right Leg"]    = { bones = {"Bip01 R Thigh", "Bip01 R Calf", "Bip01 R Foot"} },
    ["Tail"]              = { bones = {"Bip01 Tail", "Bip01 Tail1"} },
})
CM.AssignModel({
    "models/fallout/bighorner.mdl",
    "models/fallout/molerat.mdl",
    "models/fallout/giantrat.mdl",
    "models/fallout/gecko.mdl",
}, "quad_standard")

-- Coyote/mongrel/dogvicious use Spine0 Tail bone naming
CM.DeriveLimbSet("quad_canid", "quad_standard", {
    override = {
        ["Tail"] = { bones = {"Bip01 Spine0 Tail", "Bip01 Spine0 Tail1", "Bip01 Spine0 Tail2"} },
    },
})
CM.AssignModel({
    "models/fallout/coyote.mdl",
    "models/fallout/mongrel.mdl",
    "models/fallout/dogvicious.mdl",
}, "quad_canid")


CM.RegisterLimbSet("quad_brahmin", {
    ["Left Head"]       = { bones = {"Bip01 HeadL", "Bip01 Neck2L", "Bip01 Neck3L"} },
    ["Right Head"]      = { bones = {"Bip01 HeadR", "Bip01 Neck2R", "Bip01 Neck3R"} },
    ["Body"]            = { bones = {"Bip01 Spine", "Bip01 Spine1"} },
    ["Front Left Leg"]  = { bones = {"Bip01 L UpperArm", "Bip01 L Forearm", "Bip01 L Hand"} },
    ["Front Right Leg"] = { bones = {"Bip01 R UpperArm", "Bip01 R Forearm", "Bip01 R Hand"} },
    ["Back Left Leg"]   = { bones = {"Bip01 L Thigh", "Bip01 L Calf", "Bip01 L Foot"} },
    ["Back Right Leg"]  = { bones = {"Bip01 R Thigh", "Bip01 R Calf", "Bip01 R Foot"} },
    ["Tail"]            = { bones = {"Bip01 Tail", "Bip01 Tail1", "Bip01 Tail2"} },
    ["Sack"]            = { bones = {"Bip01 Sack", "Bip01 Sack2"} },
})
CM.AssignModel("models/fallout/brahmin.mdl", "quad_brahmin")

-- ============================================================ 
-- 6-legged insects (giantant, mantis, blowfly, radroach)
-- ============================================================

CM.RegisterLimbSet("hex_giantant", {
    ["Head"]              = { bones = {"Bip01 Head", "Bip01 Head Brain"} },
    ["Body"]              = { bones = {"Bip01 Spine"} },
    ["Front Left Leg"]    = { bones = {"Bip01 L UpperArm", "Bip01 L ForeArm", "Bip01 L Hand"} },
    ["Front Right Leg"]   = { bones = {"Bip01 R UpperArm", "Bip01 R ForeArm", "Bip01 R Hand"} },
    ["Mid Left Leg"]      = { bones = {"Bip01 L Thigh Mid", "Bip01 L Calf Mid", "Bip01 L Foot Mid"} },
    ["Mid Right Leg"]     = { bones = {"Bip01 R Thigh Mid", "Bip01 R Calf Mid", "Bip01 R Foot Mid"} },
    ["Back Left Leg"]     = { bones = {"Bip01 L Thigh Rear", "Bip01 L Calf Rear", "Bip01 L Foot Rear"} },
    ["Back Right Leg"]    = { bones = {"Bip01 R Thigh Rear", "Bip01 R Calf Rear", "Bip01 R Foot Rear"} },
    ["Tail"]              = { bones = {"Bip01 Tail", "Bip01 Tail01", "Bip01 Tail02"} },
})
CM.AssignModel("models/fallout/giantant.mdl", "hex_giantant")


CM.RegisterLimbSet("hex_giantantqueen", {
    ["Head"]              = { bones = {"Bip01 Head", "Bip01 Head Brain"} },
    ["Body"]              = { bones = {"Bip01 Spine", "Bip01 Spine1"} },
    ["Front Left Leg"]    = { bones = {"Bip01 L Thigh Front", "Bip01 L Calf Front", "Bip01 L Foot Front"} },
    ["Front Right Leg"]   = { bones = {"Bip01 R Thigh Front", "Bip01 R Calf Front", "Bip01 R Foot Front"} },
    ["Mid Left Leg"]      = { bones = {"Bip01 L Thigh Mid", "Bip01 L Calf Mid", "Bip01 L Foot Mid"} },
    ["Mid Right Leg"]     = { bones = {"Bip01 R Thigh Mid", "Bip01 R Calf Mid", "Bip01 R Foot Mid"} },
    ["Back Left Leg"]     = { bones = {"Bip01 L Thigh Rear", "Bip01 L Calf Rear", "Bip01 L Foot Rear"} },
    ["Back Right Leg"]    = { bones = {"Bip01 R Thigh Rear", "Bip01 R Calf Rear", "Bip01 R Foot Rear"} },
    ["Tail"]              = { bones = {"Bip01 Tail", "Bip01 Tail1", "Bip01 Tail2", "Bip01 Tail3"} },
})
CM.AssignModel("models/fallout/giantantqueen.mdl", "hex_giantantqueen")


CM.RegisterLimbSet("hex_mantis", {
    ["Head"]              = { bones = {"Bip01 Head", "Bip01 Head Brain"} },
    ["Body"]              = { bones = {"Bip01 Thorax00", "Bip01 Thorax01"} },
    ["Left Arm"]          = { bones = {"Bip01 LeftArm00", "Bip01 LeftArm01", "Bip01 LeftArm02"} },
    ["Right Arm"]         = { bones = {"Bip01 RightArm00", "Bip01 RightArm01", "Bip01 RightArm02"} },
    ["Front Left Leg"]    = { bones = {"Bip01 FrontLeftLeg00", "Bip01 FrontLeftLeg01", "Bip01 FrontLeftLeg02"} },
    ["Front Right Leg"]   = { bones = {"Bip01 FrontRightLeg00", "Bip01 FrontRightLeg01", "Bip01 FrontRightLeg02"} },
    ["Back Left Leg"]     = { bones = {"Bip01 BackLeftLeg00", "Bip01 BackLeftLeg01", "Bip01 BackLeftLeg02"} },
    ["Back Right Leg"]    = { bones = {"Bip01 BackRightLeg00", "Bip01 BackRightLeg01", "Bip01 BackRightLeg02"} },
    ["Left Wing"]         = { bones = {"Bip01 LeftWing01", "Bip01 LeftWing02"} },
    ["Right Wing"]        = { bones = {"Bip01 RightWing01", "Bip01 RightWing02"} },
    ["Tail"]              = { bones = {"Bip01 Gaster00", "Bip01 Gaster01"} },
})
CM.AssignModel("models/fallout/mantis.mdl", "hex_mantis")


CM.RegisterLimbSet("hex_blowfly", {
    ["Head"]            = { bones = {"Bip01 Head", "Bip01 Head Jaw"} },
    ["Body"]            = { bones = {"Bip01 Spine"} },
    ["Front Left Leg"]  = { bones = {"Bip01 L Thigh 01", "Bip01 L Calf 01", "Bip01 L Foot 01"} },
    ["Front Right Leg"] = { bones = {"Bip01 R Thigh 01", "Bip01 R Calf 01", "Bip01 R Foot 01"} },
    ["Mid Left Leg"]    = { bones = {"Bip01 L Thigh 02", "Bip01 L Calf 02", "Bip01 L Foot 02"} },
    ["Mid Right Leg"]   = { bones = {"Bip01 R Thigh 02", "Bip01 R Calf 02", "Bip01 R Foot 02"} },
    ["Back Left Leg"]   = { bones = {"Bip01 L Thigh 03", "Bip01 L Calf 03", "Bip01 L Foot 03"} },
    ["Back Right Leg"]  = { bones = {"Bip01 R Thigh 03", "Bip01 R Calf 03", "Bip01 R Foot 03"} },
    ["Tail"]            = { bones = {"Bip01 tail", "Bip01 tail01", "Bip01 tail02"} },
})
CM.AssignModel("models/fallout/blowfly.mdl", "hex_blowfly")

-- Radroach: 4 legs (Thigh01/11 pairs) + UpperArm forelimbs + wings + tail
CM.RegisterLimbSet("hex_radroach", {
    ["Head"]            = { bones = {"Bip01 Head"} },
    ["Body"]            = { bones = {"Bip01 Spine", "Bip01 Spine1"} },
    ["Front Left Leg"]  = { bones = {"Bip01 L UpperArm", "Bip01 L Forearm"} },
    ["Front Right Leg"] = { bones = {"Bip01 R UpperArm", "Bip01 R Forearm"} },
    ["Mid Left Leg"]    = { bones = {"Bip01 L Thigh01", "Bip01 L Calf01", "Bip01 L Foot01"} },
    ["Mid Right Leg"]   = { bones = {"Bip01 R Thigh01", "Bip01 R Calf01", "Bip01 R Foot01"} },
    ["Back Left Leg"]   = { bones = {"Bip01 L Thigh11", "Bip01 L Calf11", "Bip01 L Foot11"} },
    ["Back Right Leg"]  = { bones = {"Bip01 R Thigh11", "Bip01 R Calf11", "Bip01 R Foot11"} },
    ["Left Wing"]       = { bones = {"Bip01 Spine1 LWing"} },
    ["Right Wing"]      = { bones = {"Bip01 Spine1 RWing"} },
    ["Tail"]            = { bones = {"Bip01 Tail", "Bip01 Tail1"} },
})
CM.AssignModel("models/fallout/radroach.mdl", "hex_radroach")

-- ============================================================
-- Cazadore: flying insect, 6 legs + 4 wings + stinger + antennae
-- ============================================================
CM.RegisterLimbSet("hex_cazadore", {
    ["Head"]            = { bones = {"Bip01 Head", "Bip01 Brain"} },
    ["Body"]            = { bones = {"Bip01 Root", "Bip01 BackThrob"} },
    ["Front Left Leg"]  = { bones = {"Bip01 FrontLeftLeg01", "Bip01 FrontLeftLeg02", "Bip01 FrontLeftLeg03"} },
    ["Front Right Leg"] = { bones = {"Bip01 FrontRightLeg01", "Bip01 FrontRightLeg02", "Bip01 FrontRightLeg03"} },
    ["Mid Left Leg"]    = { bones = {"Bip01 MidLeftLeg01", "Bip01 MidLeftLeg02", "Bip01 MidLeftLeg03"} },
    ["Mid Right Leg"]   = { bones = {"Bip01 MidRightLeg01", "Bip01 MidRightLeg02", "Bip01 MidRightLeg03"} },
    ["Back Left Leg"]   = { bones = {"Bip01 BackLeftLeg01", "Bip01 BackLeftLeg02", "Bip01 BackLeftLeg03"} },
    ["Back Right Leg"]  = { bones = {"Bip01 BackRightLeg01", "Bip01 BackRightLeg02", "Bip01 BackRightLeg03"} },
    ["Front Left Wing"] = { bones = {"Bip01 FrontLeftWing01", "Bip01 FrontLeftWing02"} },
    ["Front Right Wing"]= { bones = {"Bip01 FrontRightWing01", "Bip01 FrontRightWing02"} },
    ["Back Left Wing"]  = { bones = {"Bip01 BackLeftWing01", "Bip01 BackLeftWing02"} },
    ["Back Right Wing"] = { bones = {"Bip01 BackRightWing01", "Bip01 BackRightWing02"} },
    ["Tail"]            = { bones = {"Bip01 Tail1", "Bip01 Tail2", "Bip01 Tail3", "Bip01 Tail4"} },
    ["Stinger"]         = { bones = {"Bip01 Stinger"} },
})
CM.AssignModel("models/fallout/cazadore.mdl", "hex_cazadore")

-- ============================================================
-- Radscorpion: 8 legs (4 pairs) + 2 pincer claws + stinger tail.

CM.RegisterLimbSet("oct_radscorpion", {
    ["Body"]                = { bones = {"Bip01 Spine", "Bip01 Pelvis"} },
    ["Left Pincer"]         = { bones = {"Bip01 L UpperArm", "Bip01 L Forearm", "Bip01 L Hand"} },
    ["Right Pincer"]        = { bones = {"Bip01 R UpperArm", "Bip01 R Forearm", "Bip01 R Hand"} },
    ["Front Left Leg"]      = { bones = {"Bip01 L Thigh_1", "Bip01 L Calf_1", "Bip01 L Foot_1"} },
    ["Front Right Leg"]     = { bones = {"Bip01 R Thigh_1", "Bip01 R Calf_1", "Bip01 R Foot_1"} },
    ["Mid Front Left Leg"]  = { bones = {"Bip01 L Thigh_2", "Bip01 L Calf_2", "Bip01 L Foot_2"} },
    ["Mid Front Right Leg"] = { bones = {"Bip01 R Thigh_2", "Bip01 R Calf_2", "Bip01 R Foot_2"} },
    ["Mid Back Left Leg"]   = { bones = {"Bip01 L Thigh_3", "Bip01 L Calf_3", "Bip01 L Foot_3"} },
    ["Mid Back Right Leg"]  = { bones = {"Bip01 R Thigh_3", "Bip01 R Calf_3", "Bip01 R Foot_3"} },
    ["Back Left Leg"]       = { bones = {"Bip01 L Thigh_4", "Bip01 L Calf",   "Bip01 L Foot_4"} },
    ["Back Right Leg"]      = { bones = {"Bip01 R Thigh_4", "Bip01 R Calf_4", "Bip01 R Foot_4"} },
    ["Tail"]                = { bones = {"Bip01 Tail", "Bip01 Tail1", "Bip01 Tail2", "Bip01 Tail3", "Bip01 Tail4", "Bip01 Tail5"} },
    ["Stinger"]             = { bones = {"Bip01 Tail6"} },
})
CM.AssignModel("models/fallout/radscorpion.mdl", "oct_radscorpion")


CM.RegisterLimbSet("quad_headcrab", {
    ["Head"]            = { bones = {"HCfast.body", "HCfast.chest"} },
    ["Body"]            = { bones = {"HCfast.hips", "HCfast.wiggle_front", "HCfast.wiggle_back",
                                     "HCfast.wiggle_L", "HCfast.wiggle_R"} },
    ["Front Left Leg"]  = { bones = {"HCfast.whole_L", "HCfast.clav_L", "HCfast.arm_bone1_L", "HCfast.arm_bone2_L"} },
    ["Front Right Leg"] = { bones = {"HCfast.whole_R", "HCfast.clav_R", "HCfast.arm_bone1_R", "HCfast.arm_bone2_R"} },
    ["Back Left Leg"]   = { bones = {"HCfast.leg_bone1_L", "HCfast.leg_bone2_L", "HCfast.leg_bone3_L"} },
    ["Back Right Leg"]  = { bones = {"HCfast.leg_bone1_R", "HCfast.leg_bone2_R", "HCfast.leg_bone3_R"} },
})
CM.AssignModel("models/headcrab.mdl", "quad_headcrab")

-- ============================================================
-- Robots
-- ============================================================

-- Eyebot: floating spherical drone. One fucking limb.
CM.RegisterLimbSet("robot_eyebot", {
    ["Head"] = { bones = {"Bip01", "Bip01 Head", "Bip01 Neck1",
                          "Bip01 L UpperArm", "Bip01 L Forearm", "Bip01 L Hand",
                          "Bip01 L UpperArmCenter", "Bip01 L ForearmCenter", "Bip01 L HandCenter",
                          "Bip01 L Thigh", "Bip01 L Calf", "Bip01 L Foot",
                          "Bip01 R UpperArm", "Bip01 R Forearm", "Bip01 R Hand",
                          "Bip01 R Thigh", "Bip01 R Calf", "Bip01 R Foot"} },
})
CM.AssignModel("models/fallout/eyebot.mdl", "robot_eyebot")

.
CM.RegisterLimbSet("robot_protectron", {
    ["Head"]      = { bones = {"Bip01 Head", "Bip01 Head Dome", "Dome", "Bip01 Neck", "Bip01 Neck1"} },
    ["Body"]      = { bones = {"Bip01 Spine", "Bip01 Pelvis"} },
    ["Left Arm"]  = { bones = {"Bip01 L Clavicle", "Bip01 L UpperArm", "Bip01 L Forearm", "Bip01 L Hand"} },
    ["Right Arm"] = { bones = {"Bip01 R Clavicle", "Bip01 R UpperArm", "Bip01 R Forearm", "Bip01 R Hand"} },
    ["Left Leg"]  = { bones = {"Bip01 L Thigh", "Bip01 L Calf", "Bip01 L Foot", "Bip01 L Toe0"} },
    ["Right Leg"] = { bones = {"Bip01 R Thigh", "Bip01 R Calf", "Bip01 R Foot", "Bip01 R Toe0"} },
    ["Core"]      = { bones = {"Bip01 Spine Brain", "Brain"} },
})
CM.AssignModel("models/fallout/protectron.mdl", "robot_protectron")

-- Protectron (factory variant): same biped layout, no separable dome bone.
CM.DeriveLimbSet("robot_protectron_factory", "robot_protectron", {
    override = {
        ["Head"] = { bones = {"Bip01 Head", "Bip01 Neck", "Bip01 Neck1"} },
    },
})
CM.AssignModel("models/fallout/protectron_factory.mdl", "robot_protectron_factory")

-- Mister Gutsy / Mr. Handy: . Three thruster "legs"

CM.RegisterLimbSet("robot_mistergutsy", {
    ["Head"]              = { bones = {"Bip01 Head", "Bip01 Neck 02", "Bip01 Neck 03", "Bip01 Neck 04", "Bip01 Neck1"} },
    ["Body"]              = { bones = {"Bip01 Spine", "Bip01 Spine 01", "Bip01 Pelvis"} },
    ["Left Arm"]          = { bones = {"Bip01 L Clavicle", "Bip01 L UpperArm", "Bip01 L Forearm", "Bip01 L Hand",
                                       "flameThrower"} },
    ["Right Arm"]         = { bones = {"Bip01 R Clavicle", "Bip01 R UpperArm", "Bip01 R Forearm", "Bip01 R Hand",
                                       "##Plasmagun"} },
    ["Back Thruster"]     = { bones = {"Bip01 R Thigh Front", "Bip01 R Thigh Front01",
                                       "Bip01 R Calf front", "Bip01 R Calf front01",
                                       "Bip01 R FootFront", "Bip01 R FootFront 01",
                                       "Bip01 R Toe 1 Front", "Bip01 L Toe 12 Front", "Bip01 L Toe 13 Front"} },
    ["Left Thruster"]     = { bones = {"Bip01 L Thigh", "Bip01 L Thigh 01",
                                       "Bip01 L Calf", "Bip01 L Calf 01",
                                       "Bip01 L Foot", "Bip01 L Foot 01", "Bip01 L Toe 1",
                                       "powerpack\t", "##Powerpack"} },
    ["Right Thruster"]    = { bones = {"Bip01 R Thigh", "Bip01 R Thigh01",
                                       "Bip01 R Calf", "Bip01 R Calf 01",
                                       "Bip01 R Foot", "Bip01 R Foot 01", "Bip01 R Toe"} },
    ["Core"]              = { bones = {"Bip01 Spine Brain", "Brain"} },
})
CM.AssignModel("models/fallout/mistergutsy.mdl", "robot_mistergutsy")


CM.RegisterLimbSet("robot_sentrybot", {
    ["Head"]            = { bones = {"Bip01 Head"} },
    ["Body"]            = { bones = {"Bip01 Spine", "Bip01 Pelvis", "Bip01 PelvisDetach"} },
    ["Left Arm"]        = { bones = {"Bip01 L UpperArm", "Bip01 L ForeArm", "Bip01 L Finger1"} },
    ["Right Arm"]       = { bones = {"Bip01 R UpperArm", "Bip01 R ForeArm", "Bip01 R Finger1", "Bip01 R Finger2",
                                     "##SBMissile"} },
    ["Left Leg"]        = { bones = {"Bip01 L Thigh", "Bip01 L Hand"} },
    ["Right Leg"]       = { bones = {"Bip01 R Thigh", "Bip01 R Hand"} },
    ["Back Leg"]        = { bones = {"Bip01 B Thigh", "Bip01 B Hand"} },
    ["Core"]            = { bones = {"Bip01 SpineBrain", "Bip01 Ponytail1", "Bip01 Ponytail2", "Bip01 Ponytail3"} },
})
CM.AssignModel("models/fallout/sentrybot_edit.mdl", "robot_sentrybot")


CM.RegisterLimbSet("robot_sentryturret", {
    ["Head"]   = { bones = {"Bip01 Pitch", "Bip01 Wires", "ProjectileNode"} },
    ["Body"]   = { bones = {"Bip01", "Bip01 Base", "Bip01 Yaw", "Bip01 Piston",
                            "Bip01 HingeParent", "Bip01 Hinge01", "Bip01 Hinge02"} },
})
CM.AssignModel("models/fallout/sentryturret.mdl", "robot_sentryturret")
