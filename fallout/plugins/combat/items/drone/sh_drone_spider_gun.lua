ITEM.name = "Spider Drone (9mm)"
ITEM.desc = "A small drone that can walk on most surfaces, good for reconnaissance. This one is equipped with a 9mm pistol."
ITEM.uniqueID = "drone_spider_gun"
ITEM.model = "models/props_junk/cardboard_box003a.mdl"

ITEM.combat = true

ITEM.ent = "dronesrewrite_spyspider"
ITEM.modelEnt = "models/dronesrewrite/spider/spider.mdl"
ITEM.hpMax = 20
ITEM.dmg = 10
ITEM.dmgT = "9mm"
ITEM.attribs = {
	["reflexes"] = 5,
	["aim"] = 5,
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