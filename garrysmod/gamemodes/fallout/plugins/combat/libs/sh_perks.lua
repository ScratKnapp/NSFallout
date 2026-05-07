local PLUGIN = PLUGIN

--perks handled by the traits system
PLUGIN.helperFuncs = PLUGIN.helperFuncs or {}

hook.Add("nut_OnCombatAttack", "nut_PerkAttackModify", function(action, attacker, info)
	local traits = attacker:getTraitsData()

	for k, v in pairs(traits) do
		if(v.OnAttackData) then
			v:OnAttackData(action, attacker, info)
		end
	end
end)

hook.Add("nut_OnCombatDamageProcess", "nut_PerkDamageProcess", function(target, attack, dmgTbl)
	local traits = target:getTraitsData()
	
	for k, v in pairs(traits) do
		if(v.OnDamageProcess) then
			v:OnDamageProcess(attack, dmgTbl)
		end
	end
end)