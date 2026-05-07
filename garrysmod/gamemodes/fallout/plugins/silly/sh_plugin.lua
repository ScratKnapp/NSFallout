local PLUGIN = PLUGIN
PLUGIN.name = "Silly Items"
PLUGIN.author = "Chancer"
PLUGIN.desc = "What the fuck?"

local monkeyActions = {
	"jumps around like a monkey.",	
	"makes loud monkey noises.",
	"makes quiet monkey noises.",
	"makes ridiculous monkey noises.",
}

local monkeyWords = {
	"OOH OOH! AHH! AHH!",
	"OOK OOK! AHH!",
	"MONKEY WANT BANANA!",
	"GIVE BANANA! OOH! AH! AH!",
	"OOK OOK! AH! AH! AH!",
}

local monkeySelf = {
	"You want to eat a banana.",
	"You want to eat banana.",
	"You crave banana.",
	"You want to swing from trees.",
	"You want to OOH OOH AHH AHHH AAHH!!",
}

function PLUGIN:getMonkeySActivity(client)
	local roll = math.random(1,3)
	
	local monkey
	if(roll == 1) then
		monkey = table.Random(monkeyActions)
		nut.chat.send(client, "me", "suddenly starts acting like a monkey.")
		nut.chat.send(client, "me", monkey)
	elseif(roll == 2) then
		monkey = table.Random(monkeyWords)
		nut.chat.send(client, "me", "starts making random monkey noises.")
		nut.chat.send(client, "ic", monkey)
	else
		monkey = table.Random(monkeySelf)
		nut.chat.send(client, "body", monkey)
	end
end

--debugging command for when inventories get really dumb
nut.command.add("monkey", {
	onRun = function(client, arguments)
		PLUGIN:getMonkeySActivity(client)
	end
})