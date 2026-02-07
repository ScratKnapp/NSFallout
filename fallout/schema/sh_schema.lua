SCHEMA.name = "Fallout"
SCHEMA.introName = ""
SCHEMA.desc = " "
SCHEMA.author = "Chancer"
SCHEMA.uniqueID = "fallout" -- Schema will be a unique identifier stored in the database.

nut.currency.set("", "denarius", "denarii")

nut.util.include("cl_effects.lua")
nut.util.include("sh_commands.lua")
--nut.util.include("sv_resource.lua")
--nut.util.include("sh_dev.lua") -- Developer Functions

nut.util.includeDir("libs")
--nut.util.includeDir("meta")
nut.util.includeDir("hooks")
nut.util.includeDir("derma")

--[[nut.flag.add("F", "Access to food/drink items.")
nut.flag.add("A", "Access to armor/clothing items.")
nut.flag.add("G", "Access to general items.")
nut.flag.add("S", "Access to special/classified items.")

nut.flag.add("1", "Access to melee weaponry.")
nut.flag.add("2", "Access to small weaponry.")
nut.flag.add("3", "Access to large weaponry.")
nut.flag.add("4", "Access to special weaponry.")--]]


nut.flag.add("z", "Drug flags.")
nut.flag.add("m", "Medical Items Flags.")
nut.flag.add("3", "Consumer Grade Weapons Flags.")
nut.flag.add("4", "Restricted Grade Weapons Flags.")
nut.flag.add("5", "Premium Grade Weapons Flags.")
nut.flag.add("6", "Civilian Grade Weapons Flags.")
nut.flag.add("7", "Energy Weapons Flags")
nut.flag.add("x", "Civilian Grade Augments Flags.")
nut.flag.add("X", "Illegal Augments Flags.")
nut.flag.add("A", "Light/Medium Exos Flags.")
nut.flag.add("B", "Heavy/Military Exos Flags.")

nut.flag.add("j", "Access to the junk items.")
nut.flag.add("v", "Access to the general items.")
nut.flag.add("V", "Access to the more rare items.")
nut.flag.add("E", "Effects.")
nut.flag.add("T", "Access to more dangerous tools.")
nut.flag.add("q", "Ability to scrap junk objects.")
nut.flag.add("1", "Customize item names and descriptions.")
nut.flag.add("u", "Ban from OOC.")

nut.flag.add("i", "Access to items a bar/restaurant would sell.")

nut.flag.add("d", "Identifying regular items.")
nut.flag.add("D", "Identifying magical items.")





--This is used for some entities to print stuff in the chat to people.
nut.chat.register("mind", {
	onChatAdd = function(speaker, text)
		local color = nut.chat.classes.ic.onGetColor(speaker, text)
		chat.AddText(Color(115, 115, 115), "**\""..text.."\"")
	end,
	onCanHear = 1, --range is set incredibly low so that only the client can see it.
	prefix = {"/mind"},
	font = "nutChatFontItalics",
	filter = "actions",
	deadCanChat = true
})

--adds attribute modification to factions
function SCHEMA:OnCharCreated(client, character)
	timer.Simple(0.5, function()
		local factionIndex = character:getFaction()
		
		local faction = nut.faction.indices[factionIndex]
		if(faction) then
			local attrib = faction.attrib
			if(attrib) then
				for k, v in pairs(attrib) do
					character:updateAttrib(k,v)
				end
			end
		end
	end)
end

if(CLIENT) then
	NUT_CVAR_CHATFLIP = CreateClientConVar("nut_chatflip", 1, true, true)
	function SCHEMA:SetupQuickMenu(menu)
		local buttonChatflip = menu:addCheck("Toggle Chat Flipping.", function(panel, state)
			if (state) then
				RunConsoleCommand("nut_chatflip", "1")
			else
				RunConsoleCommand("nut_chatflip", "0")
			end
		end, NUT_CVAR_CHATFLIP:GetBool())
	end
end

--fix for the pioneer models?
nut.anim.setModelClass("models/gore/rangers/arizona_cowboy.mdl", "player")
nut.anim.setModelClass("models/gore/rangers/arizona_cowboy02.mdl", "player")
nut.anim.setModelClass("models/gore/rangers/arizona_patrol_rangerf_mdl.mdl", "player")
nut.anim.setModelClass("models/gore/rangers/arizona_patrol_rangerm_mdl.mdl", "player")
nut.anim.setModelClass("models/gore/rangers/arizona_ranger.mdl", "player")
nut.anim.setModelClass("models/gore/rangers/arizona_ranger01.mdl", "player")
nut.anim.setModelClass("models/gore/rangers/arizona_rangerf.mdl", "player")
nut.anim.setModelClass("models/gore/rangers/arizona_rangerf02.mdl", "player")
nut.anim.setModelClass("models/gore/rangers/arizona_rangerf03.mdl", "player")
nut.anim.setModelClass("models/gore/rangers/arizona_smuggler.mdl", "player")
nut.anim.setModelClass("models/gore/rangers/arizona_veteran_ranger.mdl", "player")
nut.anim.setModelClass("models/gore/rangers/arizona_veteran_ranger01.mdl", "player")
nut.anim.setModelClass("models/gore/rangers/arizona_veteran_ranger02.mdl", "player")
nut.anim.setModelClass("models/gore/rangers/arizona_veteran_rangerf.mdl", "player")
nut.anim.setModelClass("models/gore/rangers/arizona_veteran_rangerhat.mdl", "player")
nut.anim.setModelClass("models/gore/hades/acolyte of mars.mdl", "player")
nut.anim.setModelClass("models/gore/hades/centurion of hades.mdl", "player")
nut.anim.setModelClass("models/gore/hades/centurion of mars.mdl", "player")
nut.anim.setModelClass("models/gore/hades/decanus of hades.mdl", "player")
nut.anim.setModelClass("models/gore/hades/equite of mars.mdl", "player")
nut.anim.setModelClass("models/gore/hades/explorator of hades.mdl", "player")
nut.anim.setModelClass("models/gore/hades/follower of mars (female).mdl", "player")
nut.anim.setModelClass("models/gore/hades/follower of mars.mdl", "player")
nut.anim.setModelClass("models/gore/hades/legate hades.mdl", "player")
nut.anim.setModelClass("models/gore/hades/legionary of hades.mdl", "player")
nut.anim.setModelClass("models/gore/hades/pilgrim of mars.mdl", "player")
nut.anim.setModelClass("models/gore/auxiliary/auxiliarym_pm.mdl", "player")
nut.anim.setModelClass("models/gore/hades/priestess of mars.mdl", "player")
nut.anim.setModelClass("models/gore/hades/vexillarius of hades.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/deserterm_01.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/deserterm_02.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/gladiator_otho.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad01.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad02.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad03.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad04.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad05.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad06.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad07.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad08.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad09.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad10.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad11.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad12.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad13.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad14.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad15.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad16.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad17.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad18.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad19.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad20.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad21.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad22.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad23.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad24.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad25.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad26.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad27.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad28.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad29.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad30.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad31.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad32.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad33.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad34.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad35.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad36.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad37.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad38.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad39.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad40.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad42.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad43.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad44.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/legion_nomad45.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/libertaras_deserterf_01.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/libertaras_deserterf_02.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/libertaras_officerf_01.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/libertaras_officerf_02.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/libertaras_officerm_01.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/libertaras_officerm_02.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/libertaras_rangerf_01.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/libertaras_rangerf_02.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/libertaras_rangerm_01.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/libertaras_rangerm_02.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/libertaras_slavef_01.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/libertaras_slavef_02.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/libertaras_slavem_01.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/libertaras_slavem_02.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/praetorian_legionary01.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/praetorian_legionary02.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/praetorian_legionary03.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/praetorian_legionary04.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/praetorian_legionary05.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/praetorian_legionary06.mdl", "player")
nut.anim.setModelClass("models/gore/subfactions/praetorian_legionary07.mdl", "player")
nut.anim.setModelClass("models/gore/auxiliary/auxiliaryf_pm.mdl", "player")
nut.anim.setModelClass("models/gore/auxiliary/auxiliary_recruitm_pm.mdl", "player")
nut.anim.setModelClass("models/gore/auxiliary/auxiliary_recruitf_pm.mdl", "player")
nut.anim.setModelClass("models/gore/auxiliary/auxiliary_captainm_pm.mdl", "player")
nut.anim.setModelClass("models/gore/auxiliary/auxiliary_captainf_pm.mdl", "player")


