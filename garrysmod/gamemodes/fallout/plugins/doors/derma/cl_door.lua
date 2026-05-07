local PANEL = {}
	function PANEL:Init()
		self:SetSize(280, 240)
		self:SetTitle(L"doorSettings")
		self:Center()
		self:MakePopup()

		self.access = self:Add("DListView")
		self.access:Dock(FILL)
		self.access:AddColumn(L"name").Header:SetTextColor(Color(25, 25, 25))
		self.access:AddColumn(L"access").Header:SetTextColor(Color(25, 25, 25))
		self.access.OnClickLine = function(this, line, selected)
			if (IsValid(line.player)) then
				local menu = DermaMenu()
					menu:AddOption(L"tenant", function()
						if (self.accessData[line.player] != DOOR_TENANT) then
							netstream.Start("doorPerm", self.door, line.player, DOOR_TENANT)
						end
					end):SetImage("icon16/user_add.png")
					menu:AddOption(L"guest", function()
						if (self.accessData[line.player] != DOOR_GUEST) then
							netstream.Start("doorPerm", self.door, line.player, DOOR_GUEST)
						end
					end):SetImage("icon16/user_green.png")
					menu:AddOption(L"none", function()
						if (self.accessData[line.player] != DOOR_NONE) then
							netstream.Start("doorPerm", self.door, line.player, DOOR_NONE)
						end
					end):SetImage("icon16/user_red.png")
				menu:Open()
			end
		end
	end

	function PANEL:setDoor(door, access, door2)
		door.nutPanel = self

		self.accessData = access
		self.door = door

		local entity = IsValid(door2) and door2 or door
		local ownerTbl = entity:getNetVar("permaOwner", {})
		
		for k, v in ipairs(player.GetAll()) do
			if (v != LocalPlayer() and v:getChar()) then
				self.access:AddLine(v:Name(), L(ACCESS_LABELS[access[v] or 0])).player = v
			end
		end

		if (self:checkAccess(DOOR_OWNER, entity)) then
			local dailyCost = entity:getNetVar("dailyCost", nut.config.get("doorCost", 10))
		
			if(dailyCost) then
				self.buy = self:Add("DButton")
				self.buy:Dock(BOTTOM)
				self.buy:SetText("Extend Ownership")
				
				local tooltip = "Cost Per Day: " ..dailyCost
				if(ownerTbl.day and ownerTbl.dur and ownerTbl.dur != -1) then
					tooltip = tooltip.. "\nYou own this for " ..ownerTbl.dur.. " more days."
				elseif(ownerTbl.day and ownerTbl.dur and ownerTbl.dur == -1) then
					tooltip = tooltip.. "\nYou have permanent ownership of this door."
				end

				self.buy:SetToolTip(tooltip)
				
				self.buy:SetTextColor(color_white)
				self.buy:DockMargin(0, 5, 0, 0)
				self.buy.DoClick = function(this)
					Derma_StringRequest("Extend Ownership?", "How many days do you wish to extend? You own it for " ..(ownerTbl.dur or 0).. " days.", "1", function(text)
						self:Remove()
						nut.command.send("doorextendowner", tonumber(text))
					end)
				end
			end
			
			self.sell = self:Add("DButton")
			self.sell:Dock(BOTTOM)
			self.sell:SetText(L"sell")
			self.sell:SetTextColor(color_white)
			self.sell:DockMargin(0, 5, 0, 0)
			self.sell.DoClick = function(this)
				self:Remove()
				nut.command.send("doorsell")
			end
		end

		if (self:checkAccess(DOOR_TENANT, entity)) then
			self.name = self:Add("DTextEntry")
			self.name:Dock(TOP)
			self.name:DockMargin(0, 0, 0, 5)
			self.name.Think = function(this)
				if (!this:IsEditing()) then
					
					self.name:SetText(ownerTbl.doorName or entity:getNetVar("title", L"dTitleOwned"))
				end
			end
			self.name.OnEnter = function(this)
				nut.command.send("doorsettitle", this:GetText())
			end
		end
	end

	function PANEL:checkAccess(access, entity)
		access = access or DOOR_GUEST

		local ownerTbl = entity:getNetVar("permaOwner", {})
		if(ownerTbl.charID and ownerTbl.charID == LocalPlayer():getChar():getID()) then
			return true
		end

		local accessData = self.accessData or {}
		if ((accessData[LocalPlayer()] or 0) >= access) then
			return true
		end

		return false
	end

	function PANEL:Think()
		if (self.accessData and !IsValid(self.door) and self:checkAccess()) then
			self:Remove()
		end
	end
vgui.Register("nutDoorMenu", PANEL, "DFrame")