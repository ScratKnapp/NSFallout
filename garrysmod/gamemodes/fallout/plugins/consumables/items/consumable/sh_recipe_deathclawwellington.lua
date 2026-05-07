ITEM.name = "Deathclaw Wellington"
ITEM.desc = "A filet of Deathclaw encased in a layer of ground and pasted, salted pinyon nuts, and a second layer of bread around it. Considered a luxury meal."
ITEM.uniqueID = "food_deathclawwellington"
ITEM.model = "models/foodnhouseholditems/bread-2.mdl"
ITEM.quantity2 = 1
ITEM.price = 5
ITEM.width = 1
ITEM.height = 1

ITEM.permit = "permit_food"

ITEM.hp = 10
ITEM.tags = {
	["Recipe"] = true,
}
ITEM.durationB = 1800 --attribute buff duration

ITEM.buffTbl = {
    attrib = {
		["str"] = 1,
		["end"] = 1,
		["cha"] = 1,
    },
    res = {
		["Energy"] = 10,
		["Kinetic"] = 10,
    },  
	amp = {
		["Energy"] = 10,
		["Kinetic"] = 10,
    },
}