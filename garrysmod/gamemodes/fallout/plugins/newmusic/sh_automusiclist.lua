local PLUGIN = PLUGIN

PLUGIN.autoMusicList = {
    [MUSIC_LEVEL_PAS] = {
        {path = "https://vgmsite.com/soundtracks/scp-containment-breach-ost/pkcdnlzo/02%20-%20Blue%20Feather.mp3", title = "Blue Feather"},
        {path = "https://vgmsite.com/soundtracks/cry-of-fear-gamerip/vpejvwgc/brandon2.mp3", title = "Brandon"},
        {path = "https://vgmsite.com/soundtracks/this-war-of-mine/lzrhgboa/07.%20Things%20Right%20and%20Wrong.mp3", title = "Things Right and Wrong"},
        {path = "dm/jazz_th_v1.wav", title = "Jazz Thieves V1"},
        {path = "dm/jazz_th_v2.wav", title = "Jazz Thieves V2"},
        {path = "dm/tlt.wav", title = "The Love Thieves"},
        {path = "dm/jpainkiller.wav", title = "Junior Painkiller"},
    },
    [MUSIC_LEVEL_COM] = {
        {path = "dm/aptiut.wav", title = "A Pain That I'm Used To"},
        {path = "dm/boag.wav", title = "Barrel of a Gun"},
        {path = "dm/iyrjeep.wav", title = "In Your Room (Jeep Rock Remix)"},
        {path = "dm/jtr.wav", title = "John the Revelator"},
        {path = "dm/black_cel.wav", title = "Black Celebration"},
        {path = "dm/no_imp.wav", title = "Nothing's Impossible"},
        {path = "dm/rush.wav", title = "Rush"},
        {path = "dm/sim.wav", title = "Sinner In Me"},
        {path = "dm/son_trim.wav", title = "Sister of Night"},
        {path = "dm/useless.wav", title = "Useless"},
        {path = "combat/the_revival.wav", title = "The Revival"},
    },
    [MUSIC_LEVEL_DEA] = {
        {path = "dm/wims_nodrum.wav", title = "Walking in My Shoes"},
        {path = "dm/wcover.wav", title = "Wrong"},
        {path = "https://vgmsite.com/soundtracks/the-binding-of-isaac-soundtrack/xdifaauufq/28%20Atempause%20%28C418%20Remix%29.mp3", title = "Atempause"},
    }
}

PLUGIN.menuMusicList = {
    [MUSIC_LEVEL_AMB] = {

    },
    [MUSIC_LEVEL_PAS] = {
        {path = "https://cdn.discordapp.com/attachments/927917390782677002/927917742143701074/Y2Mate.is_-_OLDLegacy_MADNESS_Project_Nexus_OST_Locknar_-_HQ-7_vov7-93og-128k-1641303196845.mp3", title = "HQ - Locknar"},
        {path = "https://cdn.discordapp.com/attachments/927917390782677002/945296326067879936/Y2Mate.is_-_Insurgency_Sandstorm_Operation_Exodus_Menu-L0N0bbPpCWA-160k-1645445849455.mp3", title = "Exodus"},
        {path = "https://cdn.discordapp.com/attachments/927917390782677002/965602622570627102/Caramella_Girls_-_Caramelldansen_HD_Version_Swedish_Original.mp3", title = "Caramelldansen"},
    },
    [MUSIC_LEVEL_COM] = {
        {path = "https://cdn.discordapp.com/attachments/927917390782677002/945296172833198110/Y2Mate.is_-_Insurgency_Sandstorm_OST_-_Extraction_Survival_Mode-goidjbUM7Ts-128k-1645445703583.mp3", title = "Extraction"},
        {path = "https://cdn.discordapp.com/attachments/927917390782677002/945296233919021066/Y2Mate.is_-_Insurgency_Sandstorm_OST_-_Warlord_Menu_Theme-VrrqgbxyyMo-160k-1645445773482.mp3", title = "Warlord"},
        {path = "https://cdn.discordapp.com/attachments/927917390782677002/945296368916910121/Y2Mate.is_-_Insurgency_Sandstorm_Unofficial_Soundtrack_-_Final_Counter_Attack-IF6AZF4ny-k-160k-1645446278074.mp3", title = "Final Counter Attack"},
        {path = "https://cdn.discordapp.com/attachments/927917390782677002/945296698194944020/Y2Mate.is_-_Insurgency_Sandstorm_Operation_Breakpoint_OST-nW89UUS7RAc-160k-1645446674461.mp3", title = "Breakpoint"},
    },
    [MUSIC_LEVEL_DEA] = {

    },
}

for level, music in pairs(PLUGIN.autoMusicList) do
    for _, musicData in pairs(music) do
        table.insert(PLUGIN.menuMusicList[level], {
            path = musicData.path,
            title = musicData.title,
        })
    end
end
