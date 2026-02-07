local PLUGIN = PLUGIN

function PLUGIN:RangeAccuracyModify(accuracy, weaponItem, dist)
	local toMeter = (dist/52) -- the distance in meters

	--long, medium, close, melee
	local ranges = {25,8,2,0}
	--if greater than 25, long
	--if greater than 8, medium
	--if greater than 2, close
	--if greater than 0, melee

	local range
	for k, v in ipairs(ranges) do
		if(toMeter > v) then
			range = k
			break
		end
	end
	
	local rangeMod = 0
	--gets the modifier for this age range
	if(range) then
		rangeMod = weaponItem.range[range]
		
		local rangeName = {
			"Long",
			"Medium",
			"Close",
			"Melee",
		}
						
		local rangeText = rangeName[range]
		
		accuracy = accuracy + rangeMod

		return accuracy, rangeText
	else
		return accuracy
	end
end

hook.Add("nut_ActionAttackData", "nut_RangeAccuracyModify", function(action, attacker, info)
	local accuracy = action.accuracy or 0
	local trace = info.trace

	local weapon = info.weapon or (info.action and info.action.weapon)
	if(!weapon) then return end
	
	local weaponItem = nut.item.instances[weapon]
	if(!weaponItem) then return end

	--accuracy altered by range
	if(weaponItem.range) then
		--the position to check the range to
		local hit
		if(trace and trace.Entity) then
			hit = trace.Entity:GetPos()
		elseif(trace and trace.HitPos) then
			hit = trace.HitPos
		end
		
		local dist = 0
		if(hit) then
			--distance
			dist = attacker:GetPos():Distance(hit)
		end
		
		action.accuracy = PLUGIN:RangeAccuracyModify(accuracy, weaponItem, dist)
	end
end)

nut.command.add("range", {
	syntax = "",
	onRun = function(client, arguments)
		local char = client:getChar()
		local inventory = char:getInv()
		
		local trace = client:GetEyeTrace()
		
		local hit
		if(trace.Entity) then
			hit = trace.Entity:GetPos()
		elseif(trace.HitPos) then
			hit = trace.HitPos
		end
		
		if(hit) then
			local dist = client:GetPos():Distance(hit)
		
			local toMeters = math.Round(dist/52, 2)

			--nut.chat.send(client, "react_npc", client:Name().. " reloads their weapon(s).") --print it
			nut.plugin.list["chatboxextra"]:ChatboxSend(client, "mind", toMeters.. " meters away.")
		end
	end
})