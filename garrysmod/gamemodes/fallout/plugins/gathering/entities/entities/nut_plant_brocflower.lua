ENT.Type = "anim"
ENT.Base = "nut_gathering"
ENT.PrintName = "Broc Flower Plant"
ENT.Author = ""
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Gathering - Herbs"

ENT.xpGain = 0.25

ENT.plant = true

ENT.growthTime = 1200

ENT.models = {
	"models/mosi/fnv/props/plants/brocflower.mdl"
}

ENT.resources = {
	["food_brocflower"] = 3,
	["seed_brocflower"] = 1
}

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.gatherAmt = {3,5}
ENT.collisionGroup = COLLISION_GROUP_DEBRIS

if (SERVER) then
end
