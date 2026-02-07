ENT.Type = "anim"
ENT.Base = "nut_gathering"
ENT.PrintName = "Iron Vein"
ENT.Author = "" --Weird modifications by chancer
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Gathering"

ENT.xpGain = 0.5

ENT.Name = "Iron Vein"

ENT.plant = true

ENT.models = {
	"models/props_wasteland/rockcliff01b.mdl",
	"models/props_wasteland/rockcliff01c.mdl",
	"models/props_wasteland/rockcliff01f.mdl",
	"models/props_wasteland/rockcliff01j.mdl",
	"models/props_wasteland/rockcliff01k.mdl",
}

ENT.resources = {
	["mana_core_1"] = 1,
	["gem_agate"] = 1,
	["ore_coal"] = 5,
	["ore_iron"] = 50,
	["ore_rock"] = 25
}

ENT.gatherAmt = {7,9}
ENT.spawnAdjustUp = -10

if (SERVER) then
	function ENT:OnTakeDamage( dmginfo )

	end	
end
