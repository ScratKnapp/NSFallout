local PLUGIN = PLUGIN

PLUGIN.name = "Turn System"
PLUGIN.author = "Chancer"
PLUGIN.desc = "A turn system."

PLUGIN.helperFuncs = PLUGIN.helperFuncs or {}

--[[
--just some default turn tables for convenience
PLUGIN.turns[1] = {
	name = "Combat 1",
	entities = {

	},
	order = {
		[1] = "Adventurer",
		[2] = "Monster",
	},
	current = 1,
}

PLUGIN.turns[2] = {
	name = "Combat 2",
	entities = {
	
	},
	order = {
		[1] = "Adventurer",
		[2] = "Enemy",
	},
	current = 1,
}
--]]

PLUGIN.turns = PLUGIN.turns or {
	{
		name = "Combat 1",
		entities = {

		},
		order = {
			[1] = "Player",
			[2] = "Enemy",
		},
		current = 1,
	},
	{
		name = "Combat 2",
		entities = {

		},
		order = {
			[1] = "Player",
			[2] = "Enemy",
		},
		current = 1,
	},
	{
		name = "Combat 3",
		entities = {

		},
		order = {
			[1] = "Player",
			[2] = "Enemy",
		},
		current = 1,
	},
	{
		name = "Combat 4",
		entities = {

		},
		order = {
			[1] = "Player",
			[2] = "Enemy",
		},
		current = 1,
	},
}

--adds an entity to a turn table
function PLUGIN:turnAdd(id, entity, team)
	PLUGIN.turns[id] = PLUGIN.turns[id] or {}
	PLUGIN.turns[id]["entities"] = PLUGIN.turns[id]["entities"] or {}
	
	PLUGIN.turns[id]["entities"][entity] = team --adds the entity to the table
end

--adds a team to a turn table
function PLUGIN:turnAddTeam(id, team)
	PLUGIN.turns[id] = PLUGIN.turns[id] or {}
	PLUGIN.turns[id]["order"] = PLUGIN.turns[id]["order"] or {}
	
	PLUGIN.turns[id]["order"][#PLUGIN.turns[id]["order"] + 1] = team --adds the team to the ordering table
end

--returns every member of the specified team in the table
function PLUGIN:turnGetTeam(id, team)
	PLUGIN.turns[id] = PLUGIN.turns[id] or {}
	PLUGIN.turns[id]["order"] = PLUGIN.turns[id]["order"] or {}
	
	local members = {}
	for k, v in pairs(PLUGIN.turns[id]["entities"]) do
		if(string.lower(v) == string.lower(team)) then
			members[k] = v
		end
	end
	
	return members
end

--removes an entity from a turn table
function PLUGIN:turnRemove(id, entity)
	PLUGIN.turns[id] = PLUGIN.turns[id] or {}
	PLUGIN.turns[id]["entities"] = PLUGIN.turns[id]["entities"] or {}

	PLUGIN.turns[id]["entities"][entity] = nil
end

--removes a team from a turn table
function PLUGIN:turnRemoveTeam(id, teamID)
	PLUGIN.turns[id] = PLUGIN.turns[id] or {}
	PLUGIN.turns[id]["order"] = PLUGIN.turns[id]["order"] or {}
	
	PLUGIN.turns[id]["order"][teamID] = nil --adds the team to the ordering table
end

--advances the specified turn to the next team
function PLUGIN:turnAdvance(id, cur)
	local turn = PLUGIN.turns[id]
	if(!turn) then
		return false
	end
	
	if(!cur) then
		cur = turn.current
	end
	
	local newTurnID = (cur + 1) 
	if(newTurnID > #turn.order) then
		newTurnID = 1
	end
	
	local newTurn = turn.order[newTurnID] --String name for whose turn it is
	
	turn.current = newTurnID
	
	for entity, team in pairs(turn.entities) do
		if(!IsValid(entity)) then continue end
	
		if(newTurn == turn.order[team]) then
			entity:turnProcess(newTurn, true) --each entity processes its turn
		else
			entity:turnProcess(newTurn, false) --each entity processes its turn
		end
	end

	return newTurn
end	

--finds a turn table by its name
function PLUGIN:turnByName(name)
	local id
	for k, v in pairs(PLUGIN.turns) do
		if(string.lower(v.name) == string.lower(name)) then
			id = k
			break
		elseif(string.find(string.lower(v.name), string.lower(name))) then
			id = k
		end
	end
	
	return PLUGIN.turns[id], id
end

--checks to see if a turn table has the specified team or something close to it
function PLUGIN:turnHasTeam(id, team)
	local findTeam

	local teams = PLUGIN.turns[id].order
	for k, v in pairs(teams) do
		if(string.lower(v) == string.lower(team)) then
			return v
		elseif(string.find(string.lower(v), string.lower(team))) then
			findTeam = v
		end
	end
	
	return findTeam
end

--gets the current turn in the ordering
function PLUGIN:turnCurrent(id)
	if(PLUGIN.turns[id]) then
		return PLUGIN.turns[id].current
	end
	
	return 1
end

PLUGIN.helperFuncs["turnProcess"] = function(self, turn, you)
	if(you) then
		if(self:GetMoveType() != MOVETYPE_NOCLIP) then
			self:setNetVar("showAPCircle", self:GetPos() + self:GetUp()) --puts a circle centered at current location
			self:setNetVar("turnOverIcon", nil)
		end
		
		local filter = RecipientFilter()
		filter:AddPlayer(self)
		self:EmitSound("buttons/blip1.wav", 75, 50, 1, CHAN_AUTO, 0, 1, filter)
		
		self:restoreAP()

		local buffs = self:getBuffs() or {}
		for buffID, buff in pairs(buffs) do
			if(buff.func) then
			
			end
		
			if(buff.dmg) then --damaging spells
				local dmgT = buff.dmgT or "Blunt"
				local dmg = self:receiveDamage(buff.dmg, dmgT) --gets the damage based on their resistances
				self:addHP(dmg * -1) --reduce their hp by the dmg
				
				nut.chat.send(self, "turnchat", "You have taken " ..buff.dmg.. " {" ..dmgT.. "} damage from " ..(buff.name or "Unknown").. ".")
				--nut.plugin.list["chatboxextra"]:ChatboxSend(self, "turnchat", "You have taken " ..dmg.. " {" ..dmgT.. "} damage from " ..(buff.name or "Unknown").. ".")
			end
			
			if(buff.dmgP) then --damaging spells
				local dmgT = buff.dmgT or "Blunt"
				
				local dmg = self:receiveDamage(buff.dmgP * self:getMaxHP(), dmgT) --gets the damage based on their resistances
				self:addHP(dmg * -1) --reduce their hp by the dmg
				
				nut.chat.send(self, "turnchat", "You have taken " ..buff.dmg.. " {" ..dmgT.. "} damage from " ..(buff.name or "Unknown").. ".")
				--nut.plugin.list["chatboxextra"]:ChatboxSend(self, "turnchat", "You have taken " ..dmg.. " {" ..dmgT.. "} damage from " ..(buff.name or "Unknown").. ".")
			end

			if(buff.duration) then --counts down the duration
				if(buff.duration <= 0) then
					self:removeBuff(buff, buff.uid)
					
					if(self:IsPlayer()) then
						nut.chat.send(self, "turnchat", (buff.name or "Unknown").. " has worn off.")
					end
					--nut.plugin.list["chatboxextra"]:ChatboxSend(self, "turnchat", (buff.name or "Unknown").. " has worn off.")
				else
					if(self:IsPlayer()) then
						nut.chat.send(self, "turnchat", "You are affected by " ..(buff.name or "Unknown").. " for " ..(buff.duration or "Unknown").. " more turns.")
					end
					--nut.plugin.list["chatboxextra"]:ChatboxSend(self, "turnchat", "You are affected by " ..(buff.name or "Unknown").. " for " ..(buff.duration or "Unknown").. " more turns.")
					
					buff.duration = buff.duration - 1
					
					local netBuff = {
						uid = buff.uid,
						name = buff.name,
						duration = buff.duration,
					}
					
					local JSONTbl = util.TableToJSON(netBuff)
					
					--local turnPlayers = {}
					--for k, v in pairs(turnPlayers) do
						nut.plugin.list["combat"]:buffNetworkAll(self, self, JSONTbl, buffID)
					--end
				end
			end
		end	
		
		local cooldowns = self:getCooldowns() or {}
		for action, data in pairs(cooldowns) do
			local duration = data.duration
			duration = duration - 1
		
			if(duration <= 0) then
				self:removeCooldown(action)
			else
				cooldowns[action] = {duration = duration, weapon = data.weapon}

				nut.plugin.list["combat"]:cdNetworkAll(self, action, duration, data.weapon)
			end
		end
	
		nut.plugin.list["chatboxextra"]:ChatboxSend(self, "turnchat", "Turn Change: " ..turn.. "'s turns. (YOU)")
	else
		self:setNetVar("showAPCircle", nil)
	
		nut.plugin.list["chatboxextra"]:ChatboxSend(self, "turnchat", "Turn Change: " ..turn.. "'s turns.")
	end
end

PLUGIN.helperFuncs["addAP"] = function(self, add)
	local ap = self:getAP()

	local new = math.Clamp(ap + add, 0, self:getAPMax())

	self:setNetVar("ap", new)
end

PLUGIN.helperFuncs["getAP"] = function(self)
	return self:getNetVar("ap", self:getAPMax())
end

PLUGIN.helperFuncs["getAPMax"] = function(self)
	return self:getNetVar("apMax", self.ap or 2)
end

PLUGIN.helperFuncs["restoreAP"] = function(self)
	self:setNetVar("ap", self:getAPMax())
end

nut.command.add("apcircle", {
	onRun = function(client, arguments)	
		local apCircle = client:getNetVar("showAPCircle", nil)
		
		if(apCircle) then
			client:setNetVar("showAPCircle", nil)
		else
			client:setNetVar("showAPCircle", client:GetPos() + client:GetUp())
		end
	end
})

nut.command.add("endturn", {
	onRun = function(client, arguments)	
		local turnOver = client:getNetVar("turnOverIcon", nil)
		
		if(turnOver) then
			client:setNetVar("turnOverIcon", nil)
		else
			client:setNetVar("turnOverIcon", true)
		end
	end
})

--debug function
nut.command.add("endturnall", {
	adminOnly = true,
	onRun = function(client, arguments)	
		for k, v in ipairs(player.GetAll()) do
			v:setNetVar("turnOverIcon", nil)
		end
	end
})

nut.command.add("turnnext", {
	onRun = function(client, arguments)	
		local swep = client:GetWeapon("nut_turnswep")
		
		if(IsValid(swep)) then
			local turnID = swep:getTurnID()
			local team = PLUGIN:turnAdvance(turnID)
			
			if(team) then
				client:notify(team.. "'s turn.")
			end
		end
	end
})

nut.command.add("charrestoreap", {
	syntax = "<string name>",
	adminOnly = true,
	onRun = function(client, arguments)	
		local target = nut.command.findPlayer(client, arguments[1])
		if(target) then
			target:restoreAP()
			
			client:notify(target:Name().. "'s AP has been restored.")
		end
	end
})

nut.command.add("centrestoreap", {
	adminOnly = true,
	onRun = function(client, arguments)	
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity) and entity.combat) then
			entity:restoreAP()

			client:notify(entity:Name() .. "'s AP restored.")
		else
			client:notify("You must be looking at a combat entity.")
		end		
	end
})

--chattype for turn changing messages
nut.chat.register("turnchat", {
	onGetColor = function(speaker, text)
		return Color(150,75,75)
	end,
	onChatAdd = function(speaker, text)
		chat.AddText(Color(150,75,75), text)
	end,
	filter = "actions",
	font = "nutChatFontCombat",
	onCanHear = 1,
	deadCanChat = true
})

if CLIENT then
	local function drawTurnDone()
		local textPosX = 0
		local textPosY = 0
	
		local text = "End Turn"
		
		surface.SetFont("nutChatFontCombat")
	
		local textSizeX, textSizeY = surface.GetTextSize(text)
		
		surface.SetTextColor(0, 255, 0)
		surface.SetTextPos(textPosX-textSizeX*0.5, textPosY-textSizeY*0.5) 
		surface.DrawText(text)
	end

	function PLUGIN:PostDrawOpaqueRenderables()
		local client = LocalPlayer()
		
		local circlePos = client:getNetVar("showAPCircle")
		if (circlePos) then
			local agi = client:getChar():getAttrib("agi", 0)
			local circleRad = (235 + agi*52)
			
			local trait = client:hasTrait("moving_target")
			if(trait) then
				circleRad = circleRad * 2
			end
		
			cam.Start3D2D(circlePos,Angle(0,0,0),1)
				surface.DrawCircle(0,0,circleRad*1,255,255,255,255)
				render.DrawLine(Vector(0,0,0),Vector(0,0,40),255,255,255,255)
			cam.End3D2D()
			
			cam.Start3D2D(circlePos,Angle(0,0,0),1)
				surface.DrawCircle(0,0,circleRad*2,255,255,255,255)
				render.DrawLine(Vector(0,0,0),Vector(0,0,40),255,255,255,255)
			cam.End3D2D()
		end
		
		for k, v in ipairs(player.GetAll()) do
			if(v == client) then continue end
		
			local turnOverIcon = v:getNetVar("turnOverIcon")
			if (turnOverIcon) then
				local position = v:GetPos()+v:GetUp()*80
				local angles = v.turnOverAngle or v:GetAngles()
				
				v.turnOverAngle = angles+(Angle(0,0.25,0))
				if(v.turnOverAngle.y >= 360) then
					v.turnOverAngle.y = 0
				end
				
				angles:RotateAroundAxis(angles:Forward(), 90)
				angles:RotateAroundAxis(angles:Right(), 270)

				cam.Start3D2D(position,angles,0.5)
					drawTurnDone()
				cam.End3D2D()
				
				cam.Start3D2D(position,angles+Angle(0,180,0),0.5)
					drawTurnDone(180)
				cam.End3D2D()
			end
		end
	end
end