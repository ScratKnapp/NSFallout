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

ITEM.onCombineTo = function(itemSelf, itemTarget)
	if(!itemSelf.combiner) then return true end

	local client = itemSelf.player
	
	if(itemSelf.armorOnly and !itemTarget:getData("armor", itemTarget.armor)) then
		client:notify("Can only be used on items with armor.")
		return true
	end	
	
	if(itemSelf.weaponOnly and !itemTarget:getData("dmg", itemTarget.dmg)) then
		client:notify("Can only be used on items with damage.")
		return true
	end
	
	if(itemSelf.slot and !itemTarget.upgradeSlots) then
		client:notify("Can only be used on items with slots.")
		return true
	end
	
	local query = "Do you want to upgrade this equipment? (Cannot be undone)" --the message it gives the player
	
	--upgrade slot
	local openSlots = itemTarget.upgradeSlots or {}
	local upgradeSlots = itemTarget:getData("upgradeSlots", {})
	local upgradeLog = itemTarget:getData("upgradeLog", {})
	
	if(itemSelf.upgradeLimit) then
		if((upgradeLog[itemSelf.uniqueID] or 0) >= itemSelf.upgradeLimit) then
			client:notify("Too many upgrades of this type already applied.")
			return true
		end		
	end
	
	if(itemSelf.slot and openSlots[itemSelf.slot] and upgradeSlots[itemSelf.slot]) then 
		client:notify("Upgrade slot already filled.")
		return true 
	elseif(itemSelf.slot and openSlots[itemSelf.slot]) then
		query = "Do you want to equip this item into the " ..itemSelf.slot.. " slot?"
	end
	
	client:requestQuery(query, "Upgrade", function(text)
		if(itemSelf.slot and openSlots[itemSelf.slot]) then
			upgradeSlots[itemSelf.slot] = itemSelf.uniqueID
			itemTarget:setData("upgradeSlots", upgradeSlots) --marks item as upgraded
		else
			upgradeLog[itemSelf.uniqueID] = (upgradeLog[itemSelf.uniqueID] or 0) + 1
			itemTarget:setData("upgradeLog", upgradeLog) --marks item as upgraded
		end
	
		itemSelf:upgrade(itemSelf, itemTarget)

		client:EmitSound("ambient/materials/dinnerplates1.wav", 65, 130)
		
		itemSelf:remove()
	end)
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