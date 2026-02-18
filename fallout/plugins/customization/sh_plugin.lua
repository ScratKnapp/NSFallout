local PLUGIN = PLUGIN
PLUGIN.name = "Customization"
PLUGIN.author = ""
PLUGIN.desc = "Item Customization."


function PLUGIN:getCustomFields(item, entity)
	if(item and !item.customizable) then return end
	
	local saveData
	local customizable
	local itemTable = item
	
	if(item) then
		customizable = item.customizable
		saveData = item:getData("custom", {})	
		
		if(item.getCustomFields) then
			local config = item:getCustomFields()
			return config
		end
	else
		itemTable = entity:getItemTable()
		customizable = itemTable.customizable
		saveData = entity:getData("custom", {})	
		
		if(itemTable.getCustomFields) then
			local config = itemTable:getCustomFields()
			return config
		end
		
		item = entity
	end

	local config = {
		{
			["name"] = {
				weight = 1, 
				name = "Name", 
				category = "Basic",
				value = saveData.name or itemTable.name,
				updateType = "Custom",
			},
			["desc"] = {
				weight = 2, 
				name = "Description", 
				category = "Basic",
				value = saveData.desc or itemTable.desc,
				updateType = "Custom",
			},	
			["model"] = {
				weight = 13, 
				name = "Model", 
				category = "Basic",
				value = saveData.model or itemTable.model,
				updateType = "Custom",
				onUpdate = function(item, data)
					local entity = item:getEntity()
					if(entity and IsValid(entity)) then
						entity:SetModel(data)
						entity:PhysicsInit(SOLID_VPHYSICS)
						entity:SetSolid(SOLID_VPHYSICS)
					end
				end,
			},
			["modelScale"] = {
				weight = 14, 
				name = "Model Scale", 
				category = "Basic",
				value = saveData.modelScale or itemTable.modelScale or 1,
				numeric = true,
				updateType = "Custom",
				onUpdate = function(item, data)
					local entity = item:getEntity()
					if(entity and IsValid(entity)) then
						item:onEntityCreated(entity)
					end
				end,
			},
			["material"] = {
				weight = 15, 
				name = "Material", 
				category = "Basic",
				value = saveData.material or itemTable.material,
				updateType = "Custom",
				onUpdate = function(item, data)
					local entity = item:getEntity()
					if(entity and IsValid(entity)) then
						entity:SetModelScale(data)
					end
				end,
			},
			["color"] = {
				weight = 17, 
				name = "Inventory Color", 
				category = "Basic",
				value = saveData.color or itemTable.color or nut.config.get("color"),
				updateType = "Custom",
				panelType = "DColorMixer",
			},
			["modelColor"] = {
				weight = 18, 
				name = "Model Color", 
				category = "Basic",
				value = saveData.modelColor or itemTable.modelColor,
				updateType = "Custom",
				panelType = "DColorMixer",
				onUpdate = function(item, data)
					local entity = item:getEntity()
					if(entity and IsValid(entity)) then
						entity:SetColor(data)
					end
				end,
			},
		},
		{
			["armor"] = {
				weight = 7, 
				name = "Armor", 
				category = "Combat Stats",
				value = saveData.armor,
				numeric = true,
			},
			["accuracy"] = {
				weight = 8, 
				name = "Accuracy (Bonus)", 
				category = "Combat Stats",
				value = saveData.accuracy,
				numeric = true,
			},
			["evasion"] = {
				weight = 9, 
				name = "Evasion (Bonus)", 
				category = "Combat Stats",
				value = saveData.evasion,
				numeric = true,
			},
			["critC"] = {
				weight = 10, 
				name = "Crit Chance (As Weapon)", 
				category = "Combat Stats",
				value = saveData.critC or item.critC,
				numeric = true,
			},
			["critM"] = {
				weight = 11, 
				name = "Crit Multiplier (As Weapon)", 
				category = "Combat Stats",
				value = saveData.critM or item.critM,
				numeric = true,
			},
			["critBC"] = {
				weight = 12, 
				name = "Crit Chance (Bonus)", 
				category = "Combat Stats",
				value = saveData.critBC or item.critBC,
				numeric = true,
			},
			["critBM"] = {
				weight = 13, 
				name = "Crit Multiplier (Bonus)", 
				category = "Combat Stats",
				value = saveData.critBM or item.critBM,
				numeric = true,
			},
		},
		{
			["attrib"] = {
				weight = 8, 
				name = "Attributes", 
				category = "Attributes",
				value = item:getData("attrib", itemTable.attrib),
				extra = nut.attribs.list,
				numeric = true,
			},
		},
		{
			["skills"] = {
				weight = 8, 
				name = "Skills", 
				category = "Skills",
				value = item:getData("skills", itemTable.skills),
				extra = nut.skills.list,
				numeric = true,
			},
		},
		{
			["res"] = {
				weight = 9, 
				name = "Resistances (Damage)", 
				category = "Resistances",
				value = item:getData("res", itemTable.res),
				extra = nut.plugin.list["combat"].dmgTypes, --needs effect types too
				numeric = true,
				updateType = function(item, data, fullData)
					local res = data
				
					local resEffect = fullData["resEffect"] or {}
					for k, v in pairs(data) do
						res[k] = v
					end
					
					item:setData("res", res)
				end,
			},
			["resEffect"] = {
				weight = 10, 
				name = "Resistances (Effects)", 
				category = "Resistances",
				value = item:getData("res", itemTable.res),
				extra = EFFS.effects, --needs effect types too
				numeric = true,
				updateType = function(item, data, fullData)
					--handled by res category
				end,
			},
		},
		{
			["amp"] = {
				weight = 10, 
				name = "Amplifications", 
				category = "Amplifications",
				value = item:getData("amp", itemTable.amp),
				extra = nut.plugin.list["combat"].dmgTypes,
				numeric = true,
			},
		},
		{
			["dmg"] = {
				weight = 11, 
				name = "Damage Types/Values", 
				category = "Damage Values",
				value = item:getData("dmg", itemTable.dmg),
				extra = nut.plugin.list["combat"].dmgTypes,
				numeric = true,
			},
		},
		{
			["scale"] = {
				weight = 12, 
				name = "Scaling", 
				category = "Attribute Scaling",
				value = item:getData("scale", itemTable.scaling),
				extra = nut.attribs.list,
				numeric = true,
			},
		},
		--[[
		{
			["actions"] = {
				weight = 12, 
				name = "Actions", 
				category = "Actions",
				value = 1,--saveData.actions
				updateType = "netVar",
				--panelType = "DComboBox",
			},
		},
		--]]
	}
	
	for k, category in pairs(config) do
		for var, _ in pairs(category) do
			if(!customizable[var]) then
				config[k][var] = nil
			end
		end
	end
	
	return config
end

if(SERVER) then
	function PLUGIN:getCustomData(item)
		local customData = {}
	
		if(item.getCustomData) then
			customData = item:getCustomData()
		else
			local custom = item:getData("custom", {})
		
			customData = {
				--name = custom.name or item:getName(),
				--desc = custom.desc or item:getDesc(),
				color = custom.color or item.color or nut.config.get("color") or Color(255, 255, 255),
				model = custom.model or item.model,
				material = custom.material or item.material,
				img = custom.img or item.img,
				modelScale = custom.modelScale or item.modelScale,
				attrib = custom.attrib or item.attrib,
				res = custom.res or item.res,
				amp = custom.amp or item.amp,
				armor = custom.armor or item.armor,
				evasion = custom.evasion or item.evasion,
				accuracy = custom.accuracy or item.accuracy,
				scale = custom.scale or item.scaling,
				dmg = custom.dmg or item.dmg,
			}
		end
		
		return customData
	end

	--customization statrt
	function PLUGIN:startCustom(client, item, extra)
		--customizations require a flag in the items set, so it's unnecessary to do this here, uncomment it if you want.
		--[[
		if !client:IsAdmin() then
			return
		end
		--]]

		--[[
		local customData = item:getData("custom", {})
	
		local itemInfo = {}
		itemInfo.id = item.id
		itemInfo.name = item:getName() or item.name
		itemInfo.desc = item:getDesc(true) or item.desc
		itemInfo.color = customData.color or item.color or nut.config.get("color") or Color(255, 255, 255)
		itemInfo.model = customData.model or item.model
		itemInfo.material = customData.material or item.material
		itemInfo.img = customData.img
		itemInfo.modelScale = customData.modelScale or item.modelScale
		--]]
		
		item:sync()
		
		local data = PLUGIN:getCustomData(item)
		local itemID = item.id

		netstream.Start(client, "nut_custom", itemID, data)
	end
	
	--attribute customization start
	function PLUGIN:startCustomE(client, item)
		local itemInfo = {}
		itemInfo.id = item.id
		
		itemInfo.dmg = item:getData("dmg", item.dmg)
		itemInfo.dmgT = item:getData("dmgT", item.dmgT)
		itemInfo.weight = item:getData("weight", item.weight)
		itemInfo.armor = item:getData("armor", item.armor)
		
		itemInfo.evasion = item:getData("evasion", item.evasion)
		itemInfo.accuracy = item:getData("accuracy", item.accuracy)
		
		itemInfo.critC = item:getData("critC", item.critC)
		itemInfo.critM = item:getData("critM", item.critM)
		
		if(item.magSize) then
			itemInfo.magSize = item:getData("magSize", item.magSize)
			itemInfo.currentMag = item:getData("currentMag", {})
		end
		
		itemInfo.jamC = item:getData("jamC", item.jamC)
		
		itemInfo.dura = item:getData("dura", item.durability)
		itemInfo.duraMax = item:getData("duraMax", item.durability)
		
		itemInfo.scale = item:getData("scale", item.scaling)
		
		netstream.Start(client, "nut_customE", itemInfo)
	end
	
	--attribute customization start
	function PLUGIN:startCustomDrone(client, item)
		local combatData = item:getData("combatData", item.combatData) or {}
	
		local itemInfo = {}
		itemInfo.id = item.id
		itemInfo.name = item:getData("name", item.name)
		itemInfo.desc = item:getData("desc", item.desc)
		itemInfo.techReq = item:getData("techReq", item.techReq)
		
		itemInfo.hpMax = item:getData("hpMax", item.hpMax)
		itemInfo.dmg = item:getData("dmg", item.dmg)
		itemInfo.dmgT = item:getData("dmgT", item.dmgT)
		itemInfo.armor = item:getData("armor", item.armor)
		itemInfo.attribs = item:getData("attribs", item.attribs)
		itemInfo.res = item:getData("res", item.res)
		itemInfo.actions = item:getData("actions", item.actions)
		itemInfo.model = item:getData("model", item.modelEnt)
		itemInfo.material = item:getData("material", item.materialEnt)
		
		netstream.Start(client, "nut_customDrone", itemInfo)
	end		
	
	--attribute customization start
	function PLUGIN:startCustomI(client, item)
		local itemInfo = {}
		itemInfo.id = item.id
		
		itemInfo.prefix = item:getData("prefix", item.prefix)
		itemInfo.dmg = item:getData("dmg", item.dmg)
		itemInfo.armor = item:getData("armor", item.armor)
		itemInfo.weight = item:getData("weight", item.weight)
		--itemInfo.magic = item:getData("magic", item.magic)
		itemInfo.evasion = item:getData("evasion", item.evasion)
		itemInfo.accuracy = item:getData("accuracy", item.accuracy)
		--itemInfo.critC = item:getData("critC", item.critC)
		--itemInfo.critM = item:getData("critM", item.critM)
		itemInfo.hp = item:getData("hp", item.hp)
		--itemInfo.mp = item:getData("mp", item.mp)
		itemInfo.hpMax = item:getData("hpMax", item.hpMax)
		--itemInfo.mpMax = item:getData("mpMax", item.mpMax)
		
		netstream.Start(client, "nut_customI", itemInfo)
	end		
	
	--attribute customization start
	function PLUGIN:startCustomA(client, item)
		local attribData = item:getData("attrib", item.attribs) or {}
	
		local itemInfo = {}
		itemInfo.id = item.id
		itemInfo.attrib = attribData
		
		netstream.Start(client, "nut_customA", itemInfo)
	end
	
	--attribute customization start
	function PLUGIN:startCustomR(client, item)
		local resData = item:getData("res", item.res) or {}
	
		local itemInfo = {}
		itemInfo.id = item.id
		itemInfo.res = resData
		
		netstream.Start(client, "nut_customR", itemInfo)
	end	
	
	--attribute customization start
	function PLUGIN:startCustomAmp(client, item)
		local resData = item:getData("amp", item.res) or {}
	
		local itemInfo = {}
		itemInfo.id = item.id
		itemInfo.res = resData
		
		netstream.Start(client, "nut_customAmp", itemInfo)
	end	
	
	--attribute customization start
	function PLUGIN:startCustomTags(client, item)
		local tagData = item:getData("tags", {})
	
		local itemInfo = {}
		itemInfo.id = item.id
		itemInfo.tags = tagData
		
		netstream.Start(client, "nut_customTags", itemInfo)
	end	
	
	--attribute customization start
	function PLUGIN:startCustomLabels(client, item)
		local labelData = item:getData("labels", {})
	
		local itemInfo = {}
		itemInfo.id = item.id
		itemInfo.labels = labelData
		
		netstream.Start(client, "nut_customLabels", itemInfo)
	end

	--regular finish hook
	netstream.Hook("nut_customF", function(client, data)
		local id = data[1]
		local item = nut.item.instances[id]
		local customData = data[2]
		
		if (item) then
			item:setData("custom", customData)
			item:setData("edited", client:Name()) --who last edited this thing
		end
	end)	
	
	--attribute finish hook
	netstream.Hook("nut_attribF", function(client, data)
		local id = data[1]
		local item = nut.item.instances[id]
		local attribData = data[2]
		
		if (item) then
			item:setData("attrib", attribData)
			item:setData("edited", client:Name()) --who last edited this thing
		end
	end)
	
	--finish hook
	netstream.Hook("nut_equipF", function(client, data)
		local id = data[1]
		local item = nut.item.instances[id]

		if (item) then
			for k, v in pairs(data[2]) do
				if(istable(v)) then
					for k2, v2 in pairs(v) do
						if(v2 == 0 or v == "") then
							data[2][k][k2] = nil
						end
					end
					
					item:setData(k, v)
				else
					if(v != 0 and v != "") then
						item:setData(k, v)
					else
						item:setData(k, nil)
					end
				end
			end
			
			item:setData("edited", client:Name()) --who last edited this thing
		end
	end)

	--finish hook
	netstream.Hook("nut_resF", function(client, data)
		local id = data[1]
		local item = nut.item.instances[id]
		local resData = data[2]
		
		if (item) then
			item:setData("res", resData)
			item:setData("edited", client:Name()) --who last edited this thing
		end
	end)
	
	--finish hook
	netstream.Hook("nut_ampF", function(client, data)
		local id = data[1]
		local item = nut.item.instances[id]
		local ampData = data[2]
		
		if (item) then
			item:setData("amp", ampData)
			item:setData("edited", client:Name()) --who last edited this thing
		end
	end)
	
	--finish hook
	netstream.Hook("nut_tagsF", function(client, data)
		local id = data[1]
		local item = nut.item.instances[id]
		local tagData = data[2]
		
		if (item) then
			item:setData("tags", tagData)
			item:setData("edited", client:Name()) --who last edited this thing
		end
	end)	
	
	--finish hook
	netstream.Hook("nut_labelF", function(client, data)
		local id = data[1]
		local item = nut.item.instances[id]
		local tagData = data[2]
		
		if (item) then
			item:setData("labels", tagData)
			item:setData("edited", client:Name()) --who last edited this thing
		end
	end)

	--finish hook
	netstream.Hook("nut_ItemUpdateData", function(client, itemID, data)
		--if(!item or !item.id) then return end
		
		local item = nut.item.instances[itemID]
		
		local customData = item:getData("custom", {})

		local fields = PLUGIN:getCustomFields(item)
		for _, dataFields in pairs(fields) do
			for id, v in pairs(dataFields) do
				if(data[id]) then
					if(isfunction(v.updateType)) then
						v.updateType(item, data[id], data)
					elseif(v.updateType == "Custom") then
						customData[id] = data[id]
					else
						item:setData(id, data[id])
					end
					
					if(v.onUpdate) then
						v.onUpdate(item, data[id], data)
					end
				end
			end
		end
		
		item:setData("custom", customData)
		
		if(item.postCustom) then
			item:postCustom(client, item, data)
		end
	end)
else
	--clientside hook for menus
	netstream.Hook("nut_custom", function(itemID, data)
		local custom = vgui.Create("nutItemCustom")

		custom:ItemConfig(itemID, data)
	end)
	
	netstream.Hook("nut_customA", function(data)
		local item = data
	
		--current values of item
		local attribData = item.attrib

		local frame = vgui.Create("DFrame")
		frame:SetSize(450, 600)
		frame:Center()
		frame:SetTitle("Attributes")
		frame:MakePopup()
		frame:ShowCloseButton(true)

		local scroll = vgui.Create("DScrollPanel", frame)
		scroll:Dock(FILL)

		--attribute customization
		local attribs = {}
		for k, v in pairs(nut.attribs.list) do
			local attribL = vgui.Create("DLabel", scroll)
			attribL:SetText(v.name)
			attribL:Dock(TOP)
			
			local attribC = vgui.Create("DNumberWang", scroll)
			attribC.attrib = k
			attribC:SetDecimals(2)
			attribC:Dock(TOP)
			attribC:SetMax(200)
			attribC:SetMin(-200)
			attribC:SetValue(attribData[k] or 0)
			
			attribs[k] = attribC
		end
		
		local finishB = vgui.Create("DButton", scroll)
		finishB:SetSize(60,20)
		finishB:SetText("Complete")
		finishB:Dock(TOP)
		finishB.DoClick = function()
			local customData = {}
			customData[1] = item.id
			customData[2] = {}

			for k, v in pairs(attribs) do
				local value = v:GetValue()
				if(value != 0) then
					customData[2][k] = value
				else
					customData[2][k] = nil
				end
			end

			netstream.Start("nut_attribF", customData)
			
			frame:Remove()
		end
		
		local cancelB = vgui.Create("DButton", scroll)
		cancelB:SetSize(60,20)
		cancelB:SetText("Cancel")
		cancelB:Dock(TOP)
		cancelB.DoClick = function()
			frame:Remove()
		end
	end)
	
	netstream.Hook("nut_customR", function(data)
		local item = data
	
		--current values of item
		local resData = item.res

		local frame = vgui.Create("DFrame")
		frame:SetSize(450, 600)
		frame:Center()
		frame:SetTitle("Resistances")
		frame:MakePopup()
		frame:ShowCloseButton(true)

		local scroll = vgui.Create("DScrollPanel", frame)
		scroll:Dock(FILL)

		local res = {}
		
		--damage type resistance customization
		for k, v in pairs((nut.plugin.list["combat"] and nut.plugin.list["combat"].dmgTypes) or {}) do
			local resL = vgui.Create("DLabel", scroll)
			resL:SetText(v.name)
			resL:Dock(TOP)
			
			local resC = vgui.Create("DNumberWang", scroll)
			resC.res = k
			resC:SetDecimals(2)
			resC:Dock(TOP)
			resC:SetMax(200)
			resC:SetMin(-200)
			resC:SetValue(resData[k] or 0)
			
			res[k] = resC
		end
		
		--attribute customization
		for k, v in pairs(EFFS.effects) do
			local resL = vgui.Create("DLabel", scroll)
			resL:SetText(v.name)
			resL:Dock(TOP)
			
			local resC = vgui.Create("DNumberWang", scroll)
			resC.res = k
			resC:SetDecimals(2)
			resC:Dock(TOP)
			resC:SetMax(200)
			resC:SetMin(-200)
			resC:SetValue(resData[k] or 0)
			
			res[k] = resC
		end
		
		local finishB = vgui.Create("DButton", scroll)
		finishB:SetSize(60,20)
		finishB:SetText("Complete")
		finishB:Dock(TOP)
		finishB.DoClick = function()
			local customData = {}
			customData[1] = item.id
			customData[2] = {}

			for k, v in pairs(res) do
				local value = v:GetValue()
				if(value != 0) then
					customData[2][k] = value
				else
					customData[2][k] = nil
				end
			end

			netstream.Start("nut_resF", customData)
			
			frame:Remove()
		end
		
		local cancelB = vgui.Create("DButton", scroll)
		cancelB:SetSize(60,20)
		cancelB:SetText("Cancel")
		cancelB:Dock(TOP)
		cancelB.DoClick = function()
			frame:Remove()
		end
	end)
	
	netstream.Hook("nut_customAmp", function(data)
		local item = data
	
		--current values of item
		local resData = item.res

		local frame = vgui.Create("DFrame")
		frame:SetSize(450, 600)
		frame:Center()
		frame:SetTitle("Amplifications")
		frame:MakePopup()
		frame:ShowCloseButton(true)

		local scroll = vgui.Create("DScrollPanel", frame)
		scroll:Dock(FILL)

		local res = {}
		
		--damage type resistance customization
		for k, v in pairs((nut.plugin.list["combat"] and nut.plugin.list["combat"].dmgTypes) or {}) do
			local ampL = vgui.Create("DLabel", scroll)
			ampL:SetText(v.name)
			ampL:Dock(TOP)
			
			local ampC = vgui.Create("DNumberWang", scroll)
			ampC.res = k
			ampC:SetDecimals(2)
			ampC:Dock(TOP)
			ampC:SetMax(200)
			ampC:SetMin(-200)
			ampC:SetValue(resData[k] or 0)
			
			res[k] = ampC
		end
		
		local finishB = vgui.Create("DButton", scroll)
		finishB:SetSize(60,20)
		finishB:SetText("Complete")
		finishB:Dock(TOP)
		finishB.DoClick = function()
			local customData = {}
			customData[1] = item.id
			customData[2] = {}

			for k, v in pairs(res) do
				local value = v:GetValue()
				if(value != 0) then
					customData[2][k] = value
				else
					customData[2][k] = nil
				end
			end

			netstream.Start("nut_ampF", customData)
			
			frame:Remove()
		end
		
		local cancelB = vgui.Create("DButton", scroll)
		cancelB:SetSize(60,20)
		cancelB:SetText("Cancel")
		cancelB:Dock(TOP)
		cancelB.DoClick = function()
			frame:Remove()
		end
	end)
	
	netstream.Hook("nut_customTags", function(data)
		local item = data
	
		--current values of item
		local tagData = item.tags

		local frame = vgui.Create("DFrame")
		frame:SetSize(450, 600)
		frame:Center()
		frame:SetTitle("Tags")
		frame:MakePopup()
		frame:ShowCloseButton(true)

		local scroll = vgui.Create("DScrollPanel", frame)
		scroll:Dock(FILL)

		local info = {}
		
		local tags = {
			["Gem"] = true,
			["Alchemical"] = true,
			["Bar"] = true,
			["Metal"] = true,
			["Mana Core"] = true,
			["Leather"] = true,
			["Cloth"] = true,
			["Lumber"] = true,
			["Bow Material"] = true,
			
			["Drink"] = true,
			["Alcohol"] = true,
			["Vegetable"] = true,
			["Meat"] = true,
			["Egg"] = true,
			["Sugar"] = true,
			["Fruit"] = true,
			["Ingredient"] = true,
		}
		
		--damage type resistance customization
		for k, v in pairs(tags) do
			local tag = vgui.Create("DCheckBoxLabel", scroll)
			tag:SetText(k)
			tag.tag = k
			tag:Dock(TOP)
			tag:SizeToContents()
			
			if(tagData[k]) then
				tag:SetValue(tagData[k])
			else
				tag:SetValue(false)
			end
			
			info[k] = tag
		end
		
		local finishB = vgui.Create("DButton", scroll)
		finishB:SetSize(60,20)
		finishB:SetText("Complete")
		finishB:Dock(TOP)
		finishB.DoClick = function()
			local customData = {}
			customData[1] = item.id
			customData[2] = {}
			
			for k, v in pairs(info) do
				local value = v:GetChecked()
				if(value) then
					customData[2][v.tag] = value
				end
			end

			netstream.Start("nut_tagsF", customData)
			
			frame:Remove()
		end
		
		local cancelB = vgui.Create("DButton", scroll)
		cancelB:SetSize(60,20)
		cancelB:SetText("Cancel")
		cancelB:Dock(TOP)
		cancelB.DoClick = function()
			frame:Remove()
		end
	end)
	
	--for tag damage (damage against Undead, Living, etc)
	netstream.Hook("nut_customLabels", function(data)
		local item = data
	
		--current values of item
		local labelData = item.labels

		local frame = vgui.Create("DFrame")
		frame:SetSize(450, 600)
		frame:Center()
		frame:SetTitle("Labels")
		frame:MakePopup()
		frame:ShowCloseButton(true)

		local scroll = vgui.Create("DScrollPanel", frame)
		scroll:Dock(FILL)

		local info = {}
		
		local labels = {
			["Living"] = true,
			["Undead"] = true,
			["Inanimate"] = true,
			
			["Flying"] = true,
			["Giant"] = true,
			["Mage"] = true,
			["Poisonous"] = true,
			["Leader"] = true,
			["Elemental"] = true,
			
			["Construct"] = true,
			["Humanoid"] = true,
			["Animal"] = true,
			["Bug"] = true,
			
			["Demon"] = true,
			["Bear"] = true,
			["Cat"] = true,
			["Crab"] = true,
			["Gnoll"] = true,
			["Goblin"] = true,
			["Golem"] = true,
			["Ogre"] = true,
			["Orc"] = true,
			["Spider"] = true,
			["Toad"] = true,
			["Pirate"] = true,
			["Skeletal"] = true,
			["Worm"] = true,
			
			["Remilla"] = true,
		}
		
		--damage type resistance customization
		for k, v in pairs(labels) do
			local name = vgui.Create("DLabel", scroll)
			name:SetText(k)
			name:Dock(TOP)
		
			local label = vgui.Create("DNumberWang", scroll)
			label:SetNumeric(true)
			label:SetValue(1)
			
			label.label = k
			label:Dock(TOP)
			label:SizeToContents()
			
			if(labelData[k]) then
				label:SetValue(labelData[k])
			end
			
			info[k] = label
		end
		
		local finishB = vgui.Create("DButton", scroll)
		finishB:SetSize(60,20)
		finishB:SetText("Complete")
		finishB:Dock(TOP)
		finishB.DoClick = function()
			local customData = {}
			customData[1] = item.id
			customData[2] = {}
			
			for k, v in pairs(info) do
				local value = v:GetValue()
				if(value != 1) then
					customData[2][v.label] = value
				else --no need for it
					customData[2][v.label] = nil
				end
			end

			netstream.Start("nut_labelF", customData)
			
			frame:Remove()
		end
		
		local cancelB = vgui.Create("DButton", scroll)
		cancelB:SetSize(60,20)
		cancelB:SetText("Cancel")
		cancelB:Dock(TOP)
		cancelB.DoClick = function()
			frame:Remove()
		end
	end)	
	
	local function dataTemp(data, req)
		return data[req]
	end	
	
	local function dataTempTbl(data, req, sub)
		if(data[req]) then
			return data[req][sub]
		end
	end
	
	timer.Simple(1, function()
		local partsTbl = { --it's structured like this because that's how attribs are
			["Torso"] = {
				name = "Torso",
			},
			["Head"] = {
				name = "Head",
			},
			["Left Arm"] = {
				name = "Left Arm",
			},
			["Right Arm"] = {
				name = "Right Arm",
			},
			["Left Leg"] = {
				name = "Left Leg",
			},
			["Right Leg"] = {
				name = "Right Leg",
			},
		}
	
		local menuGenerate = {
			["nut_customE"] = {
				["dmg"] = {weight = 1, name = "Base Damage", value = dataTemp, panelT = "DNumberWang"},
				["dmgT"] = {weight = 2, name = "Damage Type", value = dataTemp, panelT = "DComboBox", extra = nut.plugin.list["combat"].dmgTypes},
				["armor"] = {weight = 3, name = "Armor", value = dataTemp, panelT = "DNumberWang"},
				["weight"] = {weight = 4, name = "Weight", value = dataTemp, panelT = "DNumberWang"},
				--["evasion"] = {weight = 5, name = "Evasion", value = dataTemp, panelT = "DNumberWang"},
				--["accuracy"] = {weight = 6, name = "Accuracy", value = dataTemp, panelT = "DNumberWang"},
				["critC"] = {weight = 5, name = "Crit Chance", value = dataTemp, panelT = "DNumberWang"},
				["critM"] = {weight = 6, name = "Crit Multiplier", value = dataTemp, panelT = "DNumberWang"},
				["magSize"] = {weight = 7, name = "Magazine Size", value = dataTemp, panelT = "DNumberWang"},
				--["currentMag"] = {weight = 8, name = "Current Ammo", value = dataTemp, panelT = "DNumberWang"},
				--["jamC"] = {weight = 9, name = "Jam Chance", value = dataTemp, panelT = "DNumberWang"},
				--["psy"] = {weight = 10, name = "Cyberpsychosis Chance", value = dataTemp, panelT = "DNumberWang"},
				["dura"] = {weight = 10, name = "Durability (Current)", value = dataTemp, panelT = "DNumberWang"},
				["duraMax"] = {weight = 10, name = "Durability (Max)", value = dataTemp, panelT = "DNumberWang"},
				["scale"] = {weight = 11, name = "Grade Scaling", value = dataTempTbl, panelT = "DNumberWang", test = true, extra =  nut.attribs.list},
			},
			["nut_customI"] = {
				["prefix"] = {weight = 1, name = "Crafting Prefix", value = dataTemp, panelT = "DTextEntry"},
				["dmg"] = {weight = 2, name = "Damage (Equipment)", value = dataTemp, panelT = "DNumberWang"},
				["armor"] = {weight = 3, name = "Armor", value = dataTemp, panelT = "DNumberWang"},
				["weight"] = {weight = 4, name = "Weight (Equipment)", value = dataTemp, panelT = "DNumberWang"},
				--["magic"] = {weight = 5, name = "Magic Grade", value = dataTemp, panelT = "DNumberWang"},
				["evasion"] = {weight = 6, name = "Evasion (Consumables)", value = dataTemp, panelT = "DNumberWang"},
				["accuracy"] = {weight = 7, name = "Accuracy (Consumables)", value = dataTemp, panelT = "DNumberWang"},
				--["critC"] = {weight = 8, name = "Crit Chance (Consumables)", value = dataTemp, panelT = "DNumberWang"},
				--["critM"] = {weight = 9, name = "Crit Multiplier (Consumables)", value = dataTemp, panelT = "DNumberWang"},
				["hpMax"] = {weight = 10, name = "Max Health (Consumables)", value = dataTemp, panelT = "DNumberWang"},
				--["mpMax"] = {weight = 11, name = "Max Mana (Consumables)", value = dataTemp, panelT = "DNumberWang"},
				["hp"] = {weight = 12, name = "Health Restore (Consumables)", value = dataTemp, panelT = "DNumberWang"},
				--["mp"] = {weight = 13, name = "Mana Restore (Consumables)", value = dataTemp, panelT = "DNumberWang"},
			},
		}

		for k, v in pairs(menuGenerate) do
			netstream.Hook(k, function(data)
				local item = data
				
				local frame = vgui.Create("DFrame")
				frame:SetSize(450, 600)
				frame:Center()
				frame:SetTitle("Stats")
				frame:MakePopup()
				frame:ShowCloseButton(true)

				local scroll = vgui.Create("DScrollPanel", frame)
				scroll:Dock(FILL)
				
				local configF = {}
				for name, field in SortedPairsByMemberValue(v, "weight") do
					if(!field.test) then
						local label = vgui.Create("DLabel", scroll)
						label:SetText(field.name)
						label:Dock(TOP)

						local entry = vgui.Create(field.panelT, scroll)
						entry:SetText(field.value(data, name) or "")
						entry:Dock(TOP)
						
						if(field.panelT == "DComboBox") then
							for choice, _ in pairs(field.extra) do
								entry:AddChoice(choice)
							end
						end
						
						configF[name] = entry
					else
						local label = vgui.Create("DLabel", scroll)
						label:SetText(field.name)
						label:Dock(TOP)

						local subTbl = {}
						
						for subKey, subValue in pairs(field.extra) do
							local subLabel = vgui.Create("DLabel", scroll)
							subLabel:SetText(subValue.name)
							subLabel:Dock(TOP)

							local entry = vgui.Create(field.panelT, scroll)
							entry:SetText(field.value(data, name, subKey) or "")
							entry:Dock(TOP)
							
							subTbl[subKey] = entry
						end
						
						configF[name] = subTbl
					end
				end

				local finishB = vgui.Create("DButton", scroll)
				finishB:SetSize(60,20)
				finishB:SetText("Complete")
				finishB:Dock(TOP)
				finishB.DoClick = function()
					local customData = {}
					customData[1] = item.id
					customData[2] = {}
					
					for configK, configV in pairs(configF) do
						if(istable(configV)) then
							local subTbl = {}
							for k2, v2 in pairs(configV) do
								local value = (v2.GetValue and v2:GetValue()) or (v2.GetText and v2:GetText())
								if(value and tonumber(value) != 0 and value != "") then
									subTbl[k2] = value
								else
									subTbl[k2] = 0
								end
							end
							
							if(!table.IsEmpty(subTbl)) then
								customData[2][configK] = subTbl
							end
						else
							local value = (configV.GetValue and configV:GetValue()) or (configV.GetText and configV:GetText())
							if(value and tonumber(value) != 0 and value != "") then
								customData[2][configK] = value
							else
								customData[2][configK] = 0
							end
						end
					end
					
					netstream.Start("nut_equipF", customData)
					
					frame:Remove()
				end
				
				local cancelB = vgui.Create("DButton", scroll)
				cancelB:SetSize(60,20)
				cancelB:SetText("Cancel")
				cancelB:Dock(TOP)
				cancelB.DoClick = function()
					frame:Remove()
				end
			end)
		end
	end)
end