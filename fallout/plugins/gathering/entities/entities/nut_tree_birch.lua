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
	"models/maxib123/deadtree01.mdl",
	"models/maxib123/deadtree02.mdl",
	"models/fallout/landscape/trees/treedead01.mdl",
	"models/fallout/landscape/trees/treedead02.mdl",
	"models/fallout/landscape/trees/treedead03.mdl",
	"models/fallout/landscape/trees/treedead04.mdl",
	"models/fallout/landscape/trees/treedead05.mdl",
	"models/fallout/landscape/trees/treestump01.mdl",

}

ENT.resources = {
	["wood"] = 6,
}

ENT.gatherAmt = {4,5}

if (SERVER) then
end
