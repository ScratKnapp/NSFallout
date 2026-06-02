-- THEOPATHY 2019
-- RADIO SYSTEM 
function Radio_Reset()
    if CLIENT then
        local aftermath_cl_radio_volume = CreateClientConVar("aftermath_cl_radio_volume", "0.5", true, false, "The volume the radio plays on your local character (0.0 - 4.0)")
        local volumecache = nil
        playingindex = 0
        StationName = {"The Pass Radio", "East STATION", "Caps & Vinyl", "Fission.FM", "Classics Radio"}
        radioFreq = {}
        radioFreq[1] = 16
        radioFreq[2] = 5
        radioFreq[3] = 7
        radioFreq[4] = 100
        radioHeight = {}
        local songname = "NA"
        stations = {"https://a7.asurahosting.com/listen/the_pass_radio/radio.mp3", "http://fallout.fm:8000/falloutfm6.ogg", "http://fallout.fm:8000/falloutfm10.ogg", "http://fallout.fm:8000/falloutfm3.ogg", "http://fallout.fm:8000/falloutfm1.ogg"}
        local function AddStation(a, b, c)
            table.insert(StationName, a)
            table.insert(stations, b)
            table.insert(radioFreq, c or 90)
        end

        hook.Run("ADD_RADIO_STATIONS", AddStation)
        EV_RAIDO_STATIONS_GET_SONG = {"http://fallout.fm/now_playing.php?the_stream=http%3A%2F%2Ffallout.fm%3A8000%2Ffalloutfm6.ogg", [[http://theopathy.net/fallout9.php]], "http://fallout.fm/now_playing.php?the_stream=http%3A%2F%2Ffallout.fm%3A8000%2Ffalloutfm3.ogg", "http://fallout.fm/now_playing.php?the_stream=http%3A%2F%2Ffallout.fm%3A8000%2Ffalloutfm1.ogg"}
        -- fix because gmod hated this url uses a mirror
        local disablechatmessages = true
        function EV_RADIO_PUBLIC_CON(x)
            LocalPlayer():ConCommand("aftermath_cl_radio_changestation " .. x or "")
            hook.Run("updatedRadio", x)
        end

        hook.Add("updatedRadio", "updatedRadio", function(stat)
            if disablechatmessages then
            else
                chat.AddText(Color(255, 140, 0), "Now Playing: ", Color(255, 207, 158), stat)
            end
        end)

        function EV_RADIO_TOGGLE()
            LocalPlayer():ConCommand("aftermath_cl_radio_toggle")
        end

        function EV_RADIO_OFF()
            LocalPlayer():ConCommand("aftermath_cl_radio_off")
        end

        function EV_RADIO_GETINDEX()
            return playingindex
        end


        local radioRequestID = 0

        local function radioStop()
            if IsValid(AUDIORADIO) then AUDIORADIO:Stop() end
            AUDIORADIO = nil
        end

  
        local function radioLoad(index)
            if not stations[index] then return end
            radioRequestID = radioRequestID + 1
            local reqID = radioRequestID
            radioStop()
            playingindex = index
            loadingnew = false
            sound.PlayURL(stations[index], "noplay noblock", function(s)
                if not IsValid(s) then return end
                if reqID ~= radioRequestID then s:Stop() return end -- superseded
                radioStop() -- drop any earlier load that finished before us
                AUDIORADIO = s
                s:Play()
                s:SetVolume(math.Clamp(aftermath_cl_radio_volume:GetFloat(), 0, 10))
                loadingnew = true
            end)
        end

        -- Stop playback and cancel any in-flight load (bumping the id makes their
        -- callbacks discard themselves).
        local function radioOff()
            radioRequestID = radioRequestID + 1
            radioStop()
            loadingnew = false
            playingindex = 0
        end

        hook.Add("Think", "think_audioradio", function()
            -- Auto-recover a stream that dropped (buffer underrun -> STOPPED).
            if IsValid(AUDIORADIO) and AUDIORADIO:GetState() == GMOD_CHANNEL_STOPPED and loadingnew then
                radioLoad(playingindex)
            end

            local cvarvolume = aftermath_cl_radio_volume:GetFloat()
            if IsValid(AUDIORADIO) and cvarvolume ~= volumecache then
                AUDIORADIO:SetVolume(math.Clamp(cvarvolume, 0, 10))
                volumecache = cvarvolume
            end
        end)

        concommand.Add("aftermath_cl_radio_off", function(ply, cmd, args)
            radioOff()
        end)

        concommand.Add("aftermath_cl_radio_on", function(ply, cmd, args)
            if not (IsValid(AUDIORADIO) and (AUDIORADIO:GetState() == GMOD_CHANNEL_PLAYING or AUDIORADIO:GetState() == GMOD_CHANNEL_STALLED)) then
                radioLoad(playingindex)
            end
        end)

        concommand.Add("aftermath_cl_radio_toggle", function(ply, cmd, args)
            if IsValid(AUDIORADIO) and (AUDIORADIO:GetState() == GMOD_CHANNEL_PLAYING or AUDIORADIO:GetState() == GMOD_CHANNEL_STALLED) then
                radioOff()
            else
                radioLoad(playingindex)
            end
        end)

        local lastsong
        timer.Create("nowplayingupdate", 1, 0, function()
            if stations[playingindex] then
                http.Fetch("http://fallout.fm/now_playing.php?the_stream=" .. stations[playingindex], function(b, a, c, d)
                    if lastsong ~= b and disablechatmessages ~= true then
                        lastsong = b
                        chat.AddText(Color(255, 140, 0), "Now Playing: ", Color(255, 207, 158), b)
                    end
                end, function() end)
            end
        end)

        concommand.Add("aftermath_cl_radio_changestation", function(ply, cmd, args)
            local target
            if #args == 0 then
                -- No arg: advance to the next station, wrapping around.
                target = (tonumber(playingindex) or 0) % #stations + 1
            else
                target = math.Clamp(tonumber(args[1]) or 1, 1, #stations)
            end
            -- Already tuned and actually playing it? Don't restart the stream.
            if target == playingindex and IsValid(AUDIORADIO) then return end
            radioLoad(target)
            if not disablechatmessages then chat.AddText(Color(255, 140, 0), "Changed station to: ", Color(255, 207, 158), StationName[target]) end
        end)
    end
end

Radio_Reset()