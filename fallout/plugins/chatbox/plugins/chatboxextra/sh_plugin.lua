local PLUGIN = PLUGIN

PLUGIN.name = "Extra Chatbox"
PLUGIN.author = ""
PLUGIN.desc = ""

if (CLIENT) then	
	function PLUGIN:CreateChat2()
		if (IsValid(PLUGIN.chat2)) then
			PLUGIN.chat2:Remove()
		end
		
		PLUGIN.chat2 = vgui.Create("nutChatBox2")
	end
	
	function PLUGIN:InitPostEntity()
		timer.Simple(1, function()
			self:CreateChat2()
		end)
	end
	
	concommand.Add("nut_chatbox2", function(ply, cmd, args)
		PLUGIN:CreateChat2()
	end)
	
	-- Call onChatAdd for the appropriate chatType.
	netstream.Hook("cMsg2", function(client, chatType, text, anonymous)
		if (IsValid(client)) then
			local class = nut.chat.classes[chatType]
			text = hook.Run("OnChatReceived", client, chatType, text, anonymous) or text

			if (class) then
				CHAT_CLASS = class

					local color = class.color
					local name = anonymous and L"someone" or (IsValid(client) and client:Name() or "Console")

					if (class.onGetColor) then
						color = class.onGetColor(client, text)
					end

					local timestamp = nut.chat.timestamp(false)
					local translated = L2(chatType.."Format", name, text)

					--chat.AddText(timestamp, color, translated or string.format(class.format, name, text))
					PLUGIN.chat2:addText(timestamp, color, text)
					
					if (SOUND_CUSTOM_CHAT_SOUND and SOUND_CUSTOM_CHAT_SOUND ~= "") then
						surface.PlaySound(SOUND_CUSTOM_CHAT_SOUND)
					else
						chat.PlaySound()
					end
					
				CHAT_CLASS = nil
			end
		end
	end)
else
	-- Send a chat message using the specified chat type.
	function PLUGIN:ChatboxSend(speaker, chatType, text, anonymous, receivers)
		local class = nut.chat.classes[chatType]

		if (class and class.onCanSay(speaker, text) ~= false) then
			if (class.onCanHear and !receivers) then
				receivers = {}

				for k, v in ipairs(player.GetAll()) do
					if (v:getChar() and class.onCanHear(speaker, v) ~= false) then
						receivers[#receivers + 1] = v
					end
				end

				if (#receivers == 0) then
					return
				end
			end
			
			netstream.Start(receivers, "cMsg2", speaker, chatType, hook.Run("PlayerMessageSend", speaker, chatType, text, anonymous, receivers) or text, anonymous)
		end
	end
end

nut.command.add("chatextraclear", {
	onRun = function(client, arguments)
		client:ConCommand("nut_chatbox2")
	end
})