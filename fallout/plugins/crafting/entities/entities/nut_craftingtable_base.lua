local PLUGIN = PLUGIN

ENT.Type = "anim"
ENT.PrintName = "Crafting Table Base"
ENT.Author = " "
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.Category = "NutScript - Crafting"
ENT.RenderGroup = RENDERGROUP_BOTH

--for saving purposes
ENT.craftingbench = true

ENT.model = "models/props_c17/FurnitureTable002a.mdl"

ENT.tblLevel = 1 --crafting level of the bench

if (SERVER) then
	function ENT:Initialize()
		--self:SetModel("models/props_c17/FurnitureTable002a.mdl")
		self:SetModel(self.model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		
		local physicsObject = self:GetPhysicsObject()
		if ( IsValid(physicsObject) ) then
			physicsObject:Wake()
		end
		
		self.receivers = {}
		
		timer.Simple(1, function()
			nut.inventory.instance("grid", {10,10})
				:next(function(inventory)
					if(IsValid(self) and self.setInventory) then --why is this necessary?
						self:setInventory(inventory)
					end
				end)
		end)
	end
	
	function ENT:setInventory(inventory)
		assert(inventory, "Storage setInventory called without an inventory!")
		self:setNetVar("id", inventory:getID())

		hook.Run("StorageInventorySet", self, inventory)
	end	

	function ENT:Use(activator)
		if(self.profession) then
			if(activator:hasTrait(self.profession)) then
				netstream.Start(activator, "nut_CraftWindow", activator, self.profession, self.PrintName, self) 
			else
				activator:notify("You do not know this profession.")
			end
		else
			netstream.Start(activator, "nut_CraftWindow", activator, nil, self.PrintName, self)
		end
	end

	function ENT:getInv()
		return nut.item.inventories[self:getNetVar("id", 0)]
	end	
	
	function ENT:OnRemove()
		if (!self.nutForceDelete) then
			if (!nut.entityDataLoaded) then return end
			if (self.nutIsSafe) then return end
			if (nut.shuttingDown) then return end
		end
		
		self:deleteInventory()
		PLUGIN:saveTables()
	end
	
	function ENT:deleteInventory()
		local inventory = self:getInv()
		if (inventory) then
			inventory:delete()

			if (not self.nutForceDelete) then
				--hook.Run("StorageEntityRemoved", self, inventory)
			end

			self:setNetVar("id", nil)
		end
	end
	
	function ENT:Think()
		--if held with physgun, gravgun, or hands
		if(self:IsPlayerHolding()) then
			self.playerMoved = true
		elseif(self.playerMoved) then
			self.playerMoved = nil

			PLUGIN:saveTables()
		end
	end
else
	netstream.Hook("nut_CraftWindow", function(client, prof, name, ent)
		if (IsValid(nut.gui.crafting)) then
			nut.gui.crafting:Remove()
			return
		end
		
		surface.PlaySound("items/ammocrate_close.wav")
		nut.gui.crafting = vgui.Create("nut_Crafting")
		nut.gui.crafting.profession = prof
		nut.gui.crafting.name = name
		nut.gui.crafting.ent = ent
		nut.gui.crafting:Center()
	end)

	function ENT:Initialize()
	end
	
	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:OnRemove()
	end
end

if(CLIENT) then
	ENT.DrawEntityInfo = true
	local toScreen = FindMetaTable("Vector").ToScreen
	local colorAlpha = ColorAlpha
	local drawText = nut.util.drawText
	local configGet = nut.config.get

	function ENT:onDrawEntityInfo(alpha)
		local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)))
		local x, y = position.x, position.y

		local tx, ty = drawText(self.PrintName, x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 2)
	end
end
