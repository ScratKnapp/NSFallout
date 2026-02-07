local PLUGIN = PLUGIN
PLUGIN.name = "Dungeon Doors"
PLUGIN.author = "Vex & Chancer"
PLUGIN.desc = ""

PLUGIN.doors = PLUGIN.doors or {}

if (SERVER) then
	function PLUGIN:SaveDoors()
		local data = {}

		for _, v in ipairs(ents.FindByClass("nut_teledoor")) do		
			if (!IsValid(v)) then continue end
			
			data[#data+1] = {
				pos = v:GetPos(),
				ang = v:GetAngles(), 
				model = v:GetModel(),
				mat = v:GetMaterial(),
				color = v:GetColor(),
				
				doorID = v:getNetVar("doorID"), 
				doorLinkID = v:getNetVar("doorLinkID"), 
				-- doorFlip = v:getNetVar("doorFlip"),
				
				pass = v:getNetVar("password", false),
				enabled = v:GetEnabled(),
				doorTitle = v:GetDoorTitle(),
			}
		end

		self:setData(data)
	end

	function PLUGIN:LoadData()
		pcall(function()
			local data = self:getData({})
			if (!data) then return end

			local doors = {}

			for _, v in pairs(data) do
				local ent = ents.Create("nut_teledoor")
				ent:SetPos(v.pos)
				ent:SetAngles(v.ang)
				ent:SetModel(v.model)
				ent:SetMaterial(v.material or "")
				ent:SetColor(v.color or Color(255,255,255))
				ent:SetRenderMode(RENDERMODE_TRANSALPHA)
				
				ent:setNetVar("doorID", v.doorID)
				ent:setNetVar("doorLinkID", v.doorLinkID)
				-- ent:setNetVar("doorFlip", v.doorFlip)
				
				ent:setNetVar("password", v.pass)
				
				ent:SetEnabled(v.enabled)
				ent:SetDoorTitle(v.doorTitle or "")
				
				ent:Spawn()
				
				local physObj = ent:GetPhysicsObject()

				if (IsValid(physObj)) then
					physObj:EnableMotion(false)
					physObj:Wake()
				end
				
				if(IsValid(ent) and v.doorID) then
					if(!PLUGIN.doors) then --this shouldn't need to be here
						PLUGIN.doors = {}
					end
					
					PLUGIN.doors[v.doorID] = ent
				end
			end
		end)
	end
	
	function PLUGIN:getNextDoorID()
		local highest = -1
	
		for k, v in pairs(PLUGIN.doors) do --finds the highest valued key in the table
			if(k > highest) then
				highest = k
			end
		end
	
		return highest + 1
	end

	netstream.Hook("doorToggleState", function(entity)
		if (entity:getNetVar("status") != true) then
			entity.dummy:Fire("SetAnimation", "open", 0)
			entity:setNetVar("status", true)
			timer.Simple(3.5, function() entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS) end)
		else
			entity.dummy:Fire("SetAnimation", "close", 0)
			entity:setNetVar("status", false)
			timer.Simple(1.5, function() entity:SetCollisionGroup(COLLISION_GROUP_NONE) end)
		end
	end)

	netstream.Hook("doorTeleOpen", function(player, entity)
		entity:Fade(player)
	end)

	netstream.Hook("doorTeleWrongPW", function(player, entity)
		entity:EmitSound("doors/door_locked2.wav")
		player:notify("Wrong password!")
	end)
else
	netstream.Hook("doorTelePass", function(entity)
		Derma_StringRequest(
			"PASSWORD REQUIRED",
			"PASSWORD REQUIRED",
			"",
			function(password)
				if (entity:getNetVar("password", "0000") == password) then
					netstream.Start("doorTeleOpen", entity)
					else
					netstream.Start("doorTeleWrongPW", entity)
				end
			end
		)
	end)
end

nut.command.add("telecreate", {
	syntax = "<string model>",
	adminOnly = true,
	onRun = function(client, arguments, doorModel)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal*5
		local doorModel = arguments[1]
		
		if (!doorModel) then
			client:notify("Invalid model.")
		else
			local entity = ents.Create("nut_teledoor")
			entity:SetModel(doorModel)
			entity:SetPos(hitpos)
			entity:SetSolid(SOLID_VPHYSICS)
			entity:PhysicsInit(SOLID_VPHYSICS)
			
			local doorID = PLUGIN:getNextDoorID()
			
			entity:setNetVar("doorID", doorID)
			
			-- entity:setNetVar("doorFlip", arguments[2])
			
			entity:Spawn()
			
			if(!IsValid(entity:GetPhysicsObject())) then
				SafeRemoveEntity(entity)
				client:notify("Model has no physics object.")
			end
			
			PLUGIN.doors[doorID] = entity
		end
	end
})

-- nut.command.add("teleflip", {
	-- syntax = "<boolean flip>",
	-- adminOnly = true,
	-- onRun = function(client, arguments)
		-- local trace = client:GetEyeTraceNoCursor()
		-- local entity = trace.Entity
		-- local value = arguments[1]
		-- if (IsValid(entity) and entity:GetClass("nut_teledoor")) then
			-- entity:setNetVar("doorFlip", value)
		-- end
	-- end
-- })

nut.command.add("telemodel", {
	syntax = "<string model>",
	adminOnly = true,
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local entity = trace.Entity
		
		if (IsValid(entity) and entity:GetClass("nut_teledoor")) then
			if (!arguments[1]) then
				client:notify("Invalid argument.")
			else
				entity:SetModel(arguments[1])
				entity:SetSolid(SOLID_VPHYSICS)
				entity:PhysicsInit(SOLID_VPHYSICS)
			end
		end
	end
})

nut.command.add("telepass", {
	syntax = "<string password>",
	adminOnly = true,
	onRun = function(client, arguments)
		local data = {}
		data.start = client:GetShootPos()
		data.endpos = data.start + client:GetAimVector() * 96
		data.filter = client
			
		local target = util.TraceLine(data).Entity
		local password = arguments[1]
		
		if (IsValid(target) and target:GetClass():match("nut_teledoor")) then
			local linkedDoor = target:findLinkedDoor()
		
			if (password) then
				target:setNetVar("password", password)

				if(linkedDoor) then
					linkedDoor:setNetVar("password", password)
				end
				
				client:notify("Password set.")
			else
				target:setNetVar("password", false)
				
				if(linkedDoor) then
					linkedDoor:setNetVar("password", false)
				end

				client:notify("Password removed.")
			end
		end
	end
})

nut.command.add("teledisabled", {
	syntax = "[boolean true or false]",
	adminOnly = true,
	onRun = function(client, arguments)
		local data = {}
		data.start = client:GetShootPos()
		data.endpos = data.start + client:GetAimVector() * 96
		data.filter = client
			
		local target = util.TraceLine(data).Entity
		local disabled = arguments[1]

		if (IsValid(target) and target:GetClass():match("nut_teledoor")) then
			local linkedDoor = target:findLinkedDoor()
		
			if (disabled == "true") then
				target:SetEnabled(false)

				if(linkedDoor) then
					linkedDoor:SetEnabled(false)
				end
				
				client:notify("Door disabled.")
				
			elseif (disabled == "false") then
				target:SetEnabled(true)
				
				if(linkedDoor) then
					linkedDoor:SetEnabled(true)
				end

				client:notify("Door enabled.")
				
			else
			
				client:notify("Invalid boolean!")		
				
			end
		end
	end
})

nut.command.add("checkpassword", {
	superAdminOnly = true,
	onRun = function(client, arguments)
		local data = {}
		data.start = client:GetShootPos()
		data.endpos = data.start + client:GetAimVector() * 96
		data.filter = client
			
		local target = util.TraceLine(data).Entity
		
		if (IsValid(target) and target:GetClass():match("nut_teledoor")) then
		local getPassword = target:getNetVar("password", false)
			if (getPassword) then
				client:notify(getPassword)
			else
				client:notify("This door has no password!")
			end
		else
			client:notify("Invalid target!")
		end
	end
})

nut.command.add("cleanteledoors", {
	syntax = "<number radius>",
	adminOnly = true,
	onRun = function(client, arguments)
		if(!tonumber(arguments[1])) then
			client:notify("Invalid radius!")
		else
			for k, v in pairs(ents.FindInSphere(client:GetPos(), arguments[1] or 64)) do	
				if (IsValid(v) and v:GetClass() == "nut_teledoor") then
					SafeRemoveEntity(v)
				end
			end
		end	
	end
}) 

nut.command.add("saveteledoors", {
	adminOnly = true,
	onRun = function(client, arguments)	
		if (SERVER) then
			PLUGIN:SaveDoors()
		end
	end
})