local PLUGIN = PLUGIN

--[[
--just a simple chat command for a regular attack
nut.command.add("attack", {
	onRun = function(client, arguments)	
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			PLUGIN:attack(client, entity)
		else
			--rollHandle(client, tbl.uid)
			PLUGIN:attack(client)
		end
	end
})
--]]

--oh look it's this menu again big surprise
if(CLIENT) then
	netstream.Hook("ShowAttribs", function(client, attribs, boosted)
		local attribText = ""
		
		for k, v in pairs(boosted or attribs) do
			local boostText = ""
			if(boosted and !table.IsEmpty(boosted)) then
				local bonus = (v - (attribs[k] or 0))
				boostText = boostText.. " (" ..(((bonus >= 0) and "+") or "")..bonus.. ")"
			end
		
			local attribName = (nut.attribs.list[k] and nut.attribs.list[k].name) or "Unknown Attribute"

			attribText = attribText ..attribName.. ": " ..v..boostText.. "\n\n"
		end
	
		local attribMenu = vgui.Create("DFrame")
		attribMenu:SetSize( 500, 700 )
		attribMenu:Center()
		if(me) then
			attribMenu:SetTitle("Player Menu")
		else
			attribMenu:SetTitle(client:Name())
		end
		attribMenu:MakePopup()

		attribMenu.DS = vgui.Create( "DScrollPanel", attribMenu )
		attribMenu.DS:SetPos( 10, 50 )
		attribMenu.DS:SetSize( 500 - 10, 700 - 50 - 10 )
		function attribMenu.DS:Paint( w, h ) end
		
		attribMenu.B = vgui.Create( "DLabel", attribMenu.DS )
		attribMenu.B:SetPos( 0, 40 )
		attribMenu.B:SetFont( "nutSmallFont" )
		attribMenu.B:SetText( attribText )
		attribMenu.B:SetAutoStretchVertical( true )
		attribMenu.B:SetWrap( true )
		attribMenu.B:SetSize( 500 - 20, 10 )
		attribMenu.B:SetTextColor( Color( 255, 255, 255, 255 ) )
	end)
	
	netstream.Hook("ShowSkills", function(client, skills, boosted)
		local attribText = ""
		
		for k, v in pairs(boosted or skills) do
			local boostText = ""
			if(boosted and !table.IsEmpty(boosted)) then
				local bonus = (v - (skills[k] or 0))
				boostText = boostText.. " (" ..(((bonus >= 0) and "+") or "")..bonus.. ")"
			end
			
			local skillName = (nut.skills.list[k] and nut.skills.list[k].name) or "Unknown Skill"
			
			attribText = attribText ..skillName.. ": " ..v..boostText.. "\n\n"
		end
	
		local attribMenu = vgui.Create("DFrame")
		attribMenu:SetSize( 500, 700 )
		attribMenu:Center()
		if(me) then
			attribMenu:SetTitle("Player Menu")
		else
			attribMenu:SetTitle(client:Name())
		end
		attribMenu:MakePopup()

		attribMenu.DS = vgui.Create( "DScrollPanel", attribMenu )
		attribMenu.DS:SetPos( 10, 50 )
		attribMenu.DS:SetSize( 500 - 10, 700 - 50 - 10 )
		function attribMenu.DS:Paint( w, h ) end
		
		attribMenu.B = vgui.Create( "DLabel", attribMenu.DS )
		attribMenu.B:SetPos( 0, 40 )
		attribMenu.B:SetFont( "nutSmallFont" )
		attribMenu.B:SetText( attribText )
		attribMenu.B:SetAutoStretchVertical( true )
		attribMenu.B:SetWrap( true )
		attribMenu.B:SetSize( 500 - 20, 10 )
		attribMenu.B:SetTextColor( Color( 255, 255, 255, 255 ) )
	end)
end

nut.command.add("chargetattribs", {
	adminOnly = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])
		
		if(IsValid(target) and target:getChar()) then
			local char = target:getChar()

			local boosted = {}
		
			for k, v in pairs(nut.attribs.list) do
				boosted[k] = char:getAttrib(k)
			end
		
			local attribs = char:getAttribs()
		
			netstream.Start(client, "ShowAttribs", target, attribs, boosted)
		end
	end
})

nut.command.add("chargetskills", {
	adminOnly = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])
		
		if(IsValid(target) and target:getChar()) then
			local char = target:getChar()

			local boosted = {}
		
			for k, v in pairs(nut.skills.list) do
				boosted[k] = char:getSkill(k)
			end
		
			local skills = char:getSkills()
		
			netstream.Start(client, "ShowSkills", target, skills, boosted)
		end
	end
})

--gets a single stat it's kind of worthless
nut.command.add("chargetattrib", {
	adminOnly = true,
	syntax = "<string name> <string type>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then
			local findAtt = arguments[2]
			local attribName
			for k, v in pairs(nut.attribs.list) do
				if (nut.util.stringMatches(L(v.name, client), findAtt) or nut.util.stringMatches(k, findAtt)) then
					attribName = k
				end
			end
			if(attribName) then
				local value = target:getChar():getAttrib(attribName, 0)
			
				client:notify(target:Name().. " " ..findAtt.. ": " ..value)
			else
				client:notify("Invalid Attribute")
			end
		end
	end
})

--used for a player to display their own stat for event things
nut.command.add("attribcheck", {
	syntax = "<string attribute>",
	onRun = function(client, arguments)
		if(IsValid(client) and client:getChar()) then
			local findAtt = arguments[1]
			local attribName
			for k, v in pairs(nut.attribs.list) do
				if (nut.util.stringMatches(L(v.name, client), findAtt) or nut.util.stringMatches(k, findAtt)) then
					attribName = k
				end
			end
			
			if(attribName) then
				local value = client:getChar():getAttrib(attribName, 0)
				local name = nut.attribs.list[attribName].name
		
				nut.plugin.list["chatboxextra"]:ChatboxSend(client, "statcheck", client:Name().. " has a " ..  name .. " value of " .. value)
			else
				client:notify("Invalid Attribute")
			end
		end
	end
})

nut.command.add("skillcheck", {
	syntax = "<string skill>",
	onRun = function(client, arguments)
		if(IsValid(client) and client:getChar()) then
			local findAtt = arguments[1]
			local attribName
			for k, v in pairs(nut.skills.list) do
				if (nut.util.stringMatches(L(v.name, client), findAtt) or nut.util.stringMatches(k, findAtt)) then
					attribName = k
				end
			end
			
			if(attribName) then
				local value = client:getChar():getSkill(attribName, 0)
				local name = nut.skills.list[attribName].name
		
				nut.plugin.list["chatboxextra"]:ChatboxSend(client, "statcheck", client:Name().. " has a " ..  name .. " value of " .. value)
			else
				client:notify("Invalid Skill")
			end
		end
	end
})