ITEM.name = "Generic Ammo"
ITEM.desc = "A container filled with ammunition."
ITEM.uniqueID = "ammo_generic"
ITEM.model = "models/items/boxsrounds.mdl"
ITEM.material = "models/gibs/metalgibs/metal_gibs"
ITEM.category = "Ammunition"

ITEM.functions.use = {
	name = "Load",
	tip = "useTip",
	icon = "icon16/add.png",
	onRun = function(item)
		local client = item.player
	
		local amount = item:getData("Amount", 0)
		local ammo = tostring(item:getData("ammo"))
	
		client:GiveAmmo(amount, ammo)
		client:EmitSound("items/ammo_pickup.wav", 110)
		
		return true
	end,
	onCanRun = function(item)
		if(!item:getData("ammo")) then
			return false
		end
			
		return true
	end
}

function ITEM:getDesc()
	local desc = Format(self.desc, self.ammoAmount)
	
	local amount = self:getData("Amount", 0)
	local ammo = string.lower(tostring(self:getData("ammo")))
	
	if(ammo) then
		local fancyName = nut.plugin.list["fancyammo"].ammoNames[ammo] or ""
	
		desc = desc.. "\nContains [" ..amount.. "] " ..fancyName.. " bullets."
	end

	return desc
end

function ITEM:getName()
	local name = self.name
	
	if(self:getData("customName") != nil) then
		name = self:getData("customName")
	end

	return Format(name)
end

if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		local amount = item:getData("Amount", 0)
	
		if(amount) then
			draw.SimpleText(amount, "DermaDefault", w , h - 5, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black)
		end
	end
end