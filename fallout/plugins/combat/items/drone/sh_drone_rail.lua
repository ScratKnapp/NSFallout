ITEM.name = "Rail Rifle Drone (Rails)"
ITEM.desc = "A strange drone that fires bolts of metal at high velocity."
ITEM.uniqueID = "drone_rail"
ITEM.model = "models/props_junk/cardboard_box003a.mdl"

ITEM.combat = true

ITEM.ent = "dronesrewrite_rgundr"
ITEM.modelEnt = "models/dronesrewrite/railgundr/railgundr.mdl"
ITEM.hpMax = 400
ITEM.dmg = 100
ITEM.dmgT = "Blunt"
ITEM.attribs = {
	["reflexes"] = 10,
	["aim"] = 50,
}
ITEM.armor = {
	["Head"] = 300,
	["Torso"] = 300,
	["Left Arm"] = 300,
	["Right Arm"] = 300,
	["Left Leg"] = 300,
	["Right Leg"] = 300,
}

ITEM.techReq = 40

ITEM.price = 1000000
ITEM.permit = "permit_drone"