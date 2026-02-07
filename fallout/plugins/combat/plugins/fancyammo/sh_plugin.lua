local PLUGIN = PLUGIN
PLUGIN.name = "Stackable Ammo"
PLUGIN.author = "Chancer"
PLUGIN.desc = "Ammo that can be stacked and put into magazines and stuff."

PLUGIN.ammoNames = {
	["pistol"] = "9x19mm",
}

function PLUGIN:EjectAmmo(client, weapon)
	local weaponAmmo = weapon.ammo
	if(!weaponAmmo) then return end

	local char = client:getChar()
	local inventory = char:getInv()
	local position = client:getItemDropPos()
	
	local curMag = weapon:getData("currentMag", {})
	local curUID = curMag[1]
	local curAmt = curMag[2]

	if(!curUID or !curAmt) then return end
	
	if(curAmt > 0) then
		inventory:addSmart(curUID, 1, position, {Amount = curAmt})
	end
	
	weapon:setData("currentMag", {}, client)
end

function PLUGIN:ReloadFromInventory(client, weapon)
	local weaponAmmo = weapon.ammo
	if(!weaponAmmo) then return false end

	local char = client:getChar()
	local inventory = char:getInv()
	local position = client:getItemDropPos()
	
	local curMag = weapon:getData("currentMag", {})
	local magSize = weapon:getData("magSize", weapon.magSize)
	local curUID = curMag[1]
	local curAmt = curMag[2] or 0
	local needed = magSize - curAmt

	local ammoTypes = {}
	local ammoCounts = {}
	
	--check all the ammo in the inventory
	for k, v in pairs(inventory:getItems()) do
		if(v.base != "base_ammofancy") then continue end
	
		--make sure it can be loaded into this specific weapon
		if(v.ammo == weaponAmmo) then
			ammoTypes[v.dmgT] = ammoTypes[v.dmgT] or {}

			table.insert(ammoTypes[v.dmgT], v)
			ammoCounts[v.dmgT] = (ammoCounts[v.dmgT] or 0) + v:getData("Amount", v.ammoAmount)
		end
	end

	local largest = 0
	local largestType
	for k, v in pairs(ammoCounts) do
		if(largest < v) then
			largest = v
			largestType = k
		end
	end
	
	local ammoToBeLoaded = ammoTypes[largestType]
	if(ammoToBeLoaded) then
		for k, v in pairs(ammoToBeLoaded) do
			local ammoAmount = v:getData("Amount", v.ammoAmount)
			local remain = ammoAmount - needed
			
			local newMag
			if(curUID == v.uniqueID) then
				newMag = math.Clamp((curMag[2] or 0) + ammoAmount, 0, magSize)
			else
				newMag = math.Clamp(ammoAmount, 0, magSize)
				
				PLUGIN:EjectAmmo(client, weapon)
			end
			
			curMag = {v.uniqueID, newMag}
			weapon:setData("currentMag", curMag, client)
			
			if(remain < 1) then
				v:remove()
				needed = math.abs(remain)
			else
				v:setData("Amount", remain)
				needed = 0
				--we got all the ammo we need
				return true
			end
		end
	end
end

nut.command.add("reload", {
	syntax = "",
	onRun = function(client, arguments)
		local char = client:getChar()
		local inventory = char:getInv()
		
		local equipment = nut.plugin.list["equipment"]:getEquippedItems(client, true)

		local weaponsReloaded = {}
		for k, v in pairs(equipment) do
			local magSize = v:getData("magSize", v.magSize)
		
			if(magSize) then
				if(PLUGIN:ReloadFromInventory(client, v)) then
					weaponsReloaded[#weaponsReloaded+1] = v
				end
			end
		end

		for k, v in pairs(weaponsReloaded) do
			local reloadMsg = client:Name().. " reloads " ..v:getName()
		
			nut.plugin.list["chatboxextra"]:ChatboxSend(client, "react_npc", reloadMsg)
			nut.log.addRaw(reloadMsg, 2)
		end
	end
})

nut.command.add("reloadadmin", {
	adminOnly = true,
	syntax = "",
	onRun = function(client, arguments)
		local char = client:getChar()
		local inventory = char:getInv()
		
		local equipment = nut.plugin.list["equipment"]:getEquippedItems(client, true)
		
		for k, v in pairs(equipment) do
			local magSize = v:getData("magSize", v.magSize)
		
			if(magSize) then
				local curMag = v:getData("currentMag")
				if(!curMag) then
					curMag = {}
					curMag[1] = v.ammo
				end
	
				curMag[2] = magSize
				
				v:setData("currentMag", curMag, client)
			end
		end
		
		client:notify("Weapons reloaded.")
	end
})

nut.command.add("ammoejectall", {
	syntax = "<none>",
	onRun = function(client, arguments)
		local char = client:getChar()
		local inventory = char:getInv()
		local position = client:getItemDropPos()

		local equipment = nut.plugin.list["equipment"]:getEquippedItems(client)

		for k, v in pairs(equipment) do
			PLUGIN:EjectAmmo(client, v)
		end
	
		client:notify("Ammo ejected successfully.")
	end
})