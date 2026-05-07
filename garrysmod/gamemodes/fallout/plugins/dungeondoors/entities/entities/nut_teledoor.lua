local PLUGIN = PLUGIN
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Dungeon Door"
ENT.Category = "NutScript"
ENT.Spawnable = false
ENT.Editable = true

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 1, "Enabled", {	
		KeyName = "Enabled", 
		Edit = {
			type = "Boolean", 
			title = "Allow Use",
			order = 1, 
		},
	} )
	
	self:NetworkVar( "String", 1, "DoorTitle", {	
		KeyName = "DoorTitle", 
		Edit = {
			type = "Generic", 
			waitforenter = true,
			title = "Door Title",
			order = 2, 
		},
	} )
	
	if ( SERVER ) then
		self:NetworkVarNotify( "Enabled", self.OnEnabled )
	end
end

if (SERVER) then
	function ENT:Initialize(doorModel)
		self:SetModel(tostring(doorModel) or "models/props_c17/door01_left.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(false)
		
		self:SetEnabled(true)
		self:SetDoorTitle("")
		--self:setNetVar("disabled", true)
		self:setNetVar("hidden", true) --nutscript thinks these are doors if you dont do this

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Wake()
		end
	end
	
	function ENT:OnEnabled( name, old, new )
		if (IsValid( self )) then
			self:Input("Enabled", NULL, NULL, new)
			local linkedDoor = self:findLinkedDoor()
			if(IsValid(linkedDoor)) then
				linkedDoor:Input("Enabled", NULL, NULL, new)
			end
		end
	end
		
	function ENT:Fade(player)
		local linkedDoor = self:findLinkedDoor()
	
		if(IsValid(linkedDoor)) then
			self:EmitSound("doors/door1_move.wav", 65)
			linkedDoor:EmitSound("doors/door1_move.wav", 65)

			player:Freeze(true)
			player:setNetVar("sFadeIn", true)
			
			timer.Simple(1, function()	
				local endPos = linkedDoor:GetPos() + (linkedDoor:GetUp() * 20) + (linkedDoor:GetForward() * -50)
				player:SetPos(endPos)
			end)

			timer.Simple(2, function()
				player:Freeze(false)
				player:setNetVar("sFadeIn", false)
				player:SetCollisionGroup(COLLISION_GROUP_WEAPON)
				
				timer.Simple(5, function() 
					if(IsValid(player)) then
						player:SetCollisionGroup(COLLISION_GROUP_PLAYER)
					end
				end)
				
				self:EmitSound("doors/door_wood_close1.wav", 65)
				linkedDoor:EmitSound("doors/door_wood_close1.wav", 65)
			end)
		end
	end

	function ENT:Use(player)
		if ((self.nextUse or 0) > CurTime()) then return end
		self.nextUse = CurTime() + 1

		local linkedDoor = self:findLinkedDoor()

		if (!linkedDoor) then
			player:ChatPrint("This door does not lead anywhere.")
			return false
		end
		
		if (!self:GetEnabled()) then		
			player:notify("This door is disabled.")
			return false
		end

		if (!self:getNetVar("password", false)) then
			self:Fade(player)
		else
			netstream.Start(player, "doorTelePass", self)
			
			linkedDoor:EmitSound("doors/door_locked2.wav")
			self:EmitSound("doors/door_locked2.wav")
		end
	end
	
	function ENT:findLinkedDoor()
		if(IsValid(self:getNetVar("linkedDoor"))) then
			return self:getNetVar("linkedDoor")
		else
			for k, doorEnt in pairs(PLUGIN.doors) do
				if(IsValid(doorEnt) and self:getNetVar("doorID", -1) == doorEnt:getNetVar("doorLinkID", -2)) then
					self:setNetVar("linkedDoor", doorEnt)
					return doorEnt
				end
			end
			
			return false
		end
	end
	
	function ENT:Think()
		--if held with physgun, gravgun, or hands
		if(self:IsPlayerHolding()) then
			self.playerMoved = true
		elseif(self.playerMoved) then
			self.playerMoved = nil

			PLUGIN:SaveDoors()
		end
	end
else
	local Alpha = 0

	hook.Add("HUDPaint", "FadeIn", function()
		if (LocalPlayer():getNetVar("sFadeIn")) then
			Alpha = math.min(Alpha + 15, 255)
		else
			Alpha = math.max(Alpha - 5, 0)
		end

		if (Alpha == 0) then return end

		surface.SetDrawColor(0, 0, 0, Alpha)
		surface.DrawRect(0, 0, ScrW(), ScrH())
	end)
	
	ENT.DrawEntityInfo = true

	function ENT:onDrawEntityInfo(alpha)
		local toScreen = FindMetaTable("Vector").ToScreen
		local colorAlpha = ColorAlpha
		local drawText = nut.util.drawText
		local configGet = nut.config.get
		local text = self:GetDoorTitle()
		
		local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)))
		local x, y = position.x, position.y
		
		if (text != "") then
			drawText(text, x, y, colorAlpha(color_white, alpha), 1, 1, "nutEntDesc", alpha * 0.65)
		end
		-- drawText("(View the photo by pressing +USE button on it)", x, y + 34, colorAlpha(color_white, alpha), 1, 1, "videoFont", alpha * 0.65)
	end
end;