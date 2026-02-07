local PLUGIN = PLUGIN
PLUGIN.name = "Combat"
PLUGIN.author = "Chancer"
PLUGIN.desc = "A combat system based off of stats and rolling. Inspired by CWPNP."

PLUGIN.savedEnts = PLUGIN.savedEnts or {}

PLUGIN.CHATCOLOR_REACT = Color(70, 180, 180)
PLUGIN.CHATCOLOR_REACT2 = Color(180, 70, 180)
PLUGIN.CHATCOLOR_REACT3 = Color(220, 70, 70)

PLUGIN.CHATCOLOR_MELEE = Color(160, 95, 95)
PLUGIN.CHATCOLOR_RANGED = Color(100, 110, 150)
PLUGIN.CHATCOLOR_GRAZE = Color(150, 150, 75)
PLUGIN.CHATCOLOR_RESIST = Color(140, 125, 125)
PLUGIN.CHATCOLOR_SPECIAL = Color(80, 150, 150)

PLUGIN.CHATCOLOR_RED = Color(160, 60, 60)
PLUGIN.CHATCOLOR_GREEN = Color(60, 160, 60)

PLUGIN.COMBAT_FONT = "nutChatFontCombat"

local playerMeta = FindMetaTable("Player")

nut.config.add("combatDamageDisplay", true, "Whether to display combat damage numbers or not.", nil, {
	category = "Combat"
})

function PLUGIN:PostPlayerLoadout(client)
	client:Give("nut_cswep")
end

--function for summoning related spells
function PLUGIN:summonAction(client, action, pos)
	if(isstring(action.summon)) then
		local summon = ents.Create(action.summon)
		
		summon:SetPos(pos or client:GetEyeTrace().HitPos) --set its position
		summon:Spawn() --spawn it
		summon:Activate()

		summon:SetCreator(client)
		
		timer.Simple(1, function()
			summon:setNetVar("name", client:Name().. "'s " ..summon:Name())
		end)
	end
	
	return true
end

NUT_CVAR_LVLCONFIRM = CreateClientConVar("nut_lvlconfirm", 1, true, true)
function PLUGIN:SetupQuickMenu(menu)
	local button = menu:addCheck("Level Up Confirmations", function(panel, state)
		if (state) then
			RunConsoleCommand("nut_lvlconfirm", "1")
		else
			RunConsoleCommand("nut_lvlconfirm", "0")
		end
	end, NUT_CVAR_LVLCONFIRM:GetBool())
end

--function that determines how many attributes a player gets on character creation
function PLUGIN:Think()
	if(!SERVER) then return end

	if(PLUGIN.buffThink) then
		PLUGIN:buffThink()
	end
	
	if(PLUGIN.cdThink) then
		PLUGIN:cdThink()
	end
end

if(CLIENT) then
	surface.CreateFont("nutCombatTarget", {
		font = "Monofonto",
		size = math.max(ScreenScale(10), 36),
		weight = 400
	})
	
	surface.CreateFont("nutCombatHUD", {
		font = "Monofonto",
		size = 25,
		weight = 400
	})
end