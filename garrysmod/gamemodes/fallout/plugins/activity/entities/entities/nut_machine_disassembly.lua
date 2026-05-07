ENT.Type = "anim"
ENT.Base = "nut_factory_base"
ENT.PrintName = "Machine - Disassembly Station"
ENT.Author = ""
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Nutscript - Factories"
ENT.AutomaticFrameAdvance = true

ENT.model = "models/mosi/fallout4/furniture/workstations/workshopbench.mdl"
--ENT.material = "phoenix_storms/OfficeWindow_1-1"

ENT.displayName = "Disassembly Station"

ENT.process = {
	[1] = {
		name = "Create Ripped Cybernetics",
		required = {
			["salvaged_cybernetics"] = 1,
		},
		results = {
			["ripped_cybernetics"] = 1,
		},
		time = 1,
	},
}