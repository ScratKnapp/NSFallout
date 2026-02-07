local PLUGIN = PLUGIN

PLUGIN.name = "Activities"
PLUGIN.author = "Chancer"
PLUGIN.desc = "Adds some activities that people can do."

PLUGIN.supSpawns = PLUGIN.supSpawns or {}

if SERVER then
	function PLUGIN:SaveData()
		self.supSpawns = {}
	
		for k, v in pairs(ents.GetAll()) do
			if(!IsValid(v)) then continue end
			
			if(v.supplier) then
				table.insert(self.supSpawns, {v:GetPos(), v:GetAngles(), v:GetClass(), (v.getSaveData and v:getSaveData())})
			end
		end
		
		self:setData(self.supSpawns)
	end

	function PLUGIN:LoadData()
		pcall(function()
			self.supSpawns = self:getData()
			self:Initialize()
		end)
	end

	function PLUGIN:Initialize()
		for k, v in pairs(self.supSpawns) do
			self:setGathering(v)
		end
		
		PLUGIN:SaveData()
	end

	function PLUGIN:setGathering(point)
		local entity = ents.Create(point[3])
		if(IsValid(entity)) then
			entity:SetPos(point[1])
			entity:SetAngles(point[2])
			
			for k, v in pairs(point[4] or {}) do
				entity:setNetVar(k, v)
			end
			
			if(entity.onLoaded) then
				entity:onLoaded()
			end
			
			entity:Spawn()
		else
			table.RemoveByValue(self.supSpawns, point)
		end
	end
	
	netstream.Hook("nut_supplierUpdate", function(client, entity, data)
		for k, v in pairs(data) do
			if(k == "model") then
				entity:SetModel(v)
				
				for k, v in ipairs(entity:GetSequenceList()) do
					if (v:lower():find("idle") and v != "idlenoise") then
						entity:ResetSequence(k)
						break
					end
				end
			elseif(k == "material") then
				entity:SetMaterial(v)
			end
			
			if(v != "") then
				entity:setNetVar(k, v)
			end
		end
		
		PLUGIN:SaveData()
	end)
else
	netstream.Hook("nut_suppliermenu", function(entity)
		local supplierMenu = vgui.Create("nutSupplier")
		supplierMenu:LoadSupplier(entity)
	end)
end

--[[
nut.command.add("shipmenttest", {
    syntax = "",
    onRun = function(client, arguments)
		local items = {
			["food_banana"] = 5,
		}
	
		local entity = ents.Create("nut_shipment2")
		entity:SetPos(client:getItemDropPos())
		entity:Spawn()
		entity:setItems(items)
		entity:setNetVar("owner", client:getChar():getID())
		entity:setNetVar("displayText", "Banana Shipment")
    end
})
--]]

nut.command.add("suppliermenu", {
    adminOnly = true,
	syntax = "<none>",
    onRun = function(client, arguments)
		--open a menu here please
		local entity = client:GetEyeTrace().Entity

		if (IsValid(entity) and entity.supplier) then
			netstream.Start(client, "nut_suppliermenu", entity)
		end
    end
})