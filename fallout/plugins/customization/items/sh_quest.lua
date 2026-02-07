ITEM.name = "Quest Item"
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "A quest item."
ITEM.flag = "1"
ITEM.category = "Quest"
ITEM.onGetDropModel = true

ITEM.customizable = {
	["name"] = true,
	["desc"] = true,
	["model"] = true,
	["modelScale"] = true,
	["modelColor"] = true,
	["material"] = true,
	["color"] = true,
	["img"] = true,
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

ITEM.functions.Inspect = {
	name = "Inspect",
	tip = "Inspect this item",
	icon = "icon16/picture.png",
	onClick = function(item, test)
		local customData = item:getData("custom", {})

		local frame = vgui.Create("DFrame")
		frame:SetSize(540, 680)
		frame:SetTitle(item.name)
		frame:MakePopup()
		frame:Center()

		frame.html = frame:Add("DHTML")
		frame.html:Dock(FILL)
		
		local imageCode = [[<img src = "]]..customData.img..[["/>]]
		
		frame.html:SetHTML([[<html><body style="background-color: #000000; color: #282B2D; font-family: 'Book Antiqua', Palatino, 'Palatino Linotype', 'Palatino LT STD', Georgia, serif; font-size 16px; text-align: justify;">]]..imageCode..[[</body></html>]])
	end,
	onRun = function(item)
		return false
	end,
	onCanRun = function(item)
		local customData = item:getData("custom", {})
	
		if(!customData.img) then
			return false
		end
		
		if(item.entity) then
			return false
		end
		
		return true
	end
}

ITEM.functions.Clone = {
	name = "Clone",
	tip = "Clone this item",
	icon = "icon16/wrench.png",
	onRun = function(item)
		local client = item.player	
	
		client:requestQuery("Are you sure you want to clone this item?", "Clone", function(text)
			local inventory = client:getChar():getInv()
			
			if(!inventory:add(item.uniqueID, 1, item.data)) then
				client:notify("Inventory is full")
			end
		end)
		return false
	end,
	onCanRun = function(item)
		local client = item.player
		return client:getChar():hasFlags("1")
	end
}

ITEM.functions.Identify = {
	name = "Identify",
	tip = "Reveal the information",
	icon = "icon16/wrench.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
		local inventory = client:getChar():getInv()
		
		local scroll
	
		local ident = item:getData("ident")
		if(ident == 1) then --regular item
			if(!char:hasFlags("d")) then
				scroll = inventory:getFirstItemOfType("scroll_identity1")
			end
		elseif(ident == 2) then --magic item
			if(!char:hasFlags("D")) then
				scroll = inventory:getFirstItemOfType("scroll_identity2")
			end
		end
	
		if(scroll) then
			scroll:remove() --its like this so admins can do whatever
		end
		
		item:setData("ident", nil)
		client:notify("Item successfully identified.")
		
		return false
	end,
	onCanRun = function(item)
		local client = item.player
		local char = client:getChar()
		
		if(IsValid(item.entity)) then
			return false
		end
		
		local ident = item:getData("ident")
		if(ident) then
			local inventory = client:getChar():getInv()
			if(ident == 1) then --regular item
				if(char:hasFlags("d")) then
					return true
				end
			
				if(inventory:hasItem("scroll_identity1")) then
					return true
				end
			elseif(ident == 2) then --magic item
				if(char:hasFlags("D")) then
					return true
				end
			
				if(inventory:hasItem("scroll_identity2")) then
					return true
				end
			end
		else
			return false
		end
		
		if(char:hasFlags("1")) then
			return true
		end
		
		--it's already identified
		if(!item:getData("ident")) then 
			return false
		end
		
		return false
	end
}

ITEM.functions.Unidentify = {
	name = "Unidentify",
	tip = "Hide the information",
	icon = "icon16/wrench.png",
	onRun = function(item)
		local client = item.player	
	
		client:requestString("Unidentified Type", "Input 1 for Mundane, 2 for Magical.", function(text) --start of model
			local unid = tonumber(text)
			
			if(unid) then
				item:setData("ident", unid)
			end
		end, item:getData("ident", ""))
		
		
		return false
	end,
	onCanRun = function(item)
		--it's already unidentified
		if(item:getData("ident")) then 
			return false
		end
	
		local client = item.player
		return client:IsAdmin()
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