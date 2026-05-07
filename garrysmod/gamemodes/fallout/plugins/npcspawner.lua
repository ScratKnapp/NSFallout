local PLUGIN = PLUGIN
PLUGIN.name = "NPC Spawner"
PLUGIN.author = "Black Tea (NS 1.0), Neon (NS 1.1)"
PLUGIN.desc = "NPC Spawner."
PLUGIN.spawnpoints = PLUGIN.spawnpoints or {}

nut.config.add("spawner_enabled", true, "Whether NPC spawners are on or not.", nil, {
	category = "NPC Spawner"
})

nut.config.add("npc_spawnrate", 90, "How often an npc will be spawned at an npc spawn point.", nil, {
	data = {min = 1, max = 84600},
	category = "NPC Spawner"
})

nut.config.add("npc_maxnpcs", 100, "How many npcs the spawner is allowed to spawn at once.", nil, {
	data = {min = 1, max = 84600},
	category = "NPC Spawner"
})

PLUGIN.spawngroups = {
	["mirelurk"] = {
		"npc_vj_fo4_mirelurk",
		"npc_vj_fo4_mirelurk_hatchling",
		"npc_vj_fo4_mirelurk_hunter",
		"npc_vj_fo4_mirelurk_softshell"

	},
	["ghoul"] = {
		"npc_vj_fo4_feralghoul",
		"npc_vj_fo4_feralghoul_reaver",
		"npc_vj_fo4_feralghoul_roamer",
		"npc_vj_fo4_feralghoul_stalker",
		"npc_vj_fo4_feralghoul_gangrenous",
		"npc_vj_fo4_feralghoul_charred",
		"npc_vj_fo4_feralghoul_rotting",
	},
	["robot"] = {
		"npc_vj_f3r_protectron",
		"npc_vj_f3r_protectron_army",
		"npc_vj_f3r_eyebot",
		"npc_vj_f3r_gutsyarmy",
	},
	["bug"] = {
		"npc_vj_f3r_bloatfly",
		"npc_vj_f3r_ant",
		"npc_vj_f3r_mantis",
		"npc_vj_f3r_mantisnymph",
		"npc_vj_f3r_radroach",
		"npc_vj_f3r_radscor_small",
		"npc_vj_f3r_cazadore",
		"npc_vj_f3r_antfire",

	},
	["animal"] = {
		"npc_vj_f3r_gecko",
		"npc_vj_f3r_geckofire",
		"npc_vj_f3r_geckogold",
		"npc_vj_f3r_geckogreen",
		"npc_vj_f3r_rat",
		"npc_vj_f3r_molerat",
		"npc_vj_f3r_nightstalker",
		"npc_vj_f3r_dog_vic",
		"npc_vj_f3r_yaoguai",
		"npc_vj_f3r_coyote",
		"npc_vj_f3r_bighorner",
		"npc_vj_f3r_brahmin",
		"pack_shade",

	},	
}

PLUGIN.maxnpcs = 100
PLUGIN.spawnedNPCs = PLUGIN.spawnedNPCs or {}

if SERVER then
	local spawntime = 1
	
	function PLUGIN:Think()
		if spawntime > CurTime() then return end
		spawntime = CurTime() + nut.config.get("npc_spawnrate", 90)
		for k, v in ipairs(self.spawnedNPCs) do
			if (!v:IsValid()) then
				table.remove(self.spawnedNPCs, k)
			end
		end

		if #self.spawnedNPCs >= nut.config.get("npc_maxnpcs", 40) then return end

		local v = table.Random(self.spawnpoints)

		if(!nut.config.get("spawner_enabled", false)) then
			return
		end
		
		if (!v) then
			return
		end

		local data = {}
		data.start = v[1]
		data.endpos = data.start + Vector(0, 0, 1)
		data.filter = client
		data.mins = Vector(-16, -16, 0)
		data.maxs = Vector(16, 16, 16)

		local idat = table.Random(self.spawngroups[v[2]]) or self.spawngroup["default"]

		--nut.item.spawn(idat, v[1] + Vector( math.Rand(-8,8), math.Rand(-8,8), 20 ), nil, AngleRand())
			
		local trace = util.TraceHull(data)

		
		local nearby = false 
		local players = player.GetAll()
		
		--dont want to spawn them in too close to players
		if(players) then
			for k, v in pairs(players) do
				if(v:GetMoveType() == MOVETYPE_NOCLIP) then
					continue
				end
			
				if v:GetPos():DistToSqr(data.endpos) < 1000 * 1000 then --squared is more efficient
					nearby = true
					break
				end
			end
		end
		
		if (!nearby and !trace.Entity:IsValid()) then --dont want the npcs to stack on each other or spawn inside something.
			local ent = ents.Create(idat)
			
			table.insert(self.spawnedNPCs, ent)
				
			if (ent:IsValid()) then
				ent:SetPos(data.endpos + Vector(0,0,25))
				ent:Spawn()
			end
		end
	end

	function PLUGIN:LoadData()
		self.spawnpoints = self:getData() or {}
	end

	function PLUGIN:SaveData()
		self:setData(self.spawnpoints)
	end

else

	netstream.Hook("nut_DisplaySpawnPoints", function(data)
		for k, v in pairs(data) do
			local emitter = ParticleEmitter( v[1] )
			local smoke = emitter:Add( "sprites/glow04_noz", v[1] )
			smoke:SetVelocity( Vector( 0, 0, 1 ) )
			smoke:SetDieTime(10)
			smoke:SetStartAlpha(255)
			smoke:SetEndAlpha(255)
			smoke:SetStartSize(64)
			smoke:SetEndSize(64)
			smoke:SetColor(255,50,50)
			smoke:SetAirResistance(300)
		end
	end)

end

nut.command.add("npcspawnadd", {
	adminOnly = true,
	syntax = "<string npcgroup>",
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal*5
		local spawngroup = arguments[1] or "default"
		table.insert(PLUGIN.spawnpoints, { hitpos, spawngroup })
		client:notify("You added ".. spawngroup .. " npc spawner.")
	end
})

nut.command.add("npcspawnremove", {
	adminOnly = true,
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal*5
		local range = arguments[1] or 128
		local mt = 0
		for k, v in pairs( PLUGIN.spawnpoints ) do
			local distance = v[1]:DistToSqr(hitpos)
			if distance <= tonumber(range) * tonumber(range) then
				PLUGIN.spawnpoints[k] = nil
				mt = mt + 1
			end
		end
		client:notify(mt .. " npc spawners has been removed.")
	end
})

nut.command.add("npcspawndisplay", {
	adminOnly = true,
	onRun = function(client, arguments)
		if SERVER then
			netstream.Start(client, "nut_DisplaySpawnPoints", PLUGIN.spawnpoints)
			client:notify("Displayed All Points for 10 secs.")
		end
	end
})

nut.command.add("npcspawntoggle", {
	adminOnly = true,
	onRun = function(client, arguments)
		if(nut.config.get("spawner_enabled", false)) then
			nut.config.set("spawner_enabled", false)
			client:notify("NPC Spawners have been turned off.")
		else
			nut.config.set("spawner_enabled", true)
			client:notify("NPC Spawners have been turned on.")
		end
	end
})