local PLUGIN = PLUGIN
PLUGIN.name = "Crafting"
PLUGIN.author = "Black Tea (NS 1.0), Rusty Shackleford (NS 1.1), Chancer (NS 1.1 Beta)"
PLUGIN.desc = "Allows you craft some items. And it fucking works."

RECIPES = {}
RECIPES.recipes = {}
function RECIPES:Register( tbl )
	if !tbl.CanCraft then
		function tbl:CanCraft( player )
			local mult --used to check if we have multiple of the same item, rather than a stack.
			for k, v in pairs( self.items ) do
				local inv = player:getChar():getInv()
				local item = inv:getFirstItemOfType(k)
				
				if !inv:getFirstItemOfType(k) then
					return false
				end
				
				if (inv:getFirstItemOfType(k) and item:getData("Amount") == nil) then
					local count = inv:getItemCount(k)
					if (count >= v) then
						mult = true
					else
						return false
					end
				end
				
				if (inv:getFirstItemOfType(k)) then
					if (!mult and tonumber(item:getData("Amount")) < v and allStacks(inv, k) < v) then
						return false
					else
						mult = false
					end
				end
			end
			return true
		end
	end
	if !tbl.ProcessCraftItems then
		function tbl:ProcessCraftItems( player )
			player:EmitSound("items/ammo_pickup.wav") --change this
			
			local char = player:getChar()
			
			--[[
			for k, v in pairs(self.items) do
				local inventory = char:getInv()	
				local itemObj = inventory:getFirstItemOfType(k)
				
				if(inventory:getFirstItemOfType(k)) then
					if (!itemObj.maxstack) then --non stack items

						local count = 1
						local part = inventory:getFirstItemOfType(k)	
						part:remove()
						while (count < v) do
							part = inventory:getFirstItemOfType(k)

							part:remove()
							count = count + 1
						end
					end
					
					if (itemObj.maxstack) then --if we're dealing with quantities
						if (tonumber(itemObj:getData("Amount", 1)) >= v) then --necessary stacks are all in one item
							itemObj:setData("Amount", tonumber(itemObj:getData("Amount")) - v)
							if (tonumber(itemObj:getData("Amount", 1)) == 0) then
								itemObj:remove()
							end
						else --necessary stacks are split across multiple items
							local all = inventory:getItems()
							for m, extraStack in pairs (all) do
								if (k == extraStack.uniqueID) then
									local amount = extraStack:getData("Amount", 1)
									if(amount <= v) then
										v = v - amount
										extraStack:remove()
									else
										extraStack:setData("Amount", amount - v)
									end
								end
							end
						end
					end
				end
			end
			--]]
			
			local requiredItems = self.items
			local items = char:getInv():getItems()
			
			--checks that the player has all the items
			local count
			local success = true
			for k, required in pairs(requiredItems) do --basically goes for the least common ingredient first
				count = 0
				
				for id, item in pairs(items, false) do	
					if(item.uniqueID != k) then continue end
				
					if(count >= required) then
						break
					end
					
					--nothing left of this one
					if(item.mark and item.mark == 0) then
						continue
					end
					
					local quan = item.mark or item:getData("Amount", 1)
					
					count = count + quan
					
					local name = item.prefix or item:getName()
					if(count > required) then
						item.mark = count - required --marks the item with how much is left
					else
						item.mark = 0 --marks the item with 0 for later deletion
					end
				end
				
				--not enough of some item, so it fails
				if(count < required) then
					success = false
					break
				end
			end
			
			if(success) then
				for k, v in pairs(items) do
					if(v.mark == 0) then
						v:remove()
					elseif(v.mark) then
						v:setData("Amount", v.mark)
						v.mark = nil
					end
				end
				
				for k, v in pairs(self.result) do
					player:getChar():getInv():addSmart(k, v, player:getItemDropPos(), {creator = char:getID()})
					
					nut.log.addRaw(player:Name().. " crafted " ..nut.item.list[k].name.. ".")
				end
				
				if(self.xp) then
					PLUGIN:giveCraftXP(char, self.profession, self.xp)
				end
				
				player:notifyLocalized("You have created %s.", self.name)
			else
				client:notify("You do not have the required items.")
				
				for k, v in pairs(items) do
					v.mark = nil
				end
			end
		end
	end
	
	self.recipes[tbl.uid] = tbl
end

--finds the total amount of material in a person's inventory (across multiple items.)
function allStacks(inventory, uid)
	local all = inventory:getItems()
	local quantity = 0
	
	for k, v in pairs (all) do
		if (uid == v.uniqueID) then
			local amount = v:getData("Amount")
			if(amount != nil) then
				quantity = quantity + amount
			end
		end
	end
	
	return quantity
end

nut.util.include("sh_menu.lua")
nut.util.include("sh_commands.lua")
nut.util.include("sh_recipies.lua")
nut.util.include("sh_vars.lua")

function RECIPES:Get( name )
	return self.recipes[ name ]
end

function RECIPES:GetAll()
	return self.recipes
end

function RECIPES:GetItem( item )
	local tblRecipe = self:Get( item )
	return tblRecipe.items
end

function RECIPES:GetResult( item )
	local tblRecipe = self:Get( item )
	return tblRecipe.result
end

function RECIPES:CanCraft(player, item)
	local tblRecipe = self:Get(item)
	if PLUGIN.reqireBlueprint then
		if !tblRecipe.noBlueprint then
			local name_bp = (tblRecipe.uid)
			if !player:getFirstItemOfType(name_bp) then
				return 2
			end
		end
	end
	if !tblRecipe:CanCraft( player ) then
		return 1
	end
	return 0
end

local entityMeta = FindMetaTable("Entity")
function entityMeta:IsCraftingTable()
	return self:GetClass() == "nut_craftingtable"	
end

if CLIENT then return end
util.AddNetworkString("nut_CraftItem")
net.Receive("nut_CraftItem", function(length, client)
	local item = net.ReadString()
	local cancraft = RECIPES:CanCraft(client, item)
	local tblRecipe = RECIPES:Get(item)
	if cancraft == 0 then
		tblRecipe:ProcessCraftItems(client)
	else
		if cancraft == 2 then
			client:notify("You don't have the required blueprint.")
		elseif cancraft == 1 then
			client:notify("You don't have the required materials.")
		end
	end
end)

function PLUGIN:saveTables()
	local data = {}
	for _, v in ipairs(ents.GetAll()) do
		if(v.craftingbench) then
			data[#data + 1] = {
				ent = v:GetClass(),
				pos = v:GetPos(),
				angles = v:GetAngles(),
				invID = v:getNetVar("id")
			}
		end
	end
	
	self:setData(data)
end

--[[
function PLUGIN:SaveData()
	local data = {}
	for k, _ in pairs(benches) do
		for _, v in pairs(ents.FindByClass(k)) do
			data[#data + 1] = {
				ent = v:GetClass(),
				pos = v:GetPos(),
				angles = v:GetAngles(),
			}
		end
	end
	
	self:setData(data)
end
--]]

function PLUGIN:loadTables()
	local data = self:getData() or {}
	for k, v in pairs(data) do
		if(v.ent) then
			local position = v.pos
			local angles = v.angles
			local entity = ents.Create(v.ent)
			entity:SetPos(position)
			entity:SetAngles(angles)
			entity:Spawn()
			entity:Activate()
			
			entity:setNetVar("id", v.invID)
			
			local phys = entity:GetPhysicsObject()
			if phys and phys:IsValid() then
				phys:EnableMotion(false)
			end
		end
	end
	
	self.loadedData = true
end

function PLUGIN:LoadData()
	pcall(function()
		PLUGIN:loadTables()
	end)
end

if CLIENT then
	surface.CreateFont("nut_NotiFont", {
		font = "Myriad Pro",
		size = 16,
		weight = 500,
		antialias = true
	})
end

function PLUGIN:giveCraftXP(char, profession, xp)
	local craftTbl = char:getData("craft", {})

	if(istable(profession)) then
		for k, v in pairs(profession) do
			local craftLevel = (craftTbl[k] or 0)
		
			local newXP = xp
			if(craftLevel > 1) then
				newXP = newXP / (craftLevel ^ (1/3))
			end
		
			craftTbl[k] = math.Round(craftLevel + (newXP / table.Count(profession)), 2)
		end
	else
		local craftLevel = (craftTbl[profession] or 0)
	
		local newXP = xp
		if(craftLevel > 1) then
			newXP = newXP / (craftLevel ^ (1/3))
		end
	
		craftTbl[profession] = math.Round(craftLevel + newXP, 2)
	end
	
	char:setData("craft", craftTbl)
end

nut.command.add("charsetprofession", {
	adminOnly = true,
	syntax = "<string targ> <string prof> <number amt>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])
		
		if(!arguments[2]) then
			client:notify("No profession specified.")
			return false
		end
		
		if(!arguments[3]) then
			client:notify("No profession specified.")
			return false
		end
		
		if(IsValid(target) and target:getChar()) then
			local char = target:getChar()
			local prof = char:getData("craft", {})
			prof[arguments[2]] = tonumber(arguments[3])
			char:setData("craft", prof)
			
			client:notify("Successfully set profession level.")
		end
	end
})

nut.command.add("chargetprofession", {
	adminOnly = true,
	syntax = "<string target> <string prof>",
	onRun = function(client, arguments)
		if(!arguments[2]) then
			client:notify("No profession specified.")
			return false
		end
		
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then
			local char = target:getChar()
			local prof = char:getData("craft", {})[arguments[2]]
			
			if(!prof) then
				client:notify("Invalid profession of level is nil.")
			else
				client:notify("Profession level: " ..prof)
			end
		end
	end
})