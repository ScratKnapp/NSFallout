local PANEL = {}
function PANEL:Init()
	self.title = self:addLabel("Select Languages")
	self.subtitle = self:Add("DLabel")
	self.subtitle:SetFont("nutCharSmallButtonFont")
	self.subtitle:SetText("The lands of the Legion are diverse in origin, with many languages spoken...")
	self.subtitle:SizeToContents()
	self.subtitle:SetWrap(true)
	self.subtitle:SetAutoStretchVertical(true)
	self.subtitle:Dock(TOP)
	self.languages = self:Add("DScrollPanel")
	self.languages:Dock(FILL)
	self.languages:SetPaintBackground(false)
end

function PANEL:onDisplay()
	if not LANGUAGES or not LANGUAGES.languages then return end
	local oldChildren = self.languages:GetChildren()
	local total = total or 0
	local maximum = nut.config.get("maxLanguages", 2) or hook.Run("GetStartLanguagePoints", LocalPlayer(), panel.payload)
	local languages = {}
	local langCount = table.Count(LANGUAGES.languages)
	local barSize = (ScrH() * 0.5) / langCount
	for k, v in SortedPairsByMemberValue(LANGUAGES.languages, "category") do
		if v.ignore then continue end
		local bar = self:Add("nutAttribBar")
		bar:SetTooltip(v.desc)
		bar:setMax(1)
		bar:SetTall(barSize)
		bar:Dock(TOP)
		bar:DockMargin(2, 2, 2, 2)
		bar:setText(L(v.name))
		bar.label:SetFont("nutCharSmallButtonFont")
		bar.add:Remove()
		bar.sub:Remove()
		bar.onChanged = function(this, difference)
			if total + difference > maximum then return false end
			total = total + difference
			if languages[k] then
				languages[k] = nil
			else
				languages[k] = 1
			end

			self:setContext("languages", languages)
		end

		bar.bar.OnMousePressed = function(this)
			if bar.value == 0 then
				bar.pressing = 1
				bar:doChange()
			else
				bar.pressing = -1
				bar:doChange()
			end
		end

		bar.bar.OnMouseReleased = function() if bar.pressing then bar.pressing = nil end end
	end
end

vgui.Register("nutCharLanguages", PANEL, "nutCharacterCreateStep")