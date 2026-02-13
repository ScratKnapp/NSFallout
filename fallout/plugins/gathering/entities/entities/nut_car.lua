ENT.Type = "anim"
ENT.Base = "nut_gathering"
ENT.PrintName = "Car"
ENT.Author = "" --Weird modifications by chancer
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Gathering"

ENT.xpGain = 0.25

ENT.Name = "Car"

ENT.plant = true

ENT.models = {
	"models/props_vehicles/car002b_physics.mdl",
	--"models/props_fallout/car02.mdl",
	--"models/props_fallout/car03a.mdl",
	--"models/props_fallout/flea.mdl",
	--"models/props_fallout/postnukecorvega.mdl",
}

ENT.resources = {
	["steel"] = 15,
	["lead"] = 10,
	["oil"] = 5,
	["rubber"] = 5,
	["adhesive"] = 5,
	["j_torquerod"] = 4,
	["j_tubeflange"] = 4,
	["j_connectingrod"] = 2,
	["j_coolantcap"] = 1,
	["j_aluminumcan"] = 1,
	["j_camera"] = 1,
	["j_lightbulb"] = 1,
	["j_oilcan"] = 1,
	["j_phone"] = 1
	
}

ENT.gatherAmt = {7,9}
ENT.unfreezeOnSpawn = true
ENT.spawnAdjustUp = 10

if (SERVER) then
	function ENT:OnTakeDamage( dmginfo )

	end	
end
