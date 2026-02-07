local PLUGIN = PLUGIN
PLUGIN.name = "Lockpicking"
PLUGIN.author = " "
PLUGIN.desc = "Original Addon: https://github.com/Exho1/Skyrim-Lockpicking"

PLUGIN.spawnedGathers = PLUGIN.spawnedGathers or {}
PLUGIN.gatherPoints = PLUGIN.gatherPoints or {}

nut.config.add("pickaclesRate", 1800, "How much time it will take for a pickable entity to spawn.", nil, {
	data = {min = 1, max = 84600},
	category = "Pickables"
})

nut.config.add("pickablesMax", 30, "Number of pickable entitites the world will spawn at once.", nil, {
	data = {min = 1, max = 500},
	category = "Pickables"
})

PLUGIN.pickableModels = {
	"models/props_junk/wood_crate001a.mdl",
}

PLUGIN.pickableLoot = {
	["j_5lb_weight"] = 25,
	["j_10lb_weight"] = 1,
	["j_20lb_dumbweight"] = 1,
	["j_25lb_weight"] = 1,
	["j_40lb_barweight"] = 1,
	["j_80lb_barweight"] = 1,
	["j_80lb_curlbar"] = 1,
	["j_160lb_barweight"] = 1,
	["j_abraxo"] = 1,
	["j_alarmclock"] = 1,
	["j_aluminumcan"] = 1,
	["j_ammobag"] = 1,
	["j_antifreeze"] = 1,
	["j_ashtray"] = 1,
	["j_babybottle"] = 1,
	["j_babyrattle"] = 1,
	["j_ball"] = 1,
	["j_baseball_glove"] = 1,
	["j_baseballbase"] = 1,
	["j_basketball"] = 1,
	["j_beaker1"] = 1,
	["j_beaker2"] = 1,
	["j_beaker3"] = 1,
	["j_beakerstand"] = 1,
	["j_bioscanner"] = 1,
	["j_blanket"] = 1,
	["j_boardgame"] = 1,
	["j_blowtorch"] = 1,
	["j_bonecutter"] = 1,
	["j_bonesaw"] = 1,
	["j_bowl"] = 1,
	["j_bowlingball"] = 1,
	["j_bowlingpin"] = 1,
	["j_brahmin_skull"] = 1,
	["j_breadbox"] = 1,
	["j_broom"] = 1,
	["j_bucket"] = 1,
	["j_bunsenburn"] = 1,
	["j_burgerbox"] = 1,
	["j_buttercupbody"] = 1,
	["j_buttercupfull"] = 1,
	["j_buttercupbleg"] = 1,
	["j_butterknife"] = 1,
	["j_cactus_plant"] = 1,
	["j_cafeteriatray"] = 1,
	["j_cakepan"] = 1,
	["j_camera"] = 1,
	["j_catbowl"] = 1,
	["j_chessboard"] = 1,
	["j_circuitboard"] = 1,
	["j_clipboard"] = 1,
	["j_clotheshanger"] = 1,
	["j_clothesiron"] = 1,
	["j_coffeecup"] = 1,
	["j_coffeepot"] = 1,
	["j_coffeetin"] = 1,
	["j_collander"] = 1,
	["j_coolant"] = 1,
	["j_cottonyarn"] = 1,
	["j_cuttingboard"] = 1,
	["j_decanter"] = 1,
	["j_dishrag"] = 1,
	["j_dogbowl"] = 1,
	["j_drinkglass"] = 1,
	["j_ducttapepack"] = 1,
	["j_earexaminer"] = 1,
	["j_enamelbucket"] = 1,
	["j_extinguisher"] = 1,
	["j_featherduster"] = 1,
	["j_fork"] = 1,
	["j_fryingpan"] = 1,
	["j_fuse"] = 1,
	["j_gascan"] = 1,
	["j_globe"] = 1,
	["j_gnome"] = 1,
	["j_hairbrush"] = 1,
	["j_hammer"] = 1,
	["j_highpowermagnet"] = 1,
	["j_hotdogbox"] = 1,
	["j_hotplate"] = 1,
	["j_industrialshort"] = 1,
	["j_injector"] = 1,
	["j_jangles"] = 1,
	["j_jug"] = 1,
	["j_kitchenscale"] = 1,
	["j_ladle"] = 1,
	["j_lamp"] = 1,
	["j_lamp2"] = 1,
	["j_lifepreserver"] = 1,
	["j_lightbulb"] = 1,
	["j_lighter"] = 1,
	["j_locket"] = 1,
	["j_lumberjacksaw"] = 1,
	["j_magnifyingglass"] = 1,
	["j_microscope"] = 1,
	["j_mop"] = 1,
	["j_mrhandyfuel"] = 1,
	["j_newspaper"] = 1,
	["j_nitrogendispenser"] = 1,
	["j_oilcan"] = 1,
	["j_oilcanister"] = 1,
	["j_ovenmitt"] = 1,
	["j_paintcan"] = 1,
	["j_paintbrush"] = 1,
	["j_pan"] = 1,
	["j_papercup"] = 1,
	["j_pen"] = 1,
	["j_phone"] = 1,
	["j_picture_frame"] = 1,
	["j_pillow"] = 1,
	["j_pitcher"] = 1,
	["j_pumpkin"] = 1,
	["j_plate"] = 1,
	["j_rib"] = 1,
	["j_saucepan"] = 1,
	["j_scalpel"] = 1,
	["j_scissors"] = 1,
	["j_screwdriver"] = 1,
	["j_sensormodule"] = 1,
	["j_shoppingbasket"] = 1,
	["j_shovel"] = 1,
	["j_skull"] = 1,
	["j_soap"] = 1,
	["j_spatula"] = 1,
	["j_spoon"] = 1,
	["j_surgicaltray"] = 1,
	["j_teddybear"] = 1,
	["j_testtuberack"] = 1,
	["j_tincan"] = 1,
	["j_toaster"] = 1,
	["j_tongs"] = 1,
	["j_toothbrush"] = 1,
	["j_toyalien"] = 1,
	["j_toyblock"] = 1,
	["j_toygutsy"] = 1,
	["j_toyprotectron"] = 1,
	["j_toysentrybot"] = 1,
	["j_toycar"] = 1,
	["j_toykit"] = 1,
	["j_toysoldier"] = 1,
	["j_toytruck"] = 1,
	["j_triflag"] = 1,
	["j_turpentine"] = 1,
	["j_typewriter"] = 1,
	["j_umbrella"] = 1,
	["j_vacuumtube"] = 1,
	["j_vase"] = 1,
	["j_watch"] = 1,
	["gun_9mmpistol"] = 1,
	["gun_22lrpistol"] = 1,
	["gun_38revolver"] = 1,
	["gun_caravanshotgun"] = 1,
	["gun_lasermusket"] = 1,
	["gun_laserrevolver"] = 1,
	["gun_piperevolver"] = 1,
	["gun_pipeboltaction"] = 1,
	["gun_piperifle"] = 1,
	["melee_board"] = 1,
	["melee_boxingglove"] = 1,
	["melee_leadpipe"] = 1,
	["melee_switchblade"] = 1,
	["melee_walkingcane"] = 1,
	["melee_wrench"] = 1,
	["armor_body_clothing"] = 1,
}

PLUGIN.Pickable = {
	["nut_storage"] = {
		canPick = function(client, entity, lockpick)
			if(entity.pickable) then
				if(entity.skillCheck) then
					local char = client:getChar()
					local skill = char:getSkill("lockpick", 1)
					
					if(skill >= entity.skillCheck) then
						return true
					else
						client:notify("Your lockpicking skill is too low.")
						return false
					end
				end
			
				return true
			end
		end,
		onPick = function(client, entity, lockpick)
			entity.password = password
			entity:setNetVar("locked", nil)
			entity.pickable = nil
		end,
	},
}

function PLUGIN:CanLockpickEntity(client, entity, lockpick)
	if(!IsValid(entity)) then return false end
	if(!IsValid(client)) then return false end
	
	local trace = client:GetEyeTrace()
	if(trace.HitPos:Distance(client:GetShootPos()) > 100) then return false end

	local class = entity:GetClass()
	local pickTbl = PLUGIN.Pickable[class]
	if(pickTbl) then
		return pickTbl.canPick(client, entity, lockpick)
	else
		return false
	end
end

function PLUGIN:OnLockpickEntity(client, entity, lockpick)
	if(!IsValid(entity)) then return false end
	
	local class = entity:GetClass()
	local pickTbl = PLUGIN.Pickable[class]
	if(pickTbl) then
		return pickTbl.onPick(client, entity, lockpick)
	else
		return false
	end
end

if SERVER then
	function PLUGIN:SaveData()
		self:setData(self.gatherPoints)
	end

	function PLUGIN:LoadData()
		pcall(function()
			self.gatherPoints = self:getData()
			self:Initialize()
		end)
	end

	function PLUGIN:Initialize()
		for k, v in pairs(self.gatherPoints) do
			self:setGathering(v)
		end
	end

	local gatherSpawnTime = CurTime()
	function PLUGIN:Think()
		self:removeInvalidGathers()
		if (#self.spawnedGathers <= nut.config.get("pickablesMax", 30)) then
			if (gatherSpawnTime <= CurTime()) then
				gatherSpawnTime = gatherSpawnTime + nut.config.get("pickaclesRate", 1800)
			
				local point = table.Random(self.gatherPoints)
				if (!point) then return end

				for _, v in pairs(self.spawnedGathers) do
					if point == v[2] then --it picked one that's already full
						gatherSpawnTime = gatherSpawnTime + nut.config.get("pickaclesRate", 1800)*0.1
						return 
					end
				end

				if #self.spawnedGathers >= nut.config.get("pickablesMax", 30) then return end
				
				self:setGathering(point)
			end
		end
	end

	function PLUGIN:setGathering(point)
		if(!istable(point[2])) then
			local entity = ents.Create("nut_storage")
			
			if(IsValid(entity)) then
				entity:SetPos(point[1])
				entity:Spawn()
				
				local ranModel = table.Random(PLUGIN.pickableModels)
				local data = STORAGE_DEFINITIONS[ranModel]
				entity:SetModel(ranModel)
				entity:SetSolid(SOLID_VPHYSICS)
				entity:PhysicsInit(SOLID_VPHYSICS)
				entity:SetCreator(client)
				
				local collisionMins, collisionMaxs = entity:GetCollisionBounds()
				local height = math.abs(collisionMaxs.z - collisionMins.z)

				entity:SetPos(point[1] + entity:GetUp()*height*0.5)
	
				local physObj = entity:GetPhysicsObject()
				if(IsValid(physObj)) then
					physObj:Wake()
					physObj:EnableMotion(false)
				end

				nut.inventory.instance(data.invType, data.invData)
					:next(function(inventory)
						if (IsValid(entity)) then
							inventory.isStorage = true
							entity:setInventory(inventory)
							
							entity.pickable = true
							entity:setNetVar("locked", true)
							entity.password = math.Rand(1,1000)

							entity.skillCheck = table.Random({1, 1, 1, 1, 4, 4, 8, 8, 12, 16})
							entity:setNetVar("desc", "Lock Strength: " ..entity.skillCheck)

							entity.nutForceDelete = true
							
							local ranItems = math.random(1,4)
							for i = 1, ranItems do
								local amount, ranItem = table.Random(PLUGIN.pickableLoot)

								inventory:addSmart(ranItem, amount)
							end

							if (isfunction(data.onSpawn)) then
								data.onSpawn(entity)
							end
						end
					end, function(err)
						if (IsValid(entity)) then
							storage:Remove()
						end
					end)
				
				table.insert(self.spawnedGathers, {entity, point})
			end
		end
	end

	function PLUGIN:removeInvalidGathers()
		for k, v in ipairs(self.spawnedGathers) do
			if !IsValid(v[1]) then
				table.remove(self.spawnedGathers, k)
			end
		end
	end
end

netstream.Hook("nut_displayPickableSpawnPoints", function(data)
	for k, v in pairs(data) do
		local emitter = ParticleEmitter(v[1])
		local smoke = emitter:Add("sprites/glow04_noz", v[1])
		smoke:SetVelocity(Vector(0, 0, 1))
		smoke:SetDieTime(15)
		smoke:SetStartAlpha(255)
		smoke:SetEndAlpha(255)
		smoke:SetStartSize(64)
		smoke:SetEndSize(64)
		smoke:SetColor(0,255,0)
		smoke:SetAirResistance(300)
	end
end)

nut.command.add("pickablespawnadd", {
	adminOnly = true,
	syntax = "<string entity>",
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + Vector(trace.HitNormal*5)
		
		table.insert(PLUGIN.gatherPoints, {hitpos, arguments[1]})
		PLUGIN:setGathering(PLUGIN.gatherPoints[#PLUGIN.gatherPoints])
		
		client:notify("Pickable spawn added.")
	end
})

nut.command.add("pickablespawnremove", {
	adminOnly = true,
	syntax = "<number distance>",
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local hitpos = trace.HitPos + trace.HitNormal*5
		local range = arguments[1] or 128
		local count = 0
		for k, v in pairs(PLUGIN.gatherPoints) do
			local distance = v[1]:Distance(hitpos)
			if distance <= tonumber(range) then
				PLUGIN.gatherPoints[k] = nil
				count = count+1
			end
		end
		
		client:notify(count.. " pickable spawners removed.")
	end
})

nut.command.add("pickablespawndisplay", {
	adminOnly = true,
	onRun = function(client)
		if SERVER then
			netstream.Start(client, "nut_displayPickableSpawnPoints", PLUGIN.gatherPoints)

			client:notify("Displaying pickable spawners.")
		end
	end
})