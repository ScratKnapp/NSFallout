ITEM.name = "Signalling Device"
ITEM.desc = "A simple device that can send a signal to a similar device on the same frequency."
ITEM.model = "models/gibs/shield_scanner_gib1.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Communication"
ITEM.price = 150
ITEM.flag = "v"
ITEM.uniqueID = "signal"

ITEM.price = 20

ITEM.permit = "permit_general"

ITEM.iconCam = {
	pos = Vector(0, 0, 200),
	ang = Angle(90, 0, -60),
	fov = 2.5,
}

ITEM.functions.use = { -- sorry, for name order.
	name = "Freq",
	tip = "useTip",
	icon = "icon16/wrench.png",
	onRun = function(item)
		netstream.Start(item.player, "signalAdjust", item:getData("freq", "000,0"), item.id)

		return false
	end
}

function ITEM:getDesc(partial)
	local desc = self.desc
	
	if(!partial) then
		local PLUGIN = nut.plugin.list["signal"]
		
		desc = desc
		
		for k, v in pairs(PLUGIN.codeList) do
			desc = desc..k.. ": " ..v
			
			if(k < #PLUGIN.codeList) then
				desc = desc.. ", "
			end
		end
	end
	
	if (!self.entity or !IsValid(self.entity)) then
		return Format(desc, (self:getData("power") and "On" or "Off"), self:getData("freq", "000.0"))
	else
		local data = self.entity:getData()
	
		return Format(desc, (self.entity:getData("power") and "On" or "Off"), self.entity:getData("freq", "000.0"))
	end
	
	return desc
end
