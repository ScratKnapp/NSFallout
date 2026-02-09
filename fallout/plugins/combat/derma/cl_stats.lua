local PLUGIN = PLUGIN

local PANEL = {}

local statsBackground = Material("fonvui/stats.png")

local MARGINTOP = 80
local MARGINLEFT = 30
local MARGINRIGHT = 30
local MARGINBOT = 30

function PANEL:Init()
	local client = LocalPlayer()
	local char = client:getChar()
	local boost = char:getBoosts()
	local skillBoosts = char:getSkillBoosts()

	nut.gui.status = self

	local sizeX, sizeY = self:GetParent():GetSize()

	self:SetSize(sizeX, sizeY)
	
	self:ExtraPanel()
	
	local inner = self:Add("DPanel")
	inner:Dock(FILL)
	inner:DockMargin(MARGINLEFT,MARGINTOP,MARGINRIGHT,MARGINBOT)
	self.inner = inner
	
	sizeX = sizeX - MARGINLEFT*2
	sizeY = sizeY - MARGINTOP + MARGINBOT

	local special = inner:Add("DScrollPanel")
	special:SetSize(sizeX*0.33, sizeY)
	special:Dock(LEFT)
	special:DockMargin(4,4,4,4)
	special.Paint = function(self, w, h)
		--surface.SetDrawColor(255,0,0)
		--surface.DrawRect(0,0,w,h)
	end
	self.special = special

	local bars = {}
	local levelAttrib = (client.canLevelAttrib and client:canLevelAttrib()) or 0
	
	local attribPoints = special:Add("DLabel")
	attribPoints:SetSize(0, 40)
	attribPoints:Dock(TOP)
	attribPoints:DockMargin(0, 0, 0, 16)
	attribPoints:SetText("")
	attribPoints.Paint = function(self, w, h)
		--surface.SetDrawColor(0,47,0)
		--surface.DrawOutlinedRect(0,0,w,h,2)
		
		surface.SetFont("nutMediumFont")
		
		local pointsMsg = "SPECIAL Points: " ..levelAttrib
		
		local textSizeX, textSizeY = surface.GetTextSize(pointsMsg)
		
		surface.SetTextPos(w*0.5 - textSizeX*0.5, 0)--h*0.5 - textSizeY*0.5)
		surface.SetTextColor(0,238,0)
		surface.DrawText(pointsMsg)
	end
	
	for k, v in SortedPairsByMemberValue(nut.attribs.list, "name") do
		local attribBoost = 0
		if (boost[k]) then
			for _, bValue in pairs(boost[k]) do
				attribBoost = attribBoost + bValue
			end
		end

		local bar = special:Add("nutAttribBar")
		bar:Dock(TOP)
		bar:DockMargin(0, 0, 0, 3)
		bar:SetTooltip(v.desc)

		local attribValue = char:getAttrib(k, 0)
		if (attribBoost) then
			bar:setValue(attribValue - attribBoost or 0)
		else
			bar:setValue(attribValue)
		end

		local maximum = v.maxValue or nut.config.get("maxAttribs", 10)
		bar:setMax(maximum)
		
		if (levelAttrib < 1) then
			bar:setReadOnly()
		else
			bar.sub:Remove()
			bar.levelup = true
			bar.attrib = k

			bar.doChange = function()
				if ((bar.value == 0 and bar.pressing == -1) or (bar.value >= bar.max and bar.pressing == 1)) then
					return
				end
				
				bar.nextPress = CurTime() + 0.2
				
				if (bar:onChanged(bar.pressing) != false) then
					bar.value = math.Clamp(bar.value + bar.pressing, 0, bar.max)
				end
				
				if(bar.levelup) then
					if(NUT_CVAR_LVLCONFIRM:GetBool()) then
						Derma_Query("Increase " ..v.name.. "?", "Confirmation", "Yes", function()
							netstream.Start("statIncrease", bar.attrib, bar.value)
							levelAttrib = levelAttrib - 1
							
							if(levelAttrib < 1) then
								for k, v in pairs(bars) do
									v.pressing = false
									v.add:Remove()
								end
							end
							
							bar:setValue(bar.value)
							
							bar:setText(
								Format(
									"%s [%.1f/%.1f]",
									L(v.name),
									bar.value,
									maximum
								)
							)
						end, "No", function()
							bar.value = bar.value - 1
						end)
					else
						netstream.Start("statIncrease", bar.attrib, bar.value)
						levelAttrib = levelAttrib - 1
						
						if(levelAttrib < 1) then
							for k, v in pairs(bars) do
								v.pressing = false
								v.add:Remove()
							end
						end
						
						bar:setValue(bar.value)
						
						bar:setText(
							Format(
								"%s [%.1f/%.1f]",
								L(v.name),
								bar.value,
								maximum
							)
						)
					end
					
					timer.Simple(0, function()
						self:UpdateSkills()
					end)
				end
			end
		end
		
		bar:setText(
			Format(
				"%s [%.1f/%.1f]",
				L(v.name),
				attribValue,
				maximum
			)
		)

		if (attribBoost) then
			bar:setBoost(attribBoost)
		end
		
		table.insert(bars, bar)
	end
	
	local skills = inner:Add("DScrollPanel")
	skills:SetSize(sizeX*0.33, sizeY)
	skills:Dock(LEFT)
	skills:DockMargin(4,4,4,4)
	skills.Paint = function(self, w, h)
		--surface.SetDrawColor(0,255,0)
		--surface.DrawRect(0,0,w,h)
	end
	self.skills = skills
	
	local skillBars = {}
	local levelSkill = (client.canLevelSkill and client:canLevelSkill()) or 0
	
	local skillPoints = skills:Add("DLabel")
	skillPoints:SetSize(0, 40)
	skillPoints:Dock(TOP)
	skillPoints:DockMargin(0, 0, 0, 3)
	skillPoints:SetText("")
	skillPoints.Paint = function(self, w, h)
		--surface.SetDrawColor(255,0,0)
		--surface.DrawRect(0,0,w,h)
		
		surface.SetFont("nutMediumFont")
		
		local pointsMsg = "Skill Points: " ..levelSkill
		
		local textSizeX, textSizeY = surface.GetTextSize(pointsMsg)
		
		surface.SetTextPos(w*0.5 - textSizeX*0.5, 0)--h*0.5 - textSizeY*0.5)
		surface.SetTextColor(0,238,0)
		surface.DrawText(pointsMsg)
	end
	
	for k, v in SortedPairsByMemberValue(nut.skills.list, "name") do
		local skillBoost = 0
		if (skillBoosts[k]) then
			for _, bValue in pairs(skillBoosts[k]) do
				skillBoost = skillBoost + bValue
			end
		end

		local bar = skills:Add("nutSkillBar")
		bar:Dock(TOP)
		bar:DockMargin(0, 0, 0, 3)
		bar:SetTooltip(v.desc)

		local skillValue = char:getSkill(k, 0)
		if (skillBoost) then
			bar:setValue(skillValue - skillBoost or 0)
		else
			bar:setValue(skillValue)
		end

		local maximum = v.maxValue or nut.config.get("maxSkills", 30)
		bar:setMax(maximum)
		
		if (levelSkill < 1) then
			bar:setReadOnly()
		else
			bar.sub:Remove()
			bar.levelup = true
			bar.skill = k
			
			bar.doChange = function()
				if ((bar.value == 0 and bar.pressing == -1) or (bar.value >= bar.max and bar.pressing == 1)) then
					return
				end
				
				bar.nextPress = CurTime() + 0.2
				
				if (bar:onChanged(bar.pressing) != false) then
					bar.value = math.Clamp(bar.value + bar.pressing, 0, bar.max)
				end
				
				if(bar.levelup) then
					if(NUT_CVAR_LVLCONFIRM:GetBool()) then
						Derma_Query("Increase " ..v.name.. "?", "Confirmation", "Yes", function()
							netstream.Start("skillIncrease", bar.skill, 1)
							levelSkill = levelSkill - 1

							if(levelSkill < 1) then
								for k, v in pairs(skillBars) do
									v.pressing = false
									v.add:Remove()
								end
							end
							
							bar:setValue(bar.value)
							
							bar:setText(
								Format(
									"%s [%.1f/%.1f]",
									L(v.name),
									bar.value,
									maximum
								)
							)
						end, "No", function()
							bar.value = bar.value - 1
						end)
					else
						netstream.Start("skillIncrease", bar.skill, 1)
						levelSkill = levelSkill - 1

						if(levelSkill < 1) then
							for k, v in pairs(skillBars) do
								v.pressing = false
								v.add:Remove()
							end
						end
						
						bar:setValue(bar.value)
						
						bar:setText(
							Format(
								"%s [%.1f/%.1f]",
								L(v.name),
								bar.value,
								maximum
							)
						)
					end
				end
			end
		end
		
		bar:setText(
			Format(
				"%s [%.1f/%.1f]",
				L(v.name),
				skillValue,
				maximum
			)
		)

		if (skillBoost) then
			bar:setBoost(skillBoost)
		end
		
		table.insert(skillBars, bar)
	end
	self.skillBars = skillBars
	
	local perks = inner:Add("DScrollPanel")
	perks:SetSize(sizeX*0.32, sizeY)
	perks:Dock(LEFT)
	perks:DockMargin(4,4,4,4)
	perks.Paint = function(self, w, h)
		--surface.SetDrawColor(0,0,255)
		--surface.DrawRect(0,0,w,h)
	end
	self.perks = perks

	local levelPerk = (client.canLevelPerk and client:canLevelPerk()) or 0
	
	local perkPoints = perks:Add("DLabel")
	perkPoints:SetSize(0, 40)
	perkPoints:Dock(TOP)
	perkPoints:DockMargin(0, 0, 0, 3)
	perkPoints:SetText("")
	perkPoints.Paint = function(self, w, h)
		--surface.SetDrawColor(255,0,0)
		--surface.DrawRect(0,0,w,h)
		
		surface.SetFont("nutMediumFont")
		
		local pointsMsg = "Perk Points: " ..levelPerk
		
		local textSizeX, textSizeY = surface.GetTextSize(pointsMsg)
		
		surface.SetTextPos(w*0.5 - textSizeX*0.5, 0)--h*0.5 - textSizeY*0.5)
		surface.SetTextColor(0,238,0)
		surface.DrawText(pointsMsg)
	end

	for k, v in pairs(client:getTraitsData()) do
		local name = v.name
		local desc = v.desc
	
		local perkPanel = perks:Add("DButton")
		perkPanel:SetSize(sizeX*0.33, sizeY*0.1)
		perkPanel:SetText("")
		perkPanel:SetTooltip()
		perkPanel:Dock(TOP)
		perkPanel:DockMargin(2,2,2,2)
		perkPanel.Paint = function(self, w, h)
			surface.SetFont("nutMediumFont")
		
			surface.SetDrawColor(0, 0, 0, 200)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(50, 255, 50)
			surface.DrawOutlinedRect(0, 0, w, h, 2)
			
			local textSizeX, textSizeY = surface.GetTextSize(name)
			surface.SetTextColor(50, 255, 50)
			surface.SetTextPos(w*0.5-textSizeX*0.5, h*0.5-textSizeY*0.5) 
			surface.DrawText(name)
			
			if(v.icon) then
				if(!v.iconCache) then
					v.iconCache = Material(v.icon)
				end
			
				local ratio = h/160
			
				surface.SetMaterial(v.iconCache or "")
				surface.SetDrawColor(50, 255, 50)
				surface.DrawTexturedRect(0, 0, 145*ratio, 160*ratio)
			end
		end
		perkPanel.OnCursorEntered = function(button)
			local popup = self:PerkPopup(v, button)
			
			popup:MoveRightOf(self, -ScrW()*0.3)
		end
		perkPanel.OnCursorExited = function(button)
			if(IsValid(self.perkPopup)) then
				self.perkPopup:Remove()
			end
		end
	end
	
	--new perk button
	if (levelPerk > 0) then
		local perkPanel = perks:Add("DButton")
		perkPanel:SetSize(sizeX*0.33, sizeY*0.1)
		perkPanel:SetText("")
		perkPanel:SetTooltip("")
		perkPanel:Dock(TOP)
		perkPanel:DockMargin(2,2,2,2)
		perkPanel.Paint = function(self, w, h)
			surface.SetFont("nutMediumFont")

			surface.SetDrawColor(0, 0, 0, 200)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(50, 255, 50)
			surface.DrawOutlinedRect(0, 0, w, h, 2)
			
			local name = "Choose New Perk"
		
			local textSizeX, textSizeY = surface.GetTextSize(name)
			
			surface.SetTextColor(50, 255, 50)
			surface.SetTextPos(w*0.5-textSizeX*0.5, h*0.5-textSizeY*0.5) 
			surface.DrawText(name)
		end
		perkPanel.DoClick = function(panel)
			self:PerkChoose(panel)
		end
		
		self.newPerk = perkPanel
	end
	
	local XPBar = vgui.Create("DPanel")
	XPBar:SetSize(sizeX, ScrH()*0.03)
	XPBar:SetPos(ScrW()*0.5-sizeX*0.5, ScrH()*0.18)
	XPBar:MakePopup()
	XPBar.OnKeyCodePressed = function(this, key)
		if (key == KEY_F1) then
			self:Remove()
	
			if (IsValid(nut.gui.menu)) then
				nut.gui.menu:remove()
			end
		end
	end
	--XPBar:MoveAbove(self, 4)
	XPBar.Paint = function(self, w, h)
		local client = LocalPlayer()
	
		local level = client:getLevel()
		local nextLevel = nut.plugin.list["level"]:getLevelThresh(level)
		local xp = char:getData("xp", 0)
	
		local ratio = math.Clamp(xp / nextLevel, 0, 1)

		local barSize = w*math.Round(ratio, 2)
	
		surface.SetDrawColor(0,47,0,150)
		surface.DrawRect(0,0,w,h)
		
		surface.SetDrawColor(0,238,0,150)
		surface.DrawRect(0,0,barSize,h)
		
		surface.SetDrawColor(0,238,0,150)
		surface.DrawOutlinedRect(0, 0, w, h, 2)
		
		surface.SetFont("nutMediumFont")
			
		local levelText = "Level " ..level.. " (" ..xp.. "/" ..nextLevel.. ")"
	
		local textSizeX, textSizeY = surface.GetTextSize(levelText)
		
		surface.SetTextColor(255,255,255)
		surface.SetTextPos(w*0.5-textSizeX*0.5, h*0.5-textSizeY*0.5) 
		surface.DrawText(levelText)
	end
	self.XPBar = XPBar
	
	local respec = vgui.Create("DButton")
	respec:SetSize(sizeX*0.2, ScrH()*0.03)
	respec:SetPos(ScrW()*0.5-sizeX*0.1, ScrH()*0.215)
	respec:SetText("")
	respec:MakePopup()
	respec.OnKeyCodePressed = function(this, key)
		if (key == KEY_F1) then
			self:Remove()
	
			if (IsValid(nut.gui.menu)) then
				nut.gui.menu:remove()
			end
		end
	end
	--respec:MoveAbove(self, 4)
	respec.Paint = function(self, w, h)
		local client = LocalPlayer()

		surface.SetDrawColor(0,47,0,150)
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(0,238,0,150)
		surface.DrawOutlinedRect(0, 0, w, h, 2)
		
		surface.SetFont("nutMediumFont")
			
		local levelText = "RESPEC"
	
		local textSizeX, textSizeY = surface.GetTextSize(levelText)
		
		surface.SetTextColor(255,255,255)
		surface.SetTextPos(w*0.5-textSizeX*0.5, h*0.5-textSizeY*0.5) 
		surface.DrawText(levelText)
	end
	respec.DoClick = function(panel)
		Derma_Query("Do you want to respec?", "Respec", "Yes", function()
			netstream.Start("nut_respec")
			
			timer.Simple(0, function()
				self:ReopenPanel()
			end)
		end, "No")
	end
	self.respec = respec
end

function PANEL:UpdateSkills()
	local char = LocalPlayer():getChar()
	local skillBoosts = char:getSkillBoosts()

	local skillBars = self.skillBars
	for k, bar in pairs(skillBars) do
		if(!IsValid(bar)) then continue end
		if(!bar.skill) then continue end
		
		local skillTbl = nut.skills.list[bar.skill]
		if(!skillTbl) then continue end
		
		local maximum = skillTbl.maxValue or nut.config.get("maxSkills", 30)
		bar:setMax(maximum)
		
		local skillBoost = 0
		if (skillBoosts[bar.skill]) then
			for _, bValue in pairs(skillBoosts[bar.skill]) do
				skillBoost = skillBoost + bValue
			end
		end

		local skillValue = char:getSkill(bar.skill, 0)
		if (skillBoost) then
			bar:setValue(skillValue - skillBoost or 0)
		else
			bar:setValue(skillValue)
		end
		
		bar:setText(
			Format(
				"%s [%.1f/%.1f]",
				L(skillTbl.name),
				skillValue,
				maximum
			)
		)
	end
end

function PANEL:ExtraPanel()
	if(IsValid(self.extraPanel)) then self.extraPanel:Remove() end

	local client = LocalPlayer()

	local extraPanel = vgui.Create("DPanel")
	extraPanel:SetPos(ScrW()*0.2, ScrH()*0.95)
	extraPanel:SetSize(ScrW()*0.6, ScrH()*0.05)
	--evasion:SetPos(button:GetPos())
	--extraPanel:Center()
	extraPanel:MakePopup()
	--extraPanel:MoveRightOf(self,4)

	local evasion = extraPanel:Add("DPanel")
	evasion:SetSize(ScrW()*0.3, ScrH()*0.05)
	evasion:Dock(LEFT)
	evasion:DockMargin(0,0,0,0)

	evasion.Paint = function(panel, w, h)
		surface.SetDrawColor(0,0,0,150)
		surface.DrawRect(0,0,w,h)
		
		surface.SetDrawColor(50,125,50)
		surface.DrawOutlinedRect(0,0,w,h,2)
		
		surface.SetFont("nutMediumFont")
	
		local name = "Evasion: " ..client:getEvasion()

		local nameSizeX, nameSizeY = surface.GetTextSize(name)
		
		surface.SetTextColor(50, 255, 50)
		surface.SetTextPos(w*0.5-nameSizeX*0.5, nameSizeY*0.5) 
		surface.DrawText(name)
	end
	
	local accuracy = extraPanel:Add("DPanel")
	accuracy:SetSize(ScrW() * 0.3, ScrH() * 0.05)
	accuracy:Dock(RIGHT)
	accuracy:DockMargin(0, 0, 0, 0)
	accuracy.Paint = function(panel, w, h)
		surface.SetDrawColor(0,0,0,150)
		surface.DrawRect(0,0,w,h)
		
		surface.SetDrawColor(50,125,50)
		surface.DrawOutlinedRect(0,0,w,h,2)
	
		surface.SetDrawColor(0,0,0,150)
		surface.SetFont("nutMediumFont")
		
		local equipment = nut.plugin.list["equipment"]:getEquippedItems(client, true)
		--count how many of them actually matter for accuracy
		local count = 0
		for k, item in pairs(equipment) do
			if item:getData("dmg", item.dmg) then count = count + 1 end
		end

		if count > 0 then
			local i = 0
			for k, item in pairs(equipment) do
				if not item:getData("dmg", item.dmg) then continue end
				local name = "Accuracy (" .. item:getName() .. "):" .. client:getAccuracy(item)
				local nameSizeX, nameSizeY = surface.GetTextSize(name)
				local offset = (h / count) * i
				surface.SetTextColor(50, 255, 50)
				surface.SetTextPos(w * 0.5 - nameSizeX * 0.5, offset)
				surface.DrawText(name)
				
				i = i + 1
			end
		else
			surface.SetDrawColor(0,0,0,150)
			surface.DrawRect(0,0,w,h)
			
			surface.SetDrawColor(50,125,50)
			surface.DrawOutlinedRect(0,0,w,h,2)
		
			local name = "Accuracy: " .. client:getAccuracy()
			local nameSizeX, nameSizeY = surface.GetTextSize(name)
			
			surface.SetTextColor(50, 255, 50)
			surface.SetTextPos(w * 0.5 - nameSizeX * 0.5, nameSizeY * 0.5)
			surface.DrawText(name)
		end
	end
	
	self.extraPanel = extraPanel
	
	return extraPanel
end

function PANEL:PerkPopup(perkData, button)
	if(IsValid(self.perkPopup)) then self.perkPopup:Remove() end
	
	local name = perkData.name
	local desc = perkData.desc

	local perkPopup = vgui.Create("DPanel")
	perkPopup:SetSize(ScrW()*0.3, ScrH()*0.3)
	--perkPopup:SetPos(button:GetPos())
	perkPopup:Center()
	perkPopup:MakePopup()
	perkPopup.OnKeyCodePressed = function(this, key)
		if (key == KEY_F1) then
			self:Remove()
			
			if (IsValid(nut.gui.menu)) then
				nut.gui.menu:remove()
			end
		end
	end

	perkPopup.Paint = function(panel, w, h)
		surface.SetDrawColor(0,0,0)
		surface.DrawRect(0,0,w,h)
		
		surface.SetDrawColor(50,125,50)
		surface.DrawOutlinedRect(0,0,w,h,2)
		
		surface.SetFont("nutMediumFont")
		
		--name
		local nameSizeX, nameSizeY = surface.GetTextSize(name)
		
		surface.SetTextColor(50, 255, 50)
		surface.SetTextPos(w*0.5-nameSizeX*0.5, nameSizeY*0.5) 
		surface.DrawText(name)
		
		surface.SetDrawColor(50,125,50)
		surface.DrawOutlinedRect(0,nameSizeY+16,w,2,2)
		
		--description
		local descSizeY, descSizeY = surface.GetTextSize(desc)
		
		local descLines = nut.util.wrapText(
			desc,
			w-32,
			"nutMediumFont"
		)

		local offsetY = 0
		for k, v in pairs(descLines) do
			surface.SetTextColor(50, 255, 50)
			surface.SetTextPos(8, nameSizeY+descSizeY*0.5+16+offsetY) 
			surface.DrawText(v)
			
			offsetY = offsetY + nameSizeY+descSizeY*0.5+8
		end
	end
	
	self.perkPopup = perkPopup
	
	return perkPopup
end

function PANEL:PerkChoose(button)
	if(IsValid(self.perkChoose)) then self.perkChoose:Remove() end
	
	local client = LocalPlayer()

	--so we can exclude them
	local clientPerks = client:getTraitsData()

	local perkChoose = vgui.Create("DFrame")
	perkChoose:SetSize(ScrW()*0.3, ScrH()*0.3)
	perkChoose:Center()
	perkChoose:SetX(ScrW()*0.5)
	perkChoose:SetTitle("")
	--perkPopup:SetPos(button:GetPos())
	perkChoose.Paint = function(self, w, h)
		surface.SetDrawColor(0,0,0)
		surface.DrawRect(0,0,w,h)
	end
	
	perkChoose:MakePopup()
	perkChoose.OnKeyCodePressed = function(this, key)
		if (key == KEY_F1) then
			self:Remove()
			
			if (IsValid(nut.gui.menu)) then
				nut.gui.menu:remove()
			end
		end
	end
	
	local perkScroll = perkChoose:Add("DScrollPanel")
	perkScroll:Dock(FILL)
	perkScroll:DockMargin(0,0,0,0)
	
	local sizeX, sizeY = perkChoose:GetSize()

	local perks = TRAITS.traits
	
	for k, v in pairs(perks) do
		if(v.hidden) then continue end
		if(client:hasTrait(k)) then continue end
	
		local name = v.name
		local desc = v.desc
	
		local perkPanel = perkScroll:Add("DButton")
		perkPanel:SetSize(sizeX*0.33, sizeY*0.1)
		perkPanel:SetText("")
		perkPanel:SetTooltip("")
		perkPanel:Dock(TOP)
		perkPanel:DockMargin(2,2,2,2)
		perkPanel.Paint = function(self, w, h)
			surface.SetFont("nutMediumFont")
		
			local textSizeX, textSizeY = surface.GetTextSize(name)
			
			surface.SetTextColor(50, 255, 50)
			surface.SetTextPos(w*0.5-textSizeX*0.5, h*0.5-textSizeY*0.5) 
			surface.DrawText(name)

			surface.SetDrawColor(50, 255, 50)
			surface.DrawOutlinedRect(0, 0, w, h, 2)
			
			if(v.icon) then
				if(!v.iconCache) then
					v.iconCache = Material(v.icon)
				end
			
				local ratio = h/160
			
				surface.SetMaterial(v.iconCache or "")
				surface.SetDrawColor(50, 255, 50)
				surface.DrawTexturedRect(0, 0, 145*ratio, 160*ratio)
			end
		end
		perkPanel.OnCursorEntered = function(button)
			local popup = self:PerkPopup(v, button)
			
			popup:MoveRightOf(self, -ScrW()*0.4)
		end
		perkPanel.OnCursorExited = function(button)
			if(IsValid(self.perkPopup)) then
				self.perkPopup:Remove()
			end
		end
		perkPanel.DoClick = function(button)
			Derma_Query("Choose " ..v.name.. "?", "Confirmation", "Yes", function()
				if(IsValid(self.newPerk)) then
					self.newPerk:Remove()
				end				
				
				if(IsValid(perkChoose)) then
					perkChoose:Remove()
				end
			
				netstream.Start("perkAdd", v.uid)
				
				timer.Simple(0, function()
					self:ReopenPanel()
				end)
			end, "No", function()
			
			end)
		end
	end
	
	self.perkChoose = perkChoose
end

function PANEL:Paint(w,h)
	surface.SetMaterial(statsBackground)
	surface.SetDrawColor(255,255,255)
	surface.DrawTexturedRect(0,0,w,h)
end

function PANEL:OnRemove()
	if(IsValid(self.inner)) then
		self.inner:Remove()
	end
	
	if(IsValid(self.perkPopup)) then
		self.perkPopup:Remove()
	end
	
	if(IsValid(self.XPBar)) then
		self.XPBar:Remove()
	end
	
	if(IsValid(self.respec)) then
		self.respec:Remove()
	end
	
	if(IsValid(self.extraPanel)) then
		self.extraPanel:Remove()
	end
end

function PANEL:OnKeyCodePressed(key)
	if (key == KEY_F1) then
		self:Remove()
		
		if (IsValid(nut.gui.menu)) then
			nut.gui.menu:remove()
		end
	end
end

function PANEL:ReopenPanel()
	local parent = self:GetParent()
	self:Remove()
	parent:Add("nutStats")
end
vgui.Register("nutStats", PANEL, "EditablePanel")

hook.Add("CreateMenuButtons", "nutStats", function(tabs)
	tabs["Stats"] = function(panel)
		panel:Add("nutStats")
	end
end)