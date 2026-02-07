local PLUGIN = PLUGIN
//
local HISTORY = {}
HISTORY.uid = "exlegion" 
HISTORY.name = "Ex-Military"
HISTORY.desc = "At one point, you fought for a cause. Now you've left that life, but your training yet remains.\n+1 Strength.\nYou are not required to roleplay this background if you select it."
HISTORY.category = "History"

HISTORY.func = function(client, character)
	character:setData("history", HISTORY.uid)
	
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
HISTORY.uid = "bos_exile" 
HISTORY.name = "Former Prospector"
HISTORY.desc = "You scoured the wastes in search of goods and salvage, and you've trained your eye to spot trouble before it spots you.\n+1 Perception.\nYou are not required to roleplay this background if you select it."
HISTORY.category = "History"
--[[
HISTORY.items = {
	["bosholotags"] = 1,
}
--]]
HISTORY.func = function(client, character)
	character:setData("history", HISTORY.uid)

	character:updateAttrib("per", 1)
end
HISTORIES:Register(HISTORY)

//
local HISTORY = {}
HISTORY.uid = "tribal" 
HISTORY.name = "Tribal"
HISTORY.desc = "You once belonged to a tribe, upholding customs and tradition. Although you are no longer with them, their beliefs still guide you.\n+1 Endurance.\nYou are not required to roleplay this background if you select it."
HISTORY.category = "History"
--[[
HISTORY.items = {
	["healing power"] = 2,
}
--]]
HISTORY.func = function(client, character)
	character:setData("history", HISTORY.uid)

	character:updateAttrib("end", 1)
end
HISTORIES:Register(HISTORY)

//
local HISTORY = {}
HISTORY.uid = "caravan" 
HISTORY.name = "Former Merchant"
HISTORY.desc = "You know how to make a deal, a sharp tongue and quick wit have helped you trade and run caravans in the past.\n+1 Charisma.\nYou are not required to roleplay this background if you select it."
HISTORY.category = "History"
HISTORY.func = function(client, character)
	character:setData("history", HISTORY.uid)

	character:updateAttrib("cha", 1)
	character:giveMoney(50)
end
HISTORIES:Register(HISTORY)

//
local HISTORY = {}
HISTORY.uid = "doctor" 
HISTORY.name = "Medic"
HISTORY.desc = "You've spent a long time learning how to patch people up and keep them in one piece.\n+1 Intelligence.\nYou are not required to roleplay this background if you select it."
HISTORY.category = "History"
--[[
HISTORY.items = {
	["stimpak"] = 2,
}
--]]
HISTORY.func = function(client, character)
	character:setData("history", HISTORY.uid)

	character:updateAttrib("int", 1)
end
HISTORIES:Register(HISTORY)

//
local HISTORY = {}
HISTORY.uid = "exncr" 
HISTORY.name = "Former Courier"
HISTORY.desc = "You once held the job of delivering through the wastes, and have learned how to move and avoid danger.\n+1 Agility.\nYou are not required to roleplay this background if you select it."
HISTORY.category = "History"
--[[
HISTORY.items = {
	["ncrdogtag"] = 1,
}
--]]
HISTORY.func = function(client, character)
	character:setData("history", HISTORY.uid)

	character:updateAttrib("agi", 1)
end

HISTORIES:Register(HISTORY)
//
local HISTORY = {}
HISTORY.uid = "exraider" 
HISTORY.name = "Ex-Raider"
HISTORY.desc = "Despite being high out of your mind, or just sick on the head, you've survived through brutality and chance.\n+1 Luck.\nYou are not required to roleplay this background if you select it."
HISTORY.category = "History"
--[[
HISTORY.items = {
	["drug_jet"] = 1,
	["drug_psycho"] = 1,
}
--]]
HISTORY.func = function(client, character)
	character:setData("history", HISTORY.uid)

	character:updateAttrib("luck", 1)
end
HISTORIES:Register(HISTORY)