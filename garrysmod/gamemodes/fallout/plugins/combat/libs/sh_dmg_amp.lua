local PLUGIN = PLUGIN
PLUGIN.helperFuncs = PLUGIN.helperFuncs or {}

--function playerMeta:getAmp()
PLUGIN.helperFuncs["getAmp"] = function(self)
	local char = self:getChar()
	local inv = char:getInv()
	
	--amplifications, start with amp from buffs
	local amp = self:getNetVar("amp", self.amp or {})
	amp = table.Copy(amp)

	local buffAmp = self:getBuffAttributeTbl("amp") or {}
	
	for k, v in pairs(buffAmp) do
		amp[k] = (amp[k] or 0) + v
	end
	
	hook.Run("nut_OnGetAmp", self, amp)
	
	for k, v in pairs(amp) do
		amp[k] = v * 0.01
	end
	
	--amp from items
	for k, v in pairs(inv:getItems()) do
		if(v:getData("equip")) then
			for k2, v2 in pairs(v:getData("amp", {})) do
				if(amp[k2]) then
					amp[k2] = 1 - (1 - amp[k2]) * (1 - v2 * 0.01)
				else
					amp[k2] = 1 - (1 - v2 * 0.01)
				end
			end
		end
	end
	
	--rounds resistance so it isnt scary numbers
	for k, v in pairs(amp) do
		amp[k] = math.Round(v, 4)
	end
	
	return amp
end

hook.Add("nut_ActionAttackData", "nut_AmpModify", function(action, attacker, info)
	local amp = attacker:getAmp()
	
	if(amp) then
		local broadTypes = {
			["Kinetic"] = true,
			["Energy"] = true,
		}
		
		--generalized damage amp
		for k, v in pairs(broadTypes) do
			if(amp[k] and PLUGIN:IsBroadType(action.dmgT, k)) then
				action.dmg = action.dmg * (1 + amp[k])
			end
		end
	
		--specific damage amp
		if(amp[action.dmgT]) then
			action.dmg = action.dmg * (1 + amp[action.dmgT])
		end
		
		--general damage amp
		if(amp["dmg"]) then 
			action.dmg = action.dmg * (1 + amp["dmg"])
		end
	end
end)