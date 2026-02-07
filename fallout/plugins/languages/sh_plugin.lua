PLUGIN.name = "Character Languages"
PLUGIN.author = "Chancer (Modified by Tov)"
PLUGIN.desc = "In a world of Basic, some can say Utinni."
nut.config.add("maxLanguages", 2, "How many languages points you are given in character creation.", nil, {
	data = {
		min = 1,
		max = 20
	},
	category = "Languages"
})

LANGUAGES = {}
LANGUAGES.languages = {}
function LANGUAGES:Register(tbl)
	self.languages[tbl.uid] = tbl
end

function LANGUAGES:GetAll()
	return self.languages
end

if SERVER then
	function PLUGIN:PlayerLoadedChar(client)
		--this just makes sure everything is properly networked to clients.
		--kind of annoying and gross, but might not work properly otherwise.
		for k, v in pairs(player.GetAll()) do
			local char = v:getChar()
			if char then
				local languageData = char:getData("languages", {})
				char:setData("languages", languageData, false, player.GetAll())
			end
		end
	end
end

nut.command.add("languageadd", {
	adminOnly = true,
	syntax = "<string target> <string language>",
	onRun = function(client, arguments)
		if not arguments[2] then
			client:notify("No language specified.")
			return false
		end

		local target = nut.command.findPlayer(client, arguments[1]) or client
		if target then
			local char = target:getChar()
			if not char then return end
			for k, v in pairs(LANGUAGES.languages) do
				if string.find(string.lower(v.name), string.lower(arguments[2])) then --tries to find if their argument matches a language.
					local languageData = char:getData("languages", {})
					languageData[v.uid] = 1 --sets the actual language to being enabled.
					char:setData("languages", languageData, false, player.GetAll())
					client:notify(" You have given " .. target:GetName() .. " the " .. v.name .. " language.")
					break --only want the first one.
				end
			end
		end
	end
})

nut.command.add("languageremove", {
	adminOnly = true,
	syntax = "<string target> <string language>",
	onRun = function(client, arguments)
		if not arguments[2] then
			client:notify("No language specified.")
			return false
		end

		local target = nut.command.findPlayer(client, arguments[1]) or client
		if target then
			local char = target:getChar()
			if not char then return end
			for k, v in pairs(LANGUAGES.languages) do
				if string.find(string.lower(v.name), string.lower(arguments[2])) then --tries to find if their argument matches a language.
					local languageData = char:getData("languages", {})
					languageData[v.uid] = nil --sets the actual language to nothing.
					char:setData("languages", languageData, false, player.GetAll())
					client:notify("You have removed the " .. v.name .. " language from " .. target:GetName() .. ".")
					break --only want the first one.
				end
			end
		end
	end
})

nut.command.add("languagecheck", {
	adminOnly = true,
	syntax = "<string target> <string language>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1]) or client
		if not arguments[2] then
			client:notify("No language specified.")
			return false
		end

		if target then
			local char = target:getChar()
			if not char then return end
			local languageData = char:getData("languages")
			for k, v in pairs(LANGUAGES.languages) do
				if string.find(string.lower(v.name), string.lower(arguments[2])) then --tries to find if their argument matches a language.
					if languageData[v.uid] then
						client:notify(target:GetName() .. " has the " .. v.name .. " language.")
					else
						client:notify(target:GetName() .. " does not have the " .. v.name .. " language.")
					end

					break --only want the first one.
				end
			end
		end
	end
})

--checks whether a character has a language or not.
function hasLanguage(client, language)
	local char = client:getChar()
	if char then
		local languageData = char:getData("languages")
		if languageData then
			if languageData[language] then
				return true
			else
				return false
			end
		end
	end
	return false
end

function PLUGIN:GetStartLanguagePoints()
	return 3
end

--for blood donor language
nut.command.add("blood", {
	onRun = function(client, arguments)
		local char = client:getChar()
		if not hasLanguage(client, "donor") then
			client:notifyLocalized("You do not have the Blood Donor Language.")
			return false
		end

		local lastDust = char:getData("lastDonor", 0)
		if math.abs(tonumber(lastDust) - tonumber(os.date("%d"))) >= 2 then -- once every 2 days.
			char:setData("lastDonor", os.date("%d"))
			nut.item.spawn("food_blood", client:getItemDropPos())
			client:notifyLocalized("You have extracted blood from yourself.")
		else
			client:notifyLocalized("You can only extract blood from yourself once every 2 days.")
		end
	end
})

nut.util.include("sh_languages.lua")
if CLIENT then
	netstream.Hook("ShowLanguages", function(client)
		local languageText = ""
		for k, v in pairs(client:getChar():getData("languages", {})) do
			languageText = languageText .. LANGUAGES.languages[k].name .. ": " .. LANGUAGES.languages[k].desc .. "\n\n"
		end

		local languageMenu = vgui.Create("DFrame")
		languageMenu:SetSize(500, 700)
		languageMenu:Center()
		if me then
			languageMenu:SetTitle("Player Menu")
		else
			languageMenu:SetTitle(client:Name())
		end

		languageMenu:MakePopup()
		languageMenu.DS = vgui.Create("DScrollPanel", languageMenu)
		languageMenu.DS:SetPos(10, 50)
		languageMenu.DS:SetSize(500 - 10, 700 - 50 - 10)
		function languageMenu.DS:Paint(w, h)
		end

		languageMenu.B = vgui.Create("DLabel", languageMenu.DS)
		languageMenu.B:SetPos(0, 40)
		languageMenu.B:SetFont("nutSmallFont")
		languageMenu.B:SetText(languageText)
		languageMenu.B:SetAutoStretchVertical(true)
		languageMenu.B:SetWrap(true)
		languageMenu.B:SetSize(500 - 20, 10)
		languageMenu.B:SetTextColor(Color(255, 255, 255, 255))
	end)
end

nut.command.add("languages", {
	onRun = function(client, arguments) netstream.Start(client, "ShowLanguages", client) end
})

function PLUGIN:CanDeleteChar(client, character)
	if character.vars.languages["finedollar"] and character.vars.money < 200 then return true end
end

--adds the languagestep gui to the char creation menu
if CLIENT then
	function PLUGIN:ConfigureCharacterCreationSteps(panel)
		panel:addStep(vgui.Create("nutCharLanguages"), 100)
	end
end