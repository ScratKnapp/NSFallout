ITEM.name = "Basic Drone (9mm)"
ITEM.desc = "A normal drone equipped with a 9mm firearm."
ITEM.uniqueID = "drone_basic_gun"
ITEM.model = "models/props_junk/cardboard_box003a.mdl"

ITEM.combat = true

ITEM.ent = "dronesrewrite_ardrone"
ITEM.modelEnt = "models/dronesrewrite/ardrone/ardrone.mdl"
ITEM.hpMax = 30
ITEM.dmg = 10
ITEM.dmgT = "9mm"
ITEM.attribs = {
	["reflexes"] = 15,
	["aim"] = 10,
}
ITEM.armor = {
	["Head"] = 20,
	["Torso"] = 20,
	["Left Arm"] = 20,
	["Right Arm"] = 20,
	["Left Leg"] = 20,
	["Right Leg"] = 20,
}

ITEM.techReq = 5

ITEM.price = 1000
ITEM.permit = "permit_drone"