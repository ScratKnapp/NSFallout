if CLIENT then return end
util.AddNetworkString("NetNeonCitiesFetch")
util.AddNetworkString("NetNeonCitiesData")
util.AddNetworkString("NetNeonCitiesSave")
util.AddNetworkString("NetNeonCitiesError")
util.AddNetworkString("NetNeonCitiesMySites")
local DATA_DIR = "CYR_neoncities"
local MAX_SITES = 3
if not file.Exists(DATA_DIR, "DATA") then file.CreateDir(DATA_DIR) end
if not file.Exists(DATA_DIR .. "/pages", "DATA") then file.CreateDir(DATA_DIR .. "/pages") end
-- Index: [handle] = { owner = charID, created = timestamp }
local SITE_INDEX = {}
local function LoadIndex()
    if file.Exists(DATA_DIR .. "/index.json", "DATA") then
        local json = file.Read(DATA_DIR .. "/index.json", "DATA")
        SITE_INDEX = util.JSONToTable(json) or {}
    end
end

LoadIndex()
local function SaveIndex()
    file.Write(DATA_DIR .. "/index.json", util.TableToJSON(SITE_INDEX, true))
end

local function GetCharacterID(ply)
    if ply.getChar then
        local char = ply:getChar()
        if char then return char:getID() end
    end
    -- Fallback for non-nutscript or testing
    return ply:SteamID()
end

-- Handlers
net.Receive("NetNeonCitiesFetch", function(len, ply)
    local handle = net.ReadString() -- "myhandle" or "my_sites"
    if handle == "my_sites" then
        local charID = GetCharacterID(ply)
        local mySites = {}
        for h, data in pairs(SITE_INDEX) do
            if data.owner == charID then table.insert(mySites, h) end
        end

        net.Start("NetNeonCitiesMySites")
        net.WriteTable(mySites)
        net.Send(ply)
        return
    end

    -- Fetch specific page
    if not SITE_INDEX[handle] then
        net.Start("NetNeonCitiesError")
        net.WriteString("404: Node not initialized.")
        net.Send(ply)
        return
    end

    local path = DATA_DIR .. "/pages/" .. handle .. ".txt"
    local content = "<h1>Empty Node</h1>"
    if file.Exists(path, "DATA") then content = file.Read(path, "DATA") end
    net.Start("NetNeonCitiesData")
    net.WriteString(handle)
    net.WriteString(content)
    net.Send(ply)
end)

net.Receive("NetNeonCitiesSave", function(len, ply)
    local handle = net.ReadString()
    local content = net.ReadString() -- Full HTML
    local charID = GetCharacterID(ply)
    if not handle or handle == "" or #handle > 32 then
        net.Start("NetNeonCitiesError")
        net.WriteString("Invalid handle.")
        net.Send(ply)
        return
    end

    -- Check if exists
    if SITE_INDEX[handle] then
        -- Verify ownership
        if SITE_INDEX[handle].owner ~= charID then
            net.Start("NetNeonCitiesError")
            net.WriteString("Access Denied: You do not own this node.")
            net.Send(ply)
            return
        end
    else
        -- Create new? Check limit
        local count = 0
        for _, data in pairs(SITE_INDEX) do
            if data.owner == charID then count = count + 1 end
        end

        if count >= MAX_SITES then
            net.Start("NetNeonCitiesError")
            net.WriteString("Quota Exceeded (Max " .. MAX_SITES .. ").")
            net.Send(ply)
            return
        end

        -- Register
        SITE_INDEX[handle] = {
            owner = charID,
            created = os.time()
        }

        SaveIndex()
    end

    -- Save Content
    -- Limit content size
    if #content > 50000 then -- 50KB limit
        net.Start("NetNeonCitiesError")
        net.WriteString("Buffer Overflow: Content too large.")
        net.Send(ply)
        return
    end

    file.Write(DATA_DIR .. "/pages/" .. handle .. ".txt", content)
    net.Start("NetNeonCitiesError")
    net.WriteString("SUCCESS: Node updated.")
    net.Send(ply)
    -- Refresh list if new
    local mySites = {}
    for h, data in pairs(SITE_INDEX) do
        if data.owner == charID then table.insert(mySites, h) end
    end

    net.Start("NetNeonCitiesMySites")
    net.WriteTable(mySites)
    net.Send(ply)
end)