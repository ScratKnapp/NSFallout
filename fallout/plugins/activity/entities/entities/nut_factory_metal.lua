ENT.Type = "anim"
ENT.Base = "nut_factory_base"
ENT.PrintName = "Factory - Metal"
ENT.Author = ""
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Nutscript - Factories"
ENT.AutomaticFrameAdvance = true

ENT.model = "models/props_junk/wood_crate002a.mdl"

ENT.process = {
	[1] = {
		name = "Sheet Metal",
		required = {
			["mat_metal_raw"] = 1,
		},
		results = {
			["mat_metal"] = 1,
		},
		time = 60,
	},
}