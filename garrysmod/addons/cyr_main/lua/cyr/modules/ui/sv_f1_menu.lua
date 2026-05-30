print("[F1 Plugin] Loading sv_f1_menu.lua...")
util.AddNetworkString("cyrPluginDisable")
util.AddNetworkString("cyrPluginList")
local function syncPlugins(ply)
    local plugins = {}
    local unloaded = nut.data.get("unloaded", {}, false, true)
    for k, v in pairs(nut.plugin.list) do
        plugins[k] = unloaded[k] == true
    end

    -- Also check for plugins that are NOT in the list but are in the unloaded data
    for k, v in pairs(unloaded) do
        if plugins[k] == nil then plugins[k] = true end
    end

    net.Start("cyrPluginList")
    net.WriteTable(plugins)
    net.Send(ply)
end

net.Receive("cyrPluginList", function(len, ply)
    if not IsValid(ply) or not ply:IsSuperAdmin() then return end
    syncPlugins(ply)
end)

net.Receive("cyrPluginDisable", function(len, ply)
    if not IsValid(ply) or not ply:IsSuperAdmin() then return end
    local pluginName = net.ReadString()
    local status = net.ReadBit() == 1
    -- Use official NutScript setter to be safe
    nut.plugin.setDisabled(pluginName, status)
    -- Notify the admin
    nut.util.notify("Plugin '" .. pluginName .. "' set to " .. (status and "OFF" or "ON") .. ". Restart server to apply changes.", ply)
    -- Sync back to client immediately
    syncPlugins(ply)
end)