ENT.Type = "anim"
ENT.Base = "nut_gathering"
ENT.PrintName = "Gourd Plant"
ENT.Author = ""
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Gathering - Herbs"

ENT.xpGain = 0.25

ENT.plant = true

ENT.growthTime = 1200

ENT.models = {
	"models/mosi/fnv/props/plants/buffalogourd.mdl"
}

ENT.resources = {
	["food_gourd"] = 3,
	["seed_gourd"] = 2
}

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.gatherAmt = {3,5}
ENT.collisionGroup = COLLISION_GROUP_DEBRIS

if (SERVER) then
end
