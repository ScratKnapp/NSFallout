local PLUGIN = PLUGIN

function ENT:walkAnims(distance, walk)
	local run
	if(distance > 300 and !walk) then
		run = true
	end

	local seq
	local act
	
	--this whole block sucks
	local runAnims = {
		ACT_RUN,
		ACT_HL2MP_RUN_FAST,
	}
	
	local walkAnims = {
		ACT_WALK,
		ACT_HL2MP_WALK,
	}
	
	if(run) then
		local RunAnim = self:getNetVar("RunAnim", self.RunAnim)
	
		if(RunAnim) then
			seq = self:LookupSequence(RunAnim)
		else
			for k, v in pairs(runAnims) do
				seq = self:SelectWeightedSequence(v)
				act = v
				
				if(seq != -1) then break end
			end
		end
	else
		local WalkAnim = self:getNetVar("WalkAnim", self.WalkAnim)
		if(WalkAnim) then
			seq = self:LookupSequence(WalkAnim)
		else
			for k, v in pairs(walkAnims) do
				seq = self:SelectWeightedSequence(v)
				act = v
				
				if(seq != -1) then break end
			end
		end
	end

	local groundSpeed = 200
	
	if(seq != -1) then
		local tempAnim = self:GetSequence()
		if(tempAnim != seq and !self.prevAnim) then
			self.prevAnim = tempAnim
		end
	
		if(act) then
			self:StartActivity(act)
		end
		
		if(seq) then
			self:ResetSequence(seq)
		end
		
		--this tries to set the speed based on how fast the anim is
		groundSpeed = self:GetSequenceGroundSpeed(seq)
		if(groundSpeed < 1) then
			if(run) then --this is just a default value if the animation fails
				groundSpeed = 200
			else
				groundSpeed = 50
			end
		end
	end
	
	self.loco:SetDesiredSpeed(groundSpeed)
	self:SetPlaybackRate(1)
	self:SetPoseParameter("move_x", 1)
end

function ENT:resetAnim()
	local prevAnim = self.prevAnim or self.idle
	
	self:SetSequence(prevAnim)
	
	self.prevAnim = nil
end

function ENT:setAnim()
	local anim = self:getNetVar("anim", self.savedAnim)
	if(anim) then
		local savedAnim = tonumber(anim)
		
		local IdleAnim = self:getNetVar("IdleAnim", self.IdleAnim)
		
		timer.Simple(1, function()
			if(IsValid(self)) then
				self:ResetSequence(savedAnim)

				if(IdleAnim) then
					self.idle = self:LookupSequence(IdleAnim) or 4
				else
					for k, v in ipairs(self:GetSequenceList()) do
						if (v:lower():find("idle") and v != "idlenoise") then
							self.idle = k
							return
						end
					end
					
					self.idle = 4
				end
			end
		end)
	elseif(IdleAnim) then
		self.idle = self:LookupSequence(IdleAnim)
		self:ResetSequence(self:LookupSequence(IdleAnim))
	else
		for k, v in ipairs(self:GetSequenceList()) do
			if (v:lower():find("idle") and v != "idlenoise") then
				self.idle = k
				return self:ResetSequence(k)
			end
		end

		self.idle = 4
		self:ResetSequence(4)
	end
end

function ENT:attackAnimStart()
	local AttackAnim = self:getNetVar("AttackAnim", self.AttackAnim)
	if(AttackAnim) then
		local sequence = self:LookupSequence(AttackAnim)
		
		self:ResetSequence(sequence)
		self:SetCycle(0)
		
		timer.Simple(self:SequenceDuration(sequence), function()
			if(IsValid(self)) then
				self:setAnim()
			end
		end)
	end
end