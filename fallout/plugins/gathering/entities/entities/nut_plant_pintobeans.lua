ENT.Type = "anim"
ENT.Base = "nut_gathering"
ENT.PrintName = "Pinto Bean Plant"
ENT.Author = ""
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Gathering - Herbs"

ENT.xpGain = 0.25

ENT.plant = true

ENT.growthTime = 1200

ENT.models = {
	"models/mosi/fnv/props/plants/pinto.mdl"
}

ENT.resources = {
	["food_pintobeans"] = 3,
	["seed_pintobeans"] = 2
}

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.gatherAmt = {3,5}
ENT.collisionGroup = COLLISION_GROUP_DEBRIS

if (SERVER) then
end
