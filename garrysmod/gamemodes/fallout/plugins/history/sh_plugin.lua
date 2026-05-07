PLUGIN.name = "History Selection"
PLUGIN.author = "Chancer"
PLUGIN.desc = "History selection in character creation."

--only factions listed here will be able to choose a history
PLUGIN.factions = {
	[FACTION_WASTE or -1] = true
}

HISTORIES = {}
HISTORIES.histories = {}
function HISTORIES:Register(tbl)
	self.histories[tbl.uid] = tbl
end

function HISTORIES:GetAll()
	return self.histories
end

function HISTORIES:hasHistory(char, history)
	local charHist = char:getData("history")
	if(charHist) then
		if(charHist == history) then
			return true
		end
	end
	
	return false
end

function HISTORIES:historyFromName(name)
	local histories = HISTORIES.histories
	
	if(histories[name]) then
		return name
	end
	
	local name = string.lower(name)
	
	local history
	for k, v in pairs(histories) do
		if(string.lower(v.name) == string.lower(name)) then --exact name
			history = k
			break	
		elseif(string.find(string.lower(v.name), string.lower(name))) then --partial name
			history = k
		end
	end
	
	return history
end

local playerMeta = FindMetaTable("Player")

function playerMeta:getHistory()
	local char = self:getChar()
	
	if(char) then
		return char:getData("history", "none")
	end
end

if (SERVER) then
	function playerMeta:setHistory(history)
		local char = self:getChar()
		local history = HISTORIES.histories[history]
		
		if(char and history) then
			char:setData("history", history.uid)
			
			return true
		end
		
		return false
	end

	function PLUGIN:OnCharCreated(client, character)
		timer.Simple(0.5, function()
			local traitData = character:getData("history", {})
			local items = {}
			
			local dumbIt = 0.5
		
			for k, v in pairs(traitData) do
				local items = HISTORIES.histories[k].items
				if(items) then
					for k, v in pairs(items) do
						table.insert(items, v)
					end
				end
				
				dumbIt = dumbIt + 1
				timer.Simple(dumbIt, function()
					if(HISTORIES.histories[k].func) then
						HISTORIES.histories[k].func(client, character)
					end
				end)
			end
			
			for k, v in pairs(items) do
				dumbIt = dumbIt + 2
				timer.Simple(dumbIt, function()
					character:getInv():addSmart(v)
				end)
			end
		end)
	end
end

nut.util.include("sh_history.lua")

nut.command.add("charsethistory", {
	adminOnly = true,
	syntax = "<string target> <string history>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("Specify a target.")
			return false
		end	
		
		if(!arguments[2]) then
			client:notify("Specify a history.")
			return false
		end	
	
		local target = nut.command.findPlayer(client, arguments[1])	
		if(target) then
			local history = HISTORIES:historyFromName(arguments[2])
		
			if(history) then
				target:setHistory(history)
				
				client:notify(target:Name().. "'s History set to " ..HISTORIES.histories[history].name.. ".")
			else
				client:notify("Invalid history.")
			end
		end
	end
})

nut.command.add("chargethistory", {
	adminOnly = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("Specify a target.")
			return false
		end
	
		local target = nut.command.findPlayer(client, arguments[1])	
		if(target) then
			local history = target:getHistory()
			
			client:notify(target:Name().. "'s History is " ..HISTORIES.histories[history].name.. ".")
		end
	end
})

--adds the traitstep gui to the char creation menu
if(CLIENT) then
	function PLUGIN:ConfigureCharacterCreationSteps(panel)
		panel:addStep(vgui.Create("nutCharHistory"), 2)
	end
end