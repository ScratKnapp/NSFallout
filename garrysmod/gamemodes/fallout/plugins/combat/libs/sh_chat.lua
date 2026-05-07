local PLUGIN = PLUGIN

--chat for colors and formatting.
nut.chat.register("attack", {
	format = "%s %s",
	color = PLUGIN.CHATCOLOR_SPECIAL,
	filter = "actions",
	font = COMBAT_FONT,
	onCanHear = nut.config.get("chatRange", 280) * 4,
	deadCanChat = true
})

nut.chat.register("statcheck", {
	format = "%s %s.",
	color = PLUGIN.CHATCOLOR_REACT,
	filter = "actions",
	font = COMBAT_FONT,
	onCanHear = nut.config.get("chatRange", 280) * 4,
	deadCanChat = true
})


if(CLIENT) then
	surface.CreateFont("nutChatFontCombat", {
		font = "Verdana",
		size = math.max(ScreenScale(6), 17),
		extended = true,
		weight = 600
	})
end