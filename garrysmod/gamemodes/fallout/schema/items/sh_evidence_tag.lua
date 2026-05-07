ITEM.name = "Evidence Tag"
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "A tag that can have a description written on it."
ITEM.flag = "v"
ITEM.category = "Miscellaneous"
ITEM.onGetDropModel = true

--for people to name their shit
ITEM.functions.CustomName = {
	name = "Change Name",
	tip = "Customize this item",
	icon = "icon16/wrench.png",
	onRun = function(item)
		local client = item.player

		local customData = item:getData("custom", {})

		client:requestString("Change Name", "", function(text)
			customData.name = text or " "
			item:setData("custom", customData)
		end, customData.name)

		return false
	end,
	onCanRun = function(item)
		--[[
		local creator = item:getData("creator")
	
		local client = item.player
		
		if(creator and client:getChar():getID() == creator) then
			return true
		else
			return false
		end
		--]]
		
		return true
	end
}

--for people to name their shit
ITEM.functions.CustomDesc = {
	name = "Change Desc",
	tip = "Customize this item",
	icon = "icon16/wrench.png",
	onRun = function(item)
		local client = item.player

		local customData = item:getData("custom", {})

		client:requestString("Change Desc", "", function(text)
			customData.desc = text or " "
			item:setData("custom", customData)
		end, customData.desc)

		return false
	end,
	onCanRun = function(item)
		--[[
		local creator = item:getData("creator")
	
		local client = item.player
		
		if(creator and client:getChar():getID() == creator) then
			return true
		else
			return false
		end
		--]]
		
		return true
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
	
	return name
end

function ITEM:getDesc(partial)
	local desc = self.desc
	
	local ident = self:getData("ident")
	if(ident) then
		local undentified = "This item is unidentified."
		return undentified
	end
	
	local customData = self:getData("custom", {})
	if(customData.desc) then
		desc = customData.desc
	end
		
	if(!partial) then
		if(customData.quality) then
			desc = desc .. "\nQuality: " ..customData.quality
		end
	end
	
	return desc
end

function ITEM:onGetDropModel()
	local model = self.model
	
	local customData = self:getData("custom", {})
	if(customData.model) then
		model = customData.model
	end
	
	return Format(model)
end