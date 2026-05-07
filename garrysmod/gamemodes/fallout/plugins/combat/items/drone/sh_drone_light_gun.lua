ITEM.name = "Light Drone (10mm)"
ITEM.desc = "A light drone equipped with a 10mm firearm."
ITEM.uniqueID = "drone_light_gun"
ITEM.model = "models/props_junk/cardboard_box003a.mdl"

ITEM.combat = true

ITEM.ent = "dronesrewrite_ardrone2"
ITEM.modelEnt = "models/dronesrewrite/ardrone2/ardrone.mdl"
ITEM.hpMax = 20
ITEM.dmg = 10
ITEM.dmgT = "10mm"
ITEM.attribs = {
	["reflexes"] = 20,
	["aim"] = 10,
}
ITEM.armor = {
	["Head"] = 10,
	["Torso"] = 10,
	["Left Arm"] = 10,
	["Right Arm"] = 10,
	["Left Leg"] = 10,
	["Right Leg"] = 10,
}

ITEM.techReq = 5

ITEM.price = 1000
ITEM.permit = "permit_drone"