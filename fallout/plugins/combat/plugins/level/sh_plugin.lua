local PLUGIN = PLUGIN
PLUGIN.name = "Levels"
PLUGIN.author = "Chancer"
PLUGIN.desc = "Levelling and experience."

nut.config.add("maxLevel", 16, "The maximum level a player can reach.", nil, {
	data = {min = 1, max = 2000},
	category = "Level"
})

nut.config.add("specialLevels", 2, "Levels required to gain a skill point.", nil, {
	data = {min = 1, max = 2000},
	category = "Level"
})

nut.config.add("specialPerLevel", 1, "How many special points to give when applicable.", nil, {
	data = {min = 1, max = 2000},
	category = "Level"
})

nut.config.add("skillLevels", 1, "Levels required to gain skill points.", nil, {
	data = {min = 1, max = 2000},
	category = "Level"
})

nut.config.add("skillPerLevel", 5, "How many skill points to give when applicable.", nil, {
	data = {min = 1, max = 2000},
	category = "Level"
})

nut.config.add("perkLevels", 5, "Levels required to gain a perk point.", nil, {
	data = {min = 1, max = 2000},
	category = "Level"
})

nut.config.add("perkPerLevel", 1, "How many perk points to give when applicable.", nil, {
	data = {min = 1, max = 2000},
	category = "Level"
})

--attributes to exclude
PLUGIN.exclude = {
	--["medical"] = true,
}

--this one gets to stay since the attributes are also there.
if(CLIENT) then
	function PLUGIN:CreateCharInfoText(panel, suppress)
		--[[
		panel.level = panel.info:Add("DLabel")
		panel.level:Dock(TOP)
		panel.level:SetTall(25)
		panel.level:SetFont("nutMediumFont")
		panel.level:SetTextColor(color_white)
		panel.level:SetText("")
		panel.level:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		panel.level:DockMargin(0, 10, 0, 0)
		
		if (panel.level) then
			local char = LocalPlayer():getChar()
			if(char) then
				local level = LocalPlayer():getLevel()
				local extra = char:getData("points")
				panel.level:SetText("Level: " ..level - (extra or 0).. ((extra and " (+" ..extra.. ")") or ""))
			end
		end
		--]]
		
		local sizeX, sizeY = panel:GetSize()
		
		local XPBar = panel.info:Add("DPanel")
		XPBar:SetSize(sizeX, ScrH()*0.03)
		XPBar:SetPos(ScrW()*0.5-sizeX*0.5, ScrH()*0.18)
		XPBar:MakePopup()
		--[[
		XPBar.OnKeyCodePressed = function(this, key)
			if (key == KEY_F1) then
				self:Remove()
			end
		end
		--]]
		
		XPBar.Paint = function(self, w, h)
			local client = LocalPlayer()
			local char = client:getChar()
		
			local level = client:getLevel()
			local nextLevel = nut.plugin.list["level"]:getLevelThresh(level)
			local xp = char:getData("xp", 0)
		
			local ratio = math.Clamp(xp / nextLevel, 0, 1)

			local barSize = w*math.Round(ratio, 2)
		
			surface.SetDrawColor(0,47,0,150)
			surface.DrawRect(0,0,w,h)
			
			surface.SetDrawColor(0,238,0,150)
			surface.DrawRect(0,0,barSize,h)
			
			surface.SetDrawColor(0,238,0,150)
			surface.DrawOutlinedRect(0, 0, w, h, 2)
			
			surface.SetFont("nutMediumFont")
				
			local levelText = "Level " ..level.. " (" ..xp.. "/" ..nextLevel.. ")"
		
			local textSizeX, textSizeY = surface.GetTextSize(levelText)
			
			surface.SetTextColor(255,255,255)
			surface.SetTextPos(w*0.5-textSizeX*0.5, h*0.5-textSizeY*0.5) 
			surface.DrawText(levelText)
		end
	end
else
	netstream.Hook("nut_respec", function(client)
		PLUGIN:Respec(client)
	end)

	function PLUGIN:Respec(client)
		local char = client:getChar()
		local charLevel = client:getLevel()
		
		for k, v in pairs(nut.attribs.list) do
			char:setAttrib(k, 1)
		end
		
		for k, v in pairs(nut.skills.list) do
			char:setSkill(k, 1)
		end
		
		local traits = {}
		for k, v in pairs(client:getTraits()) do
			local traitData = TRAITS.traits[k]
			if(traitData and traitData.hidden) then
				traits[k] = v
			end
		end
		
		char:setData("traits", traits)
		
		local faction = char:getFaction()
		local factionTbl = nut.faction.indices[faction]
		if(factionTbl) then
			for k, v in pairs(factionTbl.attrib or {}) do
				char:updateAttrib(k, v)
			end
		end

		local history = client:getHistory()

		if history ~= "none" then 
			local historyList = HISTORIES.histories

			if(historyList[history].func) then
			historyList[history].func(client, char)
			end
		end 
		
		local pointAttrib = math.floor(charLevel/nut.config.get("specialLevels", 2)) * nut.config.get("specialPerLevel", 1)
		local pointSkill = math.floor((charLevel-1)/nut.config.get("skillLevels", 1)) * nut.config.get("skillPerLevel", 5)
		local pointPerk = math.floor(charLevel/nut.config.get("perkLevels", 5)) * nut.config.get("perkPerLevel", 1)

		pointAttrib = pointAttrib + nut.config.get("startAttribs", 28) - table.Count(nut.attribs.list)
		pointSkill = pointSkill + nut.config.get("charCreateSkills", 25)
		pointPerk = pointPerk + nut.config.get("maxTraits", 2)

		char:setData("ptAttrib", pointAttrib)
		char:setData("ptSkill", pointSkill)
		char:setData("ptPerk", pointPerk)
		
		--give them the associated points
	end
end

local playerMeta = FindMetaTable("Player")

function playerMeta:addXP(newXP, noNotify)
	local char = self:getChar()

	if(char) then
		local maxLevel = nut.config.get("maxLevel", 16)
		local curLevel = self:getLevel()
		--dont give xp to max level characters
		if(curLevel >= maxLevel) then return false end 

		local xp = char:getData("xp", 0)
		
		local newXP = newXP
		
		char:setData("xp", xp + newXP)
		
		self:XPtoLevel()
		
		if(!noNotify) then
			self:notify("You have gained experience.")
		end
		
		self:EmitSound("ui_popup_experienceup", 75, math.random(95,105))

		nut.log.addRaw(self:Name().. " has gained " ..newXP.. " XP.")
	end

	return false
end

function playerMeta:getLevel()
	local char = self:getChar()
	
	local level = char:getData("level", 1)
	
	return level
end

function playerMeta:canLevelAttrib()
	local char = self:getChar()

	if(char) then
		local points = char:getData("ptAttrib", 0)
		if(points > 0) then
			return points
		end
	end

	return false
end

function playerMeta:canLevelSkill()
	local char = self:getChar()

	if(char) then
		local points = char:getData("ptSkill", 0)
		if(points > 0) then
			return points
		end
	end

	return false
end

function playerMeta:canLevelPerk()
	local char = self:getChar()

	if(char) then
		local points = char:getData("ptPerk", 0)
		if(points > 0) then
			return points
		end
	end

	return false
end

function PLUGIN:getLevelThresh(level)
	local maxLevel = nut.config.get("maxLevel", 16)
	if(level >= maxLevel) then
		return math.huge
	end

	return (level * 60)
end

function playerMeta:XPtoLevel()
	local char = self:getChar()

	if(char) then
		local xp = char:getData("xp", 0)
		local charLevel = self:getLevel()
		local pointAttrib = char:getData("ptAttrib", 0)
		local pointSkill = char:getData("ptSkill", 0)
		local pointPerk = char:getData("ptPerk", 0)
		
		local startLevel = charLevel --cache this
		
		thresh = PLUGIN:getLevelThresh(charLevel)
		while (xp >= thresh) do
			xp = xp - thresh
			charLevel = charLevel + 1
			--points = points + 1
			
			if(math.fmod(charLevel, nut.config.get("specialLevels", 2)) == 0) then
				pointAttrib = pointAttrib + nut.config.get("specialPerLevel", 1)
			end
			
			if(math.fmod(charLevel, nut.config.get("skillLevels", 1)) == 0) then
				pointSkill = pointSkill + nut.config.get("skillPerLevel", 5)
			end
			
			if(math.fmod(charLevel, nut.config.get("perkLevels", 5)) == 0) then
				pointPerk = pointPerk + nut.config.get("perkPerLevel", 1)
			end
			
			char:setData("level", charLevel)
			
			thresh = PLUGIN:getLevelThresh(charLevel)
		end
		
		char:setData("ptAttrib", pointAttrib)
		char:setData("ptSkill", pointSkill)
		char:setData("ptPerk", pointPerk)
		
		char:setData("xp", xp)
		
		if(pointAttrib > 1) then
			char:getPlayer():notify("You have unassigned SPECIAL points.", true)
		end
		
		if(pointSkill > 1) then
			char:getPlayer():notify("You have unassigned Skill points.", true)
		end
		
		if(pointPerk > 1) then
			char:getPlayer():notify("You have unassigned Perk points.", true)
		end
		
		if(charLevel != startLevel) then
			self:EmitSound("ui_levelup", 75, math.random(95,105))
		end
	end
end

function playerMeta:XPPrediction(experience)
	if(!experience) then return 0 end

	local char = self:getChar()

	if(char) then
		local xp = experience
		local charLevel = self:getLevel(char) or 999 --fallback number is big to prevent exploits
		local levels = 0
		
		thresh = PLUGIN:getLevelThresh(charLevel)
		while (xp >= thresh) do
			xp = xp - thresh
			charLevel = charLevel + 1
			levels = levels + 1
			
			thresh = PLUGIN:getLevelThresh(charLevel)
		end
		
		local remain = math.Round(xp / thresh, 2)
		
		return (levels + remain)
	end
end

nut.command.add("xppredict", {
	adminOnly = true,
	syntax = "<string name>",
	onRun = function(client, arguments)	
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then
			local experience = tonumber(arguments[2])
			
			local levels = target:XPPrediction(experience)
			
			client:notify(levels)
		end
	end
})

nut.command.add("level", {
	adminOnly = true,
	syntax = "<string name>",
	onRun = function(client, arguments)	
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then
			client:notify("Levels " ..target:getLevel())
		end
	end
})

nut.command.add("charaddxp", {
	adminOnly = true,
	syntax = "<string name> <number amount> <boolean notify>",
	onRun = function(client, arguments)
		if(!tonumber(arguments[2])) then
			client:notify("Invalid amount specified.")
			return false
		end
	
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then
			local char = target:getChar()
			
			local newXP = tonumber(arguments[2])
			
			local requestString = "Are you sure you want to give " ..target:Name().. " " ..newXP.. " experience?\nThey will gain " ..target:XPPrediction(newXP).. " levels."
		
			client:requestQuery(requestString, "Add Experience", function(text)
				target:addXP(newXP, arguments[3])
				
				client:notify("Increased " ..target:Name().. "'s experience by " ..newXP.. ".")
			end)
		end
	end
})

--[[
nut.command.add("charaddlevel", {
	adminOnly = true,
	syntax = "<string name> <number amount>",
	onRun = function(client, arguments)
		if(!arguments[2] or !tonumber(arguments[2])) then
			client:notify("Invalid amount specified.")
			return false
		end
	
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then
			local char = target:getChar()
			local points = char:getData("points", 0)
			
			char:setData("points", points + arguments[2])
			
			client:notify("Increased " ..target:Name().. "'s level by " ..tonumber(arguments[2]).. ".")
		end
	end
})
--]]

nut.command.add("xparea", {
	adminOnly = true,
	syntax = "<number area> <number xp> <boolean notify>",
	onRun = function(client, arguments)
		if(!tonumber(arguments[1])) then
			client:notify("No area specified.")
			return false
		end
		
		if(!tonumber(arguments[2])) then
			client:notify("No XP amount specified.")
			return false
		end
		
		local newXP = tonumber(arguments[2])
		local requestString = "Are you sure you want to give " ..newXP.. " experience to each person?\n"
	
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal*5
		local foundPlayers = ents.FindInSphere(hitpos, tonumber(arguments[1]) or 100)
		
		for k, v in pairs(foundPlayers) do
			if(v == client) then continue end
			if (IsValid(v) and v:IsPlayer()) then
				local char = v:getChar()
				if(char) then
					requestString = requestString.. " " ..v:Name()..  " will gain " ..v:XPPrediction(newXP).. " levels."
					
					if(k < #foundPlayers) then
						requestString = requestString.. "\n"
					end
				end
			end
		end
		
		client:requestQuery(requestString, "Add Experience", function(text)
			for k, v in pairs(foundPlayers) do
				if(v == client) then continue end
				if (IsValid(v) and v:IsPlayer()) then
					if(v:GetMoveType() == MOVETYPE_NOCLIP) then continue end
				
					local char = v:getChar()
					if(char) then
						v:addXP(tonumber(arguments[2]), arguments[3])
					
						client:notify("Increased " ..v:Name().. "'s experience by " ..tonumber(arguments[2]).. ".")
					end
				end
			end
		end)		
	end
})

nut.command.add("xpareadistrib", {
	adminOnly = true,
	syntax = "<number area> <number xp>",
	onRun = function(client, arguments)
		if(!tonumber(arguments[1])) then
			client:notify("No area specified.")
			return false
		end
		
		if(!tonumber(arguments[2])) then
			client:notify("No XP amount specified.")
			return false
		end

		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal*5
		
		local entities = ents.FindInSphere(hitpos, tonumber(arguments[1]) or 100)
		local players = {}
		for k, v in pairs(entities) do
			if(v:IsPlayer()) then
				if(v != client) then --exclude the person running the command.
					players[#players+1] = v
				end
			end
		end
		
		local playerCount = math.max(#players, 1)
		local split = math.Round(tonumber(arguments[2]) / playerCount, 3)
		
		local requestString = "Are you sure you want to give " ..split.. " experience to each person?\n"
		
		for k, v in pairs(players) do
			if (IsValid(v) and v:IsPlayer()) then
				if(v:GetMoveType() == MOVETYPE_NOCLIP) then continue end
			
				local char = v:getChar()
				if(char) then
					requestString = requestString.. " " ..v:Name()..  " will gain " ..v:XPPrediction(split).. " levels."
					
					if(k < #players) then
						requestString = requestString.. "\n"
					end
				end
			end
		end
		
		client:requestQuery(requestString, "Add Experience", function(text)
			for k, v in pairs(players) do
				local char = v:getChar()
				if(char) then
					v:addXP(split, arguments[3])
					
					client:notify("Increased " ..v:Name().. "'s experience by " ..split.. ".")
				end
			end
		end)		
	end
})

if(SERVER) then
	netstream.Hook("statIncrease", function(client, attrib, value)
		local char = client:getChar()
		local ptAttrib = char:getData("ptAttrib", 0)
		
		if(ptAttrib > 0) then
			char:setData("ptAttrib", ptAttrib - 1, false, player.GetAll())
			char:setAttrib(attrib, value)
			
			client:notify("You have increased your " ..(nut.attribs.list[attrib] and nut.attribs.list[attrib].name).. ".")
			
			nut.log.addRaw(client:Name().. " increased their " ..(nut.attribs.list[attrib] and nut.attribs.list[attrib].name).. " from " ..(value-1).. " to " ..value.. ".")
		end
	end)
	
	netstream.Hook("skillIncrease", function(client, skill, value)
		local char = client:getChar()
		local ptSkill = char:getData("ptSkill", 0)
		
		if(ptSkill > 0) then
			char:setData("ptSkill", ptSkill - 1, false, player.GetAll())
			
			char:updateSkill(skill, value)
			
			client:notify("You have increased your " ..(nut.skills.list[skill] and nut.skills.list[skill].name).. ".")
			
			nut.log.addRaw(client:Name().. " increased their " ..(nut.skills.list[skill] and nut.skills.list[skill].name).. " from " ..(value-1).. " to " ..value.. ".")
		end
	end)
	
	netstream.Hook("perkAdd", function(client, perk)
		local char = client:getChar()
		local ptPerk = char:getData("ptPerk", 0)
		
		if(ptPerk > 0) then
			char:setData("ptPerk", ptPerk - 1, false, player.GetAll())
			
			client:giveTrait(perk)
			
			client:notify("You have gained the " ..(TRAITS.traits[perk] and TRAITS.traits[perk].name).. " perk.")
			
			nut.log.addRaw(client:Name().. " has gained the " ..(TRAITS.traits[perk] and TRAITS.traits[perk].name).. " perk.")
		end
	end)
end