local PLUGIN = PLUGIN
PLUGIN.name = "Passive Abilities"
PLUGIN.author = "Chancer"
PLUGIN.desc = "Adds a system for passive abilities"

PASSIVES = {}
PASSIVES.passives = {}
function PASSIVES:Register(tbl)
	self.passives[tbl.uid] = tbl
end

function PASSIVES:nameFromString(name)
	local passives = PASSIVES.passives

	if(passives[name]) then
		return name
	end
	
	local name = string.lower(name)
	
	local passive
	for k, v in pairs(passives) do
		if(string.lower(v.name) == string.lower(name)) then --exact name
			passive = k
			break	
		elseif(string.find(string.lower(v.name), string.lower(name))) then --partial name
			passive = k
		end
	end
	
	return passive
end

local playerMeta = FindMetaTable("Player")

function playerMeta:getPassives()
	local char = self:getChar()
	
	local passives = char:getData("passives", {})
	
	return passives
end

function playerMeta:hasPassive(passiveID)
	local char = self:getChar()
	
	local passives = char:getData("passives", {})
	
	return passives[passiveID]
end

if(SERVER) then
	function playerMeta:addPassive(passiveID)
		local char = self:getChar()
	
		local passives = char:getData("passives", {})
		passives[passiveID] = true
		char:setData("passives", passives)
		
		return true
	end
	
	function playerMeta:removePassive(passiveID)
		local char = self:getChar()
	
		local passives = char:getData("passives", {})
		passives[passiveID] = nil
		char:setData("passives", passives)
		
		return true
	end
	
	function PLUGIN:PlayerLoadedChar(client)
        local passives = {}
		
		for k, v in pairs(client:getPassives()) do
			passives[k] = PASSIVES.passives[k]
		end
		
		for k, passive in pairs(passives) do
			if(passive.buffs) then
				local buff = passive.buffs
				
				if(!buff.uid) then
					buff.uid = passive.uid
				end
				
				client:addBuff(buff)
			end
		end
    end
end

nut.command.add("charaddpassive", {
	adminOnly = true,
	syntax = "<string target> <string passive>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("No target specified.")
			return false
		end
	
		if(!arguments[2]) then
			client:notify("No passive specified.")
			return false
		end
	
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then
			local char = target:getChar()
			if(!char) then return end
			
			local passive = PASSIVES:nameFromString(arguments[2])
			
			if(passive) then
				local passives = char:getData("passives", {})
				passives[passive] = true
				
				char:setData("passives", passives)
				
				client:notify("You have given " .. target:Name() .. " the " ..PASSIVES.passives[passive].name.. ".")
			else
				client:notify("Invalid passive specified.")
			end
		end
	end
})

nut.command.add("charremovepassive", {
	adminOnly = true,
	syntax = "<string target> <string passive>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("No target specified.")
			return false
		end
	
		if(!arguments[2]) then
			client:notify("No passive specified.")
			return false
		end
	
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then
			local char = target:getChar()
			if(!char) then return end
			
			local passive = PASSIVES:nameFromString(arguments[2])
			
			if(passive) then
				if(target:hasPassive(passive)) then
			
					local passives = char:getData("passives", {})
					passives[passive] = nil
					
					char:setData("passives", passives)
					
					client:notify("You have taken " ..PASSIVES.passives[passive].name.. " from " ..target:Name().. ".")
				else
					client:notify(target:Name().. " does not have that passive.")
				end
			else
				client:notify("Invalid passive specified.")
			end
		end
	end
})

--command to see your own passives
nut.command.add("passivelist", {
	syntax = "<none>",
	onRun = function(client, arguments)	
		local targetPassives = client:getPassives()
		
		netstream.Start(client, "ShowPassives", targetPassives)
	end
})

--admin command to see a person's passives
nut.command.add("passivelistadmin", {
	adminOnly = true,
	syntax = "<string name>",
	onRun = function(client, arguments)	
		local target = nut.command.findPlayer(client, arguments[1])
		if(target) then
			local targetPassives = target:getPassives()
			
			netstream.Start(client, "ShowPassives", targetPassives)
		end
	end
})

if(CLIENT) then
	netstream.Hook("ShowPassives", function(passives)	
		local panel = vgui.Create("DFrame")
		panel:SetSize(ScrW() * 0.5, ScrH() * 0.5)
		panel:Center()
		panel:SetTitle("Passives")
		panel:MakePopup()
		
		local inner = vgui.Create("DScrollPanel", panel)
		inner:Dock(FILL)

		for k, v in pairs(passives) do		
			local passive = PASSIVES.passives[k]
			if(!passive) then continue end
		
			local label = inner:Add("DLabel")
			label:Dock(TOP)

			label:SetWrap(true)
			label:SetAutoStretchVertical(true)
			label:DockMargin(2,2,2,2)
			label:SetFont("nutSmallFont")
			label:SetText(passive.name.. ": " ..(passive.desc or ""))
		end
	end)
end

nut.util.include("sh_passives.lua")