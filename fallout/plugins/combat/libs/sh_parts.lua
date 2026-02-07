local PLUGIN = PLUGIN

--returns a table with modifiers for targetting parts or something
function PLUGIN:getPartsModifiers(specific, weaponItem)
	local parts = {
		["Body"] = {
			accuracyMult = 1.25,
			dmg = 1
		},
		["Head"] = {
			accuracyMult = 0.4,
			accuracy = -5,
			dmg = 1.5
		},
		["Left Arm"] = {
			accuracyMult = 1,
			dmg = 0.8
		},
		["Right Arm"] = {
			accuracyMult = 1,
			dmg = 0.8
		},
		["Left Leg"] = {
			accuracyMult = 1,
			dmg = 0.8
		},
		["Right Leg"] = {
			accuracyMult = 1,
			dmg = 0.8
		},
	}
	
	if(specific) then
		local partMod = table.Copy(parts[specific]) or {
			accuracy = 1,
			dmg = 1,
		}
		
		if(weaponItem and weaponItem.partMod) then
			local weaponMod = weaponItem.partMod[specific]
			
			if(weaponMod) then
				for k, v in pairs(weaponMod) do
					partMod[k] = (partMod[k] or 0) + v
				end
			end
		end
	
		return partMod
	end
	
	return parts
end

function PLUGIN:PartAttackModifyDamage(dmg, partMod)
	dmg = dmg * (partMod.dmg or 1)

	return dmg
end

function PLUGIN:PartAttackModifyAccuracy(accuracy, partMod)
	--prevents multipliers from reversing effectiveness with negative values
	if(accuracy > 0) then
		accuracy = accuracy * (partMod.accuracyMult or 1)
	else
		accuracy = accuracy / (partMod.accuracyMult or 1)
	end
	
	accuracy = accuracy + (partMod.accuracy or 0)
	
	return accuracy
end

hook.Add("nut_ActionAttackData", "nut_PartAttackModify", function(action, attacker, info)
	local weapon = info.weapon or (info.action and info.action.weapon)
	local weaponItem
	if(weapon) then
		weaponItem = nut.item.instances[weapon]
	end
	
	local partMod = PLUGIN:getPartsModifiers(info.partString, weaponItem)

	action.dmg = PLUGIN:PartAttackModifyDamage(action.dmg, partMod)
	action.accuracy = PLUGIN:PartAttackModifyAccuracy(action.accuracy, partMod)
end)

local injuries = {
	["Left Arm"] = {
		uid = "larm_inj",

		name = "Injured L. Arm",
		effect = "arm_inj",
		duration = 1,
		strength = 1,
		
		accuracyMult = 0.75,

		selfApply = true,
		debuff = true,
	},
	["Right Arm"] = {
		uid = "rarm_inj",

		name = "Injured R. Arm",
		effect = "arm_inj",
		duration = 1,
		strength = 1,
		
		accuracyMult = 0.75,

		selfApply = true,
		debuff = true,
	},
	["Left Leg"] = {
		uid = "lleg_inj",

		name = "Injured L. Leg",
		effect = "leg_inj",
		duration = 1,
		strength = 1,
		
		evasionMult = 0.75,

		selfApply = true,
		debuff = true,
	},
	["Right Leg"] = {
		uid = "rleg_inj",

		name = "Injured R. Leg",
		effect = "leg_inj",
		duration = 1,
		strength = 1,
		
		evasionMult = 0.75,

		selfApply = true,
		debuff = true,
	},
}

hook.Add("nut_OnReceiveDamage", "nut_durabilityDefense", function(client, dmg, dmgT, part)
	if(part and dmg > 15 and injuries[part]) then
		client:addBuff(injuries[part])
	end
end)