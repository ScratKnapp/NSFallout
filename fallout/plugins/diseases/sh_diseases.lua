local PLUGIN = PLUGIN
//
--[[
local DISEASE = {}
DISEASE.uid = "dis_"
DISEASE.name = "Disease" --shows up in diagnosis and used for giving it to people
DISEASE.desc = "You have a disease." --shows up in diagnosis
DISEASE.category = "Mental" --doesn't really do anything
DISEASE.random = 0.01 --chance that someone catches the disease randomly
DISEASE.think = 3600
DISEASE.duration = 10800

DISEASE.infect = { --chance that someone catches the disease randomly
	spreadRange = 500,
	spreadChance = 1,
} 

DISEASE.buffScale = { --buffs attributes by a multiplier
	["attrib1"] = 0.5,
	["attrib2"] = 1.1,
}

DISEASE.buff = { --buffs attributes by addition/subtraction
	["attrib1"] = 10,
	["attrib2"] = -10,
}

DISEASE.symptoms = { --prints that happen periodically when you have it
	{ --tables are checked differently and can do more things
		text = "", --text that prints in chat when symptom happens
		
		func = function(client) --function that runs when symptom happens
		
		end,
		
		cd = 3600, --how long this delays the next symptom print
	},
}

DISEASE.catch = { --when they catch it
	"",
	{ --tables are check differently and can do more things
		text = "",
		
		func = function(client)
		
		end,
	},
}

DISEASE.cure = { --when it goes away
	"",
	{ --tables are check differently and can do more things
		text = "",
		
		func = function(client)
		
		end,
	},
}
--]]

--example cold
local DISEASE = {}
DISEASE.uid = "dis_cold"
DISEASE.name = "Cold"
DISEASE.desc = "An ordinary cold, causes you to feel bad. Can be spread to others."
DISEASE.category = "Illness"
--DISEASE.random = true
DISEASE.duration = 32768 --around 9 hours
DISEASE.infect = { --chance that someone catches the disease randomly
	spreadRange = 600,
	spreadChance = 50,
} 

DISEASE.symptoms = {
	{ 
		text = {
			"Your throat hurts.",
			"Your nose is runny.",
			"Your nose is stuffed.",
			"You have a headache.",
			"You feel feverish.",
			"You feel unwell.",
		},
		
		func = function(client)
			if(math.random(0,1) == 1) then
				nut.chat.send(client, "me", "coughs.")
				client:EmitSound("ambient/voices/cough" ..math.random(1,4).. ".wav", 75, math.random(90,110))
			else
				nut.chat.send(client, "me", "sniffles.")
			end
		end,
		cd = 1800,
	},
}
DISEASE.cure = {
	"You recover from your cold."
}
DISEASES:Register(DISEASE)