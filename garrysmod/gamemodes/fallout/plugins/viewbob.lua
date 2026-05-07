local PLUGIN = PLUGIN
PLUGIN.name = "ViewBob"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "1337 S0 DR4M4T1C"

if CLIENT then
	local NUT_CVAR_VIEW = CreateClientConVar("nut_view_enabled", 1, true)
	local NUT_CVAR_VIEW_SCALE = CreateClientConVar("nut_view_scale", 0.1, true)

	local mc = math.Clamp
	local curang = Angle( 0, 0, 0 )
	local curvec = Vector( 0, 0, 0 )

	local tarang = Angle( 0, 0, 0 )
	local tarvec = Vector( 0, 0, 0 )

	local transang = Angle( 0, 0, 0 )
	
	local GetVelocity = FindMetaTable("Entity").GetVelocity
	local Length2D = FindMetaTable("Vector").Length2D

	local nobob = {
		"weapon_physgun",
		"gmod_tool",
	}

	local PANEL = {}

	local maxValues = {
		height = 30,
		horizontal = 30,
		distance = 100
	}
	
	function PANEL:Init()
		self:SetTitle("View Bob Config")
		self:SetSize(300, 140)
		self:Center()
		self:MakePopup()

		self.list = self:Add("DPanel")
		self.list:Dock(FILL)
		self.list:DockMargin(0, 0, 0, 0)

		local cfg = self.list:Add("DCheckBoxLabel")
		cfg:Dock(TOP)
		cfg:SetText("Enabled") // Set the text above the slider
		cfg:SetConVar("nut_view_enabled") // Changes the ConVar when you slide
		cfg:DockMargin(10, 0, 0, 5)
		
		local cfg = self.list:Add("DNumSlider")
		cfg:Dock(TOP)
		cfg:SetText("Scale") // Set the text above the slider
		cfg:SetMin(0)				 // Set the minimum number you can slide to
		cfg:SetMax(1)				// Set the maximum number you can slide to
		cfg:SetDecimals(2)			 // Decimal places - zero for whole number
		cfg:SetConVar("nut_view_scale") // Changes the ConVar when you slide
		cfg:DockMargin(10, 0, 0, 5)
	end
	vgui.Register("nutViewBobConfig", PANEL, "DFrame")
	
	function PLUGIN:SetupQuickMenu(menu)
		local button = menu:addButton("View Bob Config", function()
			if (nut.gui.viewconfig and nut.gui.viewconfig:IsVisible()) then
				nut.gui.viewconfig:Close()
				nut.gui.viewconfig = nil
			end

			nut.gui.viewconfig = vgui.Create("nutViewBobConfig")
		end)

		menu:addSpacer()
	end
	
	local class
	function PLUGIN:CalcView( ply, pos, ang, fov, znear, zfar)
		local rt = RealTime()
		local ft = FrameTime()
		local vel = math.floor( Length2D(GetVelocity(ply)) )
		local runspeed = ply:GetRunSpeed()
		local walkspeed = ply:GetWalkSpeed()
		local wep = ply:GetActiveWeapon()
		if wep and wep:IsValid() then
			class = ply:GetActiveWeapon():GetClass()
		else
			class = ""
		end
		local v = {}
		
		local thirdperson = GetConVar("nut_tp_enabled"):GetBool()

		if 
			(
			NUT_CVAR_VIEW:GetBool() &&
			!thirdperson &&
			IsValid(ply) &&
			ply:Alive() &&
			ply.getChar and ply:getChar() &&
			ply:GetMoveType() != MOVETYPE_NOCLIP
			)
		then
			local viewScale = NUT_CVAR_VIEW_SCALE:GetFloat()

			if !ply:ShouldDrawLocalPlayer() and (!table.HasValue(nobob, class)) then
				if ply:OnGround() then
					if vel > walkspeed+5 then
						local perc = vel/runspeed*100
						perc = math.Clamp(perc, .5, 6 )
						perc = perc * viewScale
						tarang = Angle( math.abs( math.cos( rt*(runspeed/33) )*.4*perc ), math.sin( rt*(runspeed/29) ) * .5 * perc, 0 )
						tarvec = Vector( 0, 0, math.sin( rt*(runspeed/30) )*.4*perc )
					else
						local perc = vel/walkspeed*100
						perc = math.Clamp(perc/30, 0, 4)
						perc = perc * viewScale
						tarang = Angle(math.cos( rt*(walkspeed/8) ) * .2 * perc, 0, 0)
						tarvec = Vector(0, 0, (math.sin( rt*(walkspeed/8) ) * .5)*perc)
					end
				else
					if ply:WaterLevel() >= 2 then
						tarvec = Vector( 0, 0, 0 )
						tarang = Angle( 0, 0, 0 )
					else	
						local vel = math.abs( ply:GetVelocity().z )
						local af = 0
						perc = math.Clamp( vel/200, .1, 8 )
						perc = perc * viewScale
						if perc > 1 then
							af = perc
						end
						tarang = Angle( math.cos( rt*15 ) * 2 * perc + math.Rand( -af*2, af*2 ), math.sin( rt*15 ) * 2 * perc + math.Rand( -af*2, af*2 ) ,math.Rand( -af*5, af*5 )  )
						tarvec = Vector( math.cos( rt*15 ) * .5 * perc , math.sin( rt*15 ) * .5 * perc, 0 )
					end
				end
				
				if viewScale > .1 then
					transang = LerpAngle( mc(mc(FrameTime(), 1/120, 1)*10,0,5), transang, ang)
				else
					transang = ang
				end
				curang = LerpAngle( ft * 10, curang, tarang )
				curvec = LerpVector( ft * 10, curvec, tarvec )
				
				v.angles = transang + curang
				v.origin = pos + curvec
				v.fov = fov
				
				return GAMEMODE:CalcView(ply, v.origin, v.angles, v.fov)
			end
		end

		--return GAMEMODE:CalcView(ply, pos, ang, fov, znear, zfar)
	end
end