local PLUGIN = PLUGIN
PLUGIN.name = "HP/Mana System"
PLUGIN.author = "Chancer"
PLUGIN.desc = "Adds a system for managing mana."

MANA = MANA or {}
HP = HP or {}

function PLUGIN:Think()
	if((self.nextHPCheck or 0) < CurTime()) then
		self.nextHPCheck = CurTime() + 10
		for k, v in pairs(player.GetAll()) do
			if(IsValid(v)) then
				local char = v:getChar()
				if(char) then
					--local mana = v:getMP()
					--local manaMax = v:getNetVar("mpMax", 0)
					local hp = v:getHP()
					local hpMax = v:getNetVar("hpMax", 0)
					
					--[[
					if(manaMax > 0) then
						MANA[v] = {mana, manaMax}
					else
						MANA[v] = nil
					end
					--]]
					
					HP[v] = {hp, hpMax}
				end
			end
		end
	end
	
	if((self.nextManaClean or 0) < CurTime()) then
		self.nextManaClean = CurTime() + 600
		
		--[[
		for k, v in pairs(MANA) do
			if(!IsValid(v)) then
				MANA[v] = nil
			end
		end
		--]]
		
		for k, v in pairs(HP) do
			if(!IsValid(v)) then
				HP[v] = nil
			end
		end
	end
end

--also displayed in status tab
if(CLIENT) then
	function PLUGIN:CreateCharInfoText(panel, suppress)
		local char = LocalPlayer():getChar()
		if(!char) then return end
	
		--health
		panel.hp = panel.info:Add("DLabel")
		panel.hp:Dock(TOP)
		panel.hp:SetTall(25)
		panel.hp:SetFont("nutMediumFont")
		panel.hp:SetTextColor(color_white)
		panel.hp:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		panel.hp:DockMargin(0, 10, 0, 0)
	
		local hp = LocalPlayer():getHP()
		local hpMax = LocalPlayer():getMaxHP()
		if (hp and hpMax) then
			panel.hp:SetText("Health: " ..hp.. "/" ..hpMax)
		end		
		
		--[[
		--mana
		panel.mana = panel.info:Add("DLabel")
		panel.mana:Dock(TOP)
		panel.mana:SetTall(25)
		panel.mana:SetFont("nutMediumFont")
		panel.mana:SetTextColor(color_white)
		panel.mana:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		panel.mana:DockMargin(0, 10, 0, 0)	
		
		local mana = LocalPlayer():getMP()
		local manaMax = LocalPlayer():getMaxMP()
		if (mana and manaMax) then
			panel.mana:SetText("Current Mana: " ..mana.. "/" ..manaMax)
		end
		--]]
	end
end

nut.command.add("charsetmp", {
	adminOnly = true,
	syntax = "<string target> <number value>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("No target specified")
			return false
		end
	
		if(!arguments[2]) then
			client:notify("No MP specified")
			return false
		end
	
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then
			local new = math.Clamp(tonumber(arguments[2]), 0, target:getMaxMP())
			target:setNetVar("mana", new)
			
			client:notify("Mana successfully changed.")
		end
	end
})

nut.command.add("charsethp", {
	adminOnly = true,
	syntax = "<string target> <number value>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("No target specified")
			return false
		end
	
		if(!arguments[2]) then
			client:notify("No HP specified")
			return false
		end
	
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then	
			local new = math.Clamp(tonumber(arguments[2]), 0, target:getMaxHP())
			target:setNetVar("hp", new)
			
			client:notify("Health successfully changed.")
		end
	end
})

nut.command.add("charrestorehp", {
	adminOnly = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("No target specified")
			return false
		end
	
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then	
			target:setNetVar("hp", target:getMaxHP())
			
			client:notify("Health successfully restored.")
		end
	end
})

nut.command.add("charaddhp", {
	adminOnly = true,
	syntax = "<string target> <number health>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("No target specified")
			return false
		end
		
		if(!arguments[2]) then
			client:notify("No amount specified")
			return false
		end
	
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then	
			target:addHP(tonumber(arguments[2]))
			
			client:notify("Health successfully added.")
		end
	end
})

nut.command.add("charaddmp", {
	adminOnly = true,
	syntax = "<string target> <number mana>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("No target specified")
			return false
		end
		
		if(!arguments[2]) then
			client:notify("No amount specified")
			return false
		end
	
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then	
			target:addMP(tonumber(arguments[2]))
			
			client:notify("Mana successfully added.")
		end
	end
})

nut.command.add("charrestoremp", {
	adminOnly = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("No target specified")
			return false
		end
	
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then	
			target:setNetVar("mp", target:getMaxMP())
			
			client:notify("Mana successfully restored.")
		end
	end
})

nut.command.add("charrestore", {
	adminOnly = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("No target specified")
			return false
		end
	
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then	
			target:setNetVar("hp", target:getMaxHP())
			
			client:notify("Health/Mana successfully restored.")
		end
	end
})

nut.command.add("charrestoreall", {
	adminOnly = true,
	syntax = "<none>",
	onRun = function(client, arguments)
		local count = 0
	
		for k, target in pairs(player.GetAll()) do
			if(IsValid(target) and target:getChar()) then	
				target:setNetVar("hp", target:getMaxHP())
				
				count = count + 1
			end
		end
		
		client:notify(count.. " players successfully restored.")
	end
})