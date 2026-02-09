local PLUGIN = PLUGIN

--gets a player's crit chance and crit multiplier
PLUGIN.helperFuncs["getCrit"] = function(self, weaponItem)
	local char = self:getChar()

	local chance = char:getAttrib("luck", 0)
	chance = chance + self:getBuffAttribute("critC")

	local mult = 2
	mult = mult + self:getBuffAttribute("critM")
	
	if(weaponItem) then
		chance = chance + (weaponItem:getData("critC", weaponItem.critC) or 0)
		mult = mult + (weaponItem:getData("critM", weaponItem.critM) or 0)
	end
	
	local equipment = nut.plugin.list["equipment"]:getEquippedItems(self, true)
	for k, v in pairs(equipment) do
		local critBC = v:getData("critBC", v.critBC) or 0
		local critBM = v:getData("critBM", v.critBM) or 0
	
		chance = chance + critBC
		mult = mult + critBM
	end
	
	if(self:hasTrait("bettercrits")) then
		mult = mult * 1.25
	end
	
	return chance, mult
end

--rolls a crit and a crit multiplier for a player
PLUGIN.helperFuncs["rollCrit"] = function(self, bonusC, bonusM, weaponItem)
	local char = self:getChar()
	local mult
	local msg = ""
	
	if(char) then
		local critC, critM = self:getCrit(weaponItem)
	
		critC = critC + (bonusC or 0)
		critM = critM + (bonusM or 0)
	
		local roll = math.random(1,100)
		if(critC >= roll) then
			mult = critM
			msg = "(Crit!) "
		end
	end
	
	return mult, msg
end

hook.Add("nut_OnCombatAttack", "nut_CritModify", function(action, attacker, info, fakeAttack)
	if(fakeAttack) then return end
	
	local weapon = info.weapon or (info.action and info.action.weapon)
	local weaponItem
	if(weapon) then
		weaponItem = nut.item.instances[weapon]
	end

	local crit, critMsg = attacker:rollCrit(action.critC, action.critM, weaponItem)
	if(crit) then
		action.dmg = action.dmg * crit
		action.accuracy = action.accuracy * crit
		
		action.critMsg = critMsg
	end
end)