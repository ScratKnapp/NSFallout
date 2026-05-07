local PLUGIN = PLUGIN
PLUGIN.name = "Compass";
PLUGIN.author = "CW: Gr4Ss, NS: DrodA Fixed: Parade";
PLUGIN.desc = "Adds Compass on your HUD";

nut.config.add("compassOffset", 0, "Offsets the compass.", nil, {
	data = {min = -180, max = 180},
	category = "Compass"
})


local function InitLanguages()
    local langkey = "english";
    do
        local langTable =
        {
            toggleCompass = "Toggle Compass",

        };

        table.Merge(nut.lang.stored[langkey], langTable);
    end;

    local langkey = "russian";
    do
        local langTable =
        {
            toggleCompass = "Активировать компас",

        };

        table.Merge(nut.lang.stored[langkey], langTable);
    end;
end;

function PLUGIN:InitializedPlugins()
    InitLanguages();
end;

if (CLIENT) then
	local compassMat = Material("fonvui/hud/compass.png", "noclamp smooth")

    surface.CreateFont("CompassFont", {
		font    = "Play Bold",
		size    = 20,
		weight  = 300,
		antialias = true,
		shadow = false
	});

    PLUGIN.compassText = {};
    PLUGIN.compassText[0] = " E ";
    PLUGIN.compassText[15] = "75 ";
    PLUGIN.compassText[30] = "60";
    PLUGIN.compassText[45] = "NE ";
    PLUGIN.compassText[60] = "30 ";
    PLUGIN.compassText[75] = "15 ";
    PLUGIN.compassText[90] = " N ";
    PLUGIN.compassText[105] = "345";
    PLUGIN.compassText[120] = "330";
    PLUGIN.compassText[135] = "NW ";
    PLUGIN.compassText[150] = "300";
    PLUGIN.compassText[165] = "285";
    PLUGIN.compassText[180] = " W ";
    PLUGIN.compassText[-165] = "255";
    PLUGIN.compassText[-150] = "240";
    PLUGIN.compassText[-135] = "SW ";
    PLUGIN.compassText[-120] = "210";
    PLUGIN.compassText[-105] = "195";
    PLUGIN.compassText[-90] = " S ";
    PLUGIN.compassText[-75] = "165";
    PLUGIN.compassText[-60] = "150";
    PLUGIN.compassText[-45] = "SE";
    PLUGIN.compassText[-30] = "120";
    PLUGIN.compassText[-15] = "105";

    NUT_CVAR_COMPASS = CreateClientConVar("nut_compass", 1, true, true);

    function PLUGIN:HUDPaint()
        local client = LocalPlayer();
        if !IsValid(client) or !client:Alive() then return end
        if (client:GetInfoNum("nut_compass", 0) == 0) then return end
		if (IsValid(nut.gui.menu)) then return end

        local scrW = ScrW()
        local scrH = ScrH()
		
		local scrModX = 1920/scrW
		local scrModY = 1080/scrH
		
		local compassBoxWidth = scrW*0.2
        local compassBoxHeight = scrH*0.05
		
        local compassX = scrW*0.5 - compassBoxWidth*0.5
        local compassY = 0

		local yaw = math.floor(client:GetAngles().y);

		--[[
		local finalText = "";
		for i = yaw - 50, yaw + 50 do
			local y = i;
			if i > 180 then
				y = -360 + i;
			elseif i < -180 then
				y = 360 + i;
			elseif i == -180 then
				y = 360 + i;
			end;

			if (self.compassText[y]) then
				finalText = self.compassText[y]..finalText;
			else
				finalText = " "..finalText;
			end
		end
		--]]

		local offset = nut.config.get("compassOffset", 0)

		yaw = yaw + offset
		if(yaw >= 180) then
			yaw = yaw - 360
		elseif(yaw < -180) then
			yaw = yaw + 360
		end

		local compassAngle = (-yaw + 180)/360
		
		local startU = compassAngle
		local endU = compassAngle+0.5
		local startV = 0
		local endV = 1
		
		surface.SetDrawColor(0, 238, 0, 255)
        surface.SetMaterial(compassMat)
		surface.DrawTexturedRectUV(compassX, compassY, compassBoxWidth, compassBoxHeight, startU, startV, endU, endV)

        draw.RoundedBox(0, compassX+compassBoxWidth*0.5, compassY+compassBoxHeight*0.5, 1, 20, Color(0, 238, 0, 255));
		
        --draw.DrawText(finalText, "CompassFont", scrW/2, screenHeight, Color(0, 238, 0, 255), TEXT_ALIGN_CENTER);
    end

    function PLUGIN:SetupQuickMenu(menu)
        local buttonCompass = menu:addCheck(L"toggleCompass", function(panel, state)
            if (state) then
                RunConsoleCommand("nut_compass", "1")
            else
                RunConsoleCommand("nut_compass", "0")
            end;
        end, NUT_CVAR_COMPASS:GetBool())

        menu:addSpacer()
    end
end;