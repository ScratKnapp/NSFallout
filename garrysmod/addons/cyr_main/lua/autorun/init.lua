-- 2025 Evi // CYR Framework
-- Show tooltips when hovering over empty equipment slots in inventory
SHOULDSHOWTOOLTIPSWHENEMPTY = true
-- Quick allocate attributes on click in attribute menu, instead of popup instantly allocates
QUICKALLOCATEONCLICK = true
--  _._     _,-'""`-._
-- (,-.`._,'(       |\`-/|
--     `-.-' \ )-`( , o o)
--           `-    \`_`"'- 
-- BELOW IS THE CYR FRAMEWORK CORE DO NOT TOUCH, or you can but if it breaks dont blame me
-- /shrug
NWL = NWL or {}
NWL.CurrencyName = "Credits"
NWL.CurrencySymbol = "Cr"
rgb = Color
NWL.ItemPickupTime = 1.5
-- Compass Calibration
CreateConVar("nwl_compass_offset", "0", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Global compass degree offset for map geometry alignment.")
if SERVER then
    concommand.Add("nwl_set_compass_offset", function(ply, cmd, args)
        if IsValid(ply) and not ply:IsAdmin() then
            ply:ChatPrint("Permission Denied: Admin access required.")
            return
        end

        local val = tonumber(args[1])
        if val then
            GetConVar("nwl_compass_offset"):SetFloat(val)
            local name = IsValid(ply) and ply:Nick() or "Console"
            print("[NWL] Compass offset updated to " .. val .. " by " .. name)
        else
            local msg = "Usage: nwl_set_compass_offset <degrees>"
            if IsValid(ply) then
                ply:ChatPrint(msg)
            else
                print(msg)
            end
        end
    end)
end

-- When on (default), already-stackable items (maxstack > 1) get an unlimited
-- stack. 0 uses each item's own maxstack. Non-stackable items are unaffected.
CreateConVar("nwl_stackable_items_infinite", "1", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "If 1, stackable items have an unlimited stack size. 0 uses each item's own maxstack.")

function NWL.GetStackLimit(maxstack)
    maxstack = tonumber(maxstack)
    if not maxstack or maxstack <= 1 then return maxstack end
    local cv = GetConVar("nwl_stackable_items_infinite")
    if cv and cv:GetBool() then return math.huge end
    return maxstack
end

hook.Add("GetDefaultInventoryType", "CYR_CreateDefaultInventory", function(character) return "simple" end)
hook.Add("PluginShouldLoad", "CYR_PluginLoadCheck", function(uniqueID) if uniqueID == "compass" or uniqueID == "Compass" then return false end end)
hook.Add("RemoveTabsFromMenu", "CYR_RemoveInventoryTab", function(tabs)
    tabs["inv"] = nil
    tabs["Equipment"] = nil
    tabs["equipment"] = nil
end)

AddCSLuaFile()
local function SharedInclude(filename)
    if SERVER then AddCSLuaFile(filename) end
    include(filename)
end

local function ClientInclude(filename)
    if SERVER then AddCSLuaFile(filename) end
    if CLIENT then include(filename) end
end

local function ServerInclude(filename)
    if SERVER then include(filename) end
end

local function includeModule(path, moduleName)
    -- try to include shared file, then client, then server, checking existence first
    local FoundAny = false
    path = "cyr/modules/" .. path
    local sharedFile = path .. "/sh_" .. moduleName .. ".lua"
    if file.Exists(sharedFile, "LUA") then
        SharedInclude(sharedFile)
        FoundAny = true
    end

    local clientFile = path .. "/cl_" .. moduleName .. ".lua"
    if file.Exists(clientFile, "LUA") then
        ClientInclude(clientFile)
        FoundAny = true
    end

    local serverFile = path .. "/sv_" .. moduleName .. ".lua"
    if file.Exists(serverFile, "LUA") then
        print("[CYR] Including server file: " .. serverFile)
        ServerInclude(serverFile)
        FoundAny = true
    end

    if not FoundAny then print("[CYR] Module not found: " .. moduleName .. " in path: " .. path) end
end

local function _IMPEL()
    includeModule("pac", "pac_var")
    includeModule("ui", "paint_equipmentMenu")
    includeModule("ui", "equipmentMenu")
    includeModule("ui", "fonts")
    includeModule("ui", "f1_html_content")
    includeModule("ui", "f4_html_content") -- inventory html
    includeModule("ui", "tabs_inventory") -- inventory tab logic
    includeModule("ui", "f1_menu")
    includeModule("ui", "hud_interface")
    includeModule("ui", "repaintNSMenu")
    includeModule("ui", "tooltip")
    includeModule("admin", "admin_spawnmenu")
    includeModule("chat", "chatmodify")
    includeModule("attributes", "attributes")
    includeModule("combatmodel", "combatmodel")
    includeModule("combatmodel", "definitions")
    includeModule("item", "itemmenufix")
    includeModule("ui", "char_html_content")
    includeModule("ui", "char_menu")
    includeModule("item", "item_pickup")
    includeModule("item", "stacking")
    -- Combat action menu uses the derma version (cl_actionlist.lua);
    -- leaving these out makes nutActionList fall back to it.
    -- includeModule("ui", "actis_html_content")
    -- includeModule("ui", "actis_ui_override")
    includeModule("ui", "combat_hud_theme")
    includeModule("ui", "safebox_html_content")
    includeModule("ui", "safebox_menu")
    includeModule("ui", "list_storage")
    includeModule("ui", "notify_override")
end

hook.Add("InitializedPlugins", "CYR_InitComplete", _IMPEL)

if nut and nut.util then _IMPEL() end