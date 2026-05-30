-- Server side of the pipboy INFO scoreboard's admin tools and nickname
-- helpers. The client sends a character id (not a player handle) so we never
-- act on a stale ent index; we look the player up freshly here and re-check
-- IsAdmin on every call so this surface can't be exploited by a tampered
-- client.

local function findPlayerByCharID(charID)
    charID = tonumber(charID)
    if not charID then return nil end
    for _, ply in ipairs(player.GetAll()) do
        local char = ply:getChar()
        if char and char:getID() == charID then return ply end
    end
end

local function notify(ply, msg)
    if ply.notify then ply:notify(msg) else ply:ChatPrint(msg) end
end

local ACTIONS = {}

ACTIONS["goto"] = function(admin, target)
    admin.pipboy_returnPos    = admin:GetPos()
    admin.pipboy_returnAngles = admin:EyeAngles()
    local pos = target:GetPos() + target:GetForward() * 64
    admin:SetPos(pos)
    admin:SetEyeAngles((target:GetPos() - admin:GetPos()):Angle())
    notify(admin, "Teleported to " .. target:Name() .. ".")
end

ACTIONS["bring"] = function(admin, target)
    target.pipboy_returnPos    = target:GetPos()
    target.pipboy_returnAngles = target:EyeAngles()
    target:SetPos(admin:GetPos() + admin:GetForward() * 64)
    notify(admin, "Brought " .. target:Name() .. ".")
    notify(target, "You were teleported by an administrator.")
end

ACTIONS["return"] = function(admin, target)
    -- "Return" applies to the SELECTED target if they have a stored position
    -- (e.g. they were brought here); otherwise applies to the admin themself.
    local subject = target.pipboy_returnPos and target or admin
    if not subject.pipboy_returnPos then
        return notify(admin, "No stored return position.")
    end
    subject:SetPos(subject.pipboy_returnPos)
    if subject.pipboy_returnAngles then subject:SetEyeAngles(subject.pipboy_returnAngles) end
    subject.pipboy_returnPos, subject.pipboy_returnAngles = nil, nil
    notify(admin, "Returned " .. subject:Name() .. ".")
end

ACTIONS["freeze"] = function(admin, target)
    -- Toggle freeze so the same button covers freeze + thaw.
    local frozen = target:IsFlagSet(FL_FROZEN) or target:GetMoveType() == MOVETYPE_NONE
    if frozen then
        target:Freeze(false)
        notify(admin, "Unfroze " .. target:Name() .. ".")
        notify(target, "You have been unfrozen.")
    else
        target:Freeze(true)
        notify(admin, "Froze " .. target:Name() .. ".")
        notify(target, "You have been frozen by an administrator.")
    end
end

ACTIONS["slay"] = function(admin, target)
    target:Kill()
    notify(admin, "Slayed " .. target:Name() .. ".")
    notify(target, "You were slain by an administrator.")
end

ACTIONS["kick"] = function(admin, target)
    -- Stamp the reason so other admins can read the audit trail.
    target:Kick("Kicked by " .. admin:Name() .. " via Pip-Boy.")
end

ACTIONS["recog"] = function(admin, target)
    -- Forces mutual recognition between admin and target (same effect as the
    -- /forcerecog command). Useful when an admin needs to drop into a scene
    -- without breaking IC name flow.
    local ac, tc = admin:getChar(), target:getChar()
    if not ac or not tc then return end
    tc:recognize(ac:getID())
    ac:recognize(tc:getID())
    notify(admin, "Recognized " .. target:Name() .. ".")
end

ACTIONS["spectate"] = function(admin, target)
    -- Lightweight spectate: hop to the target with admin observer body
    -- already hidden (handled by the existing observer plugin when noclip
    -- is active). We toggle noclip on if currently walking, then teleport.
    if admin:GetMoveType() ~= MOVETYPE_NOCLIP then
        admin:SetMoveType(MOVETYPE_NOCLIP)
    end
    admin.pipboy_returnPos    = admin.pipboy_returnPos or admin:GetPos()
    admin.pipboy_returnAngles = admin.pipboy_returnAngles or admin:EyeAngles()
    admin:SetPos(target:GetPos() + target:GetUp() * 32)
    admin:SetEyeAngles((target:GetPos() - admin:GetPos()):Angle())
    notify(admin, "Spectating " .. target:Name() .. ".")
end

netstream.Hook("pipboy_admin_action", function(client, action, charID)
    if not IsValid(client) or not client:IsAdmin() then return end
    local target = findPlayerByCharID(charID)
    if not IsValid(target) or not target:getChar() then
        return notify(client, "Target is no longer connected.")
    end
    local fn = ACTIONS[action]
    if not fn then return end
    fn(client, target)
end)

-- Nickname management (non-admin). Mirrors the recognition plugin's
-- charnickname command but doesn't require eye-tracing the target -- the
-- pipboy already knows the charID from the player list.
netstream.Hook("pipboy_nick_set", function(client, charID, text)
    local char = client:getChar()
    if not char then return end
    charID = tonumber(charID)
    if not charID then return end
    text = tostring(text or ""):sub(1, 64):Trim()
    if text == "" then return end

    local alias = char:getData("alias", {}) or {}
    alias[charID] = text
    char:setData("alias", alias)
    notify(client, "Nickname set.")
end)

netstream.Hook("pipboy_nick_clear", function(client, charID)
    local char = client:getChar()
    if not char then return end
    charID = tonumber(charID)
    if not charID then return end

    local alias = char:getData("alias", {}) or {}
    if alias[charID] then
        alias[charID] = nil
        char:setData("alias", alias)
        notify(client, "Nickname cleared.")
    end
end)
