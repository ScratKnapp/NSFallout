ATTRIBUTE.name = "Strength"
ATTRIBUTE.desc = "Raw physical strength. A variable of how hard you hit with melee, or how much you can lift/carry.\nAffects weight of weapon that can be equipped\n+1 HP PER POINT\nAdds 0.25 to STR skills per point"
ATTRIBUTE.maxValue = 10

--gives skill points based on this value times the amount of special points
ATTRIBUTE.skillBonus = {
	["str"] = 0.25,
}