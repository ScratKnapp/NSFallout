local PLUGIN = PLUGIN

PLUGIN.helperFuncs = PLUGIN.helperFuncs or {}

--reduces durability of an object
PLUGIN.helperFuncs["durabilityOffense"] = function(self, info, duraDamage)
	local char = self:getChar()
	local inventory = char:getInv()
	
	if(info.weapon) then --weapons
		local weaponItem = nut.item.instances[info.weapon]
		if(weaponItem) then
			local dura = weaponItem:getData("dura", weaponItem.durability)
		
			if(dura) then
				weaponItem:setData("dura", dura - (duraDamage or 1))
			end
		end
	end
end

--reduces durability of an object
PLUGIN.helperFuncs["durabilityDefense"] = function(self, part)
	local char = self:getChar()
	local inventory = char:getInv()
	
	local equipment = nut.plugin.list["equipment"]:getEquippedItems(self, true)
	
	for k, v in pairs(equipment) do
		local dura = v:getData("dura", v.durability)
		if(dura and dura > 0) then
			local armor = v:getData("armor", v.armor)
			
			if(armor and armor > 0) then
				if(part) then
					--makes it so armor only loses durability when that part is targetted
					if(istable(armor)) then
						if(armor[part]) then
							v:setData("dura", dura - 1)
						end
					else
						v:setData("dura", dura - 1)
					end
				else
					v:setData("dura", dura - 1)
				end
			end
		end
	end
end

hook.Add("nut_OnCombatAttack", "nut_durabilityOffense", function(action, attacker, info)
	local weapon = info.weapon or (info.action and info.action.weapon)
	if(!weapon) then return end
	
	local weaponItem = nut.item.instances[weapon]
	if(!weaponItem) then return end

	--0 durability items give no dmg
	local dura = weaponItem:getData("dura", weaponItem.durability)
	if(dura and dura < 1) then 
		action.dmg = 0
	end

	--calculate durability on offensive equipment
	attacker:durabilityOffense(info)
end)

hook.Add("nut_OnReceiveDamage", "nut_durabilityDefense", function(client, dmg, dmgT, part)
	if(dmg > 0) then
		client:durabilityDefense(part)
	end
end)