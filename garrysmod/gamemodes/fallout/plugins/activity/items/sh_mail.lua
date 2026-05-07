ITEM.name = "Mail"
ITEM.desc = "Carefully packaged boxes and letters that carry some kind of information."
ITEM.model = "models/vex/fallout76/backpacks/backpack_postalservice.mdl"
ITEM.uniqueID = "act_mail"

function ITEM:getDesc()
	local desc = self.desc
	
	if(self:getData("dID")) then
		desc = desc.. "\nMust be delivered to " ..self:getData("dID").. "."
	end
	
	return desc
end