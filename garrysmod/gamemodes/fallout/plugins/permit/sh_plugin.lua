PLUGIN.name = "Permit Items"
PLUGIN.author = "Chancer"
PLUGIN.desc = "Permit items that let you buy stuff."

function PLUGIN:CanPlayerUseBusiness(client, uniqueID)
	local itemTable = nut.item.list[uniqueID]

	if (!client:getChar()) then
		return false
	end

	-- ITEM.noBusiness = true means item cannot be sold via business.
	if (itemTable.noBusiness) then
		return false
	end

	-- Check if player has the flag ITEM.flag
	if (
		isstring(itemTable.permit) and
		client:getChar():getInv():hasItem(itemTable.permit)
	) then
		return true
	end
	
	if(itemTable.businessNoFlag) then
		return true
	end
end