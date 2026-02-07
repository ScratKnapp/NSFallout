local PLUGIN = PLUGIN

PLUGIN.helperFuncs = PLUGIN.helperFuncs or {}

if(SERVER) then
	--client requests evasion sync
	--for display purposes with targeting
	netstream.Hook("nut_combatEvasionSync", function(client, target, test)
		local evasion = target:getEvasion()

		target:setNetVar("evasion", evasion)
	end)
end

--calculates hit chance with the accuracy of an attack and a target
function PLUGIN:calcHitChance(accuracy, target)
	local evasion = target:getEvasion()
	
	local difference = accuracy - evasion --difference between accuracy and evasion
	
	local baseHitChance = 50
	
	local hitChance = baseHitChance + (difference * 1)
	hitChance = math.Clamp(hitChance, 5, 95)
	
	local reduct = 1
	
	local hitRoll = math.random(1, 100)
	if(hitRoll < hitChance) then --hit time
		if(difference < 0) then --more evasion than accuracy
			--graze time
			local grazeRoll = math.random(1, difference * -1)
			if(grazeRoll > 50) then
				reduct = 0.1
			elseif(grazeRoll > 30) then
				reduct = 0.5
			elseif(grazeRoll > 10) then
				reduct = 0.2
			else
				reduct = 1
			end
		else
			reduct = 1
		end
	else --miss
		reduct = 0
	end

	return hitChance, reduct
end

--a dumb thing for printing, checks if it's a graze or an evade.
function PLUGIN:evadeCheck(target, accuracy, dmg)
	local evade
	local reduct
	local hitChance
	
	if(target and accuracy) then
		hitChance, reduct = PLUGIN:calcHitChance(accuracy, target)

		if(reduct < 1 and reduct > 0) then
			evade = "Graze"
		elseif(reduct == 0) then
			evade = "Missed"
		end
	end
	
	return evade, reduct
end

--checks if a player can cast a spell or not based on how much mana it costs
function PLUGIN:costCheck(client, action)
	if(action.costHP) then
		if(client:getHP() < action.costHP) then
			return false
		end
	end
	
	--[[
	if(action.costAP) then
		if(client:getAP() < action.costAP) then
			return false
		end
	end
	--]]
	
	return true
end

--gets the damage a player does with a reegular attack
PLUGIN.helperFuncs["getDamage"] = function(self, partString, weapon)
	local char = self:getChar()
	
	if(char) then
		local totalDam = {}
	
		-- For CEnts
		local CEntdmg = self:getNetVar("dmg", self.dmg)
		if(CEntdmg) then
			for dmgT, dmgV in pairs(CEntdmg) do
				local dmg = dmgV
				
				--direct dmg buffs
				dmg = dmg + self:getBuffAttribute("dmg")

				totalDam[#totalDam + 1] = {
					dmg = dmg, 
					dmgT = dmgT,
					accuracy = self:getAccuracy()
				}
			end
		end
		
		local equipment = nut.plugin.list["equipment"]:getEquippedItems(self, true)

		for k, v in pairs(equipment) do
			if(weapon and v.id != weapon) then continue end --if looking for a specific weapon, skip others

			local dmgTbl = v:getData("dmg", v.dmg)
			if(dmgTbl) then
				for dmgT, dmgV in pairs(dmgTbl) do
					local dmg = dmgV

					for name, mult in pairs(v:getData("attribScaleDmg", v.attribScaleDmg) or {}) do
						local attrib = char:getAttrib(name, 0)
						local attribBonus = (attrib * mult)
						
						if(attribBonus > dmg) then
							dmg = dmg + dmg + (attribBonus - dmg)^(0.5)
						else
							dmg = dmg + attribBonus
						end
					end

					for name, mult in pairs(v:getData("skillScaleDmg", v.skillScaleDmg) or {}) do
						local skill = char:getSkill(name, 0)
						local skillBonus = (skill * mult)
						
						dmg = dmg + skillBonus
					end

					--damage amplification
					local amp = self:getAmp()
					if(amp) then
						if(amp[dmgT]) then
							dmg = dmg * (1 + amp[dmgT])
						end
					end

					--direct dmg buffs
					dmg = dmg + self:getBuffAttribute("dmg")

					totalDam[#totalDam + 1] = {
						dmg = dmg, --damage value
						dmgT = dmgT, --damage type of weapon
						weap = v:getName(), --name of weapon
						crit = crit,
						accuracy = accuracy, --accuracy of attack
						part = partString, --body part
					}
				end
			end
		end
		
		if(table.IsEmpty(totalDam)) then
			local unarmed = char:getSkill("unarmed", 0)
		
			totalDam[1] = {
				dmg = char:getAttrib("str", 0) * 1 + unarmed + self:getBuffAttribute("dmg"),
				dmgT = "Blunt",
				weap = "Hands",
				accuracy = self:getAccuracy()
			}
		end

		return totalDam
	end
end

--incoming damage resistance
PLUGIN.helperFuncs["getRes"] = function(self, part)
	local char = self:getChar()
	if(!char) then return {} end
	
	local inv = char:getInv()
	
	--resistance, start with resist from buffs
	local res = table.Copy(self.res or {})
	
	local buffRes = self:getBuffAttributeTbl("res") or {}
	
	for k, v in pairs(buffRes) do
		res[k] = (res[k] or 0) + v
	end
	
	--general damage resistance (affects all incoming damage)
	res["dmg"] = char:getAttrib("end", 0)
	
	res["cha"] = char:getAttrib("cha", 0)*8

	for k, v in pairs(res) do
		res[k] = v * 0.01
	end
	
	local equipment = {}
	
	for slot, itemID in pairs(self:getEquip()) do
		local item = nut.item.instances[itemID]
		
		if(item) then
			if(part and string.lower(part) != string.lower(slot)) then continue end

			equipment[#equipment+1] = item
		end
	end
	
	for k, item in pairs(char:getInv():getItems()) do
		if(item:getData("equip")) then
			local itemSlot = item:getData("customSlot", item.specialSlot or item.slot)
			if(part and part != itemSlot) then continue end
		
			equipment[#equipment+1] = item
		end
	end
	
	--resist from items
	for k, v in pairs(equipment) do
		for k2, v2 in pairs(v:getData("res", {})) do
			if(res[k2]) then --lets round it to stop any funny business
				res[k2] = 1 - (1 - res[k2]) * (1 - v2 * 0.01)
			else
				res[k2] = 1 - (1 - v2 * 0.01)
			end
		end
	end
	
	--rounds resistance so it isnt scary numbers
	for k, v in pairs(res) do
		res[k] = math.Round(v, 4)
	end

	return res
end

--unused tagging system
PLUGIN.helperFuncs["getTags"] = function(self)
	local char = self:getChar()

	local tags = {}

	return tags
end

--gets how much armor a player has from items, buffs, etc
PLUGIN.helperFuncs["getArmor"] = function(self, part)
	local char = self:getChar()
	
	local armor = self:getNetVar("armor", self.armor) or 0
	if(armor) then
		if(istable(armor)) then
			armor = armor[part] or 0
		else
			armor = armor
		end
	end

	if(char) then
		local inv = char:getInv()
		
		local equipment = {}
		
		local equipment = nut.plugin.list["equipment"]:getEquippedItems(self, true)

		for k, v in pairs(equipment) do
			local itemArmor = v:getData("armor", v.armor)
			if(itemArmor) then
				local dura = v:getData("dura", v.durability)
				
				--0 durability items give no armor
				if(dura and dura < 1) then continue end

				if(part) then
					if(istable(itemArmor)) then
						if(itemArmor[part]) then
							itemArmor = itemArmor[part]
						
							armor = armor + itemArmor
							
							for name, mult in pairs(v:getData("scale", v.scaling) or {}) do
								local attrib = char:getAttrib(name, 0)
								local attribBonus = (attrib * mult)
								
								if(attribBonus > itemArmor) then
									armor = armor + itemArmor + (attribBonus - itemArmor)^(0.5)
								else
									armor = armor + attribBonus
								end
							end
						end
					else
						armor = armor + itemArmor
						
						for name, mult in pairs(v:getData("scale", v.scaling) or {}) do
							local attrib = char:getAttrib(name, 0)
							local attribBonus = (attrib * mult)
							
							if(attribBonus > itemArmor) then
								armor = armor + itemArmor + (attribBonus - itemArmor)^(0.5)
							else
								armor = armor + attribBonus
							end
						end
					end
				end
			end
		end

		armor = armor + self:getBuffAttribute("armor")
		
		armor = math.Round(armor, 2)
	end
	
	return armor
end

--gets how much evasion a player has
PLUGIN.helperFuncs["getEvasion"] = function(self)
	local char = self:getChar()
	
	local evasion = (self.combat and self:getNetVar("evasion", self.evasion)) or 0
	
	if(char) then
		local inv = char:getInv()
		local items = (inv and inv:getItems()) or {}
		for k, v in pairs(items) do
			if(v:getData("equip")) then
				local itemEvasion = v:getData("evasion", v.evasion)
				if(itemEvasion) then
					evasion = evasion + itemEvasion
				end
			end
		end
	
		local agi = char:getAttrib("agi", 0)
		evasion = evasion + (agi * 1.0)
		
		local eva = char:getSkill("evasion", 0)
		evasion = evasion + (eva * 1)
		
		--evasion = evasion - (self:getWeight() * 0.75)
		
		evasion = evasion + self:getBuffAttribute("evasion")

		local evasionMult = self:getBuffAttributeMult("evasionMult")
		if(evasionMult > 0) then
			evasion = evasion * evasionMult
		end

		if self:hasTrait("evader") then
			evasion = evasion + 10
		end 
		
		evasion = math.Round(evasion, 2)
	end
	
	--synchronizes player evasion to clients
	--since attributes and skills are not networked always
	if(CLIENT) then
		if(!self.combat and self != LocalPlayer()) then
			if((self.nextEvasionSync or 0) < CurTime()) then
				self.nextEvasionSync = CurTime() + 10
				
				netstream.Start("nut_combatEvasionSync", self)
			end

			return self:getNetVar("evasion", evasion)
		end
	end

	return evasion
end

--gets how much accuracy a player has
PLUGIN.helperFuncs["getAccuracy"] = function(self, weapon)
	local char = self:getChar()
	
	local accuracy = self:getNetVar("accuracy", self.accuracy) or 0

	if(char) then
		local inv = char:getInv()
		
		local equipment = nut.plugin.list["equipment"]:getEquippedItems(self, true)
		
		for k, v in pairs(equipment) do
			if(weapon) then
				--if looking for a specific weapon, skip others
				if(v != weapon) then continue end

				for name, mult in pairs(v:getData("attribScaleAcc", v.attribScaleAcc) or {}) do
					local attrib = char:getAttrib(name, 0)
					local attribBonus = (attrib * mult)
					
					accuracy = accuracy + attribBonus
				end

				for name, mult in pairs(v:getData("skillScaleAcc", v.skillScaleAcc) or {}) do
					local skill = char:getSkill(name, 0)
					local skillBonus = (skill * mult)
					
					accuracy = accuracy + skillBonus
				end

				accuracy = accuracy + (v:getData("accuracy", v.accuracy) or 0)
			end
		end

		local per = char:getAttrib("per", 0)
		accuracy = accuracy + (per * 2.0)
		
		accuracy = accuracy + self:getBuffAttribute("accuracy")

		local accuracyMult = self:getBuffAttributeMult("accuracyMult")
		if(accuracyMult > 0) then
			accuracy = accuracy * accuracyMult
		end
		
		accuracy = math.Round(accuracy, 2)
	end
	
	return accuracy
end

--rolls to see if a player's weapon jammed
PLUGIN.helperFuncs["getJam"] = function(self, jamC)
	local char = self:getChar()
	local mult
	
	local roll = math.random(1, 100)
	if(roll <= jamC) then
		return true
	end
	
	return false
end

--gets a player's weight from items
PLUGIN.helperFuncs["getWeight"] = function(self)
	local char = self:getChar()
	
	local weight = 0
	if(char) then
		for k, v in pairs(char:getInv():getItems()) do
			if(v:getData("equip")) then
				weight = weight + (v:getData("weight", v.weight) or 0)
			end
		end
	end
	
	return weight
end

--gets a player's maximum weight capacity
PLUGIN.helperFuncs["getMaxWeight"] = function(self)
	local char = self:getChar()
	
	local str = char:getAttrib("str", 0)
	
	local maxWeight = 15 + (str * 0.8)
	
	return maxWeight
end

--creates a table for targeting data for the cswep
local function actionFormat(actionTbl, item)
	local action = {
		uid = actionTbl.uid,
		name = actionTbl.name,
		category = actionTbl.category,
		notarget = actionTbl.notarget,
		radius = actionTbl.radius,
		cone = actionTbl.cone,
		cone2 = actionTbl.cone2,
		box = actionTbl.box,
		selfOnly = actionTbl.selfOnly,
		itemUse = actionTbl.itemUse,
		--attackOverwrite = actionTbl.attackOverwrite,
		weapon = item, --ID of the weapon
	}

	return action
end

--gets a player's actions for the combat system
PLUGIN.helperFuncs["getActions"] = function(self)
	local char = self:getChar()
	if(!char) then return {} end

	local actions = {} 

	if(self.combat) then
		actions[#actions+1] = {
			name = "Attack",
			category = "Default",
			dmg = self:getDamage(),
		}	

		local CEntActions = self:getNetVar("actions", self.actions) or {}
		for k, v in pairs(CEntActions) do
			local action = PLUGIN:actionFind(v)
			if(action) then
				actions[#actions+1] = actionFormat(action)
			end
		end
	end

	for k, actionData in pairs(ACTS.actions) do
		if(actionData.restrict) then continue end
	
		-- Default actions
		--[[
		if(actionData.category == "Default") then
			actions[#actions+1] = actionFormat(actionData)
			continue
		end
		--]]
	
		--if the ability requires stat thresholds to use
		if(actionData.reqStats) then
			local reqStats = true
			for attrib, reqVal in pairs(actionData.reqStats) do
				if(char:getAttrib(attrib, 0) < reqVal) then
					reqStats = false
				end
			end
			if(!reqStats) then continue end
		end

		actions[#actions+1] = actionFormat(actionData)
	end

	local equipment = {}
	
	for k, itemID in pairs(self:getEquip()) do
		local item = nut.item.instances[itemID]
		
		if(item) then
			equipment[#equipment+1] = item
		end
	end
	
	local inv = char:getInv()
	local items = (inv and inv:getItems()) or {}
	for k, item in pairs(items) do
		if(item:getData("equip")) then
			equipment[#equipment+1] = item
		end
	end

	for k, v in pairs(equipment) do
		if(v:getData("dmg", v.dmg)) then
			local actionData = table.Copy(ACTS.actions[v.uniqueID])

			if(actionData) then
				actions[#actions+1] = actionFormat(actionData, v.id)
			end
		end
	
		if(v:getData("actions", v.actions)) then
			for _, action in pairs(v.actions) do
				local actionData = table.Copy(ACTS.actions[action])
				if(!actionData) then continue end
				
				--checks if they have the required stats
				local reqStats = true
				if(actionData.reqStats) then
					if(!table.IsEmpty(actionData.reqStats)) then 
						for attrib, reqVal in pairs(actionData.reqStats) do
							if(char:getAttrib(attrib) < reqVal) then
								reqStats = false
							end
						end
					end
				end
				if(!reqStats) then continue end

				actions[#actions+1] = actionFormat(actionData, v.id)
			end
		elseif(v.action) then
			local action = v.action
			local actionData = ACTS.actions[action]
			if(!actionData) then continue end
			
			--checks if they have the required stats
			local reqStats = true
			if(actionData.reqStats) then
				if(!table.IsEmpty(actionData.reqStats)) then 
					for attrib, reqVal in pairs(actionData.reqStats) do
						if(char:getAttrib(attrib) < reqVal) then
							reqStats = false
						end
					end
				end
			end
			if(!reqStats) then continue end

			actions[#actions+1] = actionFormat(actionData, v.id)
		end
	end
	
	--gets throwable items and stuff
	for k, v in pairs(items) do
		if(v.action) then
			local action = v.action
			local actionData = ACTS.actions[action]
			if(!actionData) then continue end
			
			--checks if they have the required stats
			local reqStats = true
			if(actionData.reqStats) then
				if(!table.IsEmpty(actionData.reqStats)) then 
					for attrib, reqVal in pairs(actionData.reqStats) do
						if(char:getAttrib(attrib) < reqVal) then
							reqStats = false
						end
					end
				end
			end
			if(!reqStats) then continue end

			actions[#actions+1] = actionFormat(actionData, v.id)
		end
	end
	
	return actions
end

PLUGIN.helperFuncs["traitModify"] = function(self, command, dmg)
	if(!command) then return end

	if(TRAITS) then 
		local char = self:getChar()
		local traits = char:getData("traits", {})
		
		for k, v in pairs(traits) do
			local trait = TRAITS.traits[k]
			
			if(trait and trait.modifier and trait.modifier[command]) then
				--dmg = dmg * trait.modifier[command]
			end
		end
	end
	
	return dmg
end

--function for when a player receives damage, handles armor, resistance, etc
PLUGIN.helperFuncs["receiveDamage"] = function(self, dmg, dmgT, part)
	local res = self:getRes(part)

	--physical damage reduction (DR) from armor
	
	if(PLUGIN:armorReduction(dmgT)) then
		local armorThreshold = (self:getArmor(part) * 1 * PLUGIN:armorReduction(dmgT))

		if(armorThreshold > dmg * 0.75) then
			local remain = armorThreshold - (dmg * 0.75)
			dmg = dmg - (dmg * 0.75) - remain^(1/2)
		else
			dmg = dmg - armorThreshold
		end
	end
	
	hook.Run("nut_OnReceiveDamage", self, dmg, dmgT, part)
	
	dmg = dmg * math.max(1 - (res[dmgT] or 0), 0)
	
	dmg = dmg * math.max(1 - (res["dmg"] or 0), 0) --general damage reduction
	
	if(PLUGIN:IsBroadType(dmgT, "ballistic")) then
		dmg = dmg * math.max(1 - (res["Kinetic"] or 0), 0)
	elseif(PLUGIN:IsBroadType(dmgT, "energy")) then
		dmg = dmg * math.max(1 - (res["energy"] or 0), 0)
	end

	dmg = math.Round(dmg, 2)
	
	return dmg
end

--function for when a player receives an effect, handles resistance, buff chance, etc
PLUGIN.helperFuncs["receiveEffect"] = function(self, effect)
	local char = self:getChar()
	
	if(char) then
		local res = self:getRes()
	
		local success = false
		if(effect.debuff) then --debuffing spells
			local effectChance = effect.chance or 100 --spells base chance of activating
			local resist = (res[string.lower(effect.effect)] or 0) * 100 --resistance to this particular effect
			
			resist = resist + (res["effect"] or 0)*100 + (100 - effectChance)
		
			local roll = math.random(0,100)
			
			if(roll > resist) then
				success = true
			end
		elseif(effect.chance) then --spell that with chance to activate but isn't a debuff
			local effectChance = effect.chance --spells base chance of activating
			
			local roll = math.random(1,100)
			if(roll < effectChance) then
				success = true
			end
		else --guaranteed to activate
			success = true
		end	
	
		--local response = ""
		if(success) then
			if(effect.buff or effect.debuff) then
				self:addBuff(effect)
			end

			local effTable = EFFS.effects[effect.effect]
			if(effTable and effTable.func) then
				effTable.func(self, effect)
			end
			
			local responseTbl = {
				success = success,
				duration = effect.duration,
			}
			
			return responseTbl
		else
			--effect resisted
		end
	end
end

function PLUGIN:addHelpers()
	local playerMeta = FindMetaTable("Player")
	--local CEntMeta = baseclass.Get("nut_combat")
	local CEntMeta = PLUGIN.CEntBase
	
	for k, v in pairs(PLUGIN.helperFuncs) do
		playerMeta[k] = v
		CEntMeta[k] = v
	end
end

function PLUGIN:InitializedPlugins()
	PLUGIN:addHelpers()
end