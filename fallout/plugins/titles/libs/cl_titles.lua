local PLUGIN = PLUGIN

function PLUGIN:DrawCharInfo(client, character, info)
	if (client:getNetVar("title")) then
		if(LocalPlayer():getChar():doesRecognize(character:getID())) then
			local titleCol = client:getNetVar("title").color or Color(255,100,70)
			
			titleCol = Color(titleCol.r, titleCol.g, titleCol.b)
		
			info[#info + 1] = {client:getNetVar("title").name, titleCol}
		end
	end
end

--displays the title on the character
function PLUGIN:CreateCharInfoText(panel, suppress)
	local char = LocalPlayer():getChar()
	if(!char) then return end

	local title = LocalPlayer():getNetVar("title", {}).name
	local titles = LocalPlayer():getNetVar("titles")
	
	if(titles and !table.IsEmpty(titles)) then
		panel.titleL = panel.info:Add("DLabel")
		panel.titleL:Dock(TOP)
		panel.titleL:SetFont("nutMediumFont")
		panel.titleL:SetText("Titles")
		panel.titleL:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		panel.titleL:DockMargin(0, 10, 0, 0)			
		
		panel.titles = panel.info:Add("DComboBox")
		panel.titles:Dock(TOP)
		panel.titles:SetFont("nutMediumFont")
		panel.titles:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		panel.titles:DockMargin(0, 10, 0, 0)
		panel.titles:SetTextColor(Color(0,0,0))
		panel.titles:SetText(title or "No Title")
		
		local temp = {}
		if(title) then
			temp[title] = true
			panel.titles:AddChoice("No Title")
			panel.titles:AddChoice(title or "")
		end
		
		for k, v in pairs(titles) do
			if(v == title) then continue end
			if(temp[v]) then continue end --prevents duplicates
			
			panel.titles:AddChoice(v)
			temp[v] = true
		end
		
		panel.titles.OnSelect = function(index, value, data)
			local select = {}
			select.title = panel.titles:GetText()
			
			netstream.Start("nut_titleSelect", select)
		end
	end
end

local function dataTemp(data, req)
	return data[req]
end	

local function dataTempTbl(data, req, sub)
	if(data[req]) then
		return data[req][sub]
	end
end

local function dataTempCol(data, req, sub)
	if(data[req]) then
		return Color(data[req].r, data[req].g, data[req].b)
	end
end

timer.Simple(1, function()
	local menuGenerate = {
		["nutT_create"] = {
			["name"] = {weight = 1, name = "Title Name", value = dataTemp, panelT = "DTextEntry"},
			["desc"] = {weight = 2, name = "Title Description", value = dataTemp, panelT = "DTextEntry"},
			["color"] = {weight = 3, name = "Color", value = dataTempCol, panelT = "DColorMixer", test = true},
			["attribs"] = {weight = 4, name = "Attributes", value = dataTempTbl, panelT = "DNumberWang", test = true, extra = nut.attribs.list},
			--["data"] = {weight = 5, name = "Weight", value = dataTemp, panelT = "DTextEntry"},
		}
	}

	for k, v in pairs(menuGenerate) do
		netstream.Hook(k, function(data)
			local frame = vgui.Create("DFrame")
			frame:SetSize(450, 600)
			frame:Center()
			frame:SetTitle("Title Creation")
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
				elseif(field.panelT == "DColorMixer") then
					local label = vgui.Create("DLabel", scroll)
					label:SetText(field.name)
					label:Dock(TOP)

					local entry = vgui.Create(field.panelT, scroll)
					entry:SetColor(field.value(data, name) or Color(0,0,0))
					entry:Dock(TOP)
					
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
				
				for configK, configV in pairs(configF) do
					if(istable(configV)) then
						local subTbl = {}
						for k2, v2 in pairs(configV) do
							local value = (v2.GetColor and v2:GetColor()) or (v2.GetValue and v2:GetValue()) or (v2.GetText and v2:GetText())
							if(value and value != "" and tonumber(value) != 0) then
								subTbl[k2] = value
							else
								subTbl[k2] = nil
							end
						end
						
						if(!table.IsEmpty(subTbl)) then
							customData[configK] = subTbl
						end
					else
						local value = (configV.GetColor and configV:GetColor()) or (configV.GetValue and configV:GetValue()) or (configV.GetText and configV:GetText())
						if(value and value != "" and tonumber(value) != 0) then
							customData[configK] = value
						else
							customData[configK] = nil
						end
					end
				end
				
				if(!data.edit) then
					netstream.Start("nutT_fin", customData)
				else
					customData.id = data.id
					netstream.Start("nutT_edit", customData)
				end
				
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

local function menuTitleDetails(panel, title)
	local frame = vgui.Create("DFrame")
	frame:SetSize(300, 600)
	frame:Center()
	frame:SetTitle("Titles")
	frame:MakePopup()
	frame:ShowCloseButton(true)
	frame:MoveRightOf(panel, 324)
	
	local scroll = vgui.Create("DScrollPanel", frame)
	scroll:Dock(FILL)
	
	for k, v in pairs(title) do
		local label = vgui.Create("DLabel", scroll)
		label:SetText(string.sub(k, 2).. ": " ..v)
		label:Dock(TOP)
	end
	
	local button = vgui.Create("DButton", scroll)
	button:SetText("Add to Player")
	button:Dock(TOP)
	
	button:SetTextColor(Color(255,255,255,255))
	button.Paint = function(panel, w, h)
		surface.SetDrawColor(Color(70, 80, 100, 220))
		surface.DrawRect(0, 0, w, h)
	end		
	
	button.DoClick = function()
		local data = {}
		data.id = title._id
		
		netstream.Start("nutT_give", data)
		frame:Remove()
	end
	
	local button = vgui.Create("DButton", scroll)
	button:SetText("Edit Title")
	button:Dock(TOP)
	
	button:SetTextColor(Color(255,255,255,255))
	button.Paint = function(panel, w, h)
		surface.SetDrawColor(Color(70, 80, 100, 220))
		surface.DrawRect(0, 0, w, h)
	end
	
	button.DoClick = function()
		local data = {}
		data.id = title._id
		
		netstream.Start("nutT_editstart", data)
		frame:Remove()
	end		
	
	local delButton = vgui.Create("DButton", scroll)
	delButton:SetText("Delete Title")
	delButton:Dock(TOP)
	
	delButton:SetTextColor(Color(255,255,255,255))
	delButton.Paint = function(panel, w, h)
		surface.SetDrawColor(Color(70, 80, 100, 220))
		surface.DrawRect(0, 0, w, h)
	end
	
	delButton.DoClick = function()
		netstream.Start("nutT_delete", title._id)
		frame:Remove()
	end		
end

local function menuAddTitle(scroll, title)
	if(!title._name) then return end

	local titleName = vgui.Create("DButton", scroll)
	titleName:SetText(title._name)
	titleName:SetTooltip(title._desc)
	titleName:Dock(TOP)
	titleName:SetHeight(32)
	
	titleName.DoClick = function()
		menuTitleDetails(scroll, title)
	end
	
	titleName:SetTextColor(Color(255,255,255,255))
	titleName.Paint = function(panel, w, h)
		surface.SetDrawColor(Color(70, 80, 100, 220))
		surface.DrawRect(0, 4, w, h-8)
	end
end

netstream.Hook("nutT_menu", function(data)
	local frame = vgui.Create("DFrame")
	frame:SetSize(450, 600)
	frame:Center()
	frame:SetTitle("Titles")
	frame:MakePopup()
	frame:ShowCloseButton(true)

	local scroll = vgui.Create("DScrollPanel", frame)
	scroll:Dock(FILL)
	
	for k, v in pairs(data) do
		menuAddTitle(scroll, v)
	end
end)