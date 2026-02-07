local PLUGIN = PLUGIN
PLUGIN.name = "/los and /melos"
PLUGIN.author = "Haunt and Angelsaur"
PLUGIN.desc = "Chat messages that are only heard by people you can see."

nut.chat.register("los", {
	format = "[LOS] %s says \"%s\"",
	onGetColor = function(speaker, text)
		-- If you are looking at the speaker, make it greener to easier identify who is talking.
		if (LocalPlayer():GetEyeTrace().Entity == speaker) then
			return nut.config.get("chatListenColor")
		end
		
		-- Otherwise, use the normal chat color.
		return nut.config.get("chatColor")
	end,	
	prefix = {"/los", "/lineofsight"},
	onCanHear = function(speaker, listener)
		local range = 280 ^ 2
		return (speaker:IsLineOfSightClear( listener ) and (speaker:GetPos() - listener:GetPos()):Length2DSqr() <= range)
	end,
	onChatAdd = function(speaker, text, anonymous)
			local suffix = string.sub(text, text:len())
			local speako = anonymous and "Someone" or hook.Run("GetDisplayedName", speaker, "ic") or (IsValid(speaker) and speaker:Name() or "Console")
			local pSay = string.upper(string.sub(text, 0, 1))..string.sub(text, 2)
			local pSayC = string.upper(string.sub(text, 0, 1))..string.sub(text, 2)
			
			local chatColor = nut.config.get("chatColor")
			local chatTxtColor = Color(chatColor.r, chatColor.g, chatColor.b) --i dont know why this was necessary
			
			if (LocalPlayer():GetEyeTrace().Entity == speaker) then
				chatColor = nut.config.get("chatColor")
				chatTxtColor = Color(chatColor.r, chatColor.g, chatColor.b) --i dont know why this was necessary
			end

			local nameCol = Color(chatTxtColor.r + 30, chatTxtColor.g + 30, chatTxtColor.b + 30)

			if(LocalPlayer() == speaker) then
				local chatListenColor = nut.config.get("chatListenColor")
				
				chatTxtColor = Color(chatListenColor.r, chatListenColor.g, chatListenColor.b)
				nameCol = Color(chatListenColor.r + 50, chatListenColor.g + 50, chatListenColor.b + 50)
			end
			
			-- chat.AddText(nameCol, speako, chatTxtColor, " says \""..pSayC.."\"")
			chat.AddText(nameCol, "[LOS] "..speako, chatTxtColor, " says \""..pSayC.."\"")
		end
})

nut.chat.register("melos", {
		format = "%s %s",
		onGetColor = function(speaker, text)
			-- If you are looking at the speaker, make it greener to easier identify who is talking.
			if (LocalPlayer():GetEyeTrace().Entity == speaker) then
				return nut.config.get("chatListenColor")
			end
			
			-- Otherwise, use the normal chat color.
			return nut.config.get("chatColor")
		end,
		onCanHear = function(speaker, listener)
			local range = 280 ^ 2
			return (speaker:IsLineOfSightClear( listener ) and (speaker:GetPos() - listener:GetPos()):Length2DSqr() <= range)
		end,
		onChatAdd = function(speaker, text, anonymous)
			local speako = anonymous and "Someone" or hook.Run("GetDisplayedName", speaker, "ic") or (IsValid(speaker) and speaker:Name() or "Console")
			local chatTxtColor = nut.config.get("chatColor")

			if (LocalPlayer():GetEyeTrace().Entity == speaker) then
				chatTxtColor = nut.config.get("chatListenColor")
			end
			
			chatTxtColor = Color(chatTxtColor.r, chatTxtColor.g, chatTxtColor.b)
			
			local nameCol = Color(chatTxtColor.r + 30, chatTxtColor.g + 30, chatTxtColor.b + 30)
			
			if(LocalPlayer() == speaker) then
				local chatListenColor = nut.config.get("chatListenColor")
						
				chatTxtColor = Color(chatListenColor.r + 20, chatListenColor.g + 20, chatListenColor.b + 20)
				nameCol = Color(chatListenColor.r + 50, chatListenColor.g + 50, chatListenColor.b + 50)
			end
			
			chat.AddText(nameCol, "[ME-LOS] "..speako, chatTxtColor, " " ..text)
		end,
		prefix = {"/melos", "/actionlos"},
		font = "nutChatFontItalics",
		filter = "actions",
		deadCanChat = true
	})