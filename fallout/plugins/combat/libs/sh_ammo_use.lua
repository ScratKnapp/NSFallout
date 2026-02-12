local PLUGIN = PLUGIN

PLUGIN.helperFuncs = PLUGIN.helperFuncs or {}

--uses ammo from a player's applicable weapon
PLUGIN.helperFuncs["ammoUse"] = function(self, actionTbl, item)
	local char = self:getChar()
	local inventory = char:getInv()

	--how much ammo is used
	local ammoUse = (actionTbl and actionTbl.ammoUse) or 1

	local curMag = item:getData("currentMag", {})
	local curUID = curMag[1]
	local curAmt = curMag[2] or 0

	local newMag = curAmt - ammoUse
	newMag = math.max(newMag, 0)

	item:setData("currentMag", {curUID, newMag}, self)
end

PLUGIN.specialAmmoTypes = {
	--hollow point
	["HP"] = function(action, attacker, info)
		action.dmg = action.dmg*1.2
	end,

	--armor piercing
	["AP"] = function(action, attacker, info)
		action.dmg = action.dmg*0.9
	end,
	
	--Overpressure
	["+P"] = function(action, attacker, info)
		action.dmg = action.dmg*math.Rand(1.1,1.2)
	end,
	
	--Overpressure
	["SWC"] = function(action, attacker, info)
		action.dmg = action.dmg*1.2
	end,
	
	--explosive
	["Explosive"] = function(action, attacker, info)
		--currently no easy way to add an aoe effect to this
		if(!action.effects) then action.effects = {} end

		action.effects[#action.effects+1] = {
			uid = action.uid,
			name = "Knockdown",
			effect = "knockdown",
			duration = 1,
			strength = 1,
			
			debuff = true,
		}
	end,
	
	--incendiary
	["Incendiary"] = function(action, attacker, info)
		action.effects = action.effects or {}
		action.effects[#action.effects+1] = {
			uid = action.uid,
			name = "Burning",
			effect = "fire",
			duration = 2,
			strength = 1,
			
			dmg = 15,
			dmgT = "Fire",
			
			debuff = true,
		}
	end,
	
	--surplus
	["Surplus"] = function(action, attacker, info)
		action.dmg = action.dmg*1.1
		
		--damage durability of gun an extra time
		attacker:durabilityOffense(info, 1)
	end,
	
	--Flechette
	["Flechette"] = function(action, attacker, info)
		action.dmg = action.dmg*0.9
	end,
	
	--Rubber
	["Rubber"] = function(action, attacker, info)
		action.dmg = action.dmg*0.1

		action.effects = action.effects or {}
		action.effects[#action.effects+1] = {
			uid = action.uid,
			name = "Stunned",
			effect = "stun",
			duration = 1,
			strength = 1,

			debuff = true,
		}
	end,
	
	--Dragon's breath
	["Dragon"] = function(action, attacker, info)
		action.dmg = action.dmg*0.8
		
		if(!action.effects) then 
			action.effects = {} 
		end
		
		action.effects[#action.effects+1] = {
			uid = action.uid,
			name = "Burning",
			effect = "fire",
			duration = 2,
			strength = 1,
			
			dmg = 5,
			dmgT = "Fire",
			
			debuff = true,
		}
	end,
	
	--Over charge
	["Overcharge"] = function(action, attacker, info)
		action.dmg = action.dmg*math.Rand(1.2, 1.25)
	end,
	
	--Max charge
	["Maxcharge"] = function(action, attacker, info)
		action.dmg = action.dmg*math.Rand(1.3, 1.4)
	end,
	
	--Plasma
	["Plasma"] = function(action, attacker, info)
	
	end,
	
	--High Explosive
	["HE"] = function(action, attacker, info)
	
	end,
}

hook.Add("nut_ActionAttackData", "nut_CombatAmmoUse", function(action, attacker, info, fakeAttack)
	if(fakeAttack) then return end
	if(!action.dmg) then return end
	
	local actionTbl = info.actionTbl
	if(actionTbl and actionTbl.noAmmo) then return end

	local weapon = info.weapon or (info.action and info.action.weapon)
	if(!weapon) then return end
	
	local weaponItem = nut.item.instances[weapon]
	if(!weaponItem) then return end

	if(weaponItem.magSize) then
		local curMag = weaponItem:getData("currentMag", {})
		local curUID = curMag[1]
		local curAmt = curMag[2] or 0
		if(curUID) then
			if(curAmt <= 0) then
				action.dmg = 0
			else
				attacker:ammoUse(actionTbl, weaponItem)
			end
		end
	end
end)

hook.Add("nut_ActionAttackData", "nut_CombatSpecialAmmo", function(action, attacker, info)
	if(!action.dmg) then return end
	
	local actionTbl = info.actionTbl
	if(actionTbl and actionTbl.noAmmo) then return end

	local weapon = info.weapon or (info.action and info.action.weapon)
	if(!weapon) then return end
	
	local weaponItem = nut.item.instances[weapon]
	if(!weaponItem) then return end

	if(weaponItem.magSize) then
		local curMag = weaponItem:getData("currentMag", {})
		local curUID, curAmt = curMag[1], curMag[2]
		
		local ammoItem = nut.item.list[curUID]
		
		--special ammo type ammo effects
		if(ammoItem and ammoItem.dmgT) then
			action.dmgT = ammoItem.dmgT
		
			local dmgType = PLUGIN.dmgTypes[action.dmgT]

			local specialAmmo = dmgType.special and PLUGIN.specialAmmoTypes[dmgType.special]
			if(specialAmmo) then
				specialAmmo(action, attacker, info)
			end
		end
	else
		local dmgType = PLUGIN.dmgTypes[weaponItem.dmgT]

		local specialAmmo = dmgType and dmgType.special and PLUGIN.specialAmmoTypes[dmgType.special]
		if(specialAmmo) then
			specialAmmo(action, attacker, info)
		end
	end
end)

hook.Add("nut_ActionInterrupt", "nut_ammoInterrupt", function(action, attacker)
	if(!action) then return false end

	local weapon = action.weapon
	if(!weapon) then return end

	local weaponItem = nut.item.instances[weapon]
	if(!weaponItem) then return end

	--it uses ammo
	if(weaponItem.magSize) then
		local curMag = weaponItem:getData("currentMag", {})
		local curUID, curAmt = curMag[1], curMag[2]
		
		if(!curAmt) then
			curAmt = 0
		end
		
		if(curAmt <= 0) then
			return "You are out of ammo."
		end
	end
end)
