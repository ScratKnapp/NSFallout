ITEM.name = "Repair Kit"
ITEM.desc = "A kit for repairing."
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.flag = "v"
ITEM.category = "Repair"
ITEM.repair = 0
ITEM.repairSkill = 0

--for people to name their shit
ITEM.functions.Repair = {
	name = "Repair",
	tip = "Repair an item",
	icon = "icon16/wrench.png",
	isMulti = true,
	multiOptions = function(item, client)
		local targets = {}
		
		local inventory = client:getChar():getInv()

		for k, v in pairs(inventory:getItems()) do
			if(!v:getData("dura")) then continue end
			
			local dura = v:getData("dura", v.durability)
			local maxDura = v.durability
			local percent = dura/maxDura
		
			local newAbs = {
				name = v:getName().. " (" ..percent.. ")",
				data = v
			}
			
			table.insert(targets, newAbs)
		end
		
		return targets
	end,
	onRun = function(item, data)
		if(!data) then return false end

		local target = nut.item.instances[data.id]
		if(!target) then return false end

		local client = item.player

		local dura = target:getData("dura", target.durability)
		
		local repair = target.durability * (item.repair/100)
		
		if(dura >= repair) then 
			client:notify("This kit cannot repair higher than " ..item.repair.. "%")
		
			return false
		else
			target:setData("dura", repair)
		
			client:EmitSound("ui_repairweapon_0" ..math.random(1,3).. ".wav")

			client:notify("Equipment repaired.")
			
			return true
		end
	end,
	onCanRun = function(item)
		local client = item.player
		local char = client:getChar()
		
		local skill = char:getSkill("repair", 0)
		local reqSkill = item.repairSkill
	
		if(reqSkill > skill) then
			return false
		end
	
		return true
	end
}

function ITEM:getDesc(partial)
	local desc = self.desc
	
	desc = desc.. "\nRepairs up to: " ..self.repair.. " %."
	desc = desc.. "\nRepair Skill: " ..self.repairSkill.. "."
	
	return desc
end