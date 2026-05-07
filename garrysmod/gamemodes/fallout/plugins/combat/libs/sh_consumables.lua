local PLUGIN = PLUGIN

hook.Add("nut_ActionAttackDataPre", "nut_consumableUse", function(action, attacker, info, fakeAttack)
	if(fakeAttack) then return end
	
	local weapon = info.weapon or (info.action and info.action.weapon)
	if(!weapon) then return end

	local weaponItem = nut.item.instances[weapon]
	if(!weaponItem) then return end

	local actionTbl = info.actionTbl
	if(!actionTbl) then return end

	if(actionTbl.itemCons) then
		local amount = weaponItem:getData("Amount", weaponItem.Amount or 1)
		amount = amount - 1
		
		if(amount > 0) then
			weaponItem:setData("Amount", amount)
		else
			weaponItem:remove()
			
			if(attacker:IsPlayer()) then
				local cswep = attacker:GetWeapon("nut_cswep")
				if(IsValid(cswep)) then
					cswep:resetAction()
				end
			end
		end
	end
end)