local PLUGIN = PLUGIN

function PLUGIN:attackSimulated(attacker, targets, info)
	local fakeAttack = true
	
	local data = {
		attacker = attacker,
		trace = trace,
		partString = partString,
		weapon = weapon,
		action = action,
		actionTbl = actionTbl,
	}

	local data = PLUGIN:getAttackData(attacker, info, fakeAttack)
	
	return data
end

--sets up an attack table with info from the attacker and action
function PLUGIN:getAttackData(attacker, info, fakeAttack)
	local action = table.Copy(info.actionTbl or {})
	local partString = info.partString
	local weapon = info.weapon or (info.action and info.action.weapon)
	local trace = info.trace

	local data = {}
	
	data.attacker = attacker
	data.name = attacker:Name()
	data.attackString = (action and action.attackString) or "attacks"
	data.part = partString

	if(action and !table.IsEmpty(action)) then
		local weaponItem = nut.item.instances[weapon]
	
		if(action.onGetAccuracy) then
			action.accuracy = action:onGetAccuracy(attacker, info)
		else
			action.accuracy = (attacker:getAccuracy(weaponItem) + (action.accuracy or 0)) * (action.accuracyMult or 1)
		end

		--check mana when they try to cast the action not now
		if(!fakeAttack) then
			if(PLUGIN:costCheck(attacker, action)) then
				--mana costs
				--[[
				if(action.costMP) then
					attacker:addMP(action.costMP * -1)
				end
				--]]
			
				if(action.costHP) then
					attacker:addHP(action.costHP * -1)
				end
				
				if(action.costAP) then
					attacker:addAP(action.costAP * -1)
				end
				
				if(action.CD) then
					attacker:addCooldown(action.uid, action.CD, weapon)
				end
			else
				--attacker:notify("You do not have enough mana to cast " ..action.name.. ".")
				data.failed = true --tell it that it failed
				data.actionName = action.name
				return data
			end
		
			--chance of action activation
			if(action.chance) then
				local roll = math.random(1,100)
				if(roll > tonumber(action.chance)) then --action failed
					data.failed = true --tell it that it failed
					data.actionName = action.name
					return data
				end
			end
		end
		
		hook.Run("nut_ActionAttackDataPre", action, attacker, info, fakeAttack)

		--if the action does damage we worry about damage bonuses and etc
		if(action.dmg) then
			--damage from attributes
			if(action.mult) then 
				for attrib, mult in pairs(action.mult) do
					action.dmg = action.dmg + (attacker:getChar():getAttrib(attrib, 0) * mult)
				end
			end

			--damage from attributes
			if(action.multSkill) then 
				for skill, mult in pairs(action.multSkill) do
					action.dmg = action.dmg + (attacker:getChar():getSkill(skill, 0) * mult)
				end
			end

			if(action.weaponMult) then
				local weaponDmg = 0
				
				local highestDmg = 0
				for k, v in pairs(attacker:getDamage(partString, weapon)) do
					weaponDmg = weaponDmg + v.dmg
					
					if(!action.dmgT and v.dmgT) then --just overwrite the damage type for now
						if(highestDmg < v.dmg) then
							highestDmg = v.dmg
							action.dmgT = v.dmgT
						end
					end
				end

				action.dmg = action.dmg + weaponDmg * action.weaponMult
			end

			hook.Run("nut_ActionAttackData", action, attacker, info, fakeAttack)

			--damage table
			data.damage = {}

			--local preAction = table.Copy(action)
			for i = 1, (action.multi or 1) do --multiple hits
				--this prevents the loop from decreasing/increasing things the more hits there are
				local subAction = table.Copy(action)

				hook.Run("nut_OnCombatAttack", subAction, attacker, info, fakeAttack)
			
				data.damage[i] = {
					dmg = subAction.dmg,
					dmgT = subAction.dmgT,
					accuracy = subAction.accuracy,
					special = subAction.special,
					part = partString,
					crit = subAction.critMsg,
					--ammo = currentMag, --current ammo
					--ammoMax = magSize, --max ammo
				}
			end
		else
			data.damage = {}
		end
		
		data.notarget = action.notarget
		
		--action effects
		data.effects = action.effects
		
		--summons
		data.summon = action.summon
		
		--special things
		data.special = action.special
	else
		--basic attack
		local dmgTbl = attacker:getDamage(partString, weapon)
		
		for k, v in pairs(dmgTbl) do
			hook.Run("nut_ActionAttackData", v, attacker, info, fakeAttack)
			hook.Run("nut_OnCombatAttack", v, attacker, info, fakeAttack)
		end
		
		data.damage = dmgTbl
	end
	
	data.text = nil

	return data	
end