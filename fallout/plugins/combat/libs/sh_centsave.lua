local PLUGIN = PLUGIN

if(SERVER) then
	util.AddNetworkString("nutExportCEnt")

	function PLUGIN:saveCEnts()
		PLUGIN.savedEnts = {}
		
		for k, v in pairs(ents.GetAll()) do
			if(!IsValid(v)) then continue end
			if(!v.combat or !(v.save or v.saveKey)) then continue end
			if(v.noSave) then continue end

			local saved = {
				pos = v:GetPos(), 
				ang = v:GetAngles(), 
				class = v:GetClass(), 
				saveData = (v.getSaveData and v:getSaveData())
			}
			
			local key = (v.saveKey) or (#PLUGIN.savedEnts + 1)

			v.saveKey = key
			PLUGIN.savedEnts[key] = saved
		end
		
		self:setData(PLUGIN.savedEnts)
	end
	
	function PLUGIN:loadCEnt(info, saveKey)
		local entity = ents.Create(info.class)
		if(IsValid(entity)) then
			entity:SetPos(info.pos)
			entity:SetAngles(info.ang)

			entity.saveKey = saveKey
			entity:Spawn()
			
			local saveData = info.saveData
			if(saveData) then
				entity:loadSaveData(saveData)
			end
		else
			if(saveKey) then
				PLUGIN.savedEnts[saveKey] = nil
			end
		end
	end
	
	function PLUGIN:loadCEnts()
		PLUGIN.savedEnts = self:getData()
		
		for saveKey, info in pairs(PLUGIN.savedEnts) do
			PLUGIN:loadCEnt(info, saveKey)
		end
	end
	
	function PLUGIN:LoadData()
		pcall(
			function()
				PLUGIN:loadCEnts()
			end
		)
	end
end

nut.command.add("centsave", {
	adminOnly = true,
	onRun = function(client, arguments)	
		local entity = client:GetEyeTrace().Entity --entity that we're looking at
		
		if (IsValid(entity) and entity.combat) then --makes sure it's a CEnt (Combat Entity)
			entity.save = true
			client:notify(entity:Name().. " successfully saved.")
		end
		
		client:notify("CEnt save data updated.")
		
		PLUGIN:saveCEnts()
	end
})

nut.command.add("centsaveall", {
	adminOnly = true,
	onRun = function(client, arguments)	
		local entity = client:GetEyeTrace().Entity --entity that we're looking at
		
		local count = 0
		for k, v in pairs(ents.GetAll()) do
			if(IsValid(v) and v.combat) then
				v.save = true
				count = count + 1 
			end
		end
		
		client:notify(count.. " CEnts successfully saved.")
		
		PLUGIN:saveCEnts()
	end
})


--clones a target Cent
nut.command.add("centcopy", {
	adminOnly = true,
	onRun = function(client, arguments)
		local entity = client:GetEyeTrace().Entity --entity that we're looking at
		
		if (IsValid(entity) and entity.combat) then --makes sure it's a CEnt (Combat Entity)
			local info = entity:getSaveData()
			info.class = entity:GetClass()
			
			client.CEntC = info
			local name = entity:getNetVar("name", entity:Name())
			client:notify(name.. " has been copied.") --notify the player
		else --called if they aren't looking at the right thing
			client:notify("You must be looking at a combat entity.")
		end
	end
})

--pastes a copied CEnt
nut.command.add("centpaste", {
	adminOnly = true,
	onRun = function(client, arguments)
		local info = client.CEntC
		if(info) then
			local clone = ents.Create(info.class) --the new clone entity
			clone:SetPos(client:GetEyeTrace().HitPos) --set its position
			--clone:SetAngles(info.ang) --set its angles
			
			clone:Spawn() --spawn it
			clone:loadSaveData(info)

			clone:SetCreator(client) --prop protection
			
			undo.Create("Pasted CEnt")
				undo.AddEntity(clone)
				undo.SetPlayer(client)
			undo.Finish()

			local name = clone:getNetVar("name", clone:Name())
			client:notify(name.. " has been pasted.") --notify the player
		end
	end
})

--clones a target Cent
nut.command.add("centclone", {
	adminOnly = true,
	onRun = function(client, arguments)
		local entity = client:GetEyeTrace().Entity --entity that we're looking at
		
		if (IsValid(entity) and entity.combat) then --makes sure it's a CEnt (Combat Entity)
			local saveData = entity:getSaveData()
			
			local clone = ents.Create(entity:GetClass()) --the new clone entity
			clone:SetPos(entity:GetPos()) --set its position
			clone:SetAngles(entity:GetAngles()) --set its angles
			
			clone:Spawn() --spawn it
			clone:loadSaveData(saveData)
			
			clone:SetCreator(client) --prop protection

			client:notify(entity:Name().. " has been cloned.") --notify the player
		else --called if they aren't looking at the right thing
			client:notify("You must be looking at a combat entity.")
		end
	end
})

nut.command.add("centexporttofile", {
	adminOnly = true,
	onRun = function(client, arguments)	
		local entity = client:GetEyeTrace().Entity --entity that we're looking at
		
		if (IsValid(entity) and entity.combat) then --makes sure it's a CEnt (Combat Entity)
			local CEntData = {}
			CEntData.class = entity:GetClass()
			CEntData.saveData = entity:getSaveData() or {}

			if(!CEntData.saveData.name) then
				client:notify("Save failed, unnamed CEnt.")
				return false
			end

			local path = "nutscript/"..SCHEMA.folder.."/combatexport/"
			if(!file.Exists(path, "DATA")) then
				file.CreateDir("nutscript/"..SCHEMA.folder.."/combatexport/")
			end
			
			path = "nutscript/"..SCHEMA.folder.."/combatexport/" ..string.lower(CEntData.saveData.name).. ".txt"
			file.Write(path, util.TableToJSON(CEntData))

			client:notify("CEnt successfully exported as " ..CEntData.saveData.name)
		end
	end
})

nut.command.add("centimportfromfile", {
	adminOnly = true,
	onRun = function(client, arguments)
		if(!arguments) then
			client:notify("Specify a CEnt to import.")
			return false
		end

		local CEntName = string.lower(table.concat(arguments, " "))
		
		local path = "nutscript/"..SCHEMA.folder.."/combatexport/" ..CEntName
		
		if(!file.Exists(path.. ".txt", "DATA")) then
			client:notify("No stored CEnt of that name.")
			return false
		end
		
		local import = file.Read(path.. ".txt") or ""
		local importTbl = util.JSONToTable(import)
		
		importTbl.pos = client:GetEyeTraceNoCursor().HitPos + Vector(0, 0, 10)
		importTbl.ang = Angle(0,0,0)
		
		PLUGIN:loadCEnt(importTbl)
	
		client:notify("CEnt successfully imported.")
	end
})

--exports a target CEnt
nut.command.add("centexport", {
	adminOnly = true,
	onRun = function(client, arguments)
		local entity = client:GetEyeTrace().Entity --entity that we're looking at
		
		if (IsValid(entity) and entity.combat) then --makes sure it's a CEnt (Combat Entity)
			local CEntData = {}
			CEntData.class = entity:GetClass()

			local saveData = entity:getSaveData() or {}

			for k,v in pairs(entity:GetChildren()) do
				if v:GetClass() == "ent_bonemerged" then
					saveData.bonemerged[#saveData.bonemerged+1] = v:GetModel()
				end
			end
			
			if entity:GetModelScale() != 1 then
				saveData.scale = entity:GetModelScale()
			end
			
			CEntData.saveData = saveData
		
			net.Start("nutExportCEnt")
			net.WriteTable(CEntData)
			net.Send(client)
			client:notify(entity:getNetVar("name", entity.PrintName).." exported to clipboard as text.")
		else
			client:notify("You must be looking at a combat entity.")
		end
	end
})

--imports a linked CEnt
nut.command.add("centimport", {
	adminOnly = true,
	syntax = "<string url>",
	onRun = function(client, arguments)
		http.Fetch(arguments[1],function(body) 
			client.CEntC = util.JSONToTable(body)
			
			client:notify("CEnt successfully imported from "..arguments[1])
		end,
		function(err) client:notify("Invalid link.") end)
	end
})

if (CLIENT) then
	net.Receive("nutExportCEnt",function(len,ply)
		SetClipboardText(util.TableToJSON(net.ReadTable()))
	end)
end
