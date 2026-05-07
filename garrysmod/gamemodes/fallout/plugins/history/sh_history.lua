local PLUGIN = PLUGIN
//
local HISTORY = {}
HISTORY.uid = "military" 
HISTORY.name = "Ex-Military"
HISTORY.desc = "At one point, you fought for a cause. Now you've left that life, but your training yet remains.\n+1 Strength, +4 Athletics.\nYou are not required to roleplay this background if you select it."
HISTORY.category = "History"

HISTORY.func = function(client, character)
	character:setData("history", HISTORY.uid)
	character:updateSkill("explosives", 5)
	character:updateAttrib("str", 1)
end
--[[
HISTORY.items = {
	["legionmoney"] = 3,
}
--]]
HISTORIES:Register(HISTORY)

//
local HISTORY = {}
HISTORY.uid = "prospector" 
HISTORY.name = "Prospector"
HISTORY.desc = "You scoured the wastes in search of goods and salvage, and you've trained your eye to spot trouble before it spots you.\n+1 Perception, +4 Sneak.\nYou are not required to roleplay this background if you select it."
HISTORY.category = "History"
--[[
HISTORY.items = {
	["bosholotags"] = 1,
}
--]]
HISTORY.func = function(client, character)
	character:setData("history", HISTORY.uid)
	character:updateSkill("sneak", 10)
	character:updateAttrib("per", 1)
end
HISTORIES:Register(HISTORY)

//
local HISTORY = {}
HISTORY.uid = "tribal" 
HISTORY.name = "Tribal"
HISTORY.desc = "You once belonged to a tribe, upholding customs and tradition. Although you are no longer with them, their beliefs still guide you.\n+1 Endurance, +2 Throwing.\nYou are not required to roleplay this background if you select it."
HISTORY.category = "History"
--[[
HISTORY.items = {
	["healing power"] = 2,
}
--]]
HISTORY.func = function(client, character)
	character:setData("history", HISTORY.uid)
	character:updateSkill("throwing", 5)
	character:updateAttrib("end", 1)
end
HISTORIES:Register(HISTORY)

//
local HISTORY = {}
HISTORY.uid = "caravan" 
HISTORY.name = "Former Merchant"
HISTORY.desc = "You know how to make a deal, a sharp tongue and quick wit have helped you trade and run caravans in the past.\n+1 Charisma, +4 Speech.\nYou are not required to roleplay this background if you select it."
HISTORY.category = "History"
HISTORY.func = function(client, character)
	character:setData("history", HISTORY.uid)
	character:updateSkill("speech", 10)
	character:updateAttrib("cha", 1)
	character:giveMoney(50)
end
HISTORIES:Register(HISTORY)

//
local HISTORY = {}
HISTORY.uid = "doctor" 
HISTORY.name = "Medic"
HISTORY.desc = "You've spent a long time learning how to patch people up and keep them in one piece.\n+1 Intelligence, +4 Medicine.\nYou are not required to roleplay this background if you select it."
HISTORY.category = "History"
--[[
HISTORY.items = {
	["stimpak"] = 2,
}
--]]
HISTORY.func = function(client, character)
	character:setData("history", HISTORY.uid)
	character:updateSkill("medicine", 10)
	character:updateAttrib("int", 1)
end
HISTORIES:Register(HISTORY)

//
local HISTORY = {}
HISTORY.uid = "exncr" 
HISTORY.name = "Former Courier"
HISTORY.desc = "You once held the job of delivering through the wastes, and have learned how to move and avoid danger.\n+1 Agility, +2 Evasion.\nYou are not required to roleplay this background if you select it."
HISTORY.category = "History"
--[[
HISTORY.items = {
	["ncrdogtag"] = 1,
}
--]]
HISTORY.func = function(client, character)
	character:setData("history", HISTORY.uid)
	character:updateSkill("athletics", 10)
	character:updateAttrib("agi", 1)
end

HISTORIES:Register(HISTORY)
//
local HISTORY = {}
HISTORY.uid = "exraider" 
HISTORY.name = "Ex-Raider"
HISTORY.desc = "Despite being high out of your mind, or just sick on the head, you've survived through brutality and chance.\n+1 Luck, +4 Lockpicking.\nYou are not required to roleplay this background if you select it."
HISTORY.category = "History"
--[[
HISTORY.items = {
	["drug_jet"] = 1,
	["drug_psycho"] = 1,
}
--]]
HISTORY.func = function(client, character)
	character:setData("history", HISTORY.uid)
	character:updateSkill("lockpicking", 10)
	character:updateAttrib("luck", 1)
end
HISTORIES:Register(HISTORY)

//

local HISTORY = {}
HISTORY.uid = "gunsmithhistory" 
HISTORY.name = "CRAFTER: Armorer"
HISTORY.desc = "You learned complex machining, metalworking, and woodworking to maintain and build weapons, armor, and ammunition.\nGives +20 Repair.\nYou are not required to roleplay this background if you select it."
HISTORY.category = "History"
--[[
HISTORY.items = {
	["drug_jet"] = 1,
	["drug_psycho"] = 1,
}
--]]
HISTORY.func = function(client, character)
	character:setData("history", HISTORY.uid)
    client:giveTrait("gunsmith")
	character:updateSkill("repair", 25)
end
HISTORIES:Register(HISTORY)

//
local HISTORY = {}
HISTORY.uid = "scientisthistory" 
HISTORY.name = "CRAFTER: Scientist"
HISTORY.desc = "You worked under a post-war organization that valued chemistry, engineering, and mathematics.\nGives +20 Science.\nYou are not required to roleplay this background if you select it."
HISTORY.category = "History"
--[[
HISTORY.items = {
	["drug_jet"] = 1,
	["drug_psycho"] = 1,
}
--]]
HISTORY.func = function(client, character)
	character:setData("history", HISTORY.uid)
    client:giveTrait("science")
	character:updateSkill("science", 25)
end
HISTORIES:Register(HISTORY)

//
local HISTORY = {}
HISTORY.uid = "chefhistory" 
HISTORY.name = "CRAFTER: Chef"
HISTORY.desc = "You hold an expertise in dealing with all of the strange and irradiated food of the wasteland.\nGives +20 Survival.\nYou are not required to roleplay this background if you select it."
HISTORY.category = "History"
--[[
HISTORY.items = {
	["drug_jet"] = 1,
	["drug_psycho"] = 1,
}
--]]
HISTORY.func = function(client, character)
	character:setData("history", HISTORY.uid)
    client:giveTrait("chef")
	character:updateSkill("survival", 25)
end
HISTORIES:Register(HISTORY)