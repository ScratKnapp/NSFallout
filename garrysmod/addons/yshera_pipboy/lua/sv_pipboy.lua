-- SERVER
util.AddNetworkString("pipboy")
util.AddNetworkString("pipboy_fix")
util.AddNetworkString("pipboy_toggle")



-- The client requests pipboy bone manipulation values on init; this only sends
-- the visual layout strings the clientside viewmodel rig uses.

-- Tell the client to rebuild its pipboy UI after a character spawn, otherwise
-- references to LocalPlayer():getChar() set up at file-load time go stale.
hook.Add("PlayerLoadedChar", "resetPipboy", function(client, char, data)
    net.Start("pipboy_fix")
    net.Send(client)
end)

local function registerNUT()
    nut.command.add("charsettraitid", {
        adminOnly = true,
        syntax = "<string name> <int trait>",
        onRun = function(client, arguments)
            if not arguments[2] then return L("invalidArg", client, 2) end
            local target = nut.command.findPlayer(client, arguments[1])
            if IsValid(target) and target:getChar() then
                target:getChar():setTrait(tonumber(arguments[2]) or 0)
            end
        end
    })
end

if nut or NUT or Nut then registerNUT() end
hook.Add("InitializedPlugins", "InitializedPlugins_SV_POLK", registerNUT)
