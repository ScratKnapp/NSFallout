-- INFO page: replaces the Garry's Mod scoreboard. Lists every player on the
-- server, honours the recognition / nickname system (so strangers stay
-- "[unknown]" until met IC) and exposes admin tools (goto / bring / freeze /
-- slay / kick / force-recognize) on the right-hand detail panel.
--
-- All admin actions round-trip through netstream "pipboy_admin_action" which
-- re-checks IsAdmin on the server -- clients can't spoof access by editing
-- this file.

local newfunc = math.sin
local radioFreq = {}
function surface.OutlinedBox( x, y, w, h, thickness )
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end

-- ===========================================================================
-- PEOPLE: replacement scoreboard
-- ===========================================================================

-- Selected character id (persists across page rebuilds; cleared when target
-- disconnects). Defaults to the local character on first paint.
PIPBOY_INFO_SELECTED = PIPBOY_INFO_SELECTED or nil
PIPBOY_INFO_SCROLL   = PIPBOY_INFO_SCROLL or 0
PIPBOY_INFO_ADMIN_MODE = PIPBOY_INFO_ADMIN_MODE or false -- admin-only: bypass recognition

local INFO_ROW_H        = 30
local INFO_HEADER_H     = 26
local INFO_LIST_X       = 64
local INFO_LIST_Y       = 116
local INFO_LIST_W       = 470
local INFO_LIST_H       = 540
local INFO_DETAIL_X     = 560
local INFO_DETAIL_W     = 400
local INFO_RMB_PREV     = false

-- Compose the visible roster (faction header + rows). Recognition decides if
-- the row shows a name or "[unknown]"; admins (with admin-mode toggled on)
-- see everyone with their real names.
local function info_buildRoster()
    local rows = {}
    local lp = LocalPlayer()
    local localChar = lp:getChar()
    if not localChar then return rows end

    local adminBypass = lp:IsAdmin() and PIPBOY_INFO_ADMIN_MODE

    -- Bucket players by faction index, preserving faction.indices order.
    local buckets = {}
    for _, ply in ipairs(player.GetAll()) do
        local char = ply:getChar()
        if not char then continue end
        local fid = char:getFaction() or 0
        buckets[fid] = buckets[fid] or {}
        table.insert(buckets[fid], ply)
    end

    -- Sort each bucket by display name for stable ordering.
    for _, list in pairs(buckets) do
        table.sort(list, function(a, b)
            return (a:getChar():getName() or ""):lower() < (b:getChar():getName() or ""):lower()
        end)
    end

    for fid, faction in ipairs(nut.faction.indices) do
        local list = buckets[fid]
        if not list then continue end

        -- Hidden factions are concealed from non-admins; admin-mode reveals.
        if faction.hidden and not adminBypass then
            -- Only show if any member is recognized by the local char.
            local anyRecog = false
            for _, ply in ipairs(list) do
                if ply == lp or localChar:doesRecognize(ply:getChar()) then anyRecog = true break end
            end
            if not anyRecog then continue end
        end

        local color = team.GetColor(fid) or pip_color
        table.insert(rows, {type = "header", name = (faction.name or "Unknown"):upper(), color = color})
        for _, ply in ipairs(list) do
            table.insert(rows, {type = "player", ply = ply, faction = faction, color = color})
        end
    end

    return rows, adminBypass
end

-- What does the local character call this player? Mirrors the recognition
-- plugin's display rules so the scoreboard agrees with chat / nameplates.
local function info_displayName(targetPly, localChar, adminBypass)
    local targetChar = targetPly:getChar()
    if not targetChar then return "?" end
    if targetPly == LocalPlayer() then return targetChar:getName() end

    if adminBypass then return targetChar:getName() end

    local alias = localChar:getData("alias", {}) or {}
    local nickname = alias[targetChar:getID()]
    if nickname then return nickname end

    if targetPly:getNetVar("concealed") then return targetPly:Name() end

    local faction = nut.faction.indices[targetChar:getFaction()]
    if faction and faction.isGloballyRecognized then return targetChar:getName() end

    if localChar:doesRecognize(targetChar) then return targetChar:getName() end

    return nil -- caller falls back to description / "[unknown]"
end

local function info_shortDesc(char, max)
    local d = char:getDesc() or ""
    if #d > max then d = d:utf8sub(1, max - 3) .. "..." end
    return d
end

-- Hold-R progress shared by all admin actions; resets when no button is held.
local info_hold_action, info_hold_target, info_hold_start = nil, nil, 0

local function info_doAction(action, charID, needsHold, label)
    if needsHold then
        -- Track a hold-R confirmation; the caller already drew the button.
        if IS_R_DOWN then
            if info_hold_action ~= action or info_hold_target ~= charID then
                info_hold_action, info_hold_target, info_hold_start = action, charID, CurTime()
            end
            local p = math.Clamp((CurTime() - info_hold_start) * 0.75, 0, 1)
            if p >= 1 then
                netstream.Start("pipboy_admin_action", action, charID)
                info_hold_action, info_hold_target, info_hold_start = nil, nil, 0
                return p
            end
            return p
        end
        return 0
    else
        netstream.Start("pipboy_admin_action", action, charID)
        return 1
    end
end

-- Capture mouse-wheel scrolling while INFO is the visible page.
hook.Add("pip_changepage", "info_scroll", function(from, to)
    if to == "INFO" then
        local lastScroll = 0
        hook.Add("PlayerBindPress", "!pipboy_info_scroll", function(ply, bind, pressed, num)
            if num == MOUSE_WHEEL_UP or num == MOUSE_WHEEL_DOWN then return true end
        end)
        hook.Add("PlayerButtonDown", "!pipboy_info_scroll", function(ply, num)
            if num == MOUSE_WHEEL_UP or num == MOUSE_WHEEL_DOWN then
                if lastScroll < CurTime() then
                    lastScroll = CurTime()
                    PIPBOY_INFO_SCROLL = math.max(0, PIPBOY_INFO_SCROLL + (num == MOUSE_WHEEL_UP and -1 or 1))
                end
                return true
            end
        end)
    elseif from == "INFO" then
        hook.Remove("PlayerBindPress", "!pipboy_info_scroll")
        hook.Remove("PlayerButtonDown", "!pipboy_info_scroll")
    end
end)

local function info_drawListRow(row, x, y, w, isSelected)
    -- Faction colour stripe (left).
    surface.SetDrawColor(row.color.r, row.color.g, row.color.b, 200)
    surface.DrawRect(x, y + 2, 4, INFO_ROW_H - 4)

    if isSelected then
        surface.SetDrawColor(pip_color)
        surface.DrawRect(x + 6, y + 2, w - 6, INFO_ROW_H - 4)
    end

    return isSelected and color_black or color_white
end

local function info_drawHeader(row, x, y, w)
    surface.SetDrawColor(row.color.r, row.color.g, row.color.b, 40)
    surface.DrawRect(x, y, w, INFO_HEADER_H)
    surface.SetDrawColor(row.color.r, row.color.g, row.color.b, 200)
    surface.DrawRect(x, y + INFO_HEADER_H - 2, w, 2)
    draw.DrawText(row.name, "Morton Medium@24", x + 8, y + 1, color_white)
end

local function info_drawAdminButton(label, x, y, w, charID, action, needsHold)
    local isIn, click = AddUIButton(x, y, w, 28)
    local bg = isIn and pip_color or pip_color_20
    surface.SetDrawColor(bg)
    surface.DrawRect(x, y, w, 28)
    surface.SetDrawColor(pip_color)
    surface.DrawOutlinedRect(x, y, w, 28)

    if needsHold and isIn then
        if IS_R_DOWN then
            if info_hold_action ~= action or info_hold_target ~= charID then
                info_hold_action, info_hold_target, info_hold_start = action, charID, CurTime()
            end
            local p = math.Clamp((CurTime() - info_hold_start) * 0.75, 0, 1)
            surface.SetDrawColor(pip_color.r * 0.5, pip_color.g * 0.5, pip_color.b * 0.5)
            surface.DrawRect(x, y, w * p, 28)
            if p >= 1 then
                netstream.Start("pipboy_admin_action", action, charID)
                info_hold_action, info_hold_target, info_hold_start = nil, nil, 0
            end
        elseif info_hold_action == action and info_hold_target == charID then
            info_hold_action, info_hold_target, info_hold_start = nil, nil, 0
        end
    end

    draw.DrawText(label .. (needsHold and "  [HOLD R]" or ""), "Morton Medium@24",
        x + w / 2, y + 2, isIn and color_black or color_white, TEXT_ALIGN_CENTER)

    if click and not needsHold then
        netstream.Start("pipboy_admin_action", action, charID)
        return true
    end
    return false
end

-- A small click button used for non-admin actions (nickname management).
local function info_drawTextButton(label, x, y, w, h)
    local isIn, click = AddUIButton(x, y, w, h)
    surface.SetDrawColor(pip_color)
    surface.DrawOutlinedRect(x, y, w, h)
    if isIn then
        surface.SetDrawColor(pip_color.r, pip_color.g, pip_color.b, 50)
        surface.DrawRect(x, y, w, h)
    end
    draw.DrawText(label, "Morton Medium@24", x + w / 2, y + 1, isIn and pip_color or color_white, TEXT_ALIGN_CENTER)
    return click
end

-- Pop a Derma_StringRequest above the pipboy to set / change a nickname.
local function info_promptNickname(charID, existing)
    Derma_StringRequest("Pip-Boy: Set Nickname",
        "Display this character as:",
        existing or "",
        function(text)
            text = (text or ""):Trim()
            if text == "" then return end
            netstream.Start("pipboy_nick_set", charID, text)
        end)
end

-- Pressing the scoreboard bind (TAB / +showscores) opens the pipboy on the
-- INFO page rather than letting Garry's Mod fall back to its native
-- scoreboard. Pressing it again while the pipboy is already up closes it.
hook.Add("PlayerBindPress", "pipboy_info_replaces_scoreboard", function(ply, bind, pressed)
    if not pressed then return end
    if not (bind:lower():find("showscores") or bind == "+score") then return end

    if PIPBOY_ON_SCREEN then
        if pipboy.SelectedHeader == "INFO" then
            TogglePipboyView()
        else
            CHANGE_PIP_BOY_PAGE("INFO")
        end
    else
        if CHANGE_PIP_BOY_PAGE then CHANGE_PIP_BOY_PAGE("INFO") end
        if TogglePipboyView then TogglePipboyView() end
    end
    return true
end)

-- Hide GMod's built-in scoreboard panel entirely; the pipboy INFO page is
-- the only roster surface now.
hook.Add("ScoreboardShow", "pipboy_info_hide_default_sb", function() return true end)
hook.Add("ScoreboardHide", "pipboy_info_hide_default_sb", function() return true end)

tablet.pages["INFO"] = function(color_main)
    local lp = LocalPlayer()
    local localChar = lp:getChar()
    if not localChar then return end

    -- Releasing R always cancels any in-flight hold, regardless of which
    -- button was being held when it happened. Without this the timer can
    -- "carry over" if the user moved the cursor off the button before
    -- letting go of R.
    if not IS_R_DOWN then
        info_hold_action, info_hold_target, info_hold_start = nil, nil, 0
    end

    -- Header bar
    surface.SetDrawColor(pip_color)
    draw.DrawText("STATUS", "Morton Black@42", 64, 64)
    draw.DrawText("// " .. #player.GetAll() .. " ONLINE", "Morton Medium@32", 220, 80, pip_color_accent)
    surface.DrawRect(60, 106, 940, 4)

    local isAdmin = lp:IsAdmin()

    -- Admin-mode toggle (top right of header). Reveals real names & hidden
    -- factions; only visible to admins so a regular player can't even see
    -- that the toggle exists.
    if isAdmin then
        local label = "ADMIN MODE: " .. (PIPBOY_INFO_ADMIN_MODE and "ON" or "OFF")
        local bx, by, bw, bh = 760, 70, 240, 32
        local isIn, click = AddUIButton(bx, by, bw, bh)
        surface.SetDrawColor(pip_color)
        surface.DrawOutlinedRect(bx, by, bw, bh)
        if PIPBOY_INFO_ADMIN_MODE then
            surface.SetDrawColor(pip_color.r, pip_color.g, pip_color.b, 80)
            surface.DrawRect(bx, by, bw, bh)
        end
        draw.DrawText(label, "Morton Medium@24", bx + bw / 2, by + 4,
            isIn and color_black or color_white, TEXT_ALIGN_CENTER)
        if isIn then
            surface.SetDrawColor(pip_color.r, pip_color.g, pip_color.b, 50)
            surface.DrawRect(bx, by, bw, bh)
        end
        if click then PIPBOY_INFO_ADMIN_MODE = not PIPBOY_INFO_ADMIN_MODE end
    end

    local rows, adminBypass = info_buildRoster()
    local visibleRows = math.floor(INFO_LIST_H / INFO_ROW_H)
    PIPBOY_INFO_SCROLL = math.Clamp(PIPBOY_INFO_SCROLL, 0, math.max(0, #rows - visibleRows))

    -- ============ LEFT: scrolling list ============
    local startIdx = PIPBOY_INFO_SCROLL + 1
    local drawY = INFO_LIST_Y
    local rmb = input.IsMouseDown(MOUSE_RIGHT)
    local rmbPressed = rmb and not INFO_RMB_PREV

    local selectedRow
    for i = startIdx, #rows do
        local row = rows[i]
        if drawY + (row.type == "header" and INFO_HEADER_H or INFO_ROW_H) > INFO_LIST_Y + INFO_LIST_H then break end

        if row.type == "header" then
            info_drawHeader(row, INFO_LIST_X, drawY, INFO_LIST_W)
            drawY = drawY + INFO_HEADER_H
        else
            local ply = row.ply
            if not IsValid(ply) or not ply:getChar() then
                drawY = drawY + INFO_ROW_H
                continue
            end
            local char = ply:getChar()
            local cid = char:getID()
            if PIPBOY_INFO_SELECTED == nil then PIPBOY_INFO_SELECTED = cid end

            local isSel = PIPBOY_INFO_SELECTED == cid
            local isIn, click = AddUIButton(INFO_LIST_X, drawY, INFO_LIST_W, INFO_ROW_H)
            if isIn and not isSel then
                surface.SetDrawColor(pip_color.r, pip_color.g, pip_color.b, 40)
                surface.DrawRect(INFO_LIST_X + 6, drawY + 2, INFO_LIST_W - 6, INFO_ROW_H - 4)
            end
            local textCol = info_drawListRow(row, INFO_LIST_X, drawY, INFO_LIST_W, isSel)

            local displayName = info_displayName(ply, localChar, adminBypass)
            local primary, secondary
            if displayName then
                primary = displayName
                secondary = (ply == lp) and "You" or row.faction.name
            else
                primary = "[" .. info_shortDesc(char, 36) .. "]"
                secondary = "Unknown"
            end

            draw.DrawText(primary, "Morton Medium@24", INFO_LIST_X + 14, drawY + 2, textCol)
            draw.DrawText(secondary, "Morton Medium@19", INFO_LIST_X + 14, drawY + 17, textCol)

            -- Ping right-aligned.
            local pingTxt = tostring(ply:Ping()) .. " MS"
            draw.DrawText(pingTxt, "Morton Medium@19", INFO_LIST_X + INFO_LIST_W - 8, drawY + 9, textCol, TEXT_ALIGN_RIGHT)

            if click then
                PIPBOY_INFO_SELECTED = cid
                selectedRow = row
            end
            if isSel then selectedRow = row end

            drawY = drawY + INFO_ROW_H
        end
    end

    -- Scroll indicator bar.
    if #rows > visibleRows then
        local sbX, sbY, sbW, sbH = INFO_LIST_X + INFO_LIST_W + 8, INFO_LIST_Y, 8, INFO_LIST_H
        surface.SetDrawColor(pip_color)
        surface.DrawOutlinedRect(sbX, sbY, sbW, sbH)
        local barP = math.Clamp(visibleRows / #rows, 0.05, 1)
        local pos = math.Clamp(PIPBOY_INFO_SCROLL / math.max(1, #rows - visibleRows), 0, 1)
        local barH = sbH * barP
        surface.DrawRect(sbX, sbY + pos * (sbH - barH), sbW, barH)

        -- Click on bar to jump scroll.
        local isIn, click = AddUIButton(sbX, sbY, sbW, sbH, true)
        if isIn and IsLeftMouseDown then
            local frac = (cursor.y - sbY) / sbH
            PIPBOY_INFO_SCROLL = math.Clamp(math.floor(frac * #rows), 0, math.max(0, #rows - visibleRows))
        end
    end

    INFO_RMB_PREV = rmb

    -- ============ RIGHT: detail panel ============
    if not selectedRow then
        -- Selected character may be off-screen; resolve it manually.
        for _, row in ipairs(rows) do
            if row.type == "player" and IsValid(row.ply) and row.ply:getChar() and row.ply:getChar():getID() == PIPBOY_INFO_SELECTED then
                selectedRow = row
                break
            end
        end
    end

    -- Clear stale selection (target left).
    if not selectedRow and PIPBOY_INFO_SELECTED then
        PIPBOY_INFO_SELECTED = nil
        for _, row in ipairs(rows) do
            if row.type == "player" then PIPBOY_INFO_SELECTED = row.ply:getChar():getID() break end
        end
    end

    if not selectedRow then
        draw.DrawText("NO TARGET", "Morton Medium@42", INFO_DETAIL_X, 200, pip_color_accent)
        return
    end

    local ply  = selectedRow.ply
    local char = ply:getChar()
    if not IsValid(ply) or not char then return end
    local cid  = char:getID()
    local fac  = selectedRow.faction
    local nameStr = info_displayName(ply, localChar, adminBypass)
    local recognized = nameStr ~= nil
    local alias = localChar:getData("alias", {}) or {}
    local hasNick = alias[cid] ~= nil

    -- Faction stripe / label
    surface.SetDrawColor(selectedRow.color)
    surface.DrawRect(INFO_DETAIL_X, INFO_LIST_Y, 4, 60)
    draw.DrawText((nameStr or "UNKNOWN"):upper(), "Morton Medium@42", INFO_DETAIL_X + 14, INFO_LIST_Y - 4, pip_color)
    draw.DrawText((fac.name or "Wastelander"):upper(), "Morton Medium@24", INFO_DETAIL_X + 14, INFO_LIST_Y + 38, selectedRow.color)

    -- Description (wrapped).
    local desc = recognized and (char:getDesc() or "") or ("[" .. (char:getDesc() or "") .. "]")
    if desc == "" then desc = "No description provided." end
    local descY = INFO_LIST_Y + 76
    draw.DrawText("DESCRIPTION", "Morton Medium@24", INFO_DETAIL_X, descY, pip_color_accent)
    draw.DrawNonParsedText(textWrap(desc, "Morton Medium@24", INFO_DETAIL_W), "Morton Medium@24",
        INFO_DETAIL_X, descY + 26, color_white, 0)

    -- Quick stats (ping always visible; HP/health only after recognition).
    local statsY = INFO_LIST_Y + 220
    draw.DrawText("PING", "Morton Medium@24", INFO_DETAIL_X, statsY, pip_color_accent)
    draw.DrawText(ply:Ping() .. " ms", "Morton Medium@24", INFO_DETAIL_X + 120, statsY, color_white)

    if ply == lp or recognized or adminBypass then
        draw.DrawText("HEALTH", "Morton Medium@24", INFO_DETAIL_X, statsY + 28, pip_color_accent)
        draw.DrawText(ply:Health() .. " / " .. ply:GetMaxHealth(), "Morton Medium@24", INFO_DETAIL_X + 120, statsY + 28, color_white)
    end

    if adminBypass then
        -- Admins see the SteamID and player name (the OOC identity behind the
        -- character) so they can ban / report someone without alt-tabbing.
        draw.DrawText("STEAM", "Morton Medium@24", INFO_DETAIL_X, statsY + 56, pip_color_accent)
        draw.DrawText(ply:Name(), "Morton Medium@24", INFO_DETAIL_X + 120, statsY + 56, color_white)
        draw.DrawText("ID", "Morton Medium@24", INFO_DETAIL_X, statsY + 84, pip_color_accent)
        draw.DrawText(ply:SteamID(), "Morton Medium@19", INFO_DETAIL_X + 120, statsY + 90, color_white)
    end

    -- ============ Action buttons (player-facing) ============
    local btnY = INFO_LIST_Y + 360
    if ply ~= lp then
        if hasNick then
            if info_drawTextButton("CHANGE NICKNAME", INFO_DETAIL_X, btnY, 195, 28) then
                info_promptNickname(cid, alias[cid])
            end
            if info_drawTextButton("CLEAR NICKNAME", INFO_DETAIL_X + 205, btnY, 195, 28) then
                netstream.Start("pipboy_nick_clear", cid)
            end
        else
            if info_drawTextButton("SET NICKNAME", INFO_DETAIL_X, btnY, INFO_DETAIL_W, 28) then
                info_promptNickname(cid, nil)
            end
        end
        btnY = btnY + 36
    end

    -- ============ Admin section ============
    if not isAdmin then return end

    draw.DrawText("ADMIN", "Morton Black@42", INFO_DETAIL_X, btnY, pip_color)
    surface.SetDrawColor(pip_color)
    surface.DrawRect(INFO_DETAIL_X, btnY + 40, INFO_DETAIL_W, 2)
    btnY = btnY + 48

    -- Two-column grid of admin verbs. Hold-R = destructive.
    local actions = {
        {label = "GOTO",    action = "goto",    hold = false},
        {label = "BRING",   action = "bring",   hold = true},
        {label = "RETURN",  action = "return",  hold = false},
        {label = "FREEZE",  action = "freeze",  hold = false},
        {label = "RECOG",   action = "recog",   hold = false},
        {label = "SLAY",    action = "slay",    hold = true},
        {label = "SPECTATE",action = "spectate",hold = false},
        {label = "KICK",    action = "kick",    hold = true},
    }
    for i, a in ipairs(actions) do
        local col = (i - 1) % 2
        local row = math.floor((i - 1) / 2)
        local bx = INFO_DETAIL_X + col * 205
        local by = btnY + row * 36
        info_drawAdminButton(a.label, bx, by, 195, cid, a.action, a.hold)
    end
end


local function drawQuestFrame(focused,tracked,y,quest_name )
if focused then 
surface.SetDrawColor(pip_color)
	surface.DrawRect(60, 130+y, 400, 42)


	draw.SimpleText( quest_name,  "Morton Black@42",100, 151+y,color_black,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	else 
	draw.SimpleText( quest_name,  "Morton Black@42",100, 151+y,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	
	end
	if tracked then 
	surface.SetDrawColor(focused and color_black or pip_color)
	surface.DrawRect(72, 146+y, 14, 12)
	end
end


local function charWrap(text, remainingWidth, maxWidth)
    local totalWidth = 0

    text = text:gsub(".", function(char)
        totalWidth = totalWidth + surface.GetTextSize(char)

        -- Wrap around when the max width is reached
        if totalWidth >= remainingWidth then
            -- totalWidth needs to include the character width because it's inserted in a new line
            totalWidth = surface.GetTextSize(char)
            remainingWidth = maxWidth
            return "\n" .. char
        end

        return char
    end)

    return text, totalWidth
end

function textWrap(text, font, maxWidth)
    local totalWidth = 0

    surface.SetFont(font)

    local spaceWidth = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
            local char = string.sub(word, 1, 1)
            if char == "\n" or char == "\t" then
                totalWidth = 0
            end

            local wordlen = surface.GetTextSize(word)
            totalWidth = totalWidth + wordlen

            -- Wrap around when the max width is reached
            if wordlen >= maxWidth then -- Split the word if the word is too big
                local splitWord, splitPoint = charWrap(word, maxWidth - (totalWidth - wordlen), maxWidth)
                totalWidth = splitPoint
                return splitWord
            elseif totalWidth < maxWidth then
                return word
            end

            -- Split before the word
            if char == ' ' then
                totalWidth = wordlen - spaceWidth
                return '\n' .. string.sub(word, 2)
            end

            totalWidth = wordlen
            return '\n' .. word
        end)

    return text
end

-- concatenate a space to avoid the text being parsed as valve string
local function safeText(text)
    return string.match(text, "^#([a-zA-Z_]+)$") and text .. " " or text
end



function draw.DrawNonParsedText(text, font, x, y, color, xAlign)
    return draw.DrawText(safeText(text), font, x, y, color, xAlign)
end

function draw.DrawNonParsedSimpleText(text, font, x, y, color, xAlign, yAlign)
    return draw.SimpleText(safeText(text), font, x, y, color, xAlign, yAlign)
end

function draw.DrawNonParsedSimpleTextOutlined(text, font, x, y, color, xAlign, yAlign, outlineWidth, outlineColor)
    return draw.SimpleTextOutlined(safeText(text), font, x, y, color, xAlign, yAlign, outlineWidth, outlineColor)
end

function surface.DrawNonParsedText(text)
    return surface.DrawText(safeText(text))
end

function chat.AddNonParsedText(...)
    local tbl = {...}
    for i = 2, #tbl, 2 do
        tbl[i] = safeText(tbl[i])
    end
    return chat.AddText(unpack(tbl))
end

local questDesc = [[Robert and some members of the Calypso ordered me to do some bullshit dirty work in order to get my gear back. I need to find someone that goes by "The West" to learn more.]]
questDesc = textWrap(questDesc,"Morton Medium@24",300)

PIPBOY_FOCUSED_QUEST = PIPBOY_FOCUSED_QUEST or nil

tablet.pages["QUESTS"] = function(color_main)
	surface.SetDrawColor(pip_color)
	draw.DrawText("QUESTS", "Morton Black@42", 64, 64)
	surface.DrawRect(60, 106, 400, 8)

	local char = LocalPlayer():getChar()
	if not char then return end

	local active = char:getData("quests", {}) or {}
	local registered = (QUESTS and QUESTS.quests) or {}

	local list = {}
	for uid, _ in pairs(active) do
		local q = registered[uid]
		if q then list[#list + 1] = q end
	end

	if #list == 0 then
		draw.DrawText("No active quests.", "Morton Medium@32", 64, 140, color_white)
		return
	end

	if not PIPBOY_FOCUSED_QUEST or not active[PIPBOY_FOCUSED_QUEST] then
		PIPBOY_FOCUSED_QUEST = list[1].uid
	end

	for i, q in ipairs(list) do
		local y = (i - 1) * 48
		local focused = (q.uid == PIPBOY_FOCUSED_QUEST)
		local isIn, clicked = AddUIButton(60, 130 + y, 400, 42)
		if clicked then PIPBOY_FOCUSED_QUEST = q.uid end
		drawQuestFrame(focused, focused, y, (q.name or q.uid):upper())
	end

	local focusedQuest = registered[PIPBOY_FOCUSED_QUEST]
	if focusedQuest then
		surface.SetDrawColor(pip_color)
		draw.DrawText((focusedQuest.name or focusedQuest.uid):upper(), "Morton Black@42", 650, 120)
		surface.DrawRect(600, 125, 8, 400)
		local body = focusedQuest.reminder or focusedQuest.intro or ""
		draw.DrawNonParsedText(textWrap(body, "Morton Medium@24", 300), "Morton Medium@24", 650, 166, color_white, 0)
	end
end

hook.Add("Move", "keyLiwasten2", function()


end)