-- Compatibility with the multichar charmenu plugin.

local PANEL = {}

-- How many clicks should be simulated if the add/subtract button is held down.
local AUTO_CLICK_TIME = 0.1

function PANEL:Init()
	self.title = self:addLabel("SKILLS")
	self.leftLabel = self:addLabel("points left")
	self.leftLabel:SetFont("nutCharSubTitleFont")

	self.specialSkills = self:getSpecialSkills()

	self.max = nut.config.get("maxSkills", 20)

	self.total = hook.Run(
		"GetStartSkillPoints",
		LocalPlayer(),
		self:getContext()
	) or nut.config.get("charCreateSkills", 25)
	self.skills = {}

	for k, v in SortedPairsByMemberValue(nut.skills.list, "name") do
		if (v.noStartBonus) then
			continue
		end
		self.skills[k] = self:addSkill(k, v)
	end

	--self:setContext("ptSkill", self.max)
end

function PANEL:updatePointsLeft()
	self.leftLabel:SetText(L("points left"):upper()..": "..self.left)
end

function PANEL:getSpecialSkills()
	local bonusTbl = {}
	
	local attribs = nut.gui.charCreate.context["attribs"]
	if(attribs) then
		local specialSkills = {}
	
		for attribID, attribAmt in pairs(attribs) do
			local attrib = nut.attribs.list[attribID]
			if(attrib) then
				local skillBonus = attrib.skillBonus and attrib.skillBonus[attribID]

				if(skillBonus) then
					specialSkills[attribID] = (specialSkills[attribID] or 0) + skillBonus*attribAmt
				end
			end
		end
		
		for skillID, skill in pairs(nut.skills.list) do
			if(skill.specialBonus) then
				for attribID, attribMult in pairs(skill.specialBonus) do
					local bonus = specialSkills[attribID] or 0
				
					bonusTbl[skillID] = (bonusTbl[skillID] or 0) + attribMult*bonus
				end
			end
		end
	end
	
	return bonusTbl
end

function PANEL:onDisplay()
	local skills = self:getContext("skills", {})
	local sum = 0
	for _, quantity in pairs(skills) do
		sum = sum + quantity
	end
	self.left = math.max(self.total - sum, 0)
	self:updatePointsLeft()

	self.specialSkills = self:getSpecialSkills()
	
	for key, row in pairs(self.skills) do
		row.points = skills[key] or 0
		row.bonus = self.specialSkills[key] or 0
		row:updateQuantity()
	end

	self:setContext("ptSkill", self.left)
end

function PANEL:addSkill(key, skill)
	local row = self:Add("nutCharacterSkillsRow")
	row:setSkill(key, skill, self.specialSkills[key])
	row.parent = self
	return row
end

function PANEL:onPointChange(key, delta)
	if (not key) then return 0 end
	local skills = self:getContext("skills", {})
	local quantity = skills[key] or 0
	local newQuantity = quantity + delta
	local newPointsLeft = self.left - delta
	if (
		newPointsLeft < 0 or newPointsLeft > self.total or
		newQuantity < 0 or newQuantity > self.max
	) then
		return quantity
	end

	self.left = newPointsLeft
	self:updatePointsLeft()

	skills[key] = newQuantity
	self:setContext("skills", skills)
	self:setContext("ptSkill", self.left)
	return newQuantity
end

vgui.Register("nutCharacterSkills", PANEL, "nutCharacterCreateStep")

-- Child attribute "slider" component.
PANEL = {}

function PANEL:Init()
	self:Dock(TOP)
	self:DockMargin(0, 0, 0, 4)
	self:SetTall(36)
	self:SetDrawBackground(false)

	self.buttons = self:Add("DPanel")
	self.buttons:Dock(RIGHT)
	self.buttons:SetWide(128)
	self.buttons:SetDrawBackground(false)

	self.add = self:addButton("+", 1)
	self.add:Dock(RIGHT)

	self.sub = self:addButton("-", -1)
	self.sub:Dock(LEFT)

	self.quantity = self.buttons:Add("DLabel")
	self.quantity:SetFont("nutCharSubTitleFont")
	self.quantity:SetTextColor(color_white)
	self.quantity:Dock(FILL)
	self.quantity:SetText("0")
	self.quantity:SetContentAlignment(5)
	
	self.name = self:Add("DLabel")
	self.name:SetFont("nutCharSubTitleFont")
	self.name:SetContentAlignment(4)
	self.name:SetTextColor(nut.gui.character.WHITE)
	self.name:Dock(FILL)
	self.name:DockMargin(8, 0, 0, 0)
end

function PANEL:setSkill(key, skill, bonus)
	self.key = key
	self.name:SetText(L(skill.name))
	self:SetToolTip(L(skill.desc or "noDesc"))
	self.bonus = bonus
end

function PANEL:delta(delta)
	if (IsValid(self.parent)) then
		local oldPoints = self.points
		self.points = self.parent:onPointChange(self.key, delta)
		self:updateQuantity()
		if (oldPoints ~= self.points) then
			LocalPlayer():EmitSound(unpack(SOUND_ATTRIBUTE_BUTTON))
		end
	end
end

function PANEL:addButton(symbol, delta)
	local button = self.buttons:Add("nutCharButton")
	button:SetFont("nutCharSubTitleFont")
	button:SetWide(32)
	button:SetText(symbol)
	button:SetContentAlignment(5)
	button.OnMousePressed = function(button)
		self.autoDelta = delta
		self.nextAuto = CurTime() + AUTO_CLICK_TIME
		self:delta(delta)
	end
	button.OnMouseReleased = function(button)
		self.autoDelta = nil
	end
	button.OnCursorExited = function(button)
		self.autoDelta = nil
	end
	button:SetDrawBackground(false)
	return button
end

function PANEL:Think()
	local curTime = CurTime()
	if (self.autoDelta and (self.nextAuto or 0) < curTime) then
		self.nextAuto = CurTime() + AUTO_CLICK_TIME
		self:delta(self.autoDelta)
	end
end

function PANEL:updateQuantity()
	local text = self.points
	
	if(self.bonus and self.bonus >= 1) then
		text = text.. "+" ..math.floor(self.bonus)
	end

	self.quantity:SetText(text)
end

function PANEL:Paint(w, h)
	nut.util.drawBlur(self)
	surface.SetDrawColor(0, 0, 0, 100)
	surface.DrawRect(0, 0, w, h)
end

vgui.Register("nutCharacterSkillsRow", PANEL, "DPanel")
