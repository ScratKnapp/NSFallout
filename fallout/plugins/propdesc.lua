local PLUGIN = PLUGIN
PLUGIN.name = "Prop Descriptions"
PLUGIN.author = "Blazing & Angelsaur"
PLUGIN.desc = "Allows you to set descriptions for props."

if (SERVER) then
	duplicator.RegisterEntityModifier( "exDesc", function( p, e, t ) 
		if not IsValid(e) then return end
		if not t then return end
		e:setNetVar("exDesc", t[1])
	end )
else
	function PLUGIN:ShouldDrawEntityInfo(entity)
		if (IsValid(entity) and entity:getNetVar("exDesc")) then
			return true
		end
	end 
	 
	 function PLUGIN:DrawEntityInfo(entity, alpha)
		local drawText = nut.util.drawText
		local descInfo = {}
		local exdesc = entity:getNetVar("exDesc")
		
		if (IsValid(entity) and exdesc) then
			if (exdesc ~= entity.nutDescCache) then
				entity.nutDescCache = exdesc
				entity.nutDescLines = nut.util.wrapText(exdesc, ScrW() * 0.35, "PropDescFont")
			end
			
			if(entity.nutDescLines) then
				for i = 1, #entity.nutDescLines do
					descInfo[#descInfo + 1] = {entity.nutDescLines[i]}
				end
			end

			local position = entity:LocalToWorld(entity:OBBCenter()):ToScreen()
			local ty = 0
			local x, y = position.x, position.y
			 
			for i = 1, #descInfo do
				local info = descInfo[i]
				_, ty = drawText(info[1], x, y, Color(230, 230, 230), 1, 1, "PropDescFont", 200)
				y = y + ty
			end
		end
	end
end

duplicator.RegisterEntityModifier( "exDesc", function( p, e, t ) 
	if not IsValid(e) then return end
	if not t then return end
	e:setNetVar("exDesc", t[1])
end )

nut.command.add("propdesc", {
	syntax = "<string desc>",
	onRun = function(client, arguments)
		local objdesc = arguments[1]
		local ent = client:GetEyeTrace().Entity
		if IsValid(ent) then
			if (objdesc) then
				ent:setNetVar("exDesc", objdesc)
			else	
				ent:setNetVar("exDesc", "")
			end
			duplicator.StoreEntityModifier( ent, "exDesc", { ent:getNetVar("exDesc") } ) 
		end
	end
})

if CLIENT then	
	surface.CreateFont("PropDescFont", {
		font = "Roboto",
		size = 25,
		weight = 250,
		extended = true,
		shadow = true
	 })
end