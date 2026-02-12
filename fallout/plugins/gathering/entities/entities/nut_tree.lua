ENT.Type = "anim"
ENT.Base = "nut_gathering"
ENT.PrintName = "Dead Tree"
ENT.Author = ""
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Gathering"

ENT.xpGain = 0.25

ENT.plant = true

ENT.models = {
	"models/fallout3/landscape/treewastelandhardwoodstump01.mdl",
}

ENT.resources = {
	["wood"] = 6,
}

ENT.gatherAmt = {4,5}

if (SERVER) then
end
