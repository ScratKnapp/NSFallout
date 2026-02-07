local PLUGIN = PLUGIN
PLUGIN.name = "Self PK"
PLUGIN.author = " "
PLUGIN.desc = "A command that allows you to PK yourself."

nut.chat.register("pkbroadcast", {
	format = "",
	onChatAdd = function(speaker, text, anonymous)
		chat.AddText(Color(255, 40, 40), text)
	end,
	onCanHear = 9999999,
})

nut.command.add("pkself", {
	onRun = function(client, arguments)
		client:requestQuery("Are you sure you want to PERMANENTLY kill your character?", "Verification", function(text)
			client:requestQuery("Are you certain?", "Verification", function(text)
				local deathMsg = client:Name().. " has died."
				
				nut.chat.send(client, "pkbroadcast", deathMsg)

				client:TakeDamage(9999999999, self, self)
				
				local char = client:getChar()
				
				timer.Simple(1, function()
					char:setData("permakilled", true)
					char:ban()
				end)
			end)
		end)
	end
})