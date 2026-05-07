ITEM.name = "Medical Drone"
ITEM.desc = "A drone that can perform first aid and on-site surgery."
ITEM.uniqueID = "drone_healing"
ITEM.model = "models/props_junk/cardboard_box003a.mdl"

ITEM.combat = true

ITEM.ent = "dronesrewrite_scout"
ITEM.modelEnt = "models/dronesrewrite/scout/scout.mdl"
ITEM.hpMax = 200
ITEM.dmg = 0
ITEM.dmgT = "Blunt"
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

ITEM.spells = {
	"drone_heal",
}

ITEM.techReq = 70

ITEM.price = 25000
--ITEM.permit = "permit_drone"