if not file.Exists("CYR_messages", "DATA") then file.CreateDir("CYR_messages") end
CYR.Net = CYR.Net or {}
CYR.Net.Groups = CYR.Net.Groups or {}
local CYR_SOCIAL_PROFILES = {}
local CYR_SOCIAL_POSTS = {}
CYR.Net.DiscordWebhook = "https://discord.com/api/webhooks/1457081585915531410/IE5Jme9Iy_gSfwbBXYcnMgF2L-MwvsO-z0L756JkhHc7QfKkbcviM-PQ6kFAdUTvfLTK"
function CYR.Net.SendToDiscord(content, author, image, avatar)
    if not CYR.Net.DiscordWebhook or CYR.Net.DiscordWebhook == "" then return end
    local payload = {
        username = author,
        avatar_url = avatar,
        content = content
    }

    if image and image ~= "" then
        payload.embeds = {
            {
                image = {
                    url = image
                }
            }
        }
    end

    local body = util.TableToJSON(payload)
    HTTP({
        failed = function(reason) print("[CYR] Discord Webhook Failed: " .. reason) end,
        success = function(code, body, headers) if code ~= 204 and code ~= 200 then print("[CYR] Discord Webhook Error: " .. code) end end,
        method = "POST",
        url = CYR.Net.DiscordWebhook,
        body = body,
        headers = {
            ["Content-Type"] = "application/json"
        }
    })
end

local ALLOW_SELF_MESSAGING = false
local GROUPS_FILE = "CYR_messages/groups.json"
local function LoadGroups()
    if file.Exists(GROUPS_FILE, "DATA") then
        local content = file.Read(GROUPS_FILE, "DATA")
        local data = util.JSONToTable(content)
        if data then
            CYR.Net.Groups = data
            print("[CYR] Loaded " .. table.Count(data) .. " groups from disk.")
            -- Debug types
            local k, v = next(data)
            if v and v.participants then
                local pk, pv = next(v.participants)
                print("[CYR] Debug: Participant Key Type is " .. type(pk))
            end
        else
            print("[CYR] Warning: Failed to load groups.json (Empty or Invalid)")
        end
    else
        print("[CYR] No groups.json found, starting fresh.")
    end
end

LoadGroups()
local function SaveGroups()
    file.Write(GROUPS_FILE, util.TableToJSON(CYR.Net.Groups, true))
    print("[CYR] Saved groups to disk.")
end

CYR.Net.Notifications = CYR.Net.Notifications or {}
local NOTIFICATIONS_FILE = "CYR_messages/notifications.json"
local function LoadNotifications()
    if file.Exists(NOTIFICATIONS_FILE, "DATA") then
        local content = file.Read(NOTIFICATIONS_FILE, "DATA")
        local data = util.JSONToTable(content)
        if data then CYR.Net.Notifications = data end
    end
end

LoadNotifications()
local function SaveNotifications()
    file.Write(NOTIFICATIONS_FILE, util.TableToJSON(CYR.Net.Notifications, true))
end

concommand.Add("CYR_net_reload", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    LoadGroups()
    LoadNotifications()
    print("[CYR] Net data reloaded from disk.")
    if IsValid(ply) then ply:notify("Net data reloaded.") end
end)

local function AddNotification(targetID, type, text, data)
    if not CYR.Net.Notifications[targetID] then CYR.Net.Notifications[targetID] = {} end
    table.insert(CYR.Net.Notifications[targetID], {
        id = os.time() .. "-" .. math.random(1000, 9999),
        type = type, -- "mention", "comment", "like", "message"
        text = text,
        data = data,
        time = os.time(),
        read = false
    })

    -- Limit to 50 notifications
    if #CYR.Net.Notifications[targetID] > 50 then table.remove(CYR.Net.Notifications[targetID], 1) end
    SaveNotifications()
    local targetChar = nut.char.loaded[tonumber(targetID)]
    if targetChar then
        local ply = targetChar:getPlayer()
        if IsValid(ply) and ply:getChar() == targetChar then netstream.Start(ply, "NetSocialNewNotification", text, type, data) end
    end
end

local function GetConversationID(id1, id2)
    if string.StartWith(id1, "group_") then return id1 end
    if string.StartWith(id2, "group_") then return id2 end
    if id1 < id2 then
        return id1 .. "-" .. id2
    else
        return id2 .. "-" .. id1
    end
end

local function GetConversationPath(convID)
    return "CYR_messages/" .. convID .. ".json"
end

function CYR_NET_SendMessage(senderID, receiverID, text, msgType)
    local convID = GetConversationID(senderID, receiverID)
    local path = GetConversationPath(convID)
    local data = {
        participants = {},
        messages = {}
    }

    if file.Exists(path, "DATA") then
        local content = file.Read(path, "DATA")
        local tableData = util.JSONToTable(content) or {}
        -- Migration check: if it's a list of messages (numeric keys), move to messages key
        if tableData[1] then
            data.messages = tableData
        elseif tableData.messages then
            data = tableData
        end
    end

    if not data.participants then data.participants = {} end
    -- Update names
    local senderChar = nut.char.loaded[senderID]
    if senderChar then data.participants[tostring(senderID)] = senderChar:getName() end
    local isGroup = string.StartWith(receiverID, "group_")
    if not isGroup then
        local receiverChar = nut.char.loaded[receiverID]
        if receiverChar then data.participants[tostring(receiverID)] = receiverChar:getName() end
    end

    local senderHandle = senderChar and senderChar:getName() or "Unknown"
    local rawHandle = nil
    local avatar = nil
    if CYR_SOCIAL_PROFILES and CYR_SOCIAL_PROFILES[tostring(senderID)] then
        rawHandle = CYR_SOCIAL_PROFILES[tostring(senderID)].handle
        avatar = CYR_SOCIAL_PROFILES[tostring(senderID)].avatar
        senderHandle = "@" .. rawHandle
    end

    local msgData = {
        sender = senderID,
        text = text,
        type = msgType or "text", -- "text" or "image"
        time = os.time(),
        senderName = senderHandle,
        senderHandle = rawHandle,
        senderAvatar = avatar
    }

    -- Check for mentions
    if msgData.type == "text" then
        -- Process handle mentions: @handle -> @{id|handle}
        msgData.text = string.gsub(msgData.text, "@([%w_]+)", function(handle)
            local id = GetIDByHandle(handle)
            if id then
                if tostring(id) ~= tostring(senderID) then
                    AddNotification(id, "mention", senderHandle .. " mentioned you in a message.", {
                        conversationID = convID,
                        senderID = senderID,
                        groupID = isGroup and receiverID or nil
                    })
                end
                return "@{" .. id .. "|" .. handle .. "}"
            end
            return "@" .. handle
        end)
    end

    table.insert(data.messages, msgData)
    file.Write(path, util.TableToJSON(data, true))
    if isGroup then
        -- Notify all group members
        local group = CYR.Net.Groups[receiverID]
        if group then
            -- Create a copy for network that includes group name
            local netMsgData = table.Copy(msgData)
            netMsgData.groupName = group.name
            for memberID, _ in pairs(group.participants) do
                local memberChar = nut.char.loaded[tonumber(memberID)]
                if memberChar then
                    local ply = memberChar:getPlayer()
                    if IsValid(ply) and ply:getChar() == memberChar then
                        netstream.Start(ply, "NetMsgReceive", receiverID, netMsgData)
                        if tostring(memberID) ~= tostring(senderID) then ply:notify("New group message.") end
                    end
                end
            end
        end
    else
        local receiverChar = nut.char.loaded[receiverID]
        local ply = receiverChar and receiverChar:getPlayer()
        if IsValid(ply) and ply:getChar() == receiverChar then
            netstream.Start(ply, "NetMsgReceive", senderID, msgData)
            if senderID ~= receiverID then ply:notify("New message received.") end
        end

        -- Notify sender (for UI update if needed)
        if senderID ~= receiverID then
            local sender = nut.char.loaded[senderID]
            if sender then
                local ply = senderChar:getPlayer()
                if IsValid(ply) and ply:getChar() == senderChar then netstream.Start(ply, "NetMsgReceive", receiverID, msgData) end
            end
        end
    end
end

netstream.Hook("NetMsgSend", function(client, targetCharID, text, msgType)
    local char = client:getChar()
    if not char then return end
    local senderID = char:getID()
    -- Basic validation
    if not text or text == "" then return end
    CYR_NET_SendMessage(senderID, targetCharID, text, msgType)
end)

netstream.Hook("NetMsgCreateGroup", function(client, name, participants, avatarUrl)
    local char = client:getChar()
    if not char then return end
    local ownerID = tostring(char:getID())
    if not name or name == "" then return end
    local groupID = "group_" .. os.time() .. "_" .. math.random(1000, 9999)
    local groupParticipants = {
        [ownerID] = true -- { [id] = true } for quick lookup?
    }

    -- Actually participants list is usually stored as key-value for easy lookup?
    -- Current system uses participants = { [id] = name } in conversations, but here in Groups definition:
    -- Looking at usage:
    -- Add selected participants
    for _, id in ipairs(participants) do
        groupParticipants[tostring(id)] = true
    end

    CYR.Net.Groups[groupID] = {
        id = groupID,
        name = name,
        owner = ownerID,
        participants = groupParticipants,
        avatar = avatarUrl or ""
    }

    SaveGroups()
    client:notify("Group '" .. name .. "' created.")
    netstream.Start(client, "NetMsgFetchContacts") -- Refresh list
end)

netstream.Hook("NetMsgUpdateGroupAvatar", function(client, groupID, url)
    local char = client:getChar()
    if not char then return end
    local myID = tostring(char:getID())
    local group = CYR.Net.Groups[groupID]
    if not group then return end
    -- Ensure participants is a table
    if not group.participants then
        group.participants = {
            [group.owner] = true
        }
    end

    if not group.participants[myID] then -- Must be member
        return
    end

    group.avatar = url
    SaveGroups()
    -- Notify all members to refresh contacts potentially?
    -- For simplicity, just save. Clients will fetch contacts eventually or on load.
end)

netstream.Hook("NetMsgAddToGroup", function(client, groupID, newParticipants)
    local char = client:getChar()
    if not char then return end
    local myID = tostring(char:getID())
    local group = CYR.Net.Groups[groupID]
    if not group then return end
    -- Check if user is in the group
    if not group.participants[myID] and not group.participants[tonumber(myID)] then
        client:notify("You are not in this group.")
        return
    end

    local addedNames = {}
    for _, id in ipairs(newParticipants) do
        local targetID = tostring(id)
        if not group.participants[targetID] then
            group.participants[targetID] = true
            local targetChar = nut.char.loaded[tonumber(targetID)]
            if targetChar then
                table.insert(addedNames, targetChar:getName())
                -- Notify the added user so they see the group
                local ply = targetChar:getPlayer()
                if IsValid(ply) then
                    netstream.Start(ply, "NetMsgGroupCreated", groupID)
                    ply:notify("You were added to group: " .. group.name)
                end
            end
        end
    end

    if #addedNames > 0 then
        SaveGroups()
        -- System message
        local text = "Added: " .. table.concat(addedNames, ", ")
        CYR_NET_SendMessage(myID, groupID, text, "text")
        client:notify("Members added.")
    end
end)

netstream.Hook("NetMsgRemoveFromGroup", function(client, groupID, targetID)
    local char = client:getChar()
    if not char then return end
    local myID = tostring(char:getID())
    local group = CYR.Net.Groups[groupID]
    if not group then return end
    -- Only owner can remove? Or anyone? Let's say owner for now, or self-leave
    if group.owner ~= myID and myID ~= tostring(targetID) then
        client:notify("You do not have permission to remove members.")
        return
    end

    local targetKey = tostring(targetID)
    if not group.participants[targetKey] and group.participants[tonumber(targetID)] then targetKey = tonumber(targetID) end
    if group.participants[targetKey] then
        group.participants[targetKey] = nil
        SaveGroups()
        local targetChar = nut.char.loaded[tonumber(targetID)]
        local name = targetChar and targetChar:getName() or "Unknown"
        -- System message
        local text = "Removed: " .. name
        if myID == tostring(targetID) then text = name .. " left the group." end
        CYR_NET_SendMessage(myID, groupID, text, "text")
        client:notify("Member removed.")
        -- Notify the removed user so they know?
        if targetChar then
            local ply = targetChar:getPlayer()
            if IsValid(ply) and ply:getChar() == targetChar then
                ply:notify("You were removed from group: " .. group.name)
                -- Force refresh contacts to remove group from list
                netstream.Start(ply, "NetMsgGroupCreated", groupID) -- Re-using this to trigger refresh
            end
        end
    end
end)

netstream.Hook("NetMsgLeaveGroup", function(client, groupID)
    local char = client:getChar()
    if not char then return end
    local myID = tostring(char:getID())
    local group = CYR.Net.Groups[groupID]
    if not group then return end
    local myKey = myID
    if not group.participants[myKey] and group.participants[tonumber(myID)] then myKey = tonumber(myID) end
    if group.participants[myKey] then
        group.participants[myKey] = nil
        SaveGroups()
        local name = char:getName()
        CYR_NET_SendMessage(myID, groupID, name .. " left the group.", "text")
        client:notify("You left the group.")
        -- Refresh client contacts to remove the group
        netstream.Start(client, "NetMsgGroupCreated", groupID)
    end
end)

netstream.Hook("NetMsgDeleteGroup", function(client, groupID)
    local char = client:getChar()
    if not char then return end
    local myID = tostring(char:getID())
    local group = CYR.Net.Groups[groupID]
    if not group then return end
    if tostring(group.owner) ~= myID then
        client:notify("Only the owner can delete the group.")
        return
    end

    -- Notify all participants
    for pid, _ in pairs(group.participants) do
        local pChar = nut.char.loaded[tonumber(pid)]
        if pChar then
            local ply = pChar:getPlayer()
            if IsValid(ply) and ply:getChar() == pChar then
                ply:notify("Group '" .. group.name .. "' was deleted.")
                netstream.Start(ply, "NetMsgGroupCreated", groupID)
            end
        end
    end

    CYR.Net.Groups[groupID] = nil
    SaveGroups()
    -- Optional: Delete the conversation file
    local path = "CYR_messages/" .. groupID .. ".json"
    if file.Exists(path, "DATA") then file.Delete(path) end
end)

netstream.Hook("NetMsgFetch", function(client, targetCharID, beforeTime)
    local char = client:getChar()
    if not char then return end
    local senderID = char:getID()
    local convID = GetConversationID(senderID, targetCharID)
    local path = GetConversationPath(convID)
    local messages = {}
    if file.Exists(path, "DATA") then
        local content = file.Read(path, "DATA")
        local tableData = util.JSONToTable(content) or {}
        if tableData[1] then
            messages = tableData
        elseif tableData.messages then
            messages = tableData.messages
        end
    end

    -- Pagination Logic
    if beforeTime then
        -- We want the 50 messages BEFORE 'beforeTime'
        -- Filter messages where time < beforeTime
        local filtered = {}
        for _, msg in ipairs(messages) do
            if msg.time < beforeTime then table.insert(filtered, msg) end
        end

        messages = filtered
    end

    if #messages > 50 then
        local limitedMsgs = {}
        for i = #messages - 49, #messages do
            table.insert(limitedMsgs, messages[i])
        end

        messages = limitedMsgs
    end

    netstream.Start(client, "NetMsgHistory", targetCharID, messages, beforeTime ~= nil)
end)

netstream.Hook("NetMsgFetchContacts", function(client)
    local char = client:getChar()
    if not char then return end
    local myID = char:getID()
    local files = file.Find("CYR_messages/*.json", "DATA")
    local contacts = {}
    local addedIDs = {}
    -- Add Groups
    for groupID, group in pairs(CYR.Net.Groups) do
        local isParticipant = false
        if group and group.participants then if group.participants[tostring(myID)] or group.participants[tonumber(myID)] then isParticipant = true end end
        if isParticipant then
            -- Get last message
            local lastMsg = ""
            local lastTime = 0
            local path = GetConversationPath(groupID)
            if file.Exists(path, "DATA") then
                local data = util.JSONToTable(file.Read(path, "DATA"))
                if data and data.messages and #data.messages > 0 then
                    local msg = data.messages[#data.messages]
                    lastMsg = msg.text
                    lastTime = msg.time
                end
            end

            table.insert(contacts, {
                id = groupID,
                name = (group.name or "Group") .. " (Group)",
                isOnline = true, -- Groups are always "online"
                lastMsg = lastMsg,
                lastMsgTime = lastTime,
                isGroup = true,
                participants = group.participants,
                owner = group.owner
            })
        end
    end

    -- 0.5 Add Groups
    for id, group in pairs(CYR.Net.Groups) do
        if group.participants and group.participants[tostring(myID)] then
            table.insert(contacts, {
                id = group.id,
                name = group.name,
                isGroup = true,
                owner = group.owner,
                lastMsgTime = os.time(), -- TODO: Track last msg in group
                avatar = group.avatar
            })

            addedIDs[group.id] = true
        end
    end

    -- 1. Add existing conversations
    for _, filename in ipairs(files) do
        local id1, id2 = filename:match("(%d+)-(%d+)%.json")
        id1 = tonumber(id1)
        id2 = tonumber(id2)
        local otherID
        if id1 == myID then
            otherID = id2
        elseif id2 == myID then
            otherID = id1
        end

        if otherID then
            local targetChar = nut.char.loaded[otherID]
            local name = "Unknown (" .. otherID .. ")"
            local isOnline = false
            local lastMsgTime = 0
            -- Try to get name from file first
            local path = "CYR_messages/" .. filename
            if file.Exists(path, "DATA") then
                local content = file.Read(path, "DATA")
                local tableData = util.JSONToTable(content) or {}
                if tableData.participants and tableData.participants[tostring(otherID)] then name = tableData.participants[tostring(otherID)] end
                local msgs = tableData.messages or tableData
                if msgs and #msgs > 0 then lastMsgTime = msgs[#msgs].time or 0 end
            end

            if targetChar and targetChar:getPlayer():IsValid() and targetChar:getPlayer():getChar() == targetChar then
                name = targetChar:getName()
                isOnline = true
            end

            local profile = CYR_SOCIAL_PROFILES[tostring(otherID)]
            if not profile then profile = CYR_SOCIAL_PROFILES[tonumber(otherID)] end
            local avatar = profile and profile.avatar
            local handle = profile and profile.handle
            table.insert(contacts, {
                id = otherID,
                name = name,
                isOnline = isOnline,
                hasHistory = true,
                lastMsgTime = lastMsgTime,
                avatar = avatar,
                handle = handle
            })

            addedIDs[otherID] = true
        end
    end

    netstream.Start(client, "NetMsgContacts", contacts)
end)

netstream.Hook("NetMsgFetchOnlinePlayers", function(client)
    local char = client:getChar()
    if not char then return end
    local myID = char:getID()
    local players = {}
    for _, ply in ipairs(player.GetAll()) do
        local pch = ply:getChar()
        if pch and pch:getID() ~= myID then
            local id = pch:getID()
            local profile = CYR_SOCIAL_PROFILES[tostring(id)]
            table.insert(players, {
                id = id,
                name = pch:getName(),
                handle = profile and profile.handle or nil,
                avatar = profile and profile.avatar or nil
            })
        end
    end

    netstream.Start(client, "NetMsgOnlinePlayers", players)
end)

--------------------------------------------------------------------------------
-- SOCIAL MEDIA SYSTEM
--------------------------------------------------------------------------------
if not file.Exists("CYR_social", "DATA") then file.CreateDir("CYR_social") end
local SOCIAL_PROFILES_FILE = "CYR_social/profiles.json"
local SOCIAL_POSTS_FILE = "CYR_social/posts.json"
-- CYR_SOCIAL_PROFILES and CYR_SOCIAL_POSTS defined at top of file
local function SaveProfiles()
    file.Write(SOCIAL_PROFILES_FILE, util.TableToJSON(CYR_SOCIAL_PROFILES, true))
end

local function SavePosts()
    file.Write(SOCIAL_POSTS_FILE, util.TableToJSON(CYR_SOCIAL_POSTS, true))
end

local function SanitizeHandle(handle)
    if not handle then return "" end
    -- Replace spaces with underscores
    handle = string.gsub(handle, " ", "_")
    -- Remove non-alphanumeric characters (except underscores)
    handle = string.gsub(handle, "[^%w_]", "")
    -- Limit length to 30
    if #handle > 30 then handle = string.sub(handle, 1, 30) end
    return handle
end

local function LoadSocialData()
    -- Load Posts first so migration can update them
    if file.Exists(SOCIAL_POSTS_FILE, "DATA") then CYR_SOCIAL_POSTS = util.JSONToTable(file.Read(SOCIAL_POSTS_FILE, "DATA")) or {} end
    if file.Exists(SOCIAL_PROFILES_FILE, "DATA") then
        local rawData = util.JSONToTable(file.Read(SOCIAL_PROFILES_FILE, "DATA")) or {}
        CYR_SOCIAL_PROFILES = {}
        -- Normalize keys to strings to avoid JSON number/string mismatch
        for k, v in pairs(rawData) do
            CYR_SOCIAL_PROFILES[tostring(k)] = v
            -- Normalize following/followers keys
            if v.following then
                local newFollowing = {}
                for fk, fv in pairs(v.following) do
                    newFollowing[tostring(fk)] = fv
                end

                v.following = newFollowing
            end

            if v.followers then
                local newFollowers = {}
                for fk, fv in pairs(v.followers) do
                    newFollowers[tostring(fk)] = fv
                end

                v.followers = newFollowers
            end
        end

        -- Migration: Sanitize Handles
        local changed = false
        local handleMap = {} -- handle -> charID
        -- First pass: Build map of existing valid handles
        for id, profile in pairs(CYR_SOCIAL_PROFILES) do
            local clean = SanitizeHandle(profile.handle)
            if clean ~= profile.handle then
                -- Will need update
            else
                if handleMap[string.lower(clean)] then
                    -- Collision in existing data?
                else
                    handleMap[string.lower(clean)] = id
                end
            end
        end

        -- Second pass: Fix invalid handles
        for id, profile in pairs(CYR_SOCIAL_PROFILES) do
            local clean = SanitizeHandle(profile.handle)
            if clean == "" then clean = "user_" .. id end
            if clean ~= profile.handle then
                -- Check collision
                local base = clean
                local num = 1
                while handleMap[string.lower(clean)] and handleMap[string.lower(clean)] ~= id do
                    clean = string.sub(base, 1, 25) .. "_" .. num
                    num = num + 1
                end

                print("[CYR] Migrating handle: " .. profile.handle .. " -> " .. clean)
                -- Update Posts/Comments
                local oldHandle = profile.handle
                for _, post in ipairs(CYR_SOCIAL_POSTS) do
                    if post.authorID == id then post.handle = clean end
                    if post.comments then
                        for _, comm in ipairs(post.comments) do
                            if comm.authorID == id then comm.authorHandle = clean end
                        end
                    end
                end

                profile.handle = clean
                handleMap[string.lower(clean)] = id
                changed = true
            end
        end

        if changed then
            SaveProfiles()
            SavePosts()
            print("[CYR] Social data migrated.")
        end
    end
end

LoadSocialData()
local function CleanupOldPosts()
    local twoWeeksAgo = os.time() - (14 * 24 * 60 * 60)
    local changed = false
    for i = #CYR_SOCIAL_POSTS, 1, -1 do
        if CYR_SOCIAL_POSTS[i].time < twoWeeksAgo then
            table.remove(CYR_SOCIAL_POSTS, i)
            changed = true
        end
    end

    if changed then SavePosts() end
end

-- Run cleanup on startup
CleanupOldPosts()
-- Helper: Check if handle is taken
local function IsHandleTaken(handle)
    for _, profile in pairs(CYR_SOCIAL_PROFILES) do
        if string.lower(profile.handle) == string.lower(handle) then return true end
    end
    return false
end

local function GetIDByHandle(handle)
    for id, profile in pairs(CYR_SOCIAL_PROFILES) do
        if string.lower(profile.handle) == string.lower(handle) then return id end
    end
    return nil
end

netstream.Hook("NetSocialGetProfile", function(client)
    print("[CYR DEBUG] Server received NetSocialGetProfile from " .. tostring(client))
    local char = client:getChar()
    if not char then return end
    local charID = tostring(char:getID())
    local profile = CYR_SOCIAL_PROFILES[charID]
    print("[CYR DEBUG] Sending profile data to client: " .. tostring(profile))
    netstream.Start(client, "NetSocialProfileData", profile)
end)

netstream.Hook("NetSocialCreateProfile", function(client, handle, bio)
    local char = client:getChar()
    if not char then return end
    local charID = tostring(char:getID())
    if CYR_SOCIAL_PROFILES[charID] then
        client:notify("You already have a profile.")
        return
    end

    if not handle or #handle < 3 or #handle > 30 then
        client:notify("Handle must be between 3 and 30 characters.")
        return
    end

    local cleanHandle = SanitizeHandle(handle)
    if cleanHandle ~= handle then
        client:notify("Handle contains invalid characters. Suggested: " .. cleanHandle)
        return
    end

    if IsHandleTaken(cleanHandle) then
        client:notify("Handle is already taken.")
        return
    end

    CYR_SOCIAL_PROFILES[charID] = {
        handle = cleanHandle,
        bio = bio or "",
        avatar = "",
        steamID = client:SteamID(),
        created = os.time(),
        followers = {}, -- [charID] = true
        following = {} -- [charID] = true
    }

    SaveProfiles()
    client:notify("Profile created successfully!")
    netstream.Start(client, "NetSocialProfileData", CYR_SOCIAL_PROFILES[charID])
end)

netstream.Hook("NetSocialChangeHandle", function(client, newHandle)
    local char = client:getChar()
    if not char then return end
    local charID = tostring(char:getID())
    if not CYR_SOCIAL_PROFILES[charID] then
        client:notify("You don't have a profile.")
        return
    end

    if not newHandle or #newHandle < 3 or #newHandle > 30 then
        client:notify("Handle must be between 3 and 30 characters.")
        return
    end

    local cleanHandle = SanitizeHandle(newHandle)
    if cleanHandle ~= newHandle then
        client:notify("Handle contains invalid characters. Suggested: " .. cleanHandle)
        return
    end

    if IsHandleTaken(cleanHandle) then
        client:notify("Handle is already taken.")
        return
    end

    -- Update Profile
    CYR_SOCIAL_PROFILES[charID].handle = cleanHandle
    SaveProfiles()
    -- Update Posts/Comments
    for _, post in ipairs(CYR_SOCIAL_POSTS) do
        if post.authorID == charID then post.handle = cleanHandle end
        if post.comments then
            for _, comm in ipairs(post.comments) do
                if comm.authorID == charID then comm.authorHandle = cleanHandle end
            end
        end
    end

    SavePosts()
    client:notify("Handle updated to @" .. cleanHandle)
    netstream.Start(client, "NetSocialProfileData", CYR_SOCIAL_PROFILES[charID])
end)

netstream.Hook("NetSocialUpdateProfile", function(client, bio, avatar)
    local char = client:getChar()
    if not char then return end
    local charID = tostring(char:getID())
    if not CYR_SOCIAL_PROFILES[charID] then
        client:notify("You don't have a profile.")
        return
    end

    CYR_SOCIAL_PROFILES[charID].bio = bio or ""
    CYR_SOCIAL_PROFILES[charID].avatar = avatar or ""
    SaveProfiles()
    client:notify("Profile updated!")
    netstream.Start(client, "NetSocialProfileData", CYR_SOCIAL_PROFILES[charID])
end)

netstream.Hook("NetSocialFollowUser", function(client, targetHandle, wantToFollow)
    local char = client:getChar()
    if not char then return end
    local charID = tostring(char:getID())
    local myProfile = CYR_SOCIAL_PROFILES[charID]
    if not myProfile then return end
    local targetID = nil
    local targetProfile = nil
    for id, profile in pairs(CYR_SOCIAL_PROFILES) do
        if profile.handle == targetHandle then
            targetID = id
            targetProfile = profile
            break
        end
    end

    if not targetProfile or targetID == charID then return end
    -- Initialize tables if missing (migration)
    if not myProfile.following then myProfile.following = {} end
    if not targetProfile.followers then targetProfile.followers = {} end
    local sTargetID = tostring(targetID)
    local sCharID = tostring(charID)
    local isFollowing = myProfile.following[sTargetID]
    -- If wantToFollow is nil, toggle (legacy behavior)
    if wantToFollow == nil then wantToFollow = not isFollowing end
    if not wantToFollow then
        -- Unfollow
        myProfile.following[sTargetID] = nil
        targetProfile.followers[sCharID] = nil
        client:notify("Unfollowed @" .. targetHandle)
    else
        -- Follow
        myProfile.following[sTargetID] = true
        targetProfile.followers[sCharID] = true
        client:notify("Followed @" .. targetHandle)
    end

    SaveProfiles()
    -- Send updated profile data to client so UI updates
    netstream.Start(client, "NetSocialProfileData", myProfile)
end)

netstream.Hook("NetSocialGetFollowers", function(client, handle)
    local targetID = nil
    local targetProfile = nil
    for id, profile in pairs(CYR_SOCIAL_PROFILES) do
        if profile.handle == handle then
            targetID = id
            targetProfile = profile
            break
        end
    end

    if not targetProfile then return end
    local followersList = {}
    if targetProfile.followers then
        for followerID, _ in pairs(targetProfile.followers) do
            local followerProfile = CYR_SOCIAL_PROFILES[tostring(followerID)]
            if followerProfile then
                table.insert(followersList, {
                    handle = followerProfile.handle,
                    avatar = followerProfile.avatar,
                    bio = followerProfile.bio
                })
            end
        end
    end

    netstream.Start(client, "NetSocialSearchResults", followersList)
end)

netstream.Hook("NetSocialGetFollowing", function(client, handle)
    local targetID = nil
    local targetProfile = nil
    for id, profile in pairs(CYR_SOCIAL_PROFILES) do
        if profile.handle == handle then
            targetID = id
            targetProfile = profile
            break
        end
    end

    if not targetProfile then return end
    local followingList = {}
    if targetProfile.following then
        for followingID, _ in pairs(targetProfile.following) do
            local followingProfile = CYR_SOCIAL_PROFILES[tostring(followingID)]
            if followingProfile then
                table.insert(followingList, {
                    handle = followingProfile.handle,
                    avatar = followingProfile.avatar,
                    bio = followingProfile.bio
                })
            end
        end
    end

    netstream.Start(client, "NetSocialSearchResults", followingList)
end)

netstream.Hook("NetSocialCreatePost", function(client, content, imageURL, visibility)
    local char = client:getChar()
    if not char then return end
    local charID = tostring(char:getID())
    local profile = CYR_SOCIAL_PROFILES[charID]
    if not profile then
        client:notify("You need a profile to post.")
        return
    end

    if not content or #content < 1 or #content > 500 then
        client:notify("Post content invalid length.")
        return
    end

    local post = {
        id = os.time() .. "-" .. math.random(1000, 9999),
        authorID = charID,
        steamID = client:SteamID(),
        handle = profile.handle,
        content = content,
        image = imageURL,
        visibility = visibility or "public", -- "public" or "followers"
        time = os.time(),
        likes = {}, -- [charID] = true
        comments = {} -- {authorHandle, content, time}
    }

    CYR.Net.SendToDiscord(content, profile.handle, imageURL, profile.avatar)
    -- Check for mentions
    post.mentions = {}
    if content then
        post.content = string.gsub(content, "@([%w_]+)", function(handle)
            local id = GetIDByHandle(handle)
            if id then
                if id ~= charID then
                    AddNotification(id, "mention", "@" .. profile.handle .. " mentioned you in a post.", {
                        postID = post.id
                    })

                    post.mentions[id] = true
                end
                return "@{" .. id .. "|" .. handle .. "}"
            end
            return "@" .. handle
        end)
    end

    table.insert(CYR_SOCIAL_POSTS, post)
    SavePosts()
    client:notify("Posted!")
    -- Refresh for everyone? Or just let them refresh manually/periodically?
    -- For now, let's just confirm to sender.
end)

netstream.Hook("NetSocialPinPost", function(client, postID)
    local char = client:getChar()
    if not char then return end
    local charID = tostring(char:getID())
    local profile = CYR_SOCIAL_PROFILES[charID]
    if not profile then return end
    -- Verify post ownership
    local post = nil
    for _, p in ipairs(CYR_SOCIAL_POSTS) do
        if p.id == postID then
            post = p
            break
        end
    end

    if post and post.authorID == charID then
        profile.pinnedPost = postID
        SaveProfiles()
        client:notify("Post pinned to profile.")
    else
        client:notify("Cannot pin this post.")
    end
end)

netstream.Hook("NetSocialUnpinPost", function(client)
    local char = client:getChar()
    if not char then return end
    local charID = tostring(char:getID())
    local profile = CYR_SOCIAL_PROFILES[charID]
    if profile then
        profile.pinnedPost = nil
        SaveProfiles()
        client:notify("Post unpinned.")
    end
end)

netstream.Hook("NetSocialFetchPosts", function(client, sortType, offset)
    local char = client:getChar()
    local myID = char and tostring(char:getID())
    local myProfile = myID and CYR_SOCIAL_PROFILES[myID]
    -- sortType: "recent", "likes", "hot"
    local posts = {}
    -- Filter posts
    for _, p in ipairs(CYR_SOCIAL_POSTS) do
        local visible = true
        if p.visibility == "followers" then
            visible = false
            if myID then
                if p.authorID == myID then
                    visible = true
                elseif myProfile and myProfile.following and myProfile.following[p.authorID] then
                    visible = true
                elseif p.mentions and p.mentions[myID] then
                    visible = true
                end
            end
        end

        if visible then table.insert(posts, p) end
    end

    -- Calculate like counts for sorting
    for _, p in ipairs(posts) do
        p.likeCount = table.Count(p.likes or {})
        p.commentCount = p.comments and #p.comments or 0
    end

    if sortType == "likes" then
        table.sort(posts, function(a, b) return a.likeCount > b.likeCount end)
    elseif sortType == "hot" then
        -- Hot = Likes / (Hours + 2)^1.5
        local now = os.time()
        table.sort(posts, function(a, b)
            local ageA = (now - a.time) / 3600
            local ageB = (now - b.time) / 3600
            local scoreA = a.likeCount / math.pow(ageA + 2, 1.5)
            local scoreB = b.likeCount / math.pow(ageB + 2, 1.5)
            return scoreA > scoreB
        end)
    else -- recent
        table.sort(posts, function(a, b) return a.time > b.time end)
    end

    -- Pagination
    offset = offset or 0
    local limit = 5
    local pagedPosts = {}
    for i = offset + 1, math.min(offset + limit, #posts) do
        table.insert(pagedPosts, posts[i])
    end

    -- Inject avatars into posts for display
    for _, p in ipairs(pagedPosts) do
        if p.authorID and CYR_SOCIAL_PROFILES[p.authorID] then
            p.avatar = CYR_SOCIAL_PROFILES[p.authorID].avatar
            -- Inject SteamID if missing (migration)
            if not p.steamID and CYR_SOCIAL_PROFILES[p.authorID].steamID then p.steamID = CYR_SOCIAL_PROFILES[p.authorID].steamID end
        end

        -- Inject avatars into comments
        if p.comments then
            for _, c in ipairs(p.comments) do
                if c.authorID and CYR_SOCIAL_PROFILES[c.authorID] then c.avatar = CYR_SOCIAL_PROFILES[c.authorID].avatar end
            end
        end
    end

    netstream.Start(client, "NetSocialSendPosts", pagedPosts, offset)
end)

local function BroadcastPostUpdate(post)
    local p = table.Copy(post)
    -- Calculate counts
    p.likeCount = table.Count(p.likes or {})
    p.commentCount = p.comments and #p.comments or 0
    -- Inject avatars
    if p.authorID and CYR_SOCIAL_PROFILES[p.authorID] then p.avatar = CYR_SOCIAL_PROFILES[p.authorID].avatar end
    -- We can strip comments array to save bandwidth if we only need counts vs full update
    -- But if we want real-time comments in the modal, we need the comments.
    -- However, broadcasting comments to everyone scrolling feed is heavy.
    -- Compromise: Send full post data.
    if p.comments then
        for _, c in ipairs(p.comments) do
            if c.authorID and CYR_SOCIAL_PROFILES[c.authorID] then c.avatar = CYR_SOCIAL_PROFILES[c.authorID].avatar end
        end
    end

    -- Send to everyone
    netstream.Start(nil, "NetSocialPostUpdate", p)
end

netstream.Hook("NetSocialDeletePost", function(client, postID)
    local char = client:getChar()
    if not char then return end
    local charID = tostring(char:getID())
    local isAdmin = client:IsAdmin()
    postID = tostring(postID or "")
    for i, post in ipairs(CYR_SOCIAL_POSTS) do
        if post.id == postID then
            if post.authorID == charID or isAdmin then
                table.remove(CYR_SOCIAL_POSTS, i)
                SavePosts()
                client:notify("Post deleted.")
                -- Refresh feed for client
                -- netstream.Start(client, "NetSocialPostDeleted", postID) -- Optional optimization
            else
                client:notify("You cannot delete this post.")
            end

            break
        end
    end
end)

netstream.Hook("NetSocialDeleteProfile", function(client, targetHandle)
    if not client:IsAdmin() then return end
    local targetID = nil
    for id, profile in pairs(CYR_SOCIAL_PROFILES) do
        if profile.handle == targetHandle then
            targetID = id
            break
        end
    end

    if targetID then
        CYR_SOCIAL_PROFILES[targetID] = nil
        SaveProfiles()
        -- Remove all posts by this user
        local toRemove = {}
        for i, post in ipairs(CYR_SOCIAL_POSTS) do
            if post.authorID == targetID then table.insert(toRemove, i) end
        end

        -- Remove backwards to avoid index shifting issues
        for i = #toRemove, 1, -1 do
            table.remove(CYR_SOCIAL_POSTS, toRemove[i])
        end

        SavePosts()
        client:notify("Profile and posts deleted.")
    else
        client:notify("Profile not found.")
    end
end)

netstream.Hook("NetSocialLikePost", function(client, postID)
    local char = client:getChar()
    if not char then return end
    local charID = tostring(char:getID())
    postID = tostring(postID or "")
    local profile = CYR_SOCIAL_PROFILES[charID]
    if not profile then
        client:notify("You need a profile to like posts.")
        return
    end

    for _, post in ipairs(CYR_SOCIAL_POSTS) do
        if post.id == postID then
            if not post.likes then post.likes = {} end
            if post.likes[charID] then
                post.likes[charID] = nil -- Unlike
            else
                post.likes[charID] = true -- Like
            end

            SavePosts()
            BroadcastPostUpdate(post)
            break
        end
    end
end)

netstream.Hook("NetSocialCommentPost", function(client, postID, content, imageURL)
    local char = client:getChar()
    if not char then return end
    local charID = tostring(char:getID())
    postID = tostring(postID or "")
    local profile = CYR_SOCIAL_PROFILES[charID]
    if not profile then
        client:notify("You need a profile to comment.")
        return
    end

    content = tostring(content or "")
    imageURL = tostring(imageURL or "")
    if content == "" and imageURL == "" then return end
    for _, post in ipairs(CYR_SOCIAL_POSTS) do
        if post.id == postID then
            if not post.comments then post.comments = {} end
            -- Process mentions in content
            if content ~= "" then
                content = string.gsub(content, "@([%w_]+)", function(handle)
                    local id = GetIDByHandle(handle)
                    if id then
                        if id ~= charID then
                            AddNotification(id, "mention", "@" .. profile.handle .. " mentioned you in a comment.", {
                                postID = post.id
                            })
                        end
                        return "@{" .. id .. "|" .. handle .. "}"
                    end
                    return "@" .. handle
                end)
            end

            table.insert(post.comments, {
                id = os.time() .. "-" .. math.random(1000, 9999),
                authorID = charID,
                authorHandle = profile.handle,
                content = content,
                image = imageURL,
                time = os.time()
            })

            SavePosts()
            BroadcastPostUpdate(post)
            -- Notify post author
            if post.authorID ~= charID then
                AddNotification(post.authorID, "comment", "@" .. profile.handle .. " commented on your post.", {
                    postID = post.id
                })
            end

            break
        end
    end
end)

netstream.Hook("NetSocialDeleteComment", function(client, postID, commentID)
    local char = client:getChar()
    if not char then return end
    local charID = tostring(char:getID())
    local isAdmin = client:IsAdmin()
    for _, post in ipairs(CYR_SOCIAL_POSTS) do
        if post.id == postID and post.comments then
            for i, comm in ipairs(post.comments) do
                if comm.id == commentID then
                    if isAdmin or comm.authorID == charID then
                        table.remove(post.comments, i)
                        SavePosts()
                        client:notify("Comment deleted.")
                    else
                        client:notify("You cannot delete this comment.")
                    end
                    return
                end
            end
        end
    end
end)

netstream.Hook("NetSocialSearchProfiles", function(client, query)
    if not query or query == "" then return end
    query = string.lower(query)
    local results = {}
    for id, profile in pairs(CYR_SOCIAL_PROFILES) do
        if string.find(string.lower(profile.handle), query, 1, true) then table.insert(results, profile) end
    end

    netstream.Start(client, "NetSocialSearchResults", results)
end)

netstream.Hook("NetSocialGetComments", function(client, postID)
    postID = tostring(postID or "")
    local comments = {}
    for _, post in ipairs(CYR_SOCIAL_POSTS) do
        if post.id == postID then
            if post.comments then
                -- Inject avatars
                comments = table.Copy(post.comments)
                for _, c in ipairs(comments) do
                    if CYR_SOCIAL_PROFILES[c.authorID] then c.avatar = CYR_SOCIAL_PROFILES[c.authorID].avatar end
                end
            end

            break
        end
    end

    netstream.Start(client, "NetSocialSendComments", comments)
end)

netstream.Hook("NetSocialGetProfileDetails", function(client, handle)
    local char = client:getChar()
    if not char then return end
    local myID = tostring(char:getID())
    local targetProfile = nil
    local targetID = nil
    for id, profile in pairs(CYR_SOCIAL_PROFILES) do
        if profile.handle == handle then
            targetProfile = profile
            targetID = id
            break
        end
    end

    if targetProfile then
        -- Sync Check: Ensure followers/following match
        local myProfile = CYR_SOCIAL_PROFILES[myID]
        if myProfile then
            -- Ensure tables exist
            if not myProfile.following then myProfile.following = {} end
            if not targetProfile.followers then targetProfile.followers = {} end
            local amFollowing = myProfile.following[targetID]
            if amFollowing then
                -- Ensure I am in their followers
                if not targetProfile.followers[myID] then
                    targetProfile.followers[myID] = true
                    SaveProfiles()
                end
            else
                -- Ensure I am NOT in their followers
                if targetProfile.followers[myID] then
                    targetProfile.followers[myID] = nil
                    SaveProfiles()
                end
            end
        end

        -- Get posts by this user
        local posts = {}
        local pinnedPostData = nil
        for _, post in ipairs(CYR_SOCIAL_POSTS) do
            if post.handle == handle then
                -- Visibility Check REMOVED as per request
                -- if post.visibility == "followers" and not (isMe or isFollowing) then
                --     continue
                -- end
                local p = table.Copy(post)
                -- Inject avatar
                p.avatar = targetProfile.avatar
                if targetProfile.pinnedPost == p.id then pinnedPostData = table.Copy(p) end
                table.insert(posts, p)
            end
        end

        -- Sort recent
        table.sort(posts, function(a, b) return a.time > b.time end)
        -- Inject ID for messaging
        local sendProfile = table.Copy(targetProfile)
        sendProfile.id = targetID
        sendProfile.pinnedPostData = pinnedPostData
        netstream.Start(client, "NetSocialProfileDetails", sendProfile, posts)
    else
        client:notify("Profile not found.")
    end
end)

netstream.Hook("NetSocialGetPostDetails", function(client, postID)
    local foundPost = nil
    for _, post in ipairs(CYR_SOCIAL_POSTS) do
        if post.id == postID then
            foundPost = table.Copy(post)
            -- Inject avatar
            if foundPost.authorID and CYR_SOCIAL_PROFILES[foundPost.authorID] then foundPost.avatar = CYR_SOCIAL_PROFILES[foundPost.authorID].avatar end
            -- Inject comment avatars
            if foundPost.comments then
                for _, c in ipairs(foundPost.comments) do
                    if c.authorID and CYR_SOCIAL_PROFILES[c.authorID] then c.avatar = CYR_SOCIAL_PROFILES[c.authorID].avatar end
                end
            end

            break
        end
    end

    if foundPost then
        netstream.Start(client, "NetSocialPostDetails", foundPost)
    else
        client:notify("Post not found.")
    end
end)

netstream.Hook("NetSocialGetNotifications", function(client)
    local char = client:getChar()
    if not char then return end
    local charID = tostring(char:getID())
    local notifs = CYR.Net.Notifications[charID] or {}
    -- Sort by time desc
    table.sort(notifs, function(a, b) return a.time > b.time end)
    netstream.Start(client, "NetSocialSendNotifications", notifs)
end)

netstream.Hook("NetSocialMarkNotificationRead", function(client, notifID)
    local char = client:getChar()
    if not char then return end
    local charID = tostring(char:getID())
    if CYR.Net.Notifications[charID] then
        for _, n in ipairs(CYR.Net.Notifications[charID]) do
            if n.id == notifID then
                n.read = true
                SaveNotifications()
                break
            end
        end
    end
end)

netstream.Hook("NetSocialLikeComment", function(client, postID, commentID)
    local char = client:getChar()
    if not char then return end
    local charID = tostring(char:getID())
    local profile = CYR_SOCIAL_PROFILES[charID]
    if not profile then return end
    local found = false
    local foundPost = nil
    for _, post in ipairs(CYR_SOCIAL_POSTS) do
        if post.id == tostring(postID) then
            if post.comments then
                for _, comm in ipairs(post.comments) do
                    if comm.id == commentID then
                        if not comm.likes then comm.likes = {} end
                        if comm.likes[charID] then
                            comm.likes[charID] = nil
                            client:notify("Unliked comment.")
                        else
                            comm.likes[charID] = true
                            client:notify("Liked comment.")
                            -- Notify comment author
                            if comm.authorID ~= charID then
                                AddNotification(comm.authorID, "like", "@" .. profile.handle .. " liked your comment.", {
                                    postID = post.id
                                })
                            end
                        end

                        comm.likeCount = table.Count(comm.likes)
                        found = true
                        foundPost = post
                        break
                    end
                end
            end
        end

        if found then break end
    end

    if found and foundPost then
        SavePosts()
        BroadcastPostUpdate(foundPost)
        -- Send updated comments to the liker to refresh UI
        local comments = table.Copy(foundPost.comments)
        for _, c in ipairs(comments) do
            if c.authorID and CYR_SOCIAL_PROFILES[c.authorID] then c.avatar = CYR_SOCIAL_PROFILES[c.authorID].avatar end
        end

        netstream.Start(client, "NetSocialSendComments", comments)
    end
end)