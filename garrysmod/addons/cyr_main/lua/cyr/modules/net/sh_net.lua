CYR = CYR or {}
CYR.Net = CYR.Net or {}
if SERVER then
    AddCSLuaFile("CYR/modules/net/pages/create_profile.lua")
    AddCSLuaFile("CYR/modules/net/pages/feed.lua")
    AddCSLuaFile("CYR/modules/net/pages/messages.lua")
    AddCSLuaFile("CYR/modules/net/pages/post_view.lua")
    AddCSLuaFile("CYR/modules/net/pages/profile_view.lua")
    AddCSLuaFile("CYR/modules/net/pages/search_results.lua")
    AddCSLuaFile("CYR/modules/net/cl_html_templates.lua")
    AddCSLuaFile("CYR/modules/net/pages/free_the_files.lua")
    AddCSLuaFile("CYR/modules/net/pages/free_eddies.lua")
    AddCSLuaFile("CYR/modules/net/pages/page_unsorted.lua")
    include("CYR/modules/net/sv_neoncities.lua")
    -- CHESS MULTIPLAYER LOGIC
    local chess_lobbies = {}
    netstream.Hook("NetChessJoin", function(client, lobbyID)
        lobbyID = string.lower(lobbyID or "global")
        if not chess_lobbies[lobbyID] then chess_lobbies[lobbyID] = {} end
        -- Remove from potential other lobbies
        for lid, players in pairs(chess_lobbies) do
            for i, p in ipairs(players) do
                if p == client then
                    table.remove(players, i)
                    break
                end
            end
        end

        table.insert(chess_lobbies[lobbyID], client)
        -- Notify others in lobby
        for _, p in ipairs(chess_lobbies[lobbyID]) do
            if IsValid(p) and p ~= client then netstream.Start(p, "NetChessPlayerJoined", client:Name()) end
        end

        -- Send confirmation
        netstream.Start(client, "NetChessJoined", lobbyID, #chess_lobbies[lobbyID])
    end)

    netstream.Hook("NetChessMove", function(client, lobbyID, fen, moveSan)
        lobbyID = string.lower(lobbyID or "global")
        if not chess_lobbies[lobbyID] then return end
        -- Broadcast to others in lobby
        for _, p in ipairs(chess_lobbies[lobbyID]) do
            if IsValid(p) and p ~= client then netstream.Start(p, "NetChessUpdate", fen, moveSan) end
        end
    end)

    netstream.Hook("NetChessInvite", function(client, targetName, lobbyID)
        local target = nut.util.findPlayer(targetName)
        if IsValid(target) then
            netstream.Start(target, "NetChessInvited", client:Name(), lobbyID)
            client:notify("Invitation sent to " .. target:Name())
        else
            client:notify("Could not find player: " .. targetName)
        end
    end)
end

nut.command.add("net", {
    syntax = "[string url_or_handle]",
    onRun = function(client, arguments)
        if SERVER then
            local target = nil
            if arguments and arguments[1] then
                target = arguments[1]
                -- Easter Egg / Alias
                if string.lower(target) == "ages" then
                    target = "net://bomb.df"
                    -- If it's a handle (starts with @), convert to profile URL
                elseif string.StartWith(target, "@") then
                    target = "net://profile/" .. string.sub(target, 2)
                elseif not string.StartWith(target, "net://") then
                    -- Assume it's a handle if no protocol  
                    target = "net://profile/" .. target
                end
            end

            netstream.Start(client, "NetOpen", target)
        end
    end
})