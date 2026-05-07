ENT.Type = "anim"
ENT.Base = "nut_factory_base"
ENT.PrintName = "Machine - Cybernetic Recycler"
ENT.Author = ""
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Nutscript - Factories"
ENT.AutomaticFrameAdvance = true

ENT.model = "models/nt/props_tech/techcartbox1.mdl"
--ENT.material = "phoenix_storms/OfficeWindow_1-1"

ENT.displayName = "Cybernetic Recycler"

ENT.process = {
	[1] = {
		name = "Recycle Cybernetics",
		required = {
			["ripped_cybernetics"] = 1,
		},
		results = {
			["coin_5"] = 1,
		},
		time = 1,
	},
}