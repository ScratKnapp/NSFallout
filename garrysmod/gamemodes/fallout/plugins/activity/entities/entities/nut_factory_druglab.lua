ENT.Type = "anim"
ENT.Base = "nut_factory_base"
ENT.PrintName = "Factory - Druglab"
ENT.Author = ""
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Nutscript - Factories (Illegal)"
ENT.AutomaticFrameAdvance = true

ENT.model = "models/props_junk/wood_crate002a.mdl"

ENT.process = {
	[1] = {
		name = "Synthetic Marijuana",
		required = {
			["mat_organic"] = 3,
		},
		results = {
			["drug_marijuana_synthetic"] = 1,
		},
		time = 300,
	},
}