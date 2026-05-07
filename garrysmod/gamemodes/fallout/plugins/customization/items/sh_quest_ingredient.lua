ITEM.name = "Quest Ingredient"
ITEM.desc = " "
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Crafting"
ITEM.flag = "1"
ITEM.color = Color(50, 150, 50)

ITEM.functions.Inspect = {
	name = "Inspect",
	tip = "Inspect this item",
	icon = "icon16/picture.png",
	onClick = function(item)
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
		
		return true
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
	name = "Customize Craft Stats",
	tip = "Customize this item",
	icon = "icon16/wrench.png",
	onRun = function(item)		
		nut.plugin.list["customization"]:startCustomI(item.player, item)
		
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

ITEM.functions.CustomAmp = {
	name = "Customize Amplifications",
	tip = "Customize this item",
	icon = "icon16/wrench.png",
	onRun = function(item, data)
		nut.plugin.list["customization"]:startCustomAmp(item.player, item)
		
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

ITEM.functions.CustomTags = {
	name = "Customize Tags",
	tip = "Customize this item",
	icon = "icon16/wrench.png",
	onRun = function(item, data)
		nut.plugin.list["customization"]:startCustomTags(item.player, item)
		
		return false
	end,
	onCanRun = function(item)
		local client = item.player
		return client:getChar():hasFlags("1")
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

function ITEM:getDesc(partial)
	local desc = self.desc

	local customData = self:getData("custom", {})
	if(customData.desc) then
		desc = customData.desc
	end
	
	if(!partial) then		
		if(LocalPlayer():IsAdmin()) then
			local hp = self:getData("hp", self.hp)
			if(hp) then
				desc = desc.. "\n HP: " ..hp.. "."
			end
			
			local mp = self:getData("mp", self.mp)
			if(mp) then
				desc = desc.. "\n MP: " ..mp.. "."
			end
			
			local ap = self:getData("ap", self.ap)
			if(ap) then
				desc = desc.. "\n AP: " ..ap.. "."
			end
		
			local hpMax = self:getData("hpMax", self.hpMax)
			if(hpMax) then
				desc = desc.. "\n Max HP: " ..hpMax.. "."
			end
			
			local mpMax = self:getData("mpMax", self.mpMax)
			if(mpMax) then
				desc = desc.. "\n Max MP: " ..mpMax.. "."
			end
			
			local apMax = self:getData("apMax", self.apMax)
			if(apMax) then
				desc = desc.. "\n Max MP: " ..apMax.. "."
			end
			
			local evasion = self:getData("evasion", self.evasion)
			if(evasion) then
				desc = desc.. "\n Evasion: " ..evasion.. "."
			end
			
			local accuracy = self:getData("accuracy", self.accuracy)
			if(accuracy) then
				desc = desc.. "\n Accuracy: " ..accuracy.. "."
			end
			
			local armor = self:getData("armor", self.armor)
			if(armor) then
				desc = desc.. "\n Armor: " ..armor.. "."
			end
			
			local critC = self:getData("critC", self.critC)
			if(critC) then
				desc = desc.. "\n Crit Chance: " ..critC.. "."
			end
			
			local critM = self:getData("critM", self.critM)
			if(critM) then
				desc = desc.. "\n Crit Multiplier: " ..critM.. "."
			end
			
			local magic = self:getData("magic", self.magic)
			if(magic) then
				desc = desc.. "\n Magic Bonus: " ..magic.. "."
			end
			
			local res = self:getData("res", self.res)
			if(res) then
				desc = desc.. "\n\n<color=50,200,50>Resistances</color>"
				
				for k, v in pairs(res) do
					if(v != 0) then
						local dmgType = (nut.plugin.list["spells"] and nut.plugin.list["spells"].dmgTypes[k])
						if(dmgType) then
							desc = desc.. "\n " ..dmgType.name.. " Resistance: " ..v.. "%."
						end
					
						local effect = EFFS.effects[k]
						if(effect) then
							desc = desc.. "\n " ..effect.name.. " Resistance: " ..v.. "%."
						end
					end
				end
			end		
			
			local amp = self:getData("amp", self.amp)
			if(amp) then
				desc = desc.. "\n\n<color=50,200,50>Amplifications</color>"
				
				for k, v in pairs(amp) do
					if(v != 0) then
						local dmgType = (nut.plugin.list["spells"] and nut.plugin.list["spells"].dmgTypes[k])
						if(dmgType) then
							desc = desc.. "\n " ..dmgType.name.. " Amplification: " ..v.. "%."
						end
					
						local effect = EFFS.effects[k]
						if(effect) then
							desc = desc.. "\n " ..effect.name.. " Amplification: " ..v.. "%."
						end
					end
				end
			end
			
			local attrib = self:getData("attrib", self.attrib)
			if(attrib) then
				desc = desc.. "\n\n<color=50,200,50>Bonuses</color>"
				
				local boostTbl = self:getData("attrib")

				for k, v in pairs(boostTbl) do
					if(v != 0 and nut.attribs.list[k]) then
						desc = desc .. "\n " ..nut.attribs.list[k].name.. ": " .. v
					end
				end
			end
		end
	end
		
	return desc --Format(desc, COOKLEVEL[(self:getData("cooked") or 1)][1])
end

function ITEM:getName()
	local name = self.name
	
	local customData = self:getData("custom", {})
	if(customData.name) then
		name = customData.name
	end
	
	return name
end

function ITEM:onGetDropModel()
	local model = self.model
	
	local customData = self:getData("custom", {})
	if(customData.model) then
		model = customData.model
	end
	
	return Format(model)
end

if (CLIENT) then --draws a square on the food item for how well cooked it is.
	function ITEM:paintOver(item, w, h)
		draw.SimpleText((item.getName and item:getName()) or item.name, "DermaDefault", w * 0.5, h * 0.2, Color(200,200,200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	
		local quantity = item:getData("Amount", 1)

		if (quantity > 1) then
			draw.SimpleText(quantity, "DermaDefault", w - 12, h - 14, Color(50,50,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
		end
	end
end