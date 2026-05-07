local PLUGIN = PLUGIN
PLUGIN.name = "Perma 3d Radios"
PLUGIN.author = " "
PLUGIN.desc = "Adds a command to save 3d stream radios."

if StreamRadioLib then
	function PLUGIN:SaveRadios()
		local data = {}

		for k, v in ipairs(ents.FindByClass("sent_streamradio")) do
			local settings = v.GetSettings and v:GetSettings()
		
			data[#data+1] = {
				ply = v.pl,
				mdl = v:GetModel(),
				pos = v:GetPos(),
				ang = v:GetAngles(),
				settings = settings,
			}
		end

		self:setData(data)
	end
	
	function PLUGIN:SaveData()
		--PLUGIN:SaveRadios()
	end

	function PLUGIN:LoadData()
		local data = self:getData() or {}

		for k, v in ipairs(data) do
			local settings = v.settings or {}
			local ent = StreamRadioLib.SpawnRadio(v.ply, v.mdl, v.pos, v.ang, settings)
			
			if !IsValid(ent) then return end

			timer.Simple(10, function()
				if(IsValid(ent)) then
					StreamRadioLib.EditRadio(ent, settings)
					ent:SetToolURL(settings.StreamUrl, true)
				end
			end)
			
			local phys = ent:GetPhysicsObject()
			if (IsValid(phys)) then
				phys:EnableCollisions(false)
				phys:EnableMotion(false)
			end
		end
	end
	
	nut.command.add("3dradioclean", {
		superAdminOnly = true,
		onRun = function (client, arguments)
			for k, ent in pairs( ents.FindByClass( "sent_streamradio" ) ) do
				ent:Remove()
			end
			client:notify("Cleanup done")
		end
	})
	
	nut.command.add("3dradiosave", {
		superAdminOnly = true,
		onRun = function (client, arguments)
			PLUGIN:SaveRadios()
			
			local count = table.Count(ents.FindByClass("sent_streamradio"))
			
			client:notify(count.. " 3D Radio(s) saved.")
		end
	})
end