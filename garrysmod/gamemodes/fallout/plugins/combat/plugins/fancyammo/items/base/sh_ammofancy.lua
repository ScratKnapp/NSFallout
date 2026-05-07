ITEM.name = "Ammo Base"
ITEM.desc = "Ammo"
ITEM.category = "Ammunition"
ITEM.model = "models/Items/BoxSRounds.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.ammo = "pistol"
ITEM.ammoAmount = 1

--ITEM.dmgType = ""

ITEM.flag = "v"

--ITEM.maxstack = 100 --set this if you want it to stack with other items of the same type
--ITEM.bullet = "pistol" --use this for magazine stuff, otherwise it'll just load like a normal bullet

--extra function to make ammo saving more reliable, turned off for now.
local function onLoad(item)
	local plugin = nut.plugin.list["ammosave"]
	local client = item.player
	if(client and client:getChar()) then
		local ammoTable = {}
		
		for k, v in ipairs(plugin.ammoList) do
			local ammo = client:GetAmmoCount(v)
			if (ammo > 0) then
				ammoTable[v] = ammo
			end
		end
		
		client:getChar():setData("ammo", ammoTable)
	end
end

--[[
// On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.use = { -- sorry, for name order.
	name = "Load",
	icon = "icon16/add.png",
	onRun = function(item)
		local total = item:getData("Amount", item.ammoAmount) or 1
		local ammo = item.ammo
	
		item.player:GiveAmmo(total, item.ammo)
		item.player:EmitSound("items/ammo_pickup.wav", 110)
		onLoad(item)
		
		return true
	end,
	onCanRun = function(item)
		return true
	end
}
--]]

--[[
// On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.useX = { -- sorry, for name order.
	name = "Load X",
	icon = "icon16/add.png",
	onRun = function(item)
		local client = item.player
	
		local total = item:getData("Amount", item.ammoAmount) or 1
		local ammo = item.ammo
	
		client:requestString("Split", "", function(text)	
			amount = math.Clamp(tonumber(text) or 0, 1, total - 1)
			
			item:setData("Amount", total - amount)
			
			client:GiveAmmo(amount, item.ammo)
			client:EmitSound("items/ammo_pickup.wav", 110)
		end, 1)
		
		return false
	end,
	onCanRun = function(item)
		local total = item:getData("Amount", item.ammoAmount) or 1
		
		if(total < 1) then
			return false
		end
		
		return true
	end
}
--]]

// On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.LoadInto = { -- sorry, for name order.
	name = "Load Into",
	icon = "icon16/add.png",
	isMulti = true,
	multiOptions = function(item, client)
		local targets = {}
		local inventory = client:getChar():getInv()
		
		local equipment = {}
		
		for k, v in pairs(client:getEquip()) do
			local weaponItem = nut.item.instances[v]
		
			if(!weaponItem) then continue end
			if(!weaponItem.ammo) then continue end
			
			if(weaponItem.ammo == item.ammo) then
				equipment[#equipment+1] = weaponItem
			end
		end
		
		for k, v in pairs(inventory:getItems()) do
			if(!v.ammo) then continue end

			if(v.class and v.ammo == item.ammo) then
				equipment[#equipment+1] = v
			end
		end
		
		for k, v in pairs(equipment) do
			local newAbs = {
				name = v:getName(),
				data = v.id
			}
			
			table.insert(targets, newAbs)
		end
		
		return targets
	end,
	onRun = function(item, data)
		if(!data) then return false end

		local weapon = nut.item.instances[data]
		if(!weapon) then return end
	
		local client = item.player

		local magSize = weapon:getData("magSize", weapon.magSize) or 0

		local newAmt = item:getData("Amount", item.ammoAmount)
		local curAmt = 0
		
		local loaded = weapon:getData("currentMag", {})
		if(!table.IsEmpty(loaded)) then
			local oldAmmo = loaded[1]
			local oldAmmoAmt = loaded[2]
		
			local oldAmmoItem = nut.item.list[oldAmmo]
			if((oldAmmoItem and oldAmmoItem.dmgT) != item.dmgT) then
				nut.plugin.list["fancyammo"]:EjectAmmo(client, weapon)
			else
				--if gun is already full of this type of ammo
				if(oldAmmoAmt == magSize) then
					client:notify("Gun is already fully loaded.")
					return false
				end
				
				curAmt = oldAmmoAmt
			end
		end
		
		newAmt = newAmt + curAmt
		local leftover = newAmt - magSize
		newAmt = math.Clamp(newAmt, 0, magSize)

		local newMag = {item.uniqueID, newAmt}
		weapon:setData("currentMag", newMag)

		if(leftover > 0) then
			item:setData("Amount", leftover)
		else
			item:remove()
		end
		
		weapon:sync()

		client:EmitSound("items/ammo_pickup.wav", 75)

		local combatMsg = client:Name().. " reloads " ..item:getName()
		nut.plugin.list["chatboxextra"]:ChatboxSend(client, "react_npc", combatMsg)

		return false
	end,
	onCanRun = function(item)
		local total = item:getData("Amount", item.ammoAmount) or 1
		
		if(total < 1) then
			return false
		end
		
		return true
	end
}

ITEM.functions.Split = {
	tip = "Take a part out.",
	icon = "icon16/delete.png",
	onRun = function(item)
		local client = item.player
		local inventory = client:getChar():getInv()
		local position = client:getItemDropPos()
		
		local stack = item:getData("Amount", item.ammoAmount)
		if(stack <= 1) then return false end

		client:requestString("Split", "", function(text)	
			amount = math.Clamp(tonumber(text), 1, stack - 1)
			
			item:setData("Amount", item:getData("Amount") - amount)
			local customData = item:getData("custom", {})
			
			inventory:addSmart(item.uniqueID, 1, position, {Amount = amount, custom = customData})
			
			client:EmitSound("ui_items_takeall.wav", 65, 130)
		end, 1)

		return false
	end,
	onCanRun = function(item)
		if(item.entity) then
			return false
		end
		
		if(item:getData("Amount", 1) <= 1) then
			return false
		end
		
		return true
	end	
}

ITEM.onCombine = function(itemSelf, itemTarget)
	if(!itemSelf.maxstack) then
		return false
	end

	if(itemSelf.uniqueID == itemTarget.uniqueID) then
		local amountSelf = itemSelf:getData("Amount", itemSelf.ammoAmount)
		local amountTarget = itemTarget:getData("Amount", itemTarget.ammoAmount)

		local combined = amountSelf + amountTarget
		
		local maxstack = itemSelf.maxstack
		
		if(combined > maxstack) then
			itemSelf:setData("Amount", maxstack)
			itemTarget:setData("Amount", combined - maxstack)
		else
			itemTarget:remove()
			itemSelf:setData("Amount", amountSelf + amountTarget)
		end

		itemSelf.player:EmitSound("ui_items_takeall.wav", 65, 130)
	end
end

ITEM.onCombineTo = function(itemSelf, itemMagazine)
	local client = itemSelf.player

	local curAmmo = itemMagazine:getData("ammo")

	if(itemSelf.bullet and itemMagazine.magazine) then
		if(itemMagazine.ammoTypes) then
			if(!itemMagazine.ammoTypes[itemSelf.bullet]) then
				client:notify("That type of bullet doesn't fit in the magazine.")
				return false
			end
		end
		
		if(curAmmo and curAmmo != itemSelf.bullet) then
			client:notify("A different kind of bullet is already in the magazine.")
			return false
		end

		local amountSelf = itemMagazine:getData("Amount", 0)
		local amountTarget = itemSelf:getData("Amount", itemSelf.ammoAmount)

		local combined = amountSelf + amountTarget
		
		if(combined > itemMagazine.maxstack) then
			itemMagazine:setData("Amount", itemMagazine.maxstack)
			itemSelf:setData("Amount", combined - itemMagazine.maxstack)
		else
			itemMagazine:setData("Amount", amountSelf + amountTarget)
			itemSelf:remove()
		end
		
		itemMagazine:setData("ammo", itemSelf.bullet)
		
		client:EmitSound("ui_items_takeall.wav", 65, 130)
	end
end

function ITEM:getName()
	local name = self.name
	
	local customData = self:getData("custom", {})
	if(customData.name) then
		name = customData.name
	end

	return name
end

function ITEM:getDesc()
	local desc = self.desc
	
	local customData = self:getData("custom", {})
	if(customData.desc) then
		desc = customData.desc
	end
	
	local amount = self:getData("Amount", self.ammoAmount)
	local ammo = string.lower(self.ammo)
	
	if(ammo) then
		local fancyName = nut.plugin.list["fancyammo"].ammoNames[ammo] or ""
	
		desc = desc.. "\nContains [" ..amount.. "] " ..fancyName.. " bullets."
	end
	
	return desc
end

if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		local amount = item:getData("Amount", item.ammoAmount)
	
		if(amount) then
			draw.SimpleText(amount, "DermaDefault", w , h - 5, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black)
		end
	end
end