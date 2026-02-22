local PLUGIN = PLUGIN

nut.util.include("sh_anim.lua")
nut.util.include("sh_buffs.lua")
nut.util.include("sh_helpers.lua")
nut.util.include("sh_hooks.lua")

ENT.Type = "nextbot"
ENT.Base = "base_nextbot"
ENT.PrintName = "Combat Base"
ENT.Category = "NutScript"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.combat = true
ENT.model = "models/Humans/Group01/male_02.mdl"

ENT.hp = 0
ENT.dmg = 0
ENT.dmgT = "Physical"

--[[
--all attributes
ENT.attribs = {
	["end"] = 0,
	["stm"] = 0,
	["foresight"] = 0,
	["intelligence"] = 0,
	["luck"] = 0,
	["mana"] = 0,
	["str"] = 0,
	["vitality"] = 0
}
--]]

function ENT:Initialize()
	self:basicSetup()
end

--this is just here because it's a nextbot
function ENT:RunBehaviour()
	while (true) do
		local patrol = self:GetPatrol()
		if(patrol.route and !patrol.pause) then
			local current = (patrol.current or 1)

			if(!self.ongoingPatrol and ((self.nextPatrol or 0) < CurTime())) then
				self.ongoingPatrol = true
			
				self:walkAnims(0)
			
				local patrolPos = patrol.route[current+1]
				local done = self:MoveTo(patrolPos, {})

				if(done) then
					self.nextPatrol = CurTime() + (patrol.wait or 1)
				
					patrol.current = (patrol.current + 1) % (#patrol.route)
					self.ongoingPatrol = nil
				end
			end
		else
			if(self.desiredPos) then
				self:MoveTo(self.desiredPos, {tolerance = 10})
			end
		end

		coroutine.yield()
	end
end

function ENT:FailedPath()
	self.failedPath = true
end

function ENT:StuckTeleport(pos)
	self.desiredPos = nil
	self.failedPath = nil

	self:SetPos(pos)

	self:resetAnim()
	
	self:GravityDisable()
end

function ENT:GravityEnable()
	self.loco:SetGravity(1000)
	self:SetGravity(1000)
end

function ENT:GravityDisable()
	self.loco:SetGravity(0)
	self:SetGravity(0)
end

function ENT:MoveTo(pos, options, endFunc)
	if(!pos) then return end

	local dist = self:GetPos():Distance2D(pos)
	local estimation = dist / self:GetSequenceGroundSpeed(self:GetSequence())

	local startMove = CurTime()
	
	self.desiredPos = pos
	
	self:GravityEnable()

	local nav = navmesh.GetNearestNavArea(pos)
	if(IsValid(nav)) then
		if(!self.failedPath) then
			local closest = nav:GetClosestPointOnArea(pos)
			if(closest:DistToSqr(pos) <= 50000) then
				pos = closest
			else
				self:FailedPath()
			end
		end
	end
	
	if(navmesh.IsLoaded() and !self.failedPath) then
		local path = Path("Follow")
		path:SetMinLookAheadDistance(options.lookahead or 500)
		
		local tolerence = options.tolerance or 25
		if(self:GetModelScale() > 1) then
			tolerence = tolerence + (10 * self:GetModelScale())
		end
		
		path:SetGoalTolerance(tolerence)

		if(!path:Compute(self, pos)) then
			self:FailedPath()
			return
		end
		
		if (!path:IsValid()) then 
			self:FailedPath()
			return
		end
		
		while(path:IsValid()) do
			if(self.interruptPath) then 
				self.interruptPath = nil
				return 
			end
			
			self.loco:FaceTowards(pos)
			path:Update(self)
			
			if (self.loco:IsStuck()) then
				self:StuckTeleport(pos)
				
				return true
			end

			coroutine.yield()
		end
	else
	--elseif(self.failedPath) then
		local distToNewPos = self:GetPos():DistToSqr(pos)

		while (distToNewPos >= 8192) do
			if(self.interruptPath) then 
				self.interruptPath = nil
				return
			end
			
			if (self.loco:IsStuck()) then
				self:StuckTeleport(pos)
				
				return true
			end

			if((startMove + estimation) < CurTime()) then
				self:StuckTeleport(pos)
				
				return
			end

			self.loco:FaceTowards(pos)
			self.loco:FaceTowards(pos)
			self.loco:FaceTowards(pos)
			self.loco:FaceTowards(pos)
			self.loco:Approach(pos, 1)

			distToNewPos = self:GetPos():DistToSqr(pos)

			coroutine.yield()
		end
	end
	
	self:GravityDisable()

	self.desiredPos = nil
	self:resetAnim()

	return true
end

function ENT:basicSetup()
	self:SetRenderMode(RENDERMODE_TRANSALPHA)

	if (SERVER) then
		--self.attribs = self.savedAttribs or self.attribs or {}
		self.inv = self.inv or {}
	
		local model
		if(self.models) then
			model = table.Random(self.models)
		else
			model = self.model
		end

		self:SetModel(model)
		self:SetSkin(self.skin or 0)
		self:SetMaterial(self.material or self:GetMaterial())
		self:SetColor(self.color)
		
		self:SetUseType(SIMPLE_USE)
		
		if(!self.saveKey) then
			self:DropToFloor()
		end
	end
	
	self:physicsSetup()
	
	if(SERVER) then
		if(self.modelScale) then
			self:SetModelScale(self.modelScale)
			self:Activate()
		end
	end

	self:setAnim()
end

function ENT:physicsSetup()
	if(SERVER) then
		self:DrawShadow(true)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_BBOX)

		local physObj = self:GetPhysicsObject()
		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:EnableGravity(false)
			--physObj:Sleep()
			physObj:EnableCollisions(false)
			physObj:SetMass(101)
		end
		
		if(self.loco) then
			self.loco:SetAcceleration(900)
			self.loco:SetDeceleration(100000)
			self.loco:SetGravity(0)
			
			self:SetGravity(0)
		end
	end
	
	self:SetCollisionBounds(Vector(-20,-20,0), Vector(20,20,100))
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
end

function ENT:getSaveData()
	local saveData = {
		name = self:Name(),
		desc = self:Desc(),
		hp = self:getHP(),
		hpMax = self:getMaxHP(true),
		mp = self:getMP(),
		mpMax = self:getMaxMP(),
		
		armor = self:getNetVar("armor", self.armor),
		armorBreak = self:getNetVar("armorBreak", self.armorBreak),
		evasion = self:getNetVar("evasion", self.evasion),
		accuracy = self:getNetVar("accuracy", self.accuracy),
		
		attribs = self:getNetVar("attribs", self.attribs),
		actions = self:getNetVar("actions", self.actions),
		dmg = self:getNetVar("dmg", self.dmg),
		res = self:getNetVar("res", self.res),
		amp = self:getNetVar("amp", self.amp),
		
		model = self:GetModel(),
		modelScale = self:GetModelScale(),
		mat = self:GetMaterial(),
		color = self:GetColor(),
		patrol = self:GetPatrol(),
		
		IdleAnim = self:getNetVar("IdleAnim"),
		WalkAnim = self:getNetVar("WalkAnim"),
		RunAnim = self:getNetVar("RunAnim"),
		AttackAnim = self:getNetVar("AttackAnim"),
		CurAnim = self:GetSequence(),
	}
	
	if(IsValid(self.weapon)) then
		saveData.weapon = {self.weapon:GetModel(), self.weapon:GetMaterial()}
	end
	
	saveData.bodygroups = {}
	for k, v in pairs(self:GetBodyGroups() or {}) do
		saveData.bodygroups[v.id] = self:GetBodygroup(v.id)
	end
	
	local subMats = {}
	for k, v in pairs(self:GetMaterials() or {}) do
		subMats[k-1] = self:GetSubMaterial(k-1)
	end
	saveData.submat = subMats
	
	for k,v in pairs(self:GetChildren()) do
		if v:GetClass() == "ent_bonemerged" then
			saveData.bonemerged[#saveData.bonemerged+1] = v:GetModel()
		end
	end
	
	return saveData
end

function ENT:loadSaveData(data)
	self:SetModel(data.model or self:GetModel())
	self:SetMaterial(data.mat or self:GetMaterial() or "")
	self:SetColor(data.color or self:GetColor() or Color(255,255,255))

	for k, v in pairs(data.bodygroups or {}) do
		self:SetBodygroup(k, v)
	end

	for k, v in pairs(data.submat or {}) do
		self:SetSubMaterial(k, v)
	end
	
	if(data.weapon) then
		self:EquipWeapon(data.weapon[1], data.weapon[2])
	end
	
	self:setNetVar("attribs", data.attribs)
	self:setNetVar("res", data.res)
	self:setNetVar("amp", data.amp)
	self:setNetVar("dmg", data.dmg)
	self:setNetVar("actions", data.actions)

	self:setMaxHP(data.hpMax or self.hpMax or self.hp)
	self:setHP(data.hp or self.hp or 0)

	self:setNetVar("name", data.name or self:Name())
	self:setNetVar("desc", data.desc or self:Desc())
	
	self:setNetVar("armor", data.armor or self.armor)
	self:setNetVar("armorBreak", data.armor or self.armorBreak)
	self:setNetVar("evasion", data.evasion or self.evasion)
	self:setNetVar("accuracy", data.accuracy or self.accuracy)
	
	for k, v in pairs(data.bonemerged or {}) do
		local nextBonemerged = ents.Create("prop_physics")
		nextBonemerged:SetModel(v)
		nextBonemerged:Spawn()
		nextBonemerged:Activate()
		rb655_ApplyBonemerge(nextBonemerged, clone)
	end
	
	if(data.anim) then --to support older CEnts
		self:ResetSequence(data.anim)
	elseif(data.CurAnim) then
		self:ResetSequence(data.CurAnim)
	end
	
	self:setNetVar("WalkAnim", data.WalkAnim)
	self:setNetVar("RunAnim", data.RunAnim)
	self:setNetVar("IdleAnim", data.IdleAnim)
	self:setNetVar("AttackAnim", data.AttackAnim)
	
	self:physicsSetup()
	
	if(data.modelScale) then
		self:SetModelScale(data.modelScale or self:GetModelScale())
		self:Activate()
	end
	
	if(data.patrol) then
		self.patrol = data.patrol
	end
end

function ENT:Think()
	self:CustomThink()

	if(SERVER) then	
		if(!self.loco or !IsValid(self.loco)) then return end
	
		if(self:IsPlayerHolding()) then
			--if held with physgun while moving, will teleport to end when hold ends
			if(self.desiredPos) then 
				self.nudged = true
			end
		else
			local physObj = self:GetPhysicsObject()
			if(IsValid(physObj)) then
				if(physObj:GetPos() != self:GetPos()) then
					physObj:SetPos(self:GetPos())
					physObj:SetAngles(self:GetAngles())
				end

				if(!physObj:IsAsleep()) then
					physObj:Sleep()
				end
			end
			
			--if held with physgun while moving, will teleport to end when hold ends
			if(self.nudged and self.desiredPos) then
				self:SetPos(self.desiredPos)
				self.nudged = nil
			end
			
			if(!self.desiredPos) then
				self.loco:SetVelocity(Vector(0,0,0))
			elseif(self.desiredPos and !self.loco:IsOnGround()) then --basically they drift off into the sunset if you dont do this
				--self:SetPos(self.desiredPos)
				--self.desiredPos = nil
			end
		end
		
		if(IsValid(self.follow) and !self.desiredPos and !(self.follow and self.follow:InVehicle())) then
			local followPos = self.follow:GetPos() + self.follow:GetRight() * -50
		
			local range = self:GetRangeSquaredTo(followPos)
		
			if(range > 32768 and !stuck) then
				self:movementStart(followPos)
			
				self.desiredPos2 = followPos
			elseif((self.desiredPos2 and range < 256) or stuck) then
				self.loco:SetVelocity(Vector(0,0,0))

				self:SetPos(followPos)
				
				self.desiredPos2 = nil
				
				self:resetAnim()
			end
			
			if(self.desiredPos2) then
				self.loco:Approach(followPos, 1)
			end
		end
		
		if(self.loco and self.loco:GetDesiredSpeed() != 0) then
			self:StepThink()
		end
	end
end

--adds a weapon model to a CEnt's hands
function ENT:EquipWeapon(modelPath, materialPath)
	if(IsValid(self.weapon)) then 
		SafeRemoveEntity(self.weapon)
	end

	self.WeaponMount = self:LookupAttachment("anim_attachment_RH")
	self.WeaponPosition = self:GetAttachment(self.WeaponMount)

	self.weapon = ents.Create("prop_dynamic")
	self.weapon:SetModel(modelPath)
	
	if(materialPath) then
		self.weapon:SetMaterial(materialPath)
	end
	
	self.weapon:Spawn()
	self.weapon:SetParent(self, self.WeaponMount)
	self.weapon:SetMoveType(MOVETYPE_NONE)
	
	if(self.weapon:GetBoneCount() > 1) then -- if it has bones to merge
		self.weapon:AddEffects(EF_BONEMERGE)
	elseif(self.WeaponPosition) then --if it do not have bones to merge
		self.weapon:SetPos(self.WeaponPosition.Pos)
		self.weapon:SetAngles(self.WeaponPosition.Ang)
	end
	
	self.savedWeapon = {modelPath, materialPath}
end

function ENT:CustomThink()
end

function ENT:HandleStuck()
end

--death
function ENT:die()
	if(!self.noRag) then
		local ragdoll = ents.Create("prop_ragdoll")
		if IsValid(ragdoll) then 
			ragdoll:SetPos(self:GetPos())
			ragdoll:SetModel(self:GetModel())
			ragdoll:SetAngles(self:GetAngles())
			ragdoll:Spawn()
			ragdoll:SetSkin(self:GetSkin())
			ragdoll:SetColor(self:GetColor())
			ragdoll:SetMaterial(self:GetMaterial())
			ragdoll:SetBloodColor(self:GetBloodColor())
				
			for k, v in pairs(self:GetMaterials() or {}) do
				local subMat = self:GetSubMaterial(k-1)

				ragdoll:SetSubMaterial(k-1, subMat)
			end
				
			local num = ragdoll:GetPhysicsObjectCount()-1
	   
			for i=0, num do
				local bone = ragdoll:GetPhysicsObjectNum(i)

				if IsValid(bone) then
					local bp, ba = self:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))
					if bp and ba then
						bone:SetPos(bp)
						bone:SetAngles(ba)
					end
				end
			end
			
			for k, v in pairs(self:GetBodyGroups() or {}) do
				ragdoll:SetBodygroup(v.id, self:GetBodygroup(v.id))
			end
			
			ragdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			
			if (self:IsOnFire()) then --if the npc is on fire, set the ragdoll on fire too.
				ragdoll:Ignite(10,20)
			end
			
			ragdoll.hasMenu = true
			
			local data = {
				class = self:GetClass(),
				saveData = self:getSaveData(),
			}
			
			ragdoll.deathData = data
		end
	
		--gets rid of ragdolls that dont have phys objects, just a cautionary thing.
		if(!IsValid(ragdoll:GetPhysicsObject())) then
			SafeRemoveEntity(ragdoll)
		end
	end
	
	if(self.inv) then
		for k, v in pairs(self.inv) do
			nut.item.spawn(v, self:GetPos())
		end
	end
	
	SafeRemoveEntity(self)
end


--death
function ENT:statue()
	if(!self.noRag) then
		local ragdoll = ents.Create("prop_ragdoll")
		if ragdoll:IsValid() then 
			ragdoll:SetPos(self:GetPos())
			ragdoll:SetModel(self:GetModel())
			ragdoll:SetAngles(self:GetAngles())
			ragdoll:Spawn()
			ragdoll:SetSkin(self:GetSkin())
			ragdoll:SetColor(self:GetColor())
			ragdoll:SetMaterial(self:GetMaterial())
			ragdoll:SetBloodColor(self:GetBloodColor())
				
			local num = ragdoll:GetPhysicsObjectCount()-1
	   
			for i=0, num do
				local bone = ragdoll:GetPhysicsObjectNum(i)

				if IsValid(bone) then
					local bp, ba = self:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))
					if bp and ba then
						bone:SetPos(bp)
						bone:SetAngles(ba)
						
						bone:EnableMotion(false)
					end
				end
			end
			
			for k, v in pairs(self:GetBodyGroups() or {}) do
				ragdoll:SetBodygroup(v.id, self:GetBodygroup(v.id))
			end
			
			ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
			
			if (self:IsOnFire()) then --if the npc is on fire, set the ragdoll on fire too.
				ragdoll:Ignite(10,20)
			end
			
			ragdoll.hasMenu = true
		end
	
		--gets rid of ragdolls that dont have phys objects, just a cautionary thing.
		if(!IsValid(ragdoll:GetPhysicsObject())) then
			SafeRemoveEntity(ragdoll)
		end
	end
	
	if(self.inv) then
		for k, v in pairs(self.inv) do
			nut.item.spawn(v, self:GetPos())
		end
	end
	
	SafeRemoveEntity(self)
end

function ENT:movementStart(position, walk)
	if(SERVER) then
		if(self.desiredPos) then self.interruptPath = true end
		
		self.desiredPos = position
		self.patrol = nil
		
		self:walkAnims(self:GetPos():Distance(position), walk)
	end
end

--dont do anything
function ENT:OnTakeDamage(dmginfo)
end

--dont do it
function ENT:OnTraceAttack( dmginfo, dir, trace )
end

--no
function ENT:OnKilled( dmginfo )
end

function ENT:OnRemove()
end

function ENT:StepThink()
	if(!self.FootstepSounds) then return end
	if(!self.Stepped) then self.Stepped = {} end
	if(!self.StoredStepCycle) then self.StoredStepCycle = 2 end

	if((self.nextStepThink or 0) > CurTime()) then return end
	self.nextStepThink = CurTime()+0.05

	if(self.StepData) then --uses animation cycles to determine steps
		local cycle = self:GetCycle()
		if(cycle < self.StoredStepCycle) then
			for k, v in pairs(self.StepData) do
				self.Stepped[k] = nil
			end
		end
	
		for k, v in pairs(self.StepData) do
			if(cycle >= v and !self.Stepped[k]) then
				self:FootstepSound()
				self.Stepped[k] = true
			end

			self.StoredStepCycle = cycle
		end
	end
end

function ENT:FootstepSound()
	local sound = self.FootstepSounds
	
	if(istable(sound)) then
		sound = table.Random(sound)
	end

	self:EmitSound(sound, 75, self.pitch)
end

if (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end

	local TEXT_OFFSET = Vector(0, 0, 0)
	local toScreen = FindMetaTable("Vector").ToScreen
	local colorAlpha = ColorAlpha
	local drawText = nut.util.drawText
	local configGet = nut.config.get

	ENT.DrawEntityInfo = true

	function ENT:onDrawEntityInfo(alpha)
		--local position = toScreen(self:LocalToWorld(self, self:WorldSpaceCenter(self)) + TEXT_OFFSET)
		local position = toScreen(self:WorldSpaceCenter(self))
		local x, y = position.x, position.y
		drawText(self:Name(), x, y, colorAlpha(Color(190,50,50), alpha), 1, 1, nil, alpha * 0.65)

		if (self:Desc()) then
			drawText(self:Desc(), x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
		end

		local buffs = (self.getBuffs and self:getBuffs())
		if(buffs and !table.IsEmpty(buffs)) then
			local buffText = ""
			
			for k, v in pairs(buffs) do
				buffText = buffText.. " " ..(v.name or v.uid or "").. "."
			end
			
			drawText(buffText, x, y + 32, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
		end
	end
end

PLUGIN.CEntBase = ENT