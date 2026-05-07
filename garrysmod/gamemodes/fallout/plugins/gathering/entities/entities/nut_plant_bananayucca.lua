ENT.Type = "anim"
ENT.Base = "nut_gathering"
ENT.PrintName = "Banana Yucca Plant"
ENT.Author = ""
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Gathering - Herbs"

ENT.xpGain = 0.25

ENT.plant = true

ENT.growthTime = 1200

ENT.models = {
	"models/mosi/fnv/props/plants/bananayucca.mdl"
}

ENT.resources = {
	["food_bananayucca"] = 3,
	["seed_bananayucca"] = 1
}

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.gatherAmt = {3,5}
ENT.collisionGroup = COLLISION_GROUP_DEBRIS

if (SERVER) then
end
