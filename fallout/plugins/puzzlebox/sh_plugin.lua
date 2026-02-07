local PLUGIN = PLUGIN

PLUGIN.name = "Puzzle Box - First Week"
PLUGIN.author = "Seamus"
PLUGIN.desc = "Adds a box for critical thinking."

if SERVER then
	PLUGIN.directionStages = {}
	PLUGIN.presetPath = string.Split("snnwnneenwseeseeeeswweesweweenwwwesnssnnwweswnnswesssesswenesewsweeeweswswnensnnnswsnswwwsnssneewwe","")
	
	function PLUGIN:PlayerInitialSpawn(client)
		PLUGIN.directionStages[client:SteamID64()] = 0
	end

	function PLUGIN:PostInitEntity()
		--PLUGIN.pathTable = string.Split("snnwnneenwseeseeeeswweesweweenwwwesnssnnwweswnnswesssesswenesewsweeeweswswnensnnnswsnswwwsnssneewwe","")
		--http.Fetch("https://www.dropbox.com/s/4pzlru78qubgnyb/puzzlesolution.txt?dl=1",function(body)  end)
	end
end

nut.command.add("checkwinner", {
	adminOnly = true,
	syntax = "",
	onRun = function(client, arguments)
		client:notify(PLUGIN.winner and PLUGIN.winner or "No one has completed the challenge yet.") 
	end
})