ITEM.name = "Enhancement Base"
ITEM.desc = " "
ITEM.model = "models/hgn/cru/buildings/obj/lightcrystal.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.maxstack = 1

ITEM.flag = "v"
ITEM.category = "Upgrades"

ITEM.enhancement = true

--[[
ITEM.armorOnly = true
ITEM.weaponOnly = true
ITEM.armor = 5
ITEM.dmg = 1
ITEM.weight = 0.75

ITEM.attribs = 1
--]]

local function tableMerger(finished, tab)
	for k, v in pairs(tab) do
		if(istable(v)) then
			if(!finished[k]) then
				finished[k] = {}
			end
			
			tableMerger(finished[k], v)
		else
			if(!isbool(finished[k])) then
				finished[k] = (finished[k] or 0) + v
			end
		end
	end
end

local function tableRemover(finished, tab)
	for k, v in pairs(tab) do
		if(istable(v)) then
			if(!finished[k]) then
				finished[k] = {}
			end
			
			tableRemover(finished[k], v)
		else
			if(!isbool(finished[k])) then
				finished[k] = (finished[k] or 0) - v
			end
		end
	end
end

function ITEM:upgrade(itemSelf, itemTarget, undo)
	local itemStats = {
		dmg = itemTarget:getData("dmg", itemTarget.dmg),
		armor = itemTarget:getData("armor", itemTarget.armor),
		weight = itemTarget:getData("weight", itemTarget.weight),
		
		accuracy = itemTarget:getData("accuracy", itemTarget.accuracy),
		evasion = itemTarget:getData("evasion", itemTarget.evasion),
		magSize = itemTarget:getData("magSize", itemTarget.magSize),
		
		res = itemTarget:getData("res", itemTarget.res),
		amp = itemTarget:getData("amp", itemTarget.amp),
		attrib = itemTarget:getData("attrib", itemTarget.attrib),
		skills = itemTarget:getData("skills", itemTarget.skills),
		
		reqStats = itemTarget:getData("reqStats", itemTarget.reqStats),
	}

	local upgradeStats = {
		dmg = itemSelf.dmg,
		armor = itemSelf.armor,
		weight = itemSelf.weight,
		
		accuracy = itemSelf.accuracy,
		evasion = itemSelf.evasion,
		magSize = itemSelf.magSize,
		
		res = itemSelf.res,
		amp = itemSelf.amp,
		attrib = itemSelf.attrib,
		skills = itemSelf.skills,
		
		reqStats = itemSelf.reqStats,
	}

	--merges the things
	if(!undo) then
		tableMerger(itemStats, upgradeStats)
	else
		tableRemover(itemStats, upgradeStats)
	end

	for k, v in pairs(itemStats) do
		itemTarget:setData(k, v)
	end
end


function ITEM:CanUpgrade(target)
	if(!target.equipment) then return false end --only equipment items for now
	
	local item = self

	--"Can only be used on items with armor."
	if(item.armorOnly and !target:getData("armor", target.armor)) then
		return false
	end	
	
	--"Can only be used on items with damage."
	if(item.weaponOnly and !target:getData("dmg", target.dmg)) then
		return false
	end

	--"You can only use these on melee weapons."
	if (item.meleeOnly) and target.category ~= "Weapon - Melee" then
		return false
	end
	
	--"Can only be used on items with slots."
	if(item.slot and !target.upgradeSlots) then
		return false
	end
	
	--upgrade slot
	local openSlots = target.upgradeSlots or {}
	local upgradeSlots = target:getData("upgradeSlots", {})
	local upgradeLog = target:getData("upgradeLog", {})
	
	--"Too many upgrades of this type already applied."
	if(item.upgradeLimit) then
		if((upgradeLog[item.uniqueID] or 0) >= item.upgradeLimit) then
			return false
		end		
	end

	--"Upgrade slot already filled."
	if(item.slot and openSlots[item.slot] and upgradeSlots[item.slot]) then 
		return false 
	elseif(item.slot and openSlots[item.slot]) then
		return true
	end
	
	if(!item.slot) then
		return true
	end
end

ITEM.functions.Upgrade = {
	name = "Upgrade",
	icon = "icon16/contrast.png",
	isMulti = true,
	multiOptions = function(item, client)
		local possible = {}
		
		local inventory = client:getChar():getInv():getItems()
		for k, v in pairs(inventory) do
			if(item:CanUpgrade(v)) then
				possible[#possible+1] = v
			end
		end

		local targets = {}

		for k, v in pairs(possible) do
			local itemTable = nut.item.instances[v.id]

			if(itemTable) then
				local name = itemTable:getName() or itemTable.name or itemTable.uniqueID
			
				local newAbs = {
					name = name,
					data = v
				}
				
				table.insert(targets, newAbs)
			end
		end
		
		return targets
	end,
	onRun = function(item, data)
		if(!data) then return false end
	
		local target = nut.item.instances[data.id]
		if(!target) then return end
	
		local client = item.player
		local char = client:getChar()
	
		--upgrade slot
		local openSlots = target.upgradeSlots or {}
		local upgradeSlots = target:getData("upgradeSlots", {})
		local upgradeLog = target:getData("upgradeLog", {})
	
		--local query = "Do you want to equip this item into the " ..item.slot.. " slot?"
		local query = "Do you want to upgrade " ..target:getName().. "?"
	
		client:requestQuery(query, "Upgrade", function(text)
			if(item.slot and openSlots[item.slot]) then
				upgradeSlots[item.slot] = item.uniqueID
				target:setData("upgradeSlots", upgradeSlots) --marks item as upgraded
			else
				upgradeLog[item.uniqueID] = (upgradeLog[item.uniqueID] or 0) + 1
				target:setData("upgradeLog", upgradeLog) --marks item as upgraded
			end
		
			item:upgrade(item, target)

			client:EmitSound("ambient/materials/dinnerplates1.wav", 65, 130)
			
			item:remove()
		end)

		return false
	end,
	onCanRun = function(item)
		local client = item.player

		if(IsValid(item.entity)) then
			return false
		end
		
		return true
	end
}