local PLUGIN = PLUGIN

--[[
nut.command.add("cent", {
	--adminOnly = true,
	syntax = "<string command>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("Specify a command for the entity to run.")
		end
		
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			if(!entity:runCMD(client, arguments[1], arguments[2])) then
				client:notify("Invalid command.")
			end
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})
--]]

nut.command.add("centname", {
	adminOnly = true,
	syntax = "<string name>",
	onRun = function(client, arguments)
		if(!arguments) then
			client:notify("Specify a name for the entity.")
		end
		
		local name = table.concat(arguments, " ")
		
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			entity:setNetVar("name", name)
			client:notify("Entity's name has been changed to " ..name.. ".")
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centdesc", {
	adminOnly = true,
	syntax = "<string description>",
	onRun = function(client, arguments)
		if(!arguments) then
			client:notify("Specify a description for the entity.")
		end
		
		local desc = table.concat(arguments, " ")
		
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			entity:setNetVar("desc", desc)
			client:notify(entity:Name().. "'s description has been changed.")
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centsay", {
	adminOnly = true,
	syntax = "<string sentence>",
	onRun = function(client, arguments)
		if(!arguments) then
			client:notify("Put something for the CEnt to say.")
		end

		local msg = table.concat(arguments, " ")

		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			nut.chat.send(entity, "say_npc", entity:Name().. " says \"" ..msg.."\"")
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centwhisper", {
	adminOnly = true,
	syntax = "<string sentence>",
	onRun = function(client, arguments)
		if(!arguments) then
			client:notify("Put something for the CEnt to say.")
		end

		local msg = table.concat(arguments, " ")

		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			nut.chat.send(entity, "whisper_npc", entity:Name().. " whispers \"" ..msg.."\"")
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centyell", {
	adminOnly = true,
	syntax = "<string sentence>",
	onRun = function(client, arguments)
		if(!arguments) then
			client:notify("Put something for the CEnt to say.")
		end

		local msg = table.concat(arguments, " ")

		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			nut.chat.send(entity, "far_npc", entity:Name().. " yells \"" ..msg.."\"")
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centscream", {
	adminOnly = true,
	syntax = "<string sentence>",
	onRun = function(client, arguments)
		if(!arguments) then
			client:notify("Put something for the CEnt to say.")
		end

		local msg = table.concat(arguments, " ")

		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			nut.chat.send(entity, "scream_npc", entity:Name().. " yells \"" ..msg.."\"")
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centme", {
	adminOnly = true,
	syntax = "<string action>",
	onRun = function(client, arguments)
		if(!arguments) then
			client:notify("Put something for the CEnt to do.")
		end

		local msg = table.concat(arguments, " ")

		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			nut.chat.send(client, "say_npc", "**" ..entity:Name().. " " ..msg)
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centmefar", {
	adminOnly = true,
	syntax = "<string action>",
	onRun = function(client, arguments)
		if(!arguments) then
			client:notify("Put something for the CEnt to do.")
		end

		local msg = table.concat(arguments, " ")

		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			nut.chat.send(client, "far_npc", "**" ..entity:Name().. " " ..msg)
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centmefarfar", {
	adminOnly = true,
	syntax = "<string action>",
	onRun = function(client, arguments)
		if(!arguments) then
			client:notify("Put something for the CEnt to do.")
		end

		local msg = table.concat(arguments, " ")

		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			nut.chat.send(client, "farfar_npc", "**" ..entity:Name().. " " ..msg)
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centmodel", {
	adminOnly = true,
	syntax = "<string model>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("Specify a model for the entity.")
			return false
		end
		
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			entity:SetModel(arguments[1])
			
			for k, v in ipairs(entity:GetSequenceList()) do
				if (v:lower():find("idle") and v != "idlenoise") then
					entity:ResetSequence(k)
					break
				end
			end
			
			client:notify(entity:Name().. "'s model has been changed.")
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centkill", {
	adminOnly = true,
	onRun = function(client, arguments)		
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			entity:die()
			client:notify(entity:Name().. " has been slain.")
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centinvadd", {
	adminOnly = true,
	syntax = "<string item>",
	onRun = function(client, arguments)		
		if(!arguments[1]) then
			client:notify("Specify an item.")
			return
		end
	
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			local uniqueID = arguments[1]
		
			if(!nut.item.list[uniqueID]) then
				for k, v in SortedPairs(nut.item.list) do
					if (nut.util.stringMatches(v.name, uniqueID)) then
						uniqueID = k

						break
					end
				end
			end
			
			if(!nut.item.list[uniqueID]) then
				client:notify("Invalid item.")
				return
			end
			
			table.insert(entity.inv, uniqueID)
			client:notify(nut.item.list[uniqueID].name.. " added to entity's inventory.")
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centinvremove", {
	adminOnly = true,
	syntax = "<string item>",
	onRun = function(client, arguments)		
		if(!arguments[1]) then
			client:notify("Specify an item.")
			return
		end
	
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			local uniqueID = arguments[1]
		
			if(!nut.item.list[uniqueID]) then
				for k, v in SortedPairs(nut.item.list) do
					if (nut.util.stringMatches(v.name, uniqueID)) then
						uniqueID = k

						break
					end
				end
			end
			
			if(!nut.item.list[uniqueID]) then
				client:notify("Invalid item.")
				return
			end
			
			if(table.RemoveByValue(entity.inv, uniqueID)) then
				client:notify(nut.item.list[uniqueID].name.. " removed from entity's inventory.")
			else
				client:notify(nut.item.list[uniqueID].name.. " not found.")
			end
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})


nut.command.add("centattrib", {
	adminOnly = true,
	syntax = "<string attribute> <number value>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("Specify an attribute.")
			return
		end
		
		if(!arguments[2]) then
			client:notify("Specify a number value.")
			return
		end
		
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			local attrib = string.lower(arguments[1])
			local entAttribs = entity.attribs
			
			local attribKey
			local attribName
			for k, v in pairs(nut.attribs.list) do
				if (nut.util.stringMatches(v.name, attrib) or nut.util.stringMatches(k, attrib)) then
					attribKey = k
					attribName = v.name
				end
			end
			
			if(attribKey) then
				entAttribs[attribKey] = arguments[2]
				
				client:notify(attribName.. " set to " ..arguments[2].. ".")
			else
				client:notify("Invalid attribute specified.")
			end
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centattribs", {
	adminOnly = true,
	onRun = function(client, arguments)	
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			
			local attribs = entity.attribs
			
			netstream.Start(client, "ShowAttribs", client, attribs)
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centskills", {
	adminOnly = true,
	onRun = function(client, arguments)	
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			
			local skills = entity.skills
			
			netstream.Start(client, "ShowSkills", client, skills)
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centconfig", {
	adminOnly = true,
	onRun = function(client, arguments)	
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			PLUGIN:CEnt_config(client, entity)
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centres", {
	adminOnly = true,
	onRun = function(client, arguments)	
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			PLUGIN:CEnt_configR(client, entity)
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centfollow", {
	adminOnly = true,
	syntax = "<string target>",
	onRun = function(client, arguments)	
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target)) then
			local entity = client:GetEyeTrace().Entity
			if (IsValid(entity) and entity.combat) then
				entity.follow = target
			else
				client:notify("You must be looking at a combat entity.")
			end
		end
	end
})

nut.command.add("centfollowstop", {
	adminOnly = true,
	onRun = function(client, arguments)	
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			entity.follow = nil
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centactionadd", {
	adminOnly = true,
	syntax = "<string action>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("Specify an action to add.")
		end
	
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			local action = PLUGIN:actionFind(arguments[1])
		
			if(action) then
				local actions = entity.actions or {}
				actions[#actions + 1] = action.uid
				entity.actions = actions
				
				client:notify(entity:Name().. " now has the " ..(action.name or " ").. " action.")
			else
				client:notify("Invalid action.")
			end
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centactionremove", {
	adminOnly = true,
	syntax = "<string action>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("Specify a action to remove.")
		end
	
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			local action = PLUGIN:actionFind(arguments[1])
		
			if(action) then
				local actions = entity.actions or {}
				
				local targetSpell
				for k, v in pairs(actions) do
					if(v == action.uid) then
						targetSpell = k
						break
					end
				end

				if(targetSpell) then
					table.remove(actions, targetSpell)
					entity.actions = actions
					
					client:notify(entity:Name().. " no longer has the " ..(action.name or " ").. " action.")
				else
					client:notify(entity:Name().. " does not have " ..(action.name or " ").. ".")
				end
			else
				client:notify("Invalid action.")
			end
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centscale", {
	adminOnly = true,
	syntax = "<number scale>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("Specify a scale for the entity.")
		end
		
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			entity:SetModelScale(tonumber(arguments[1]))
			client:notify("Entity's scale has been changed.")
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("cleancents", {
	adminOnly = true,
	syntax = "<number radius>",
	onRun = function(client, arguments)
		if(arguments[1]) then
			local count = 0
		
			local trace = client:GetEyeTraceNoCursor()
			local hitpos = trace.HitPos + trace.HitNormal*5
			for k, v in pairs(ents.FindInSphere(hitpos, arguments[1] or 100)) do
				if IsValid(v) and (v.combat) then
					count = count + 1
					SafeRemoveEntity(v)
				end
			end
			
			client:notify(count.. " Combat Entities have been cleaned up from the map.")
		else
			client:notify("Specify a radius")
			return false
		end
	end
})

nut.chat.register("react_fail", { --reaction roll
	onChatAdd = function(speaker, text)
		chat.AddText(PLUGIN.CHATCOLOR_RED, text)
	end,
	color = PLUGIN.CHATCOLOR_RED,
	filter = "actions",
	font = "nutChatFontCombat",
	onCanHear = nut.config.get("chatRange", 280) * 5,
	deadCanChat = true
})

nut.chat.register("react_success", { --reaction roll
	onChatAdd = function(speaker, text)
		chat.AddText(PLUGIN.CHATCOLOR_GREEN, text)
	end,
	color = PLUGIN.CHATCOLOR_GREEN,
	filter = "actions",
	font = "nutChatFontCombat",
	onCanHear = nut.config.get("chatRange", 280) * 5,
	deadCanChat = true
})

nut.chat.register("melee_npc", {
	onChatAdd = function(speaker, text)
		chat.AddText(PLUGIN.CHATCOLOR_MELEE, text)
	end,
	filter = "actions",
	font = "nutChatFontCombat",
	onCanHear = nut.config.get("chatRange", 280) * 5,
	deadCanChat = true
})

nut.chat.register("fort_npc", {
	onChatAdd = function(speaker, text)
		chat.AddText(Color(200,200,200), text)
	end,
	filter = "actions",
	font = "nutChatFontCombat",
	onCanHear = nut.config.get("chatRange", 280) * 5,
	deadCanChat = true
})

nut.chat.register("react_npc", { --reaction roll
	onGetColor = function(speaker, text)
		local client = LocalPlayer()
	
		if(speaker == client) then
			return PLUGIN.CHATCOLOR_REACT2
		elseif(client.Name and string.find(text, client:Name())) then
			return PLUGIN.CHATCOLOR_REACT3
		else
			return PLUGIN.CHATCOLOR_REACT
		end
	end,
	onChatAdd = function(speaker, text)
		local client = LocalPlayer()
	
		-- If the player's name is in there, make the color different so they know it involves them.
		if(speaker == client) then 
			chat.AddText(PLUGIN.CHATCOLOR_REACT2, text)
		elseif(client.Name and string.find(text, client:Name())) then
			chat.AddText(PLUGIN.CHATCOLOR_REACT3, text)
		else
			chat.AddText(PLUGIN.CHATCOLOR_REACT, text)
		end
	end,
	filter = "actions",
	font = "nutChatFontCombat",
	onCanHear = nut.config.get("chatRange", 280) * 5,
	deadCanChat = true,
})

nut.chat.register("whisper_npc", {
	onChatAdd = function(speaker, text)
		local color = nut.config.get("chatColor")
		
		chat.AddText(Color(color.r - 35, color.g - 35, color.b - 35), text)
	end,
	filter = "actions",
	font = "nutChatFont",
	onCanHear = nut.config.get("chatRange", 280) * 0.25,
	deadCanChat = true
})

nut.chat.register("say_npc", {
	onChatAdd = function(speaker, text)
		local color = nut.config.get("chatColor")
		
		chat.AddText(Color(color.r, color.g, color.b), text)
	end,
	filter = "actions",
	font = "nutChatFont",
	onCanHear = nut.config.get("chatRange", 280),
	deadCanChat = true
})

nut.chat.register("far_npc", {
	onChatAdd = function(speaker, text)
		local color = nut.config.get("chatColor")
		
		chat.AddText(Color(color.r + 35, color.g + 35, color.b + 35), text)
	end,
	filter = "actions",
	font = "nutChatFont",
	onCanHear = nut.config.get("chatRange", 280) * 2,
	deadCanChat = true
})

nut.chat.register("farfar_npc", {
	onChatAdd = function(speaker, text)
		local color = nut.config.get("chatColor")
		
		chat.AddText(Color(color.r + 55, color.g + 55, color.b + 55), text)
	end,
	filter = "actions",
	font = "nutChatFont",
	onCanHear = nut.config.get("chatRange", 280) * 4,
	deadCanChat = true
})

nut.chat.register("scream_npc", {
	onChatAdd = function(speaker, text)
		local color = nut.config.get("chatColor")

		chat.AddText(Color(200, 20, 20), text)
	end,
	filter = "actions",
	font = "nutChatFont",
	onCanHear = nut.config.get("chatRange", 280) * 4,
	deadCanChat = true
})

if(SERVER) then
	function PLUGIN:CEnt_config(client, entity)
		nut.plugin.list["routes"]:NetworkRouteData(self.Owner)
	
		local config = {
			["name"] = {weight = 1, name = "Name", value = entity:Name()},
			["desc"] = {weight = 2, name = "Description", value = entity:Desc()},		
			["hp"] = {weight = 3, name = "Health", value = entity:getHP()},
			["hpMax"] = {weight = 4, name = "Max Health", value = entity:getMaxHP()},
			["mp"] = {weight = 5, name = "Mana", value = entity:getMP()},
			["mpMax"] = {weight = 6, name = "Max Mana", value = entity:getMaxMP()},
			--["magic"] = {weight = 7, name = "Magic Bonus", value = entity.magic},
			["armor"] = {weight = 7, name = "Armor", value = entity.armor},
			--["dmg"] = {weight = 8, name = "Base Damage", value = entity.dmg},
		}
		
		local extra = {}
		extra.attribs = entity:getNetVar("attribs", entity.attribs)
		--extra.dmgT = entity.dmgT

		netstream.Start(client, "CEnt_config", entity, config, extra)
	end
	
	function PLUGIN:CEnt_configR(client, entity)		
		local extra = {}
		extra.res = entity.res
	
		netstream.Start(client, "CEnt_configR", entity, extra)
	end
	
	netstream.Hook("CEnt_configF", function(client, entity, data)
		if(data.attribs) then		
			entity:setNetVar("attribs", data.attribs)
		end
		
		if(data.name) then
			entity:setNetVar("name", data.name)
		end
		
		if(data.desc) then
			entity:setNetVar("desc", data.desc)
		end
		
		if(data.hp) then
			entity:setNetVar("hp", tonumber(data.hp))
		end		
		
		if(data.hpMax) then
			entity:setNetVar("hpMax", tonumber(data.hpMax))
		end
		
		if(data.mp) then
			entity:setNetVar("mp", tonumber(data.mp))
		end
		
		if(data.mpMax) then
			entity:setNetVar("mpMax", tonumber(data.mpMax))
		end
		
		if(data.armor) then
			entity.armor = tonumber(data.armor)
		end
		
		if(data.patrol) then
			if(data.patrol == "" or data.patrol == "None") then
				entity.patrol = {}
			else
				local route = nut.plugin.list["routes"].routes[data.patrol]
				if(route) then
					entity.patrol = {
						name = data.patrol,
						current = 1,
						wait = 1, --how long it waits before going to the next patrol point
						pause = false, --pauses the patrol, if it goes into combat or something
					}
				end
			end
		end
	end)
	
	netstream.Hook("CEnt_configRF", function(client, entity, data)
		if(data) then
			entity.res = data
		end
	end)
else
	local partsTbl = {
		["Body"] = "Body",
		["Head"] = "Head",
		["Left Arm"] = "Left Arm",
		["Right Arm"] = "Right Arm",
		["Left Leg"] = "Left Leg",
		["Right Leg"] = "Right Leg",
	}

	netstream.Hook("CEnt_config", function(entity, config, extra)
		local command = vgui.Create("nutCombatCommand")
		command:CEntConfig(entity)
	
		--[[
		local attribs = extra.attribs or {}
		local skills = extra.skills or {}
		local armor = extra.armor or {}
		
		local frame = vgui.Create("DFrame")
		frame:SetSize(450, 600)
		frame:Center()
		frame:SetTitle("CEnt Configuration")
		frame:MakePopup()
		frame:ShowCloseButton(true)

		local scroll = vgui.Create("DScrollPanel", frame)
		scroll:Dock(FILL)
		
		local configF = {}
		for k, v in SortedPairsByMemberValue(config, "weight") do
			local label = vgui.Create("DLabel", scroll)
			label:SetText(v.name)
			label:Dock(TOP)

			local entry = vgui.Create("DTextEntry", scroll)
			entry:SetText(v.value or "")
			entry:Dock(TOP)
			
			configF[k] = entry
		end
		
		local labelDT = vgui.Create("DLabel", scroll)
		labelDT:SetText("Damage Type")
		labelDT:Dock(TOP)
		
		local entryDT = vgui.Create("DComboBox", scroll)
		entryDT:SetText(extra.dmgT or "")
		entryDT:Dock(TOP)
		for k, v in pairs(PLUGIN.dmgTypes) do
			entryDT:AddChoice(k)
		end
		configF["dmgT"] = entryDT
		
		local label = vgui.Create("DLabel", scroll)
		label:SetText("Attributes")
		label:Dock(TOP)
		
		local configA = {}
		for k, v in pairs(nut.attribs.list) do
			local label = vgui.Create("DLabel", scroll)
			label:SetText(v.name)
			label:Dock(TOP)

			local entry = vgui.Create("DNumberWang", scroll)
			entry:SetMax(1000)
			entry:SetValue(attribs[k] or 0)
			entry:Dock(TOP)
			
			configA[k] = entry
		end
		
		local label = vgui.Create("DLabel", scroll)
		label:SetText("Skills")
		label:Dock(TOP)
		
		local configSk = {}
		for k, v in pairs(nut.skills.list) do
			local label = vgui.Create("DLabel", scroll)
			label:SetText(v.name)
			label:Dock(TOP)

			local entry = vgui.Create("DNumberWang", scroll)
			entry:SetMax(1000)
			entry:SetValue(skills[k] or 0)
			entry:Dock(TOP)
			
			configSk[k] = entry
		end		
		
		local label = vgui.Create("DLabel", scroll)
		label:SetText("Armor")
		label:Dock(TOP)
		
		local configAr = {}
		for k, v in pairs(armor) do
			local label = vgui.Create("DLabel", scroll)
			label:SetText(partsTbl[k] or "")
			label:Dock(TOP)

			local entry = vgui.Create("DNumberWang", scroll)
			entry:SetMax(1000000)
			entry:SetValue(v or 0)
			entry:Dock(TOP)
			
			configAr[k] = entry
		end
		
		local finishB = vgui.Create("DButton", scroll)
		finishB:SetSize(60,20)
		finishB:SetText("Complete")
		finishB:Dock(TOP)
		finishB.DoClick = function()
			local data = {}

			for k, v in pairs(configF) do
				data[k] = v:GetText()
			end
			
			data.attribs = {}
			for k, v in pairs(configA) do
				data.attribs[k] = tonumber(v:GetValue())
			end
			
			data.skills = {}
			for k, v in pairs(configSk) do
				data.skills[k] = tonumber(v:GetValue())
			end
			
			data.armor = {}
			for k, v in pairs(configAr) do
				data.armor[k] = tonumber(v:GetValue())
			end
			
			netstream.Start("CEnt_configF", entity, data)
			
			frame:Remove()
		end
		
		local cancelB = vgui.Create("DButton", scroll)
		cancelB:SetSize(60,20)
		cancelB:SetText("Cancel")
		cancelB:Dock(TOP)
		cancelB.DoClick = function()
			frame:Remove()
		end
		--]]
	end)
	
	netstream.Hook("CEnt_configR", function(entity, extra)
		local res = extra.res or {}

		local frame = vgui.Create("DFrame")
		frame:SetSize(450, 600)
		frame:Center()
		frame:SetTitle("CEnt Resistances")
		frame:MakePopup()
		frame:ShowCloseButton(true)

		local scroll = vgui.Create("DScrollPanel", frame)
		scroll:Dock(FILL)
		
		local label = vgui.Create("DLabel", scroll)
		label:SetText("Resistances")
		label:Dock(TOP)
		
		local config = {}
		--damage type resistance customization
		
		local resTypes = table.Copy(PLUGIN.dmgTypes or {})
		resTypes["kinetic"] = {
			name = "Kinetic (General)",
		}
		resTypes["energy"] = {
			name = "Energy (General)",
		}
		
		for k, v in SortedPairsByMemberValue(resTypes, "name") do
			local resL = vgui.Create("DLabel", scroll)
			resL:SetText(v.name)
			resL:Dock(TOP)
			
			local resC = vgui.Create("DNumberWang", scroll)
			resC.res = k
			resC:SetDecimals(2)
			resC:Dock(TOP)
			resC:SetMax(200)
			resC:SetMin(-200)
			resC:SetValue(res[k] or 0)
			
			config[k] = resC
		end
		
		local configE = {}
		--effect resistance
		for k, v in SortedPairsByMemberValue(EFFS.effects, "name") do
			local resL = vgui.Create("DLabel", scroll)
			resL:SetText(v.name)
			resL:Dock(TOP)
			
			local resC = vgui.Create("DNumberWang", scroll)
			resC.resE = k
			resC:SetDecimals(2)
			resC:Dock(TOP)
			resC:SetMax(200)
			resC:SetMin(-200)
			resC:SetValue(res[k] or 0)
			
			config[k] = resC
		end
		
		local finishB = vgui.Create("DButton", scroll)
		finishB:SetSize(60,20)
		finishB:SetText("Complete")
		finishB:Dock(TOP)
		finishB.DoClick = function()
			local data = {}

			for k, v in pairs(config) do
				data[k] = v:GetText()
			end
			
			netstream.Start("CEnt_configRF", entity, data)
			
			frame:Remove()
		end
		
		local cancelB = vgui.Create("DButton", scroll)
		cancelB:SetSize(60,20)
		cancelB:SetText("Cancel")
		cancelB:Dock(TOP)
		cancelB.DoClick = function()
			frame:Remove()
		end
	end)
end
