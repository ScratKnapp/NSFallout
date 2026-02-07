-- Most of this is currently unused, but it's here anyways
local PLUGIN = PLUGIN

local playerMeta = FindMetaTable("Player")

local function findTargetInRad(startPos, radius)
	local entities = ents.FindInSphere(startPos, radius)
	local targets = {}

	for k, target in pairs(entities) do
		if(target:GetClass() == "prop_ragdoll" and target.nutPlayer) then
			target = target.nutPlayer
		end
	
		if(IsValid(target) and (target:IsPlayer() or target.combat)) then
			if(target:GetMoveType() == MOVETYPE_NOCLIP) then continue end --ignore noclipped people
		
			targets[#targets + 1] = target
		end
	end
	
	return targets
end

local function findTargetInCone(startPos, forward, cone, cone2)
	local entities = ents.FindInCone(startPos, forward * cone, cone, cone2 or 90)
	local targets = {}
	
	for k, target in pairs(entities) do
		if(target:GetClass() == "prop_ragdoll" and target.nutPlayer) then
			target = target.nutPlayer
		end
	
		if(IsValid(target) and (target:IsPlayer() or target.combat)) then
			if(target:GetMoveType() == MOVETYPE_NOCLIP) then continue end --ignore noclipped people
		
			targets[#targets + 1] = target
		end
	end
	
	return targets
end

local function findTargetInBox(position, mins, maxs)
	local boxMins = position + mins
	local boxMaxs = position + maxs
	
	local entities = ents.FindInBox(boxMins, boxMaxs)
	local targets = {}
	
	for k, target in pairs(entities) do
		if(target:GetClass() == "prop_ragdoll" and target.nutPlayer) then
			target = target.nutPlayer
		end
	
		if(IsValid(target) and (target:IsPlayer() or target.combat)) then
			if(target:GetMoveType() == MOVETYPE_NOCLIP) then continue end --ignore noclipped people
		
			targets[#targets + 1] = target
		end
	end
	
	return targets
end

function PLUGIN:attackStart(client, info)
	local attacker = info.attacker
	local trace = info.trace
	local action = info.action
	local actionTbl = info.actionTbl
	local partString = info.partString
	local weapon = info.weapon

	local entity = trace.Entity
	local target = entity
	local selfOnly = action.selfOnly
	local hitPos = trace.HitPos
	
	if(target:IsRagdoll() and target.nutPlayer) then
		target = target.nutPlayer
	end
	
	info.client = client
	
	if(actionTbl.onCanAct) then
		if(!actionTbl:onCanAct(attacker, info)) then
			return false
		end
	end
	
	if(client:IsPlayer() and client:KeyDown(IN_WALK)) then --self targetting
		selfOnly = true
	end

	local targets

	if(actionTbl.onGetTargets) then
		targets = actionTbl:onGetTargets(attacker, info)
	elseif(selfOnly) then --action that targets self
		if(action.radius) then --sphere around caster
			targets = findTargetInRad(attacker:GetPos(), action.radius)
		elseif(action.box) then
			targets = findTargetInBox(attacker:GetPos(), action.box)
		else --only affects the caster
			targets = {attacker}
		end
	elseif(action.notarget) then --action that requires no target
		if(action.radius) then --no targetted aoe
			targets = findTargetInRad(hitPos, action.radius)
		elseif(action.cone) then --cone originating from attacker
			local forward = attacker:GetForward() * Vector(1,1,0)
			
			targets = findTargetInCone(attacker:GetPos(), forward, action.cone, action.cone2)
		elseif(action.box) then
			targets = findTargetInBox(hitPos, action.box)
		end
	elseif(IsValid(target)) then--actions that requires a target
		if(target:GetClass() == "prop_ragdoll" and target.nutPlayer) then
			targets = target.nutPlayer
		elseif (target.combat or target:IsPlayer()) then
			if(IsValid(attacker) and attacker != target) then
				if(!action.uid) then --regular attack, not a action
					targets = {target}
				else
					if(action.radius) then --sphere around entity
						local entities = ents.FindInSphere(target:GetPos(), action.radius)
						
						targets = findTargetInRad(target:GetPos(), action.radius)
					elseif(action.cone) then --cone starting from target
						local forward = attacker:GetForward() * Vector(1,1,0)

						targets = findTargetInCone(attacker:GetPos(), forward, action.cone, action.cone2)
					elseif(action.box) then
						targets = findTargetInBox(attacker:GetPos(), action.box)
					else --single target
						targets = {target}
					end
				end
				
				if(attacker.combat) then
					--attacker:attackAnim()
				end
			end
		end
	end
	
	if(targets or action.notarget) then
		PLUGIN:attack(attacker, targets, info)
	end
end

--sets up an attack table with info from the attacker and action
function PLUGIN:getAttackData(attacker, info)
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
		
		hook.Run("nut_ActionAttackDataPre", action, attacker, info)

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

			hook.Run("nut_ActionAttackData", action, attacker, info)

			--damage table
			data.damage = {}

			--local preAction = table.Copy(action)
			for i = 1, (action.multi or 1) do --multiple hits
				--this prevents the loop from decreasing/increasing things the more hits there are
				local subAction = table.Copy(action)

				hook.Run("nut_OnCombatAttack", subAction, attacker, info)
			
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
			hook.Run("nut_ActionAttackData", v, attacker, info)
			hook.Run("nut_OnCombatAttack", v, attacker, info)
		end
		
		data.damage = dmgTbl
	end
	
	data.text = nil

	return data	
end

--main attack function, handles mostly everything
function PLUGIN:attack(attacker, target, info)
	local action = info.action
	local actionTbl = info.actionTbl
	
	local actionID = action and action.uid
	local name = attacker:Name() --name of attacker
	
	local attackData = PLUGIN:getAttackData(attacker, info)
	if(attackData.failed) then
		local response = name.. "'s ability <" ..attackData.actionName.. "> has failed to activate!"
		
		--nut.chat.send(attacker, "react_npc", response)
		nut.plugin.list["chatboxextra"]:ChatboxSend(attacker, "react_npc", response)

		nut.log.addRaw(response, 2)
		
		return false --just stop here we dont need to do anything else
	end

	--if it's a summoning action or summons something when it happens
	if(attackData.summon) then
		PLUGIN:summonAction(attacker, info)
	end

	--local response = attackInfo.name.. " " ..(attackInfo.attackString or "")
	local responseTbl = {}

	--handles damage parts of the attack
	local damage = attackData.damage --damage table
	local effects = attackData.effects
	local special = attackData.special
	
	if(target) then
		for k, v in pairs(target) do
			if(actionTbl.noSelf and v == attacker) then continue end
			
			local evade
			
			if(damage) then
				if(!responseTbl["dmg"]) then responseTbl["dmg"] = {} end
				responseTbl["dmg"][v] = PLUGIN:damageProcess(v, attackData)

				evade = true
				--checks if the attack missed or not
				--if it missed, apply effect too
				if(table.IsEmpty(responseTbl["dmg"][v])) then
					--clear this so it isnt in the response table
					responseTbl["dmg"][v] = nil 
				
					evade = false
				else
					for k, dmgTbl in pairs(responseTbl["dmg"][v]) do
						if(!dmgTbl.evade) then
							evade = false
						end
					end
				end
			end
			
			if(effects) then
				if(!responseTbl["effect"]) then responseTbl["effect"] = {} end

				if(!evade) then
					local effectResponse, extraResponse = PLUGIN:effectProcess(v, attackData)
					
					--effects affecting the target
					responseTbl["effect"][v] = effectResponse
					
					if(extraResponse) then
						responseTbl["effect"][attacker] = responseTbl["effect"][attacker] or {}
						--effects affecting the attacker (selfApply)
						table.Merge(responseTbl["effect"][attacker], extraResponse)
					end
				end
			end
			
			if(special) then
				action.special(attacker, v)
			end
		end
	end
	
	PLUGIN:combatStringCreate(attackData, responseTbl, info)
end

--processing damage and creates the chat message
function PLUGIN:damageProcess(target, attack, responseString)
	local attackInfo = table.Copy(attack) --just in case

	local damage = attackInfo.damage
	
	local responseTbl = {} --for printed string later

	if(IsValid(target) and !table.IsEmpty(damage)) then		
		local totalDam = 0
		
		hook.Run("nut_OnCombatDamageProcess", target, damage, attackInfo)

		for k, v in pairs(damage) do	
			if(!v.dmg) then	continue end
			
			--variance
			v.dmg = math.Round(math.Rand(v.dmg * 0.99, v.dmg * 1.01))
			
			--evasion
			local evade, evaReduct = PLUGIN:evadeCheck(target, v.accuracy, v.dmg)
			v.dmg = v.dmg * (evaReduct or 1)
			
			--reduce damage by target's resistances
			v.dmg = target:receiveDamage(v.dmg, v.dmgT, v.part) --resistances handled in here

			--round it so there's no crazy decimals
			v.dmg = math.Round(math.max(v.dmg, 0), 2) 
			
			--set the target's hp
			target:addHP(v.dmg * -1)
			
			responseTbl[#responseTbl+1] = {
				target = target,
				dmg = v.dmg,
				dmgT = v.dmgT,
				crit = v.crit,
				evade = evade,
			}

			totalDam = totalDam + (v.dmg or 0)
		end
		
		hook.Run("nut_OnCombatDamageProcessPost", target, damage, attackInfo)
	end

	return responseTbl
end

--processing effects and creates the chat message
function PLUGIN:effectProcess(target, attack)
	local attackInfo = table.Copy(attack) or {} --just in case
	local effects = attackInfo.effects

	local responseTbl = {}
	local extraTbl

	for k, effect in pairs(effects) do
		local effectName = effect.name or effect.effect or effect.uid
	
		if(effect.uid) then
			effect.uid = effect.uid..k
		end
	
		if(effect.selfApply) then --self effects from casting spell
			if(attackInfo.attacker) then	
				extraTbl = extraTbl or {}
				extraTbl[effectName] = attackInfo.attacker:receiveEffect(effect)
			end
		else --regular effects on target
			if(target) then
				responseTbl[effectName] = target:receiveEffect(effect)
			end
		end
	end
	
	return responseTbl, extraTbl
end

function PLUGIN:combatStringCreate(attackData, responseTbl, info)	
	local attacker = attackData.attacker

	--who all will receive the chat message
	local receivers = {}

	local chatPrint = ""
	
	--start of the string, "Attacker "
	chatPrint = chatPrint..((attackData.name and attackData.name.. " ") or "Something ")
	
	--[[
	local weaponString = ""
	if(attacker:IsPlayer()) then
		local char = attacker:getChar()
		for k, v in pairs(char:getInv():getItems()) do
			if(!v:getData("equip")) then continue end
			if(!v:getData("dmg", v.dmg)) then continue end

			weaponString = weaponString.. " {" ..v:getName().. "}"
		end
	end
	--]]

	local partString = info.partString
	if(partString) then
		partString = "[" ..partString.. "]"
	else
		partString = ""
	end

	--attack's description
	if(attackData.attackString) then
		--chatPrint = chatPrint..attackData.attackString.. "." ..weaponString
		chatPrint = chatPrint..attackData.attackString.. " " ..partString.. "."
	else
		chatPrint = chatPrint.. "attempts to use {" ..(attackData.name or "Attack").."}"
	end
	
	--a simplified print with no damage numbers or effects
	local simplePrint = chatPrint

	--damage line
	local dmgPrint = ""
	local dmgTbl = responseTbl.dmg

	if(dmgTbl and !table.IsEmpty(dmgTbl)) then
		dmgPrint = "[DAMAGE]"

		for client, clientDMG in pairs(dmgTbl) do
			receivers[#receivers+1] = client
		
			local totalDam = 0 --total damage
			local totalMiss = 0
		
			dmgPrint = dmgPrint.. " " ..client:Name().. " {"
			simplePrint = simplePrint.. " (" ..client:Name().. ") "
			for k, dmgTbl in pairs(clientDMG) do
				totalDam = totalDam + (dmgTbl.dmg or 0)
			
				if(dmgTbl.evade) then
					totalMiss = totalMiss+1
				end
			
				local dmgS = (dmgTbl.dmg or 0).. " "
				local critS = ((dmgTbl.crit) or "")
				local evasionS = ((dmgTbl.evade and "[" ..dmgTbl.evade.. "] ") or "")
				local dmgTS = (dmgTbl.dmgT or "Blunt")
				
				--dmgPrint = dmgPrint..dmgS..critS..evasionS..dmgTS
				
				if(k != #clientDMG) then
					--dmgPrint = dmgPrint.. " + "
				--elseif(#clientDMG > 1) then
				else --print on the last one
					--dmgPrint = dmgPrint.. " [" ..totalDam.. "]"
					
					--for multi hits, tells you how many missed, if any
					if(#clientDMG > 1) then
						if(totalMiss > 0) then
							evasionS = "[" ..totalMiss.. " Missed] "
						end
					end
					
					dmgPrint = dmgPrint..totalDam.. " " ..critS..evasionS..dmgTS
				end
			end
			
			dmgPrint = dmgPrint.. "}"
		end

		chatPrint = chatPrint.. "\n" ..dmgPrint
	end

	--effect line
	local effectPrint = ""
	local effectTbl = responseTbl.effect
	
	if(effectTbl and !table.IsEmpty(effectTbl)) then
		effectPrint = "[EFFECT]"
		for client, clientEff in pairs(effectTbl) do
			receivers[#receivers+1] = client
		
			effectPrint = effectPrint.. " " ..client:Name().. " ["
			
			local loop = 1
			for effName, effTbl in pairs(clientEff) do
				if(!effTbl.success) then continue end

				if(effTbl.duration > 1) then 
					effectPrint = effectPrint..effName.. ": " ..effTbl.duration.. "T"
				else
					effectPrint = effectPrint..effName.. ": Now"
				end
				
				if(loop != table.Count(clientEff)) then
					effectPrint = effectPrint.. ", "
				end
				
				loop = loop + 1 --stupid iterator
			end
			
			effectPrint = effectPrint.. "]"
		end

		chatPrint = chatPrint.. "\n" ..effectPrint
	end

	if(attackData.attacker) then
		receivers[#receivers+1] = attackData.attacker
	end

	local entities = ents.FindInSphere(attackData.attacker:GetPos(), nut.config.get("chatRange", 280) * 5)
	for k, v in pairs(entities) do
		if(v:IsPlayer()) then
			receivers[#receivers+1] = v
		end
	end
	
	if(nut.config.get("combatDamageDisplay")) then
		nut.plugin.list["chatboxextra"]:ChatboxSend(attackData.attacker, "react_npc", chatPrint, false, receivers)
	else
		nut.plugin.list["chatboxextra"]:ChatboxSend(attackData.attacker, "react_npc", simplePrint, false, receivers)
	end

	nut.log.addRaw(chatPrint)
end

function PLUGIN:summonAction(attacker, info)
	local actionTbl = info.actionTbl
	local trace = info.trace
	local pos = trace.HitPos

	local summon = ents.Create(actionTbl.summon)
	if(IsValid(summon)) then
		summon:SetPos(pos)
		summon:SetCreator(attacker)
		summon.playerControlled = true
		summon:Spawn()
		
		if(summon.Name) then
			local name = summon:Name()
			summon:setNetVar("name", attacker:Name().. "'s " ..(name or ""))
		end
			
		if(attacker:IsPlayer()) then
			attacker:Give("nut_cmover")
		end
		
		if(attacker.turnData) then
			local id = attacker.turnData[1] or 1
			local team = attacker.turnData[2] or 1
		
			PLUGIN:turnAdd(id, summon, team)
		end
		
		if(actionTbl.onSummon) then
			actionTbl:onSummon(attacker, info, summon)
		end
	end
end