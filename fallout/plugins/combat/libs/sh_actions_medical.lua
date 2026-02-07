local PLUGIN = PLUGIN

local ACT
ACT = {}
ACT.uid = "med_aid"
ACT.name = "First Aid"
ACT.desc = "+10 HP per use. Medicine modifier: 0.75."
ACT.category = "Medical"
ACT.restrict = true
ACT.attackString = "applies first aid"
ACT.CD = 1
ACT.attackOverwrite = function(actionTbl, client, trace, part, weapon)
	local char = client:getChar()
	local target
	
	local altPressed
	if(client:IsPlayer() and client:KeyDown(IN_WALK)) then --self targeting
		target = client
	else
		target = trace.Entity
	end
	if(!IsValid(target)) then return end
	
	local healAmt = 10
	healAmt = healAmt + char:getSkill("medicine", 0) * 0.75

	if(weapon) then
		local weaponItem = nut.item.instances[weapon]
	
		if(weaponItem) then
			--0 durability items give no dmg
			local dura = weaponItem:getData("dura", weaponItem.durability) or 0
			if(dura < 1) then 
				healAmt = 0
			end
		
			local dura = weaponItem:getData("dura", weaponItem.durability)
		
			weaponItem:setData("dura", dura - (duraDamage or 1))
		end
	end

	local trait = client:hasTrait("healer")
	if(trait) then
		if(target != client) then
			healAmt = healAmt * 1.25
		end
	end
	
	healAmt = math.Round(healAmt)

	target:addHP(healAmt)
	
	if(actionTbl.CD) then
		client:addCooldown(actionTbl.uid, actionTbl.CD)
	end
	
	local healMsg = client:Name().. " " ..actionTbl.attackString.. " for " ..target:Name().. " restoring " ..healAmt.. " HP."
	
	nut.plugin.list["chatboxextra"]:ChatboxSend(client, "react_npc", healMsg)
	nut.log.addRaw(healMsg, 2)
end
ACTS:Register(ACT)

local ACT
ACT = {}
ACT.uid = "med_care"
ACT.name = "Advanced Care"
ACT.desc = "+15 HP per use. Medicine modifier: 1."
ACT.category = "Medical"
ACT.restrict = true
ACT.attackString = "provides advanced care"
ACT.CD = 1
ACT.attackOverwrite = function(actionTbl, client, trace, part, weapon)
	local char = client:getChar()
	local target
	
	local altPressed
	if(client:IsPlayer() and client:KeyDown(IN_WALK)) then --self targeting
		target = client
	else
		target = trace.Entity
	end
	if(!IsValid(target)) then return end
	
	local healAmt = 15
	healAmt = healAmt + char:getSkill("medicine", 0) * 1

	if(weapon) then
		local weaponItem = nut.item.instances[weapon]
	
		if(weaponItem) then
			--0 durability items give no dmg
			local dura = weaponItem:getData("dura", weaponItem.durability) or 0
			if(dura < 1) then 
				healAmt = 0
			end
		
			local dura = weaponItem:getData("dura", weaponItem.durability)
		
			weaponItem:setData("dura", dura - (duraDamage or 1))
		end
	end

	local trait = client:hasTrait("healer")
	if(trait) then
		if(target != client) then
			healAmt = healAmt * 1.25
		end
	end

	healAmt = math.Round(healAmt)

	target:addHP(healAmt)
	
	if(actionTbl.CD) then
		client:addCooldown(actionTbl.uid, actionTbl.CD)
	end
		
	local healMsg = client:Name().. " " ..actionTbl.attackString.. " for " ..target:Name().. " restoring " ..healAmt.. " HP."
	
	nut.plugin.list["chatboxextra"]:ChatboxSend(client, "react_npc", healMsg)
	nut.log.addRaw(healMsg, 2)
end
ACTS:Register(ACT)

local ACT
ACT = {}
ACT.uid = "med_surgery"
ACT.name = "Field Surgery"
ACT.desc = "+25 HP per use. Medicine modifier: 1.25."
ACT.category = "Medical"
ACT.restrict = true
ACT.attackString = "performs field surgery"
ACT.CD = 2
ACT.attackOverwrite = function(actionTbl, client, trace, part, weapon)
	local char = client:getChar()
	local target
	
	local altPressed
	if(client:IsPlayer() and client:KeyDown(IN_WALK)) then --self targeting
		target = client
	else
		target = trace.Entity
	end
	if(!IsValid(target)) then return end
	
	local healAmt = 25
	healAmt = healAmt + char:getSkill("medicine", 0) * 1.25

	if(weapon) then
		local weaponItem = nut.item.instances[weapon]
	
		if(weaponItem) then
			--0 durability items give no dmg
			local dura = weaponItem:getData("dura", weaponItem.durability) or 0
			if(dura < 1) then 
				healAmt = 0
			end
		
			local dura = weaponItem:getData("dura", weaponItem.durability)
		
			weaponItem:setData("dura", dura - (duraDamage or 1))
		end
	end

	local trait = client:hasTrait("healer")
	if(trait) then
		if(target != client) then
			healAmt = healAmt * 1.25
		end
	end
	
	healAmt = math.Round(healAmt)

	target:addHP(healAmt)
	
	if(actionTbl.CD) then
		client:addCooldown(actionTbl.uid, actionTbl.CD)
	end
	
	local healMsg = client:Name().. " " ..actionTbl.attackString.. " on " ..target:Name().. " restoring " ..healAmt.. " HP."
	
	nut.plugin.list["chatboxextra"]:ChatboxSend(client, "react_npc", healMsg)
	nut.log.addRaw(healMsg, 2)
end
ACTS:Register(ACT)