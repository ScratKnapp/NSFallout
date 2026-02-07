local PLUGIN = PLUGIN

local weathers = {
	
	
	{
		weather = "rain",
		event = "Dark grey clouds with slight tints of green form on the horizon. Approaching rapidly, the clouds cover the skies within minutes, and droplets begin falling from the sky, as the region is caught under a light drizzle. It increases progressively until there is a fair amount of rainfall. The rain is visibly dirty and irradiated, and singes the skin when it makes contact.",
		duration = 900, --this is in seconds, how long until the system automatically stops the weather
		eventOver = "The rain slowly dies off, giving way to clear skies.", --this is optional
	},

	{
		weather = "sandstorm",
		event = "A large rolling cloud of dust and sand approaches the area at a slow pace, blotting out the sky until it washes over the region. It becomes hard to breathe without a mask, and much harder to see.",
		duration = 900, --this is in seconds, how long until the system automatically stops the weather
		eventOver = "The sandstorm eventually rolls over, and the skies quickly clear out once again.", --this is optional
	},
	{
		weather = "storm",
		event = "From above a few light rain falls almost out of nowhere. The distant sound of thunder grows more apparent over the next minute. It very quickly ramps up to a heavy rain, accompanied by loud thunder and lightning strikes. The rain that falls is a sickly green irradiated hue, and it burns the skin wherever it makes contact.",
		eventOver = "The storming stops as quickly as it came, giving way to clear-ish skies, with the dark grey storm clouds passing away distantly.", --this is optional
		duration = 900, --this is in seconds, how long until the system automatically stops the weather
		sound = { --sounds
			"ambient/atmosphere/thunder1.wav",
			"ambient/atmosphere/thunder2.wav",
			"ambient/atmosphere/thunder3.wav",
			"ambient/atmosphere/thunder4.wav",
		}
	},

}

function PLUGIN:weatherStart()
	local weather = weathers[math.random(#weathers)]
	
	if(weather.weather) then
		RunConsoleCommand("sw_weather", weather.weather)
	end
	
	local players = player.GetAll()
	
	if(weather.event) then --sends the event text to everybody, probably
		for k, v in pairs(players) do
			nut.chat.send(v, "weather", weather.event)
		end
	end
	
	if(weather.sound) then
		local sound = table.Random(weather.sound)
		for k, v in pairs(players) do
			v:ConCommand("play " ..sound)
		end
	end
	
	if(weather.duration) then --stops the weather after a certain duration
		timer.Simple(weather.duration, function()
			RunConsoleCommand("sw_weather", "none")
			
			if(weather.eventOver) then
				for k, v in pairs(player.GetAll()) do
					nut.chat.send(v, "weather", weather.eventOver)
				end
			end
		end)
		
		return weather.duration
	end
end

-- command for easy body status updates
nut.chat.register("weather", {
	onChatAdd = function(speaker, text)
		local color = nut.chat.classes.ic.onGetColor(speaker, text)
		chat.AddText(Color(255, 150, 0), "**"..text)
	end,
	onCanHear = function(speaker, listener)
		if(speaker == listener) then
			return true
		else
			return false
		end
	end,
	font = "nutChatFontItalics",
	filter = "actions",
	deadCanChat = true
})