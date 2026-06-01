ITEM.name = "Med-X"
ITEM.desc = "A hypodermic needle filled of a brand of morphine that reduces the perception of and emotional response to pain."
ITEM.model = "models/mosi/fallout4/props/aid/medx.mdl"
ITEM.uniqueID = "drug_medx"
ITEM.quantity2 = 1
ITEM.price = 0
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Drugs"
 
ITEM.stomach = false
 
ITEM.permit = "permit_drug"
 
ITEM.duration = 1800
 
ITEM.buffTbl = {
	res = {
    ["Energy"] = 25,
	["Kinetic"] = 25,
    },
}

ITEM.effect = {
	colorMod = {
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = 0,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = 0,
		["$pp_colour_contrast"] = 1,
		["$pp_colour_colour"] = 1.5,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0
	},
	
	duration = 60,
}

function ITEM:onEntityCreated(entity)
	entity:SetSubMaterial(0, "phoenix_storms/ps_grass")
end