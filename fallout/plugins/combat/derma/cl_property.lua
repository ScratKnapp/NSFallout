local PLUGIN = PLUGIN

if(CLIENT) then
	local PANEL = {}

	function PANEL:Init()
		local client = LocalPlayer()
		local char = client:getChar()
	
		nut.gui.property = self

		self:SetSize(self:GetParent():GetSize())
		
		local props = char:getData("props", {})
		
		if(table.IsEmpty(props)) then
			self.error = self:Add("DLabel")
			self.error:SetFont("nutMenuButtonLightFont")
			self.error:Dock(FILL)
			self.error:SetText("You do not own any properties.")
			self.error:SetTextColor(color_white)
			self.error:SetExpensiveShadow(1, color_black)
			self.error:SizeToContents()
			self.error:SetContentAlignment(5)
			return
		end
	end

	vgui.Register("nutProperty", PANEL, "EditablePanel")

	hook.Add("CreateMenuButtons", "nutProperty", function(tabs)
		tabs["Property"] = function(panel)
			panel:Add("nutProperty")
		end
	end)
end