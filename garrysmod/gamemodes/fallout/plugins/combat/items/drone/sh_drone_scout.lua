ITEM.name = "Scout Drone (9mm)"
ITEM.desc = "A military-grade drone equipped with a 9mm firearm."
ITEM.uniqueID = "drone_scout"
ITEM.model = "models/props_junk/cardboard_box003a.mdl"

ITEM.combat = true

ITEM.ent = "dronesrewrite_scout"
ITEM.modelEnt = "models/dronesrewrite/scout/scout.mdl"
ITEM.hpMax = 200
ITEM.dmg = 20
ITEM.dmgT = "9mm"
ITEM.attribs = {
	["reflexes"] = 30,
	["aim"] = 40,
}
ITEM.armor = {
	["Head"] = 300,
	["Torso"] = 300,
	["Left Arm"] = 300,
	["Right Arm"] = 300,
	["Left Leg"] = 300,
	["Right Leg"] = 300,
}

ITEM.techReq = 25

ITEM.price = 2500
ITEM.permit = "permit_drone"