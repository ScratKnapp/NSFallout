ITEM.name = "Bloodberry"
ITEM.desc = "A blood red berry, it carries the smell of fresh blood."
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.material = "models/XQM/WoodPlankTexture"
ITEM.uniqueID = "herb_bloodberry"

ITEM.iconCam = {
	pos = Vector(-200, 0, 0),
	ang = Angle(0, -0, 0),
	fov = 2.75,
}

ITEM.tags = {
	["Ingredient"] = true,
	["Alchemical"] = true,
	["Herb"] = true,
}

ITEM.craft = {
	buffTbl = {
		attrib = {
			["str"] = 0.5,
			["end"] = 0.5,
			["vitality"] = 1,
		},
	},
}