PLUGIN.name = "Map Damage Destroyer"
PLUGIN.author = "Chancer"
PLUGIN.desc = "This tries to delete kill/damage entities on the map."

nut.config.add("killEntsOff", false, "Whether to remove trigger_hurts and other annoying entities.", nil, {
	category = "Map"
})

function PLUGIN:Think()
	if(nut.config.get("killEntsOff", false)) then
		if(!self.cleanedEnts) then
			self.cleanedEnts = true
			
			timer.Simple(10, function()
				local list = ents.FindByClass("trigger_hurt")
				for k, v in pairs(list) do
					SafeRemoveEntity(v)
				end
				
				list = ents.FindByClass("env_entity_dissolver")
				for k, v in pairs(list) do
					SafeRemoveEntity(v)
				end		
				
				list = ents.FindByClass("trigger_physics_trap")
				for k, v in pairs(list) do
					SafeRemoveEntity(v)
				end
			end)
		end
	end
end

nut.command.add("killentsoff", {
	adminOnly = true,
	onRun = function(client, arguments)
		local list = ents.FindByClass("trigger_hurt")

		local count = 0
		for k, v in pairs(list) do
			count = count + 1
			SafeRemoveEntity(v)
		end
		
		list = ents.FindByClass("env_entity_dissolver")
		for k, v in pairs(list) do
			count = count + 1
			SafeRemoveEntity(v)
		end		
		
		list = ents.FindByClass("trigger_physics_trap")
		for k, v in pairs(list) do
			count = count + 1
			SafeRemoveEntity(v)
		end
		
		client:notify("Removed " ..count.. " entities.")
	end
})