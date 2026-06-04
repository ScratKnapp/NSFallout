ENT.Type = "anim"
ENT.Base = "nut_gathering"
ENT.PrintName = "Xander Root Plant"
ENT.Author = ""
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Gathering - Herbs"

ENT.xpGain = 0.25

ENT.plant = true

ENT.growthTime = 1200

ENT.models = {
	"models/mosi/fnv/props/plants/xanderroot01.mdl"
}

ENT.resources = {
	["plant_xanderroot"] = 2,
	["seed_xanderroot"] = 1
}

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.gatherAmt = {3,5}
ENT.collisionGroup = COLLISION_GROUP_DEBRIS

if (SERVER) then
end
