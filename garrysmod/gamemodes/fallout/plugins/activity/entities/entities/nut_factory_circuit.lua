ENT.Type = "anim"
ENT.Base = "nut_factory_base"
ENT.PrintName = "Factory - Circuitry"
ENT.Author = ""
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Nutscript - Factories"
ENT.AutomaticFrameAdvance = true

ENT.model = "models/props_junk/wood_crate002a.mdl"

ENT.process = {
	[1] = {
		name = "Circuitry",
		required = {
			["mat_metal_precious"] = 1,
		},
		results = {
			["mat_circuitry"] = 1,
		},
		time = 120,
	},
	[2] = {
		name = "Circuit Board",
		required = {
			["mat_circuitry"] = 1,
			["mat_microchip"] = 1,
		},
		results = {
			["mat_circuit_board"] = 1,
		},
		time = 60,
	},
}