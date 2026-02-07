PLUGIN.name = "Better Music Plugin"
PLUGIN.desc = "Music player with less spaghetti code"
PLUGIN.author = "Tov"
nut.music = nut.music or {}
MUSIC_LEVEL_AMB = 0
MUSIC_LEVEL_PAS = 1
MUSIC_LEVEL_COM = 2
MUSIC_LEVEL_DEA = 3
MUSIC_SELECT_NONE = 0
MUSIC_SELECT_CURLEVEL = 1
MUSIC_SELECT_OTHERLEVEL = 2
MUSIC_SELECT_ALL = 3
nut.util.include("sh_automusiclist.lua")
nut.util.include("sv_music.lua")
nut.util.include("cl_music.lua")
--[[AutoCombat]]
nut.config.add("autoCombatDur", 15, "Maximum duration auto combat music should play (auto music triggers reset this duration).", nil, {
	data = {
		min = 5,
		max = 60
	},
	category = "Music"
})

nut.config.add("passMusicMin", 300, "Minumum time before auto passive music plays again.", nil, {
	data = {
		min = 60, -- 1 minute/1 hour
		max = 3600
	},
	category = "Music"
})

nut.config.add("passMusicMax", 1800, "Minumum time before auto passive music plays again.", nil, {
	data = {
		min = 120, -- 2 minutes /1.5 hour
		max = 5400
	},
	category = "Music"
})
--[[TO-DO
1. Death Music done
2. Auto Music done
3. Support with areas done
4. audio and auto music trigger toggles done
5. make quickMenu options for music
6. make nowPlaying stuff
]]