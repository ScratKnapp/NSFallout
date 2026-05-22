local PLUGIN = PLUGIN or {}
nut.char.registerVar("pac", {
    default = {},
    field = "_pac",
    noNetworking = true, -- Prevent auto-sync of large data
    onSet = function(character, key, value, noReplication, receiver)
        local pac = character:getPac()
        local client = character:getPlayer()
        pac[key] = value
        -- Disable standard netstream replication for large data
        -- if not noReplication and IsValid(client) then netstream.Start(receiver or client, "charPac", character:getID(), key, value) end
        character.vars.pac = pac
    end,
    onGet = function(character, key, default)
        local pac = character.vars.pac or {}
        if key then
            if not pac then return default end
            local value = pac[key]
            return value == nil and default or value
        else
            return default or pac
        end
    end
})

if CLIENT then
    netstream.Hook("charPac", function(id, key, value)
        local character = nut.char.loaded[id]
        if character then
            character.vars.pac = character.vars.pac or {}
            character.vars.pac[key] = value
        end
    end)
end