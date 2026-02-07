local PANEL = {}

function PANEL:Init()
	self.title = self:addLabel("HISTORY")
	
	self.history = self:Add("DScrollPanel")
	self.history:Dock(FILL)

	self.history:SetDrawBackground(false)
end

function PANEL:onDisplay()
	if(!HISTORIES or !HISTORIES.histories) then return end

	if(IsValid(self.restrictLabel)) then
		self.restrictLabel:Remove()
	end

	local race = nut.gui.charCreate.context["faction"]

	local historyFactions = nut.plugin.list["history"].factions
	if(race and !historyFactions[race]) then
		if(self.bars) then
			for k, v in pairs(self.bars) do
				v:Remove()
			end
		end
		
		self:setContext("history", nil)
	
		self.restrictLabel = self:addLabel("Your race cannot choose a History.")
		
		return
	else
		if(IsValid(self.restrictLabel)) then
			self.restrictLabel:Remove()
		end
	end

	local oldChildren = self.history:GetChildren()
	
	local total = total or 0
	local maximum = 1
	local history = {}
	
	if(self.bars) then
		for k, v in pairs(self.bars) do
			v:Remove()
		end
	end
	
	self.bars = {}	
	
	for k, v in SortedPairsByMemberValue(HISTORIES.histories, "category") do
		if(v.ignore) then continue end
	
		self.bars[k] = self:Add("nutAttribBar")
		local bar = self.bars[k]
		
		bar:SetToolTip(v.desc)
		bar:setMax(1)
		bar:Dock(TOP)
		bar:DockMargin(2, 2, 2, 2)
		bar:setText(L(v.name))
		
		bar.onChanged = function(this, difference)
			if ((total + difference) > maximum) then
				return false
			end

			total = total + difference
			
			if(history[k]) then
				history[k] = nil
			else
				history[k] = 1
			end
			
			self:setContext("history", history)
		end
		
		bar.bar.OnMousePressed = function(this)
			if(bar.value == 0) then
				bar.pressing = 1
				bar:doChange()
			else
				bar.pressing = -1
				bar:doChange()
			end
		end
		
		bar.bar.OnMouseReleased = function()
			if (bar.pressing) then
				bar.pressing = nil
			end
		end
	end
end

vgui.Register("nutCharHistory", PANEL, "nutCharacterCreateStep")