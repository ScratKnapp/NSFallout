ITEM.name = "Warrior Drone (7.62×51mm)"
ITEM.desc = "A military-grade drone equipped with twin miniguns."
ITEM.uniqueID = "drone_warrior"
ITEM.model = "models/props_junk/cardboard_box003a.mdl"

ITEM.combat = true

ITEM.ent = "dronesrewrite_warriordr"
ITEM.modelEnt = "models/dronesrewrite/warriordr/warriordr.mdl"
ITEM.hpMax = 500
ITEM.dmg = 50
ITEM.dmgT = "7.62×51mm"
ITEM.attribs = {
	["reflexes"] = 20,
	["aim"] = 60,
}
ITEM.armor = {
	["Head"] = 500,
	["Torso"] = 500,
	["Left Arm"] = 500,
	["Right Arm"] = 500,
	["Left Leg"] = 500,
	["Right Leg"] = 500,
}

ITEM.techReq = 75

ITEM.price = 100000
ITEM.permit = "permit_drone"