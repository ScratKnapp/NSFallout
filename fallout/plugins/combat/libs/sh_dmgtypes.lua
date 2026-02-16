local PLUGIN = PLUGIN

PLUGIN.dmgTypes = {
	--guns
		["Nails"] = {
		name = "Nails",
		armor = 0.95,
		kinetic = true,
	},
	
		["BB"] = {
		name = "BB",
		armor = 0.95,
		kinetic = true,
	},
	
	[".22LR"] = {
		name = "22LR Damage",
		armor = 0.95,
		kinetic = true,
	},
	
	[".22LR HP"]= {
		name = ".22LR Hollow Point",
		armor = 1.15,		
		special = "HP",
		kinetic = true,
	},
	
	[".32"] = {
		name = ".32",
		armor = 0.95,
		kinetic = true,
	},
	
	[".32 HP"] = {
		name = ".32 Hollow Point",
		armor = 1.15,	
		special = "HP",		
		kinetic = true,
	},

	
	[".38"] = {
		name = ".38",
		armor = 0.95,
		kinetic = true,
	},
	
	[".38 HP"] = {
		name = ".38 Hollow Point",
		armor = 1.15,
		special = "HP",
		kinetic = true,
	},
	
	[".308"] = {
		name = ".308",
		armor = 0.95,
		kinetic = true,
	},
	
	[".308 HP"] = {
		name = ".308 Hollow Point",
		armor = 1.15,		
		special = "HP",
		kinetic = true,
	},
	
	[".308 AP"] = {
		name = ".308 AP",
		armor = 0.7,
		special = "AP",
		kinetic = true,
	},
	
	[".357 Magnum"] = {
		name = ".357 Magnum",
		armor = 0.95,
		kinetic = true,
	},
	
	[".357 Magnum HP"] = {
		name = ".357 Hollow Point",
		armor = 1.15,		
		special = "HP",
		kinetic = true,
	},

	[".44 Magnum"] = {
		name = ".44 Magnum",
		armor = 0.95,
		kinetic = true,
	},
	
	[".44 Magnum HP"] = {
		name = ".44 Hollow Point",
		armor = 1.15,		
		special = "HP",
		kinetic = true,
	},
	
	[".44 Magnum SWC"] = {
		name = ".44 SWC",
		armor = 0.85,
		special = "SWC",
		kinetic = true,
	},
	
	[".45 Auto"] = {
		name = ".45 Auto",
		armor = 0.95,
		kinetic = true,
	},
	[".45 Auto HP"] = {
		name = ".45 Hollow Point",
		armor = 1.15,		
		special = "HP",
		kinetic = true,
	},
	[".45 Auto +P"] = {
		name = ".45 +P",
		armor = 0.85,
		special = "+P",
		kinetic = true,
	},
	
	[".45-70 Gov't"] = {
		name = ".45-70 Gov't",
		armor = 0.95,
		kinetic = true,
	},
	[".45-70 Gov't HP"] = {
		name = ".45-70 Gov't HP",
		armor = 1.15,		
		special = "HP",
		kinetic = true,
	},
	[".45-70 Gov't SWC"] = {
		name = ".45-70 Gov't SWC",
		armor = 0.75,
		special = "SWC",
		kinetic = true,
	},		
	
	[".50 MG"] = {
		name = ".50 MG",
		armor = 0.65,
		kinetic = true,
	},
	[".50 MG Explosive"] = {
		name = ".50 MG Explosive",
		armor = 0.65,
		special = "Explosive",
		kinetic = true,
	},
	[".50 MG AP"] = {
		name = ".50 MG AP",
		armor = 0.1,
		special = "AP",
		kinetic = true,
	},
	[".50 MG Incendiary"] = {
		name = ".50 MG Incendiary",
		armor = 0.65,
		special = "Incendiary",
		kinetic = true,
	},

	["5mm"] = {
		name = "5mm",
		armor = 0.65,
		kinetic = true,
	},
	["5mm AP"] = {
		name = "5mm AP",
		armor = 0.35,
		special = "AP",
		kinetic = true,
	},
	["5mm HP"] = {
		name = "5mm HP",
		armor = 0.9,		
		special = "HP",
		kinetic = true,
	},
	["5mm Surplus"] = {
		name = "5mm Surplus",
		armor = 0.85,
		special = "Surplus",
		kinetic = true,
	},
	
	["5.56"] = {
		name = "5.56",
		armor = 0.95,
		kinetic = true,
	},
	["5.56 AP"] = {
		name = "5.56 AP",
		armor = 0.6,
		special = "AP",
		kinetic = true,
	},
	["5.56 HP"] = {
		name = "5.56 HP",
		armor = 1.15,		
		special = "HP",
		kinetic = true,
	},
	
	["9mm"] = {
		name = "9mm",
		armor = 0.95,
		kinetic = true,
	},
	["9mm +P"] = {
		name = "9mm +P",
		armor = 0.85,
		special = "+P",
		kinetic = true,
	},
	["9mm HP"] = {
		name = "9mm HP",
		armor = 1.15,		
		special = "HP",
		kinetic = true,
	},
	
	["10mm"] = {
		name = "10mm",
		armor = 0.95,
		kinetic = true,
	},
	["10mm HP"] = {
		name = "10mm HP",
		armor = 1.15,		
		special = "HP",
		kinetic = true,
	},
	
	["12.7mm"] = {
		name = "12.7mm",
		armor = 0.9,
		kinetic = true,
	},
	["12.7mm HP"] = {
		name = "12.7mm HP",
		armor = 1.15,		
		special = "HP",
		kinetic = true,
	},
	
	["12 Gauge"] = {
		name = "12 Gauge",
		armor = 0.9,
		kinetic = true,
	},
	["12 Gauge Flechette"] = {
		name = "12 Gauge Flechette",
		armor = 0.5,
		special = "Flechette",
		kinetic = true,
	},
	["12 Gauge Rubber"] = {
		name = "12 Gauge Rubber",
		armor = 2,
		special = "Rubber",
		kinetic = true,
	},
	["12 Gauge Dragon's Breath"] = {
		name = "12 Gauge Dragon's Breath",
		armor = 0.75,
		special = "Dragon",
		kinetic = true,
	},
	["12 Gauge Explosive"] = {
		name = "12 Gauge Explosive",
		armor = 0.5,
		special = "Explosive",
		kinetic = true,
	},
	
	["20 Gauge"] = {
		name = "20 Gauge",
		armor = 0.9,
		kinetic = true,
	},
	
	["Electron Charge Pack"] = {
		name = "Electron Charge Pack",
		armor = 0.6,
		kinetic = true,
	},
	["Electron Charge Pack Over Charge"] = {
		name = "Electron Charge Pack Over Charge",
		armor = 0.4,
		special = "Overcharge",
		energy = true,
	},
	["Electron Charge Pack Max Charge"] = {
		name = "Electron Charge Pack Max Charge",
		armor = 0.5,
		special = "Maxcharge",
		energy = true,
	},
	["Flamer Fuel"] = {
		name = "Flamer Fuel",
		armor = 0.6,
		energy = true,
	},
	["Energy Cell"] = {
		name = "Energy Cell",
		armor = 0.6,
		energy = true,
	},
	["Energy Cell Over Charge"] = {
		name = "Energy Cell Over Charge",
		armor = 0.4,
		special = "Overcharge",
		energy = true,
	},
	["Energy Cell Max Charge"] = {
		name = "Energy Cell Max Charge",
		armor = 0.5,
		special = "Maxcharge",
		energy = true,
	},
	
	["Microfusion Cell"] = {
		name = "Microfusion Cell",
		armor = 0.6,
		energy = true,
	},
	["Microfusion Cell Over Charge"] = {
		name = "Shell Damage",
		armor = 0.4,
		special = "Overcharge",
		energy = true,
	},
	["Microfusion Cell Max Charge"] = {
		name = "Shell Damage",
		armor = 0.5,
		special = "Maxcharge",
		energy = true,
	},
	
	["40mm Grenade"] = {
		name = "40mm Grenade",
		armor = 0.95,
		kinetic = true,

	},
	["40mm Grenade Incendiary"] = {
		name = "40mm Grenade Incendiary",
		armor = 0.95,
		special = "Incendiary",
		kinetic = true,

	},
	["40mm Grenade Plasma"] = {
		name = "40mm Grenade Plasma",
		armor = 0.5,
		special = "Plasma",
		energy = true,
	},
	
	["Missile"] = {
		name = "Missile",
		armor = 0.95,
		kinetic = true,

	},
	["Missile HE"] = {
		name = "Missile HE",
		armor = 0.95,
		special = "HE",
		kinetic = true,
	},
	
	["2mm EC"] = {
		name = "2mm EC",
		armor = 0.95,
		special = "2mm",
		kinetic = true,
	},
	
	["Slash"] = {
		name = "Slash",
		armor = 0.9,
		kinetic = true,

	},
	["Pierce"] = {
		name = "Pierce",
		armor = 0.8,
		kinetic = true,

	},
	["Blunt"] = {
		name = "Blunt",
		armor = 0.8,
		kinetic = true,
	},
	
	["Sonic"] = {
		name = "Sonic",
		armor = 0.1,
	},
	["Radiation"] = {
		name = "Radiation",
		armor = 0.1,
	},
	["Acid"] = {
		name = "Acid",
		armor = 0.5,
		kinetic = true,
	},
	["Poison"] = {
		name = "Poison",
		armor = 0.1,
	},
	["Venom"] = {
		name = "Venom",
		armor = 0.1,
	},
	
	["Fire"] = {
		name = "Fire",
		armor = 0.5,
		kinetic = true,
	},
	
	["Laser"] = {
		name = "Laser",
		armor = 0.15,
		energy = true,
	},
	["Plasma"] = {
		name = "Plasma",
		armor = 0.1,
		energy = true,
	},
	["Explosion"] = {
		name = "Explosion",
		armor = 1,
		kinetic = true,
	},
}

--checks if things are considered broader types
--such as being "kinetic" or "energy"
--PLUGIN:IsBroadType("9mm", "kinetic")
function PLUGIN:IsBroadType(dmgT, broad)
	local dmgTable = PLUGIN.dmgTypes[dmgT]
	if(dmgTable) then
		if(dmgTable[string.lower(broad)]) then
			return true
		end
	end
	
	return false
end

--function that determines how armor will reduce certain damage types
function PLUGIN:armorReduction(dmgT)
	return ((PLUGIN.dmgTypes[dmgT] and PLUGIN.dmgTypes[dmgT].armor) or 1)
end
