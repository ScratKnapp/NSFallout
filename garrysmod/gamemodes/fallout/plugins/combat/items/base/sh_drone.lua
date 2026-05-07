ITEM.name = "Drone Base"
ITEM.desc = " "
ITEM.model = "models/props_junk/cardboard_box003a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Drone"
ITEM.color = Color(255, 253, 0)

ITEM.flag = "v"

ITEM.functions.DeployCombat = {
	name = "Deploy (Combat)",
	tip = "useTip",
	icon = "icon16/arrow_up.png",
	onRun = function(item)
		local client = item.player
		
		local techReq = item:getData("techReq", item.techReq)
		if(techReq) then
			local tech = client:getChar():getAttrib("tech", 0)
			
			if(tech < techReq) then
				client:notify("You do not have enough technical skill to use this for combat.")
				return false
			end
		end
		
		local deploy = item:getData("deploy")
		if(IsValid(deploy)) then
			SafeRemoveEntity(deploy)
		end

		local ent = ents.Create(item.CEnt or "nut_combat")
		ent:SetPos(client:EyePos() + client:GetAimVector() * 50)
				
		ent.Owner = client
		ent:SetCreator(client)
		
		ent:Spawn()
		
		if(item:getData("model", item.modelEnt)) then
			ent:SetModel(item:getData("model", item.modelEnt))
		end
		
		if(item:getData("material", item.materialEnt)) then
			ent:SetMaterial(item:getData("material", item.materialEnt))
		end
		
		local customData = item:getData("custom", {})
		
		ent:setNetVar("name", customData.name or item.name or ent:getNetVar("name"))
		ent:setNetVar("desc", customData.desc or item.desc or ent:getNetVar("desc"))
		ent:setNetVar("hp", item:getData("hp", item.hp) or item:getData("hpMax", item.hpMax) or ent:getNetVar("hp"))
		ent:setNetVar("hpMax", item:getData("hpMax", item.hpMax) or ent:getNetVar("hpMax"))

		ent.dmg = item:getData("dmg", item.dmg) or ent:getNetVar("dmg") or 0
		ent.dmgT = item:getData("dmgT", item.dmgT) or ent:getNetVar("dmgT")
		ent.armor = item:getData("armor", item.armor) or ent:getNetVar("armor") or {}
		
		ent.attribs = item:getData("attrib", item.attribs) or ent.attribs or {}
		ent.res = item:getData("res", item.res) or ent.res or {}
		ent.spells = item:getData("spells", item.spells) or ent.spells or {}
		
		ent:DropToFloor()
		
		item:setData("deploy", ent)

		return false
	end,
	onCanRun = function(item)
		if(item:getData("combat", item.combat)) then
			return true
		end
		
		return false
	end
}

ITEM.functions.Deploy = {
	name = "Deploy",
	tip = "useTip",
	icon = "icon16/arrow_up.png",
	onRun = function(item)
		local client = item.player
		
		local deploy = item:getData("deploy")
		if(IsValid(deploy)) then
			SafeRemoveEntity(deploy)
		end
		
		if(item.ent) then
			local ent = ents.Create(item.ent)

			if(IsValid(ent)) then
				ent:SetPos(client:EyePos() + client:GetAimVector() * 50)
				
				ent.Owner = client
				ent:Spawn()
				ent:AddModule("AI Moving core")
				ent:AddModule("AI Follow owner")
				
				item:setData("deploy", ent)
			end
		end

		return false
	end,
}

ITEM.functions.Deploy2 = {
	name = "Deploy (Erratic)",
	tip = "useTip",
	icon = "icon16/arrow_up.png",
	onRun = function(item)
		local client = item.player
		
		local deploy = item:getData("deploy")
		if(IsValid(deploy)) then
			SafeRemoveEntity(deploy)
		end
		
		if(item.ent) then
			local ent = ents.Create(item.ent)
			ent:SetPos(client:EyePos() + client:GetAimVector() * 50)
			
			ent.Owner = client
			ent:Spawn()
			ent:AddModule("AI Moving core")
			ent:AddModule("AI Follow owner")
			ent:AddModule("AI Random moving")
			
			item:setData("deploy", ent)
		end

		return false
	end,
}

ITEM.functions.Deploy3 = {
	name = "Deploy (Wandering)",
	tip = "useTip",
	icon = "icon16/arrow_up.png",
	onRun = function(item)
		local client = item.player
		
		local deploy = item:getData("deploy")
		if(IsValid(deploy)) then
			SafeRemoveEntity(deploy)
		end
		
		if(item.ent) then
			local ent = ents.Create(item.ent)
			ent:SetPos(client:EyePos() + client:GetAimVector() * 50)
			
			ent.Owner = client
			ent:Spawn()
			ent:AddModule("AI Moving core")
			ent:AddModule("AI Random moving")
			
			item:setData("deploy", ent)
		end

		return false
	end,
}

ITEM.functions.Recall = {
	name = "Recall",
	tip = "useTip",
	icon = "icon16/arrow_down.png",
	onRun = function(item)
		local client = item.player
		
		local deploy = item:getData("deploy")
		if(IsValid(deploy)) then
			SafeRemoveEntity(deploy)
		end
		
		item:setData("deploy", nil)
		
		return false
	end,
	onCanRun = function(item)
		local deploy = item:getData("deploy")
		if(deploy) then
			return true
		end
		
		return false
	end
}

ITEM.functions.Custom = {
	name = "Customize",
	tip = "Customize this item",
	icon = "icon16/wrench.png",
	onRun = function(item)		
		nut.plugin.list["customization"]:startCustom(item.player, item)
		
		return false
	end,
	
	onCanRun = function(item)
		local client = item.player
		return client:getChar():hasFlags("1")
	end
}

ITEM.functions.CustomStats = {
	name = "Customize Stats",
	tip = "Customize this item",
	icon = "icon16/wrench.png",
	onRun = function(item)		
		nut.plugin.list["customization"]:startCustomDrone(item.player, item)
		
		return false
	end,
	
	onCanRun = function(item)
		local client = item.player
		return client:getChar():hasFlags("1")
	end
}

ITEM.functions.CustomAtr = {
	name = "Customize Attributes",
	tip = "Customize this item",
	icon = "icon16/wrench.png",
	onRun = function(item, data)
		nut.plugin.list["customization"]:startCustomA(item.player, item)
		
		return false
	end,
	onCanRun = function(item)
		local client = item.player
		return client:getChar():hasFlags("1")
	end
}

ITEM.functions.CustomRes = {
	name = "Customize Resistances",
	tip = "Customize this item",
	icon = "icon16/wrench.png",
	onRun = function(item, data)
		nut.plugin.list["customization"]:startCustomR(item.player, item)
		
		return false
	end,
	onCanRun = function(item)
		local client = item.player
		return client:getChar():hasFlags("1")
	end
}

function ITEM:getName()
	local name = self.name
		
	local ident = self:getData("ident")
	if(ident) then
		local undentified = "Unidentified Item"
		return undentified
	end

	local customData = self:getData("custom", {})
	if(customData.name) then
		name = customData.name
	end
	
	return Format(name)
end


local partsTbl = {
	"Torso",
	"Head",
	"Left Arm",
	"Right Arm",
	"Left Leg",
	"Right Leg",
}

function ITEM:getDesc(partial)
	local desc = self.desc
	
	local customData = self:getData("custom", {})
	if(customData.desc) then
		desc = customData.desc
	end

	if(!partial) then
		desc = desc.. "\n"
	
		local hpMax = self:getData("hpMax", self.hpMax)
		if(hpMax) then
			desc = desc.. "\nHP: " ..hpMax
		end
		
		local dmg = self:getData("dmg", self.dmg)
		if(dmg) then
			desc = desc.. "\nDMG: " ..dmg
		end
		
		local dmgT = self:getData("dmgT", self.dmgT)
		if(dmgT) then
			desc = desc.. "\nDMG Type: " ..dmgT
		end
		
		local armor = self:getData("armor", self.armor)
		if(armor) then
			desc = desc.. "\n\n<color=50,200,50>Armor</color>: "
			for k, v in pairs(armor) do
				desc = desc.. "\n " ..(k or "").. ": " ..v
			end
		end
		
		local attribs = self:getData("attrib", self.attribs)
		if(attribs) then
			desc = desc.. "\n\n<color=50,200,50>Attributes</color>: "
			for k, v in pairs(attribs) do
				local attrib = nut.attribs.list[k]
				if(attrib and attrib.name) then
					desc = desc.. "\n " ..attrib.name.. ": " ..v
				end
			end
		end
		
		local res = self:getData("res", self.res)
		if(res and res != {}) then --no bonuses means no need for bonuses in the desc
			desc = desc .. "\n\n<color=50,200,50>Resistances</color>"

			for k, v in pairs(res) do
				if(v != 0) then
					local dmgType = (nut.plugin.list["spells"] and nut.plugin.list["spells"].dmgTypes[k])
					if(dmgType) then
						desc = desc .. "\n " ..dmgType.name.. " Resistance: " ..v.. "%."
					end
				
					local effect = EFFS.effects[k]
					if(effect) then
						desc = desc .. "\n " ..effect.name.. " Resistance: " ..v.. "%."
					end
				end
			end
		end
	end
	
	return desc
end