-- CYR DHTML Chat - Client-Side Wrapper
-- Replaces NutScript chatbox with DHTML panel
if SERVER then return end
include("cl_chat_html.lua")
CYR = CYR or {}
CYR.Chat = CYR.Chat or {}
-- ============================================
-- DHTML CHAT PANEL
-- ============================================
local chatPanel = nil
local chatHTML = nil
local chatEntry = nil
local chatActive = false
local combatPoppedOut = false
-- Pop-out combat log
local combatPopout = nil
local combatPopoutHTML = nil
-- SAFETY: Define variable for zombie panels still reading it
CYR.Chat.LastMessageTime = CurTime()
-- Clean up any Derma versions if they exist
if IsValid(CYR.Chat.Panel) and CYR.Chat.Panel.RichText then CYR.Chat.Panel:Remove() end
-- Scan for orphaned chat panels (Derma version had .RichText property)
for _, p in ipairs(vgui.GetWorldPanel():GetChildren()) do
    if IsValid(p) and p.RichText and p.Remove then p:Remove() end
end

-- ============================================
-- HELPERS
-- ============================================
local function SendToJS(hookName, data)
    if not IsValid(chatHTML) then return end
    local json = util.TableToJSON(data or {})
    local b64 = util.Base64Encode(json)
    if b64 then
        b64 = string.gsub(b64, "\n", "")
        b64 = string.gsub(b64, "\r", "")
    end

    chatHTML:Call("Webhooks.trigger('" .. hookName .. "', JSON.parse(atob('" .. b64 .. "')))")
end

local function SendToPopoutJS(hookName, data)
    if not IsValid(combatPopoutHTML) then return end
    local json = util.TableToJSON(data or {})
    local b64 = util.Base64Encode(json)
    if b64 then
        b64 = string.gsub(b64, "\n", "")
        b64 = string.gsub(b64, "\r", "")
    end

    combatPopoutHTML:Call("Webhooks.trigger('" .. hookName .. "', JSON.parse(atob('" .. b64 .. "')))")
end

local function LoadColors()
    local colors = {
        primary = cookie.GetString("cyr_f4_primary", "#FF4400"),
        secondary = cookie.GetString("cyr_f4_secondary", "#E0E0E0"),
        tertiary = cookie.GetString("cyr_f4_tertiary", "#FF0000")
    }

    SendToJS("updateColors", colors)
    if IsValid(combatPopoutHTML) then SendToPopoutJS("updateColors", colors) end
end

-- ============================================
-- CHAT FILTERS (NutScript categories)
-- ============================================
local function GetFilterCategories()
    local seen = {}
    local categories = {}
    if nut and nut.chat and nut.chat.classes then
        for k, v in pairs(nut.chat.classes) do
            local filter = v.filter or "ic"
            if not seen[filter] then
                seen[filter] = true
                categories[#categories + 1] = filter
            end
        end
    end

    local defaults = {"ic", "actions", "ooc", "pm"}
    for _, d in ipairs(defaults) do
        if not seen[d] then categories[#categories + 1] = d end
    end

    table.sort(categories)
    return categories
end

local function GetActiveFilters()
    local filters = {}
    local cvar = GetConVar("nut_chatfilter")
    if cvar then
        local str = cvar:GetString():lower()
        if str ~= "none" and str ~= "" then
            for filter in str:gmatch("([^,]+)") do
                filter = filter:Trim()
                if filter ~= "" then filters[#filters + 1] = filter end
            end
        end
    end
    return filters
end

-- ============================================
-- COMMAND AUTOCOMPLETE
-- ============================================
local sentCommands = false
local function SendCommands()
    if sentCommands then return end
    if not (nut and nut.command and nut.command.list) then return end
    local commands = {}
    for cmd, data in pairs(nut.command.list) do
        -- Filter by access
        if nut.command.hasAccess(LocalPlayer(), cmd) then
            -- Only include primary commands (skip aliases if they point to same table)
            -- But we want all usable aliases. NutScript stores aliases as separate entries pointing to same data.
            commands[#commands + 1] = {
                cmd = cmd,
                syntax = data.syntax or "",
                desc = data.desc or ""
            }
        end
    end

    table.sort(commands, function(a, b) return a.cmd < b.cmd end)
    SendToJS("updateCommands", {
        commands = commands
    })

    sentCommands = true
end

local function InitFilters()
    local categories = GetFilterCategories()
    local activeFilters = GetActiveFilters()
    SendToJS("initFilters", {
        categories = categories,
        activeFilters = activeFilters
    })

    SendCommands()
end

-- ============================================
-- SERIALIZE chat.AddText ARGS TO SEGMENTS
-- ============================================
local function SerializeChatArgs(...)
    local args = {...}
    local segments = {}
    local currentColor = {
        r = 255,
        g = 255,
        b = 255
    }

    for i = 1, #args do
        local v = args[i]
        if IsColor(v) then
            currentColor = {
                r = v.r,
                g = v.g,
                b = v.b
            }
        elseif type(v) == "Player" and IsValid(v) then
            local tc = team.GetColor(v:Team())
            table.insert(segments, {
                text = v:Name(),
                r = tc.r or 255,
                g = tc.g or 255,
                b = tc.b or 255
            })
        elseif type(v) == "string" then
            table.insert(segments, {
                text = v,
                r = currentColor.r,
                g = currentColor.g,
                b = currentColor.b
            })
        end
    end
    return segments
end

-- ============================================
-- RESIZE HANDLE HELPERS
-- ============================================
local CHAT_MIN_W, CHAT_MIN_H = 300, 180
local RESIZE_GRIP = 12
-- ============================================
-- CREATE THE CHAT PANEL
-- ============================================
function CYR.Chat.Create()
    -- Remove existing
    if IsValid(chatPanel) then chatPanel:Remove() end
    local scrW, scrH = ScrW(), ScrH()
    local savedW = cookie.GetNumber("cyr_chat_w", scrW * 0.4)
    local savedH = cookie.GetNumber("cyr_chat_h", scrH * 0.35)
    local border = 32
    -- Main panel (invisible container, resizable)
    chatPanel = vgui.Create("DPanel")
    chatPanel:SetPos(border, scrH - savedH - border - 36)
    chatPanel:SetSize(savedW, savedH)
    chatPanel:SetPaintedManually(false)
    chatPanel:SetMouseInputEnabled(false)
    chatPanel:SetKeyboardInputEnabled(false)
    -- Resize state
    local resizing = false
    local resizeStartX, resizeStartY = 0, 0
    local resizeStartW, resizeStartH = 0, 0
    chatPanel.Paint = function(self, w, h)
        -- Draw resize grip when chat is active
        if chatActive then
            local pc = HexToColor(cookie.GetString("cyr_f4_primary", "#FF4400"))
            -- Bottom-right corner grip
            surface.SetDrawColor(pc.r, pc.g, pc.b, 80)
            for i = 0, 2 do
                local offset = RESIZE_GRIP - (i * 4)
                surface.DrawLine(w - offset, h, w, h - offset)
            end
        end
    end

    chatPanel.OnCursorMoved = function(self, x, y)
        if not chatActive then return end
        local w, h = self:GetSize()
        -- Show resize cursor near bottom-right corner
        if x > w - RESIZE_GRIP and y > h - RESIZE_GRIP then
            self:SetCursor("sizenwse")
        else
            self:SetCursor("arrow")
        end
    end

    chatPanel.OnMousePressed = function(self, code)
        if code ~= MOUSE_LEFT or not chatActive then return end
        local x, y = self:CursorPos()
        local w, h = self:GetSize()
        if x > w - RESIZE_GRIP and y > h - RESIZE_GRIP then
            resizing = true
            resizeStartX, resizeStartY = gui.MousePos()
            resizeStartW, resizeStartH = self:GetSize()
            self:MouseCapture(true)
        end
    end

    chatPanel.OnMouseReleased = function(self, code)
        if code ~= MOUSE_LEFT then return end
        if resizing then
            resizing = false
            self:MouseCapture(false)
            -- Save size
            local w, h = self:GetSize()
            cookie.Set("cyr_chat_w", w)
            cookie.Set("cyr_chat_h", h)
        end
    end

    chatPanel.Think = function(self)
        if resizing then
            local mx, my = gui.MousePos()
            local dw = mx - resizeStartX
            local dh = my - resizeStartY
            local newW = math.max(CHAT_MIN_W, resizeStartW + dw)
            local newH = math.max(CHAT_MIN_H, resizeStartH + dh)
            self:SetSize(newW, newH)
            -- Reposition so bottom stays put
            local scrH2 = ScrH()
            self:SetPos(32, scrH2 - newH - 32 - 36)
            -- Update text entry width
            if IsValid(chatEntry) then
                chatEntry:SetWide(newW - 8)
                local px, py = self:GetPos()
                chatEntry:SetPos(px + 4, py + newH + 2)
            end
        end
    end

    -- DHTML
    chatHTML = vgui.Create("DHTML", chatPanel)
    chatHTML:Dock(FILL)
    chatHTML:SetMouseInputEnabled(false)
    chatHTML:SetKeyboardInputEnabled(false)
    chatHTML.Paint = function() end
    -- Register JS -> Lua webhook
    chatHTML:AddFunction("gmod", "webhook", function(name, jsonStr)
        local data = {}
        if jsonStr and jsonStr ~= "" then data = util.JSONToTable(jsonStr) or {} end
        if name == "popOutCombatLog" then
            CYR.Chat.PopOutCombatLog()
        elseif name == "combatLogEntry" then
            if IsValid(combatPopoutHTML) then SendToPopoutJS("addCombatEntry", data) end
        elseif name == "combatChatEntry" then
            if IsValid(combatPopoutHTML) then SendToPopoutJS("addCombatChatMessage", data) end
        elseif name == "transferCombatMessages" then
            -- Forward existing combat messages from main chat to pop-out
            if IsValid(combatPopoutHTML) then timer.Simple(0.2, function() if IsValid(combatPopoutHTML) then SendToPopoutJS("insertCombatHTML", data) end end) end
        elseif name == "filterChanged" then
            local filters = data.filters or {}
            if #filters == 0 then
                RunConsoleCommand("nut_chatfilter", "none")
            else
                RunConsoleCommand("nut_chatfilter", table.concat(filters, ","))
            end
        end
    end)

    chatHTML:SetHTML(CYR.UI.ChatHTML or "<h1>CHAT ERROR</h1>")
    -- Load colors and filters after a brief delay
    timer.Simple(0.3, function()
        if IsValid(chatHTML) then
            LoadColors()
            InitFilters()
            -- Restore popped-out state
            if combatPoppedOut then
                SendToJS("setPoppedOut", {
                    state = true
                })
            end
        end
    end)

    -- Store ref
    CYR.Chat.panel = chatPanel
    CYR.Chat.html = chatHTML
    CYR.Chat.html = chatHTML
end

-- ============================================
-- AUTOCOMPLETE HELPER
-- ============================================
local function SetupAutocomplete(entry)
    if not (nut and nut.command) then return end
    local suggestions = {}
    local selected = 0
    local suggestionPanel
    function entry:UpdateSuggestions()
        if IsValid(suggestionPanel) then suggestionPanel:Remove() end
        suggestions = {}
        selected = 0
        local text = self:GetText() or ""
        if text:sub(1, 1) ~= "/" or #text < 1 then return end
        local cmdInput = text:sub(2):lower()
        local available = {}
        for k, v in pairs(nut.command.list) do
            if nut.command.hasAccess(LocalPlayer(), k) then
                if k:lower():find(cmdInput, 1, true) then
                    available[#available + 1] = {
                        cmd = k,
                        syntax = v.syntax or "",
                        desc = v.desc or ""
                    }
                end
            end
        end

        table.sort(available, function(a, b) return a.cmd < b.cmd end)
        suggestions = available
        if #suggestions > 0 then
            suggestionPanel = vgui.Create("DPanel")
            suggestionPanel:SetParent(vgui.GetWorldPanel())
            suggestionPanel:SetDrawOnTop(true)
            local h = math.min(#suggestions, 5) * 20 + 4
            suggestionPanel:SetSize(entry:GetWide(), h)
            local ex, ey = entry:LocalToScreen(0, 0)
            suggestionPanel:SetPos(ex, ey - h - 2)
            function suggestionPanel:Paint(w, h)
                DisableClipping(true)
                surface.SetDrawColor(0, 0, 0, 240)
                surface.DrawRect(0, 0, w, h)
                surface.SetDrawColor(255, 255, 255, 20)
                surface.DrawOutlinedRect(0, 0, w, h)
                surface.SetFont("nutChatFont")
                for i = 1, math.min(#suggestions, 5) do
                    local data = suggestions[i]
                    local y = (i - 1) * 20 + 2
                    if i == selected then
                        surface.SetDrawColor(255, 255, 255, 20)
                        surface.DrawRect(2, y, w - 4, 18)
                    end

                    draw.SimpleText("/" .. data.cmd, "nutChatFont", 6, y, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                    if data.syntax ~= "" then
                        local tw, _ = surface.GetTextSize("/" .. data.cmd)
                        draw.SimpleText(data.syntax, "nutChatFont", 6 + tw + 10, y, Color(150, 150, 150), TEXT_ALIGN_LEFT)
                    end
                end

                DisableClipping(false)
            end
        end
    end

    entry.OnChange = function(self)
        self:UpdateSuggestions()
        -- Also run the ChatTextChanged hook that NutScript expects
        local text = self:GetText()
        hook.Run("ChatTextChanged", text)
    end

    local oldKeyCode = entry.OnKeyCodeTyped
    entry.OnKeyCodeTyped = function(self, code)
        if IsValid(suggestionPanel) and #suggestions > 0 then
            if code == KEY_UP then
                selected = selected - 1
                if selected < 1 then selected = #suggestions end
                return true
            elseif code == KEY_DOWN then
                selected = selected + 1
                if selected > math.min(#suggestions, 5) then selected = 1 end
                return true
            elseif code == KEY_TAB or (code == KEY_ENTER and selected > 0) then
                local data = suggestions[selected > 0 and selected or 1]
                if data then
                    self:SetText("/" .. data.cmd .. " ")
                    self:SetCaretPos(self:GetText():len())
                    self:UpdateSuggestions()
                    return true
                end
            end
        end

        if code == KEY_TAB then
            CYR.Chat.Close()
            return true
        end

        if oldKeyCode then return oldKeyCode(self, code) end
    end
end

function CYR.Chat.Open()
    if chatActive then return end
    if not IsValid(chatPanel) then CYR.Chat.Create() end
    chatActive = true
    -- Enable mouse on DHTML for tab clicks
    chatHTML:SetMouseInputEnabled(true)
    chatPanel:SetMouseInputEnabled(true)
    -- Tell JS we're active
    SendToJS("setActive", {
        active = true
    })

    -- Enable interaction on combat popout while chat is open
    if IsValid(combatPopout) then combatPopout:SetMouseInputEnabled(true) end
    -- Create text entry
    local px, py = chatPanel:GetPos()
    local panelW, panelH = chatPanel:GetSize()
    chatEntry = vgui.Create("DTextEntry")
    chatEntry:SetPos(px + 4, py + panelH + 2)
    chatEntry:SetSize(panelW - 8, 28)
    chatEntry:SetFont("nutChatFont")
    chatEntry:SetPaintBackground(false)
    chatEntry:SetTextColor(Color(255, 255, 255))
    chatEntry:SetAllowNonAsciiCharacters(true)
    chatEntry:SetHistoryEnabled(true)
    chatEntry.History = nut.chat and nut.chat.history or {}
    -- SetupAutocomplete will handle OnChange and key events
    SetupAutocomplete(chatEntry)
    chatEntry.Paint = function(self, w, h)
        surface.SetDrawColor(5, 5, 5, 230)
        surface.DrawRect(0, 0, w, h)
        local primaryHex = cookie.GetString("cyr_f4_primary", "#FF4400")
        local pc = HexToColor(primaryHex)
        surface.SetDrawColor(pc.r, pc.g, pc.b, 80)
        surface.DrawOutlinedRect(0, 0, w, h)
        self:DrawTextEntryText(Color(255, 255, 255, 200), Color(pc.r, pc.g, pc.b), Color(255, 255, 255, 200))
    end

    chatEntry.OnEnter = function(self)
        local text = self:GetText()
        CYR.Chat.Close()
        if text and text:find("%S") then
            nut.chat = nut.chat or {}
            nut.chat.history = nut.chat.history or {}
            if not (nut.chat.lastLine or ""):find(text, 1, true) then
                nut.chat.history[#nut.chat.history + 1] = text
                nut.chat.lastLine = text
            end

            -- Use standard GMod say command instead of netstream.
            -- This fixes issues if the chatbox plugin's server hook is missing.
            LocalPlayer():ConCommand("say \"" .. text:gsub("\"", "\\\"") .. "\"")
        end
    end

    chatEntry:MakePopup()
    chatEntry:RequestFocus()
    hook.Run("StartChat")
end

function CYR.Chat.Close()
    if not chatActive then return end
    chatActive = false
    if IsValid(chatEntry) then chatEntry:Remove() end
    if IsValid(chatHTML) then
        chatHTML:SetMouseInputEnabled(false)
        chatPanel:SetMouseInputEnabled(false)
        SendToJS("setActive", {
            active = false
        })
    end

    -- Disable interaction on combat popout when chat closes
    if IsValid(combatPopout) then
        combatPopout:SetMouseInputEnabled(false)
        combatPopout:SetKeyboardInputEnabled(false)
    end

    hook.Run("FinishChat")
end

-- ============================================
-- POP-OUT COMBAT LOG
-- ============================================
function CYR.Chat.PopOutCombatLog()
    if IsValid(combatPopout) then
        combatPopout:Remove()
        return
    end

    local w, h = 400, 320
    local x = cookie.GetNumber("cyr_combatlog_x", ScrW() - w - 40)
    local y = cookie.GetNumber("cyr_combatlog_y", ScrH() * 0.3)
    combatPopout = vgui.Create("DPanel")
    combatPopout:SetSize(w, h)
    combatPopout:SetPos(x, y)
    combatPopout:SetMouseInputEnabled(false)
    combatPopout:SetKeyboardInputEnabled(false)
    combatPopout.Paint = function() end
    combatPopout.OnRemove = function(self)
        local px, py = self:GetPos()
        cookie.Set("cyr_combatlog_x", px)
        cookie.Set("cyr_combatlog_y", py)
        combatPopout = nil
        combatPopoutHTML = nil
        combatPoppedOut = false
        SendToJS("setPoppedOut", {
            state = false
        })
    end

    -- DHTML fills entire panel
    combatPopoutHTML = vgui.Create("DHTML", combatPopout)
    combatPopoutHTML:Dock(FILL)
    combatPopoutHTML.Paint = function() end
    combatPopoutHTML:SetHTML(CYR.UI.ChatHTML)
    combatPopoutHTML:AddFunction("gmod", "webhook", function(name, jsonStr) if name == "closeCombatPopout" then if IsValid(combatPopout) then combatPopout:Remove() end end end)
    timer.Simple(0.3, function()
        if not IsValid(combatPopoutHTML) then return end
        local colors = {
            primary = cookie.GetString("cyr_f4_primary", "#FF4400"),
            secondary = cookie.GetString("cyr_f4_secondary", "#E0E0E0"),
            tertiary = cookie.GetString("cyr_f4_tertiary", "#FF0000")
        }

        SendToPopoutJS("updateColors", colors)
        combatPopoutHTML:Call("switchTab('combat')")
        combatPopoutHTML:Call("setActive(true)")
        combatPopoutHTML:Call([[
            var tb = document.getElementById('tab-bar');
            tb.style.display = 'flex';
            tb.style.alignItems = 'center';
            tb.style.justifyContent = 'space-between';
            tb.innerHTML = '<span style="padding:0 16px;color:var(--primary-color);font-size:11px;letter-spacing:1px;">COMBAT LOG</span>' +
                '<span onclick="Webhooks.callLua(\'closeCombatPopout\', {})" style="padding:0 12px;color:var(--tertiary-color,#f44);cursor:pointer;font-family:VCR OSD Mono,monospace;font-size:13px;opacity:0.7;">X</span>';
            document.getElementById('filter-bar').style.display = 'none';
            document.getElementById('filter-bar').style.height = '0';
        ]])
        -- Transfer existing combat messages from main chat to pop-out
        timer.Simple(0.2, function() if IsValid(chatHTML) then chatHTML:Call("transferCombatToPopout()") end end)
    end)

    combatPoppedOut = true
    SendToJS("setPoppedOut", {
        state = true
    })
end

-- ============================================
-- OVERRIDE chat.AddText
-- ============================================
chat.cyrOriginalAddText = chat.cyrOriginalAddText or chat.AddText
function chat.AddText(...)
    if not IsValid(chatHTML) then
        chat.cyrOriginalAddText(...)
        return
    end

    local segments = SerializeChatArgs(...)
    -- Read the NutScript CHAT_CLASS filter for category filtering
    local filter = "ic"
    if CHAT_CLASS and CHAT_CLASS.filter then filter = CHAT_CLASS.filter end
    SendToJS("addChatMessage", {
        segments = segments,
        filter = filter
    })

    -- Update last message time for fade tracking
    CYR.Chat.LastMessageTime = CurTime()
    -- Play chat sound
    if SOUND_CUSTOM_CHAT_SOUND and SOUND_CUSTOM_CHAT_SOUND ~= "" then surface.PlaySound(SOUND_CUSTOM_CHAT_SOUND) end
end

-- ============================================
-- ADD COMBAT LOG ENTRY (called from netstream)
-- ============================================
function CYR.Chat.AddCombatEntry(data)
    if IsValid(chatHTML) then SendToJS("addCombatEntry", data) end
end

-- ============================================
-- HOOKS
-- ============================================
-- Hide default chatbox
hook.Add("HUDShouldDraw", "CYR_Chat_HideDefault", function(name) if name == "CHudChat" then return false end end)
-- Intercept messagemode
hook.Add("PlayerBindPress", "CYR_Chat_Bind", function(client, bind, pressed)
    bind = bind:lower()
    if bind:find("messagemode") and pressed then
        if not chatActive then CYR.Chat.Open() end
        return true
    end
end)

-- Close on escape / game UI
hook.Add("Think", "CYR_Chat_Think", function()
    if chatActive then
        if gui.IsGameUIVisible() then CYR.Chat.Close() end
        if not IsValid(chatEntry) then CYR.Chat.Close() end
    end
end)

-- Disable NutScript chatbox plugin hooks so they don't conflict
local function DisableNSChatbox()
    -- Don't remove nut.gui.chat entirely - chatboxextra depends on it for :GetSize()/:GetPos()
    -- Instead, hide it and make it inert
    if nut and nut.gui and IsValid(nut.gui.chat) then
        nut.gui.chat:SetVisible(false)
        nut.gui.chat:SetMouseInputEnabled(false)
        nut.gui.chat:SetKeyboardInputEnabled(false)
        -- Override addText so it doesn't render in the old chatbox
        nut.gui.chat.addText = function() end
    end

    local hooksToClean = {"PlayerBindPress", "HUDShouldDraw", "ChatText", "InitPostEntity"}
    for _, hookName in ipairs(hooksToClean) do
        local tbl = hook.GetTable()[hookName]
        if tbl then
            for id, fn in pairs(tbl) do
                if type(id) == "table" and id.name == "Chatbox" then hook.Remove(hookName, id) end
            end
        end
    end

    if not chat.nutAddText then chat.nutAddText = function() end end
    -- Intercept chatboxextra's cMsg2 AFTER plugins load so we override its hook
    -- Route through combat chat pipeline (shows in combat panel + COMMS when not popped out)
    if netstream then
        netstream.Hook("cMsg2", function(client, chatType, text, anonymous)
            if not IsValid(chatHTML) then return end
            if not (nut and nut.chat and nut.chat.classes) then return end
            local class = nut.chat.classes[chatType]
            if not class then return end
            local name = anonymous and "Someone" or (IsValid(client) and client:Name() or "Console")
            local color = class.color or Color(255, 200, 200)
            if class.onGetColor then color = class.onGetColor(client, text) end
            local formatted = string.format(class.format or "%s: %s", name, text)
            local segments = {
                {
                    text = formatted,
                    r = color.r,
                    g = color.g,
                    b = color.b
                }
            }

            -- Route to combat chat pipeline (both panels)
            SendToJS("addCombatChatMessage", {
                segments = segments
            })

            -- Also forward to pop-out if it exists
            if IsValid(combatPopoutHTML) then
                SendToPopoutJS("addCombatChatMessage", {
                    segments = segments
                })
            end
        end)
    end
end

-- Create on init
hook.Add("InitPostEntity", "CYR_Chat_Init", function()
    timer.Simple(1, function()
        DisableNSChatbox()
        CYR.Chat.Create()
    end)
end)

-- Also disable after plugins reload
hook.Add("InitializedPlugins", "CYR_Chat_DisableNS", function()
    timer.Simple(1.5, function()
        DisableNSChatbox()
        if not IsValid(chatPanel) then CYR.Chat.Create() end
    end)
end)

-- Receive NutScript ChatText events (system messages)
hook.Add("ChatText", "CYR_Chat_SystemMessages", function(index, name, text, messageType)
    if messageType == "none" and IsValid(chatHTML) then
        local segments = {
            {
                text = text,
                r = 200,
                g = 200,
                b = 200
            }
        }

        SendToJS("addChatMessage", {
            segments = segments,
            filter = "ic"
        })
        return true
    end
end)

-- Receive combat log events from server
if netstream then netstream.Hook("cyrCombatLog", function(data) CYR.Chat.AddCombatEntry(data) end) end
-- Re-init on reload (hot-reload support)
if LocalPlayer and IsValid(LocalPlayer()) then
    timer.Simple(0.5, function()
        DisableNSChatbox()
        CYR.Chat.Create()
    end)
end

print("[CYR] DHTML Chat module loaded!")
concommand.Add("FixChatPlz", function()
    CYR.Chat.Create()
    print("[CYR] Chat reloaded via FixChatPlz")
end)