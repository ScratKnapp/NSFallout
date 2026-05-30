local PLUGIN = PLUGIN
PLUGIN.name = "New Fancy Third Person"
PLUGIN.author = "Evii & Black Tea"
PLUGIN.desc = "Third Person plugin."
nut.config.add("thirdperson", true, "Allow Thirdperson in the server.", nil, {
	category = "server"
})

if CLIENT then
	local d_CYR_CVAR_THIRDPERSON = CreateClientConVar("CYR_tp_enabled", "0", true)
	local d_CYR_CVAR_TP_CLASSIC = CreateClientConVar("CYR_tp_classic", "0", true)
	local d_CYR_CVAR_TP_VERT = CreateClientConVar("CYR_tp_vertical", 10, true)
	local d_CYR_CVAR_TP_HORI = CreateClientConVar("CYR_tp_horizontal", 0, true)
	local d_CYR_CVAR_TP_DIST = CreateClientConVar("CYR_tp_distance", 50, true)
	local d_CYR_CVAR_TP_Sensitivity = CreateClientConVar("CYR_tp_sensitivity", 1, true)
	-- same convars as above but for Nutscript compatibility
	local nutscript_CVAR_THIRDPERSON = CreateClientConVar("nut_thirdperson", "0", true)
	local nutscript_CVAR_TP_CLASSIC = CreateClientConVar("nut_tp_classic", "0", true)
	local nutscript_CVAR_TP_VERT = CreateClientConVar("nut_tp_vertical", 10, true)
	local nutscript_CVAR_TP_HORI = CreateClientConVar("nut_tp_horizontal", 0, true)
	local nutscript_CVAR_TP_DIST = CreateClientConVar("nut_tp_distance", 50, true)
	local nutscript_CVAR_TP_Sensitivity = CreateClientConVar("nut_tp_sensitivity", 1, true)
	-- same convars as above but for ix compatibility
	local ix_CVAR_THIRDPERSON = CreateClientConVar("ix_thirdperson", "0", true)
	local ix_CVAR_TP_CLASSIC = CreateClientConVar("ix_tp_classic", "0", true)
	local ix_CVAR_TP_VERT = CreateClientConVar("ix_tp_vertical", 10, true)
	local ix_CVAR_TP_HORI = CreateClientConVar("ix_tp_horizontal", 0, true)
	local ix_CVAR_TP_DIST = CreateClientConVar("ix_tp_distance", 50, true)
	local ix_CVAR_TP_Sensitivity = CreateClientConVar("ix_tp_sensitivity", 1, true)
	-- convar to determine what convars to use
	local CYR_CVAR_TP_ENABLED = CreateClientConVar("CYR_thirdpersonBindings", "0", true, false, "0 is CYR, 1 is Nutscript, 2 is ix")
	local CYR_CVAR_THIRDPERSON = d_CYR_CVAR_THIRDPERSON
	local CYR_CVAR_TP_CLASSIC = d_CYR_CVAR_TP_CLASSIC
	local CYR_CVAR_TP_VERT = d_CYR_CVAR_TP_VERT
	local CYR_CVAR_TP_HORI = d_CYR_CVAR_TP_HORI
	local CYR_CVAR_TP_DIST = d_CYR_CVAR_TP_DIST
	local CYR_CVAR_TP_Sensitivity = d_CYR_CVAR_TP_Sensitivity
	local function UpdateBindings()
		local index = CYR_CVAR_TP_ENABLED:GetInt()
		chat.AddText(Color(255, 255, 0), "Third Person Bindings: ", Color(255, 255, 255), index == 0 and "CYR" or index == 1 and "Nutscript" or index == 2 and "ix")
		if index == 0 then
			CYR_CVAR_THIRDPERSON = d_CYR_CVAR_THIRDPERSON
			CYR_CVAR_TP_CLASSIC = d_CYR_CVAR_TP_CLASSIC
			CYR_CVAR_TP_VERT = d_CYR_CVAR_TP_VERT
			CYR_CVAR_TP_HORI = d_CYR_CVAR_TP_HORI
			CYR_CVAR_TP_DIST = d_CYR_CVAR_TP_DIST
			CYR_CVAR_TP_Sensitivity = d_CYR_CVAR_TP_Sensitivity
		elseif index == 1 then
			CYR_CVAR_THIRDPERSON = nutscript_CVAR_THIRDPERSON
			CYR_CVAR_TP_CLASSIC = nutscript_CVAR_TP_CLASSIC
			CYR_CVAR_TP_VERT = nutscript_CVAR_TP_VERT
			CYR_CVAR_TP_HORI = nutscript_CVAR_TP_HORI
			CYR_CVAR_TP_DIST = nutscript_CVAR_TP_DIST
			CYR_CVAR_TP_Sensitivity = nutscript_CVAR_TP_Sensitivity
		elseif index == 2 then
			CYR_CVAR_THIRDPERSON = ix_CVAR_THIRDPERSON
			CYR_CVAR_TP_CLASSIC = ix_CVAR_TP_CLASSIC
			CYR_CVAR_TP_VERT = ix_CVAR_TP_VERT
			CYR_CVAR_TP_HORI = ix_CVAR_TP_HORI
			CYR_CVAR_TP_DIST = ix_CVAR_TP_DIST
			CYR_CVAR_TP_Sensitivity = ix_CVAR_TP_Sensitivity
		end
	end

	UpdateBindings()
	cvars.AddChangeCallback("CYR_thirdpersonBindings", UpdateBindings)
	concommand.Add("CYR_tp_toggle", function()
		local setTP = GetConVar("CYR_tp_enabled"):GetInt() == 0 and 1 or 0
		GetConVar("CYR_tp_enabled"):SetInt(setTP)
	end)

	concommand.Add("ix_tp_toggle", function()
		local setTP = GetConVar("ix_thirdperson"):GetInt() == 0 and 1 or 0
		GetConVar("ix_thirdperson"):SetInt(setTP)
	end)

	concommand.Add("nut_tp_toggle", function()
		local setTP = GetConVar("nut_thirdperson"):GetInt() == 0 and 1 or 0
		GetConVar("nut_thirdperson"):SetInt(setTP)
	end)

	local PANEL = {}
	local maxValues = {
		height = 30,
		horizontal = 30,
		distance = 100
	}

	function PANEL:Init()
		self:SetTitle(L("thirdpersonConfig"))
		self:SetSize(300, 140)
		self:Center()
		self:MakePopup()
		self.list = self:Add("DPanel")
		self.list:Dock(FILL)
		self.list:DockMargin(0, 0, 0, 0)
		local cfg = self.list:Add("DNumSlider")
		cfg:Dock(TOP)
		cfg:SetText("Height") -- Set the text above the slider
		cfg:SetMin(0) -- Set the minimum number you can slide to
		cfg:SetMax(30) -- Set the maximum number you can slide to
		cfg:SetDecimals(0) -- Decimal places - zero for whole number
		cfg:SetConVar("CYR_tp_vertical") -- Changes the ConVar when you slide
		cfg:DockMargin(10, 0, 0, 5)
		local cfg = self.list:Add("DNumSlider")
		cfg:Dock(TOP)
		cfg:SetText("Horizontal") -- Set the text above the slider
		cfg:SetMin(-30) -- Set the minimum number you can slide to
		cfg:SetMax(30) -- Set the maximum number you can slide to
		cfg:SetDecimals(0) -- Decimal places - zero for whole number
		cfg:SetConVar("CYR_tp_horizontal") -- Changes the ConVar when you slide
		cfg:DockMargin(10, 0, 0, 5)
		local cfg = self.list:Add("DNumSlider")
		cfg:Dock(TOP)
		cfg:SetText("Distance") -- Set the text above the slider
		cfg:SetMin(0) -- Set the minimum number you can slide to
		cfg:SetMax(100) -- Set the maximum number you can slide to
		cfg:SetDecimals(0) -- Decimal places - zero for whole number
		cfg:SetConVar("CYR_tp_distance") -- Changes the ConVar when you slide
		cfg:DockMargin(10, 0, 0, 5)
	end

	vgui.Register("nutTPConfig", PANEL, "DFrame")
	local function isAllowed()
		return nut.config.get("thirdperson")
	end

	function PLUGIN:SetupQuickMenu(menu)
		if isAllowed() then
			menu:addCategory("Thirdperson")
			local button = menu:addCheck(L"thirdpersonToggle", function(panel, state)
				if state then
					RunConsoleCommand("CYR_tp_enabled", "1")
				else
					RunConsoleCommand("CYR_tp_enabled", "0")
				end
			end, CYR_CVAR_THIRDPERSON:GetBool())

			local button = menu:addCheck(L"thirdpersonClassic", function(panel, state)
				if state then
					RunConsoleCommand("CYR_tp_classic", "1")
				else
					RunConsoleCommand("CYR_tp_classic", "0")
				end
			end, CYR_CVAR_TP_CLASSIC:GetBool())

			local button = menu:addButton(L"thirdpersonConfig", function()
				if nut.gui.tpconfig and nut.gui.tpconfig:IsVisible() then
					nut.gui.tpconfig:Close()
					nut.gui.tpconfig = nil
				end

				nut.gui.tpconfig = vgui.Create("nutTPConfig")
			end)

			menu:addSpacer()
		end
	end

	function IS_IN_THIRDPERSON()
		if not isAllowed() then return false end
		-- determine what convar we're using
		if CYR_CVAR_TP_ENABLED:GetInt() == 1 then
			return nutscript_CVAR_THIRDPERSON:GetBool()
		elseif CYR_CVAR_TP_ENABLED:GetInt() == 2 then
			return ix_CVAR_THIRDPERSON:GetBool()
		else
			return d_CYR_CVAR_THIRDPERSON:GetBool()
		end
	end

	local playerMeta = FindMetaTable("Player")
	function playerMeta:CanOverrideView()
		if self:GetMoveType() == MOVETYPE_NOCLIP then return false end
		local ragdoll = Entity(self:getLocalVar("ragdoll", 0))
		-- Do not use third person when the character menu is open.
		if IsValid(nut.gui.char) and nut.gui.char:IsVisible() then return false end
		return CYR_CVAR_THIRDPERSON:GetBool() and not IsValid(self:GetVehicle()) and isAllowed() and IsValid(self) and self:getChar() and not self:getNetVar("actAng") and not IsValid(ragdoll) and LocalPlayer():Alive()
	end

	local view, traceData, traceData2, aimOrigin, crouchFactor, ft, trace, curAng
	local clmp = math.Clamp
	crouchFactor = 0
	function PLUGIN:CalcView(client, origin, angles, fov)
		ft = FrameTime()
		if IS_IN_THIRDPERSON() and client:CanOverrideView() and LocalPlayer():GetViewEntity() == LocalPlayer() then
			if (client:OnGround() and client:KeyDown(IN_DUCK)) or client:Crouching() then
				crouchFactor = Lerp(ft * 5, crouchFactor, 1)
			else
				crouchFactor = Lerp(ft * 5, crouchFactor, 0)
			end

			if hook.Run("IsBlockingThirdPerson") then return end
			curAng = owner.camAng or Angle(0, 0, 0)
			view = {}
			view.fov = fov
			traceData = {}
			traceData.start = client:GetPos() + client:GetViewOffset() + curAng:Up() * clmp(CYR_CVAR_TP_VERT:GetInt(), 0, maxValues.height) + curAng:Right() * clmp(CYR_CVAR_TP_HORI:GetInt(), -maxValues.horizontal, maxValues.horizontal) - client:GetViewOffsetDucked() * .5 * crouchFactor
			traceData.endpos = traceData.start - curAng:Forward() * clmp(CYR_CVAR_TP_DIST:GetInt(), 0, maxValues.distance)
			traceData.filter = client
			view.origin = util.TraceLine(traceData).HitPos
			aimOrigin = view.origin
			view.angles = curAng + client:GetViewPunchAngles()
			traceData2 = {}
			traceData2.start = aimOrigin
			traceData2.endpos = aimOrigin + curAng:Forward() * 65535
			traceData2.filter = client
			if CYR_CVAR_TP_CLASSIC:GetBool() or (owner.isWepRaised and owner:isWepRaised() or (owner:KeyDown(bit.bor(IN_FORWARD, IN_BACK, IN_MOVELEFT, IN_MOVERIGHT)) and owner:GetVelocity():Length() >= 10)) then client:SetEyeAngles((util.TraceLine(traceData2).HitPos - client:GetShootPos()):Angle()) end
			view = hook.Run("PostCalcView", view) or view
			return view
		end
	end

	local diff, fm, sm
	function PLUGIN:CreateMove(cmd)
		owner = LocalPlayer()
		if not hook.Run("IsBlockingThirdPerson") then
			if owner:CanOverrideView() and LocalPlayer():GetViewEntity() == LocalPlayer() then
				-- Don't modify movement if noclipping, let the base game handle it
				if owner:GetMoveType() == MOVETYPE_NOCLIP then return false end
				local camAngles = owner.camAng or Angle(0, 0, 0)
				local forward = camAngles:Forward()
				local right = camAngles:Right()
				local up = camAngles:Up()
				-- Remove pitch from forward and right vectors for horizontal movement
				forward.z = 0
				right.z = 0
				forward:Normalize()
				right:Normalize()
				local oldForwardMove = cmd:GetForwardMove()
				local oldSideMove = cmd:GetSideMove()
				local newVelocity = forward * oldForwardMove + right * oldSideMove
				cmd:SetForwardMove(newVelocity:Dot(owner:EyeAngles():Forward()))
				cmd:SetSideMove(newVelocity:Dot(owner:EyeAngles():Right()))
				return false -- Still return false to allow the game to process the modified commands
			end
		end
	end

	function PLUGIN:InputMouseApply(cmd, x, y, ang)
		owner = LocalPlayer()
		if not owner.camAng then owner.camAng = Angle(0, 0, 0) end
		if owner:CanOverrideView() and LocalPlayer():GetViewEntity() == LocalPlayer() then
			local sens = CYR_CVAR_TP_Sensitivity:GetFloat()
			x = x * sens
			y = y * sens
			owner.camAng.p = clmp(math.NormalizeAngle(owner.camAng.p + y / 50), -85, 85)
			owner.camAng.y = math.NormalizeAngle(owner.camAng.y - x / 50)
			return true
		end
	end

	function PLUGIN:ShouldDrawLocalPlayer()
		if LocalPlayer():GetViewEntity() == LocalPlayer() and not IsValid(LocalPlayer():GetVehicle()) and LocalPlayer():CanOverrideView() then return true end
	end
end