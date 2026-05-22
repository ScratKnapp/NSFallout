local SOCIAL = CYR.Net.Social
function SOCIAL:BuildMessages(targetID)
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    self.messengerPanel = html -- Store reference for hooks
    html.activeContact = targetID
    -- Interface with Lua
    function html:DetectImages(text)
        local words = string.Explode(" ", text)
        local cleanWords = {}
        local imageURL = nil
        for _, word in ipairs(words) do
            local lower = string.lower(word)
            local isImgURL = lower:find("https?://") and (lower:find("%.png") or lower:find("%.jpg") or lower:find("%.jpeg") or lower:find("%.gif") or lower:find("%.webp") or lower:find("imgur%.com") or lower:find("catbox%.moe"))
            if isImgURL and not imageURL then
                imageURL = word
            else
                table.insert(cleanWords, word)
            end
        end
        return table.concat(cleanWords, " "), imageURL
    end

    function html:SetContacts(data)
        -- Proxy avatars
        for _, c in pairs(data) do
            if c.avatar then c.avatar = CYR.Net.ProxyImgur(c.avatar) end
        end

        local json = util.TableToJSON(data)
        self:Call("updateContacts(" .. json .. ")")
    end

    function html:SetOnlinePlayers(data)
        for _, p in pairs(data) do
            if p.avatar then p.avatar = CYR.Net.ProxyImgur(p.avatar) end
        end

        local json = util.TableToJSON(data)
        self:Call("updateOnlineList(" .. json .. ")")
    end

    function html:OnHistoryReceived(messages, isPagination)
        local myID = LocalPlayer():getChar():getID()
        -- Mark which messages are mine
        for _, msg in ipairs(messages) do
            msg.isMine = msg.sender == myID
            if msg.senderAvatar then msg.senderAvatar = CYR.Net.ProxyImgur(msg.senderAvatar) end
            local cleanText, imgURL = self:DetectImages(msg.text or "")
            msg.text = cleanText
            msg.hasImageEmbed = imgURL
            if imgURL then msg.hasImageEmbed = CYR.Net.ProxyImgur(imgURL) end
        end

        local json = util.TableToJSON(messages)
        if isPagination then
            self:Call("prependMessages(" .. json .. ")")
        else
            self:Call("setMessages(" .. json .. ")")
        end
    end

    function html:AddMessage(msg)
        msg.isMine = msg.sender == LocalPlayer():getChar():getID()
        if msg.senderAvatar then msg.senderAvatar = CYR.Net.ProxyImgur(msg.senderAvatar) end
        local cleanText, imgURL = self:DetectImages(msg.text or "")
        msg.text = cleanText
        msg.hasImageEmbed = imgURL
        if imgURL then msg.hasImageEmbed = CYR.Net.ProxyImgur(imgURL) end
        local json = util.TableToJSON(msg)
        self:Call("addMessage(" .. json .. ")")
    end

    html:AddFunction("CYR_net", "sendMessage", function(text) if html.activeContact then netstream.Start("NetMsgSend", html.activeContact, text, "text") end end)
    html:AddFunction("CYR_net", "fetchOnlinePlayers", function() netstream.Start("NetMsgFetchOnlinePlayers") end)
    html:AddFunction("CYR_net", "selectContact", function(id)
        html.activeContact = id
        netstream.Start("NetMsgFetch", id)
    end)

    html:AddFunction("CYR_net", "fetchMore", function(id, time) if html.activeContact == id then netstream.Start("NetMsgFetch", id, time) end end)
    html:AddFunction("CYR_net", "createGroup", function(name, jsonIds)
        if not name or name == "" then return end
        local ids = {}
        if jsonIds and jsonIds ~= "" then ids = util.JSONToTable(jsonIds) or {} end
        netstream.Start("NetMsgCreateGroup", name, ids)
    end)

    html:AddFunction("CYR_net", "addToGroup", function(groupID, jsonIds)
        if not groupID then return end
        local ids = {}
        if jsonIds and jsonIds ~= "" then ids = util.JSONToTable(jsonIds) or {} end
        netstream.Start("NetMsgAddToGroup", groupID, ids)
        timer.Simple(0.2, function() netstream.Start("NetMsgFetchContacts") end)
    end)

    html:AddFunction("CYR_net", "removeFromGroup", function(groupID, memberID)
        if not groupID or not memberID then return end
        netstream.Start("NetMsgRemoveFromGroup", groupID, memberID)
        timer.Simple(0.2, function() netstream.Start("NetMsgFetchContacts") end)
    end)

    html:AddFunction("CYR_net", "leaveGroup", function(groupID)
        if not groupID then return end
        netstream.Start("NetMsgLeaveGroup", groupID)
        timer.Simple(0.2, function() netstream.Start("NetMsgFetchContacts") end)
    end)

    html:AddFunction("CYR_net", "deleteGroup", function(groupID)
        if not groupID then return end
        netstream.Start("NetMsgDeleteGroup", groupID)
        timer.Simple(0.2, function() netstream.Start("NetMsgFetchContacts") end)
    end)

    html:AddFunction("CYR_net", "closeMessages", function() self:Navigate("net://feed", "FEED") end)
    netstream.Start("NetMsgFetchContacts")
    if targetID then netstream.Start("NetMsgFetch", targetID) end
    local myID = LocalPlayer():getChar():getID()
    local page = [[
        <!DOCTYPE html>
        <html>
        <head>
            ]] .. CYR.Net.HTML.CSS .. [[

            <style>
                /* Chat Specific Styles */
                body { padding: 0; display: flex; height: 100vh; overflow: hidden; }
                
                .sidebar {
                    width: 250px;
                    background: rgba(0,0,0,0.5);
                    border-right: 1px solid #00f0ff;
                    display: flex;
                    flex-direction: column;
                }
                
                .sidebar-header {
                    padding: 10px;
                    background: rgba(0, 240, 255, 0.1);
                    text-align: center;
                    font-weight: bold;
                    border-bottom: 1px solid #00f0ff;
                    flex-shrink: 0;
                }
                
                #contact-list {
                    flex: 1;
                    overflow-y: auto;
                }
                
                .contact {
                    padding: 10px;
                    border-bottom: 1px solid rgba(0, 240, 255, 0.2);
                    cursor: pointer;
                    transition: background 0.2s;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }
                
                .contact:hover, .contact.active {
                    background: rgba(0, 240, 255, 0.2);
                }
                
                .contact-name { font-weight: bold; }

                .contact-avatar {
                    width: 30px;
                    height: 30px;
                    border: 1px solid #00f0ff;
                    background: #333;
                    background-size: cover;
                    background-position: center;
                    flex-shrink: 0;
                }
                
                .chat-area {
                    flex: 1;
                    display: flex;
                    flex-direction: column;
                    background: rgba(0,0,0,0.2);
                }
                
                .chat-header {
                    padding: 10px;
                    background: rgba(0,0,0,0.8);
                    border-bottom: 1px solid #00f0ff;
                    font-size: 1.2em;
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    gap: 10px;
                }

                #chat-actions { display:flex; gap: 8px; }
                #chat-actions button { width: auto; font-size: 12px; padding: 6px 10px; }
                
                .messages {
                    flex: 1;
                    overflow-y: auto;
                    padding: 20px;
                    display: flex;
                    flex-direction: column;
                }
                
                .input-area {
                    padding: 10px;
                    background: rgba(0,0,0,0.8);
                    border-top: 1px solid #00f0ff;
                    display: flex;
                    gap: 10px;
                }
                
                .input-area input { margin-bottom: 0; }
                .input-area button { width: auto; font-size: 14px; padding: 10px 15px; }

                .message-bubble { 
                    max-width: 60%;
                    word-wrap: break-word;
                    background: rgba(0, 240, 255, 0.05);
                    border: 1px solid rgba(0, 240, 255, 0.2);
                    padding: 10px;
                }
                
                .message-bubble.mine {
                    background: rgba(0, 240, 255, 0.15);
                    border-color: rgba(0, 240, 255, 0.4);
                }

                .msg-row { display:flex; align-items:flex-end; gap: 10px; margin-bottom: 8px; }
                .msg-row.mine { justify-content: flex-end; }
                .msg-avatar {
                    width: 26px;
                    height: 26px;
                    border: 1px solid rgba(0, 240, 255, 0.6);
                    background: #333;
                    background-size: cover;
                    background-position: center;
                    flex-shrink: 0;
                }
                
                .message-text { margin-bottom: 5px; }
                .message-image {
                    max-width: 100%;
                    max-height: 300px;
                    border: 1px solid #00f0ff;
                    display: block;
                    margin-top: 5px;
                }

                .msg-timestamp {
                    text-align: center;
                    color: rgba(0, 240, 255, 0.4);
                    font-size: 0.8em;
                    margin: 15px 0;
                    text-transform: uppercase;
                    width: 100%;
                }

                /* Simple overlay modal for group management / group creation */
                #overlay {
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0,0,0,0.8);
                    display: none;
                    align-items: center;
                    justify-content: center;
                    z-index: 200;
                }
                #overlay .modal {
                    background: #111;
                    border: 2px solid #00f0ff;
                    width: 600px;
                    max-width: 90vw;
                    max-height: 80vh;
                    display: flex;
                    flex-direction: column;
                    padding: 16px;
                }
                #overlay .modal h2 { margin: 0 0 10px 0; }
                #overlay .modal .scroll { overflow-y:auto; border: 1px solid #333; padding: 10px; flex: 1; }
                #overlay .modal .row { display:flex; justify-content: space-between; align-items:center; gap: 10px; margin-top: 10px; }
                #overlay .modal input { background:#222; border: 1px solid #444; color:#fff; padding: 8px; font-family: 'Rajdhani', sans-serif; }
                #overlay .modal button { width:auto; }
            </style>
        </head>
        <body>
            <div class="sidebar">
                <div class="sidebar-header" style="display: flex; justify-content: space-between; align-items: center;">
                    <span>CONTACTS</span>
                    <div style="display:flex; gap:5px;">
                        <button onclick="openNewChat()" style="width: auto; padding: 2px 8px; font-size: 0.8em; border: 1px solid #00f0ff; color: #00f0ff; background: transparent;">+</button>
                        <button onclick="CYR_net.closeMessages()" style="width: auto; padding: 2px 8px; font-size: 0.8em; border: 1px solid #ff0055; color: #ff0055; background: transparent;">X</button>
                    </div>
                </div>
                <div id="contact-list"></div>
                <button onclick="openCreateGroup()" style="margin: 5px;">+ NEW GROUP</button>
            </div>
            <div class="chat-area">
                <div class="chat-header">
                    <div id="chat-header-avatar" style="width: 32px; height: 32px; background: #222; margin-right: 12px; border: 1px solid #00f0ff; background-size: cover; background-position: center;"></div>
                    <div id="chat-header">SELECT A CONTACT</div>
                    <div id="chat-actions"></div>
                </div>
                <div class="messages" id="messages"></div>
                <div class="input-area">
                    <input type="text" id="msg-input" placeholder="Type a message..." onkeydown="if(event.key === 'Enter') send()">
                    <button onclick="send()">SEND</button>
                </div>
            </div>

            <div id="overlay">
                <div class="modal">
                    <h2 id="overlay-title">GROUP</h2>
                    <div id="overlay-body" class="scroll"></div>
                    <div class="row">
                        <button onclick="closeOverlay()" style="border-color:#f00; color:#f00;">CLOSE</button>
                        <div id="overlay-actions" style="display:flex; gap:8px;"></div>
                    </div>
                </div>
            </div>
            
            <script>
                var myID = ]] .. myID .. [[;
                var activeContactId = null;
                var contactsCache = [];
                var lastVirtualTime = 0;
                var oldestMessageTime = 0;
                var isFetching = false;

                function formatTime(unix) {
                    var now = Math.floor(Date.now() / 1000);
                    var diff = now - unix;
                    if (diff < 12 * 3600) {
                        if (diff < 60) return "Just now";
                        if (diff < 3600) return Math.floor(diff / 60) + "m ago";
                        return Math.floor(diff / 3600) + "h ago";
                    }
                    var date = new Date(unix * 1000);
                    return date.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit', hour12: false}) + " " + date.toLocaleDateString();
                }

                function closeOverlay() {
                    document.getElementById('overlay').style.display = 'none';
                    document.getElementById('overlay-body').innerHTML = '';
                    document.getElementById('overlay-actions').innerHTML = '';
                }

                function openOverlay(title, bodyHtml, actionsHtml) {
                    document.getElementById('overlay-title').innerText = title;
                    document.getElementById('overlay-body').innerHTML = bodyHtml || '';
                    document.getElementById('overlay-actions').innerHTML = actionsHtml || '';
                    document.getElementById('overlay').style.display = 'flex';
                }

                function getActiveContact() {
                    for (var i=0; i<contactsCache.length; i++) {
                        if (String(contactsCache[i].id) === String(activeContactId)) return contactsCache[i];
                    }
                    return null;
                }

                function renderHeaderActions() {
                    var el = document.getElementById('chat-actions');
                    var c = getActiveContact();
                    if (!c || !c.isGroup) {
                        el.innerHTML = '';
                        return;
                    }

                    el.innerHTML = '<button onclick="openGroupManage()"><i class="fa fa-users"></i> MANAGE</button>';
                }

                function openGroupManage() {
                    var c = getActiveContact();
                    if (!c || !c.isGroup) return;

                    var participants = c.participants || {};
                    var ids = Object.keys(participants);
                    ids.sort();

                    var isOwner = (String(c.owner || '') === String(myID));
                    var body = '';
                    body += '<div style="margin-bottom:10px; color:#aaa;">Members</div>';
                    if (ids.length === 0) {
                        body += '<div style="color:#666;">No members.</div>';
                    } else {
                        ids.forEach(function(id){
                            var canRemove = isOwner && String(id) !== String(myID);
                            body += '<div style="display:flex; justify-content:space-between; align-items:center; gap:10px; padding:6px 0; border-bottom:1px solid #222;">'
                                + '<div style="color:#00f0ff;">' + id + '</div>'
                                + (canRemove ? ('<button onclick="CYR_net.removeFromGroup(\'' + c.id + '\',' + id + ')" style="border-color:#f00; color:#f00;">REMOVE</button>') : '<div></div>')
                                + '</div>';
                        });
                    }

                    var actions = '';
                    actions += '<button onclick="openGroupAdd()"><i class="fa fa-user-plus"></i> ADD</button>';
                    actions += '<button onclick="CYR_net.leaveGroup(\'' + c.id + '\')" style="border-color:#f00; color:#f00;"><i class="fa fa-sign-out"></i> LEAVE</button>';
                    if (isOwner) {
                        actions += '<button onclick="CYR_net.deleteGroup(\'' + c.id + '\')" style="border-color:#f00; color:#f00;"><i class="fa fa-trash"></i> DELETE</button>';
                    }
                    openOverlay(c.name || 'Group', body, actions);
                }

                function openGroupAdd() {
                    var c = getActiveContact();
                    if (!c || !c.isGroup) return;
                    var participants = c.participants || {};
                    var body = '<div style="margin-bottom:10px; color:#aaa;">Add members from your contacts</div>';

                    var rows = 0;
                    contactsCache.forEach(function(ct){
                        if (ct.isGroup) return;
                        if (participants && participants[String(ct.id)]) return;
                        rows++;

                        var displayName = (ct.handle && ct.handle !== "") ? "@" + ct.handle : (ct.name || ct.id);
                        var avatar = ct.avatar || '';
                        var avStyle = 'width:22px; height:22px; border:1px solid #00f0ff; background:#333; background-size:cover; background-position:center; display:inline-block;';
                        if (avatar) avStyle += 'background-image:url(' + avatar + ');';
                        body += '<label style="display:flex; align-items:center; gap:10px; padding:6px 0; border-bottom:1px solid #222; cursor:pointer;">'
                            + '<input type="checkbox" class="add-member" value="' + ct.id + '">' 
                            + '<span style="' + avStyle + '"></span>'
                            + '<span>' + displayName + '</span>'
                            + '</label>';
                    });

                    if (rows === 0) {
                        body += '<div style="color:#666;">No eligible contacts to add.</div>';
                    }

                    var actions = '';
                    actions += '<button onclick="submitGroupAdd()"><i class="fa fa-check"></i> ADD SELECTED</button>';
                    openOverlay('Add Members', body, actions);
                }

                function submitGroupAdd() {
                    var c = getActiveContact();
                    if (!c || !c.isGroup) return;
                    var ids = [];
                    document.querySelectorAll('.add-member:checked').forEach(function(cb){ ids.push(Number(cb.value)); });
                    if (ids.length > 0) {
                        CYR_net.addToGroup(c.id, JSON.stringify(ids));
                    }
                    closeOverlay();
                }

                function openCreateGroup() {
                    var body = '';
                    body += '<div style="margin-bottom:10px;">'
                        + '<div style="color:#aaa; margin-bottom:6px;">Group name</div>'
                        + '<input id="new-group-name" type="text" placeholder="Group name" style="width:100%;">'
                        + '</div>';
                    body += '<div style="margin-bottom:10px; color:#aaa;">Select members</div>';

                    var rows = 0;
                    contactsCache.forEach(function(ct){
                        if (ct.isGroup) return;
                        rows++;
                        var displayName = (ct.handle && ct.handle !== "") ? "@" + ct.handle : (ct.name || ct.id);
                        var avatar = ct.avatar || '';
                        var avStyle = 'width:22px; height:22px; border:1px solid #00f0ff; background:#333; background-size:cover; background-position:center;';
                        if (avatar) avStyle += 'background-image:url(' + avatar + ');';
                        body += '<label style="display:flex; align-items:center; gap:10px; padding:6px 0; border-bottom:1px solid #222; cursor:pointer;">'
                            + '<input type="checkbox" class="new-group-member" value="' + ct.id + '">' 
                            + '<div style="' + avStyle + '"></div>'
                            + '<span>' + displayName + '</span>'
                            + '</label>';
                    });
                    if (rows === 0) body += '<div style="color:#666;">No contacts available.</div>';

                    var actions = '<button onclick="submitCreateGroup()"><i class="fa fa-plus"></i> CREATE</button>';
                    openOverlay('Create Group', body, actions);
                }

                function submitCreateGroup() {
                    var name = (document.getElementById('new-group-name') || {}).value || '';
                    name = name.trim();
                    if (!name) return;

                    var ids = [];
                    document.querySelectorAll('.new-group-member:checked').forEach(function(cb){ ids.push(Number(cb.value)); });
                    CYR_net.createGroup(name, JSON.stringify(ids));
                    closeOverlay();
                }

                function updateContacts(contacts) {
                    contactsCache = contacts || [];
                    // Sort by last message time descending
                    contactsCache.sort(function(a, b) {
                        return (b.lastMsgTime || 0) - (a.lastMsgTime || 0);
                    });

                    var list = document.getElementById('contact-list');
                    list.innerHTML = '';
                    contacts.forEach(function(c) {
                        var div = document.createElement('div');
                        div.className = 'contact ' + (c.id == activeContactId ? 'active' : '');
                        var avatar = c.avatar || '';
                        var displayName = (c.handle && c.handle !== "") ? "@" + c.handle : c.name;
                        var nameStyle = c.isOnline ? '' : 'color: #888;';
                        
                        div.innerHTML = '<div class="contact-avatar" style="' + (avatar ? ('background-image:url(' + avatar + ');') : '') + '"></div>'
                            + '<div><div class="contact-name" style="' + nameStyle + '">' + displayName + '</div></div>';
                        div.onclick = function() {
                            activeContactId = c.id;
                            document.querySelectorAll('.contact').forEach(el => el.classList.remove('active'));
                            div.classList.add('active');
                            document.getElementById('chat-header').innerText = displayName;
                            var headAv = document.getElementById('chat-header-avatar');
                            if(headAv) {
                                 if(c.avatar) headAv.style.backgroundImage = 'url(' + c.avatar + ')';
                                 else headAv.style.backgroundImage = 'none';
                            }
                            CYR_net.selectContact(c.id);
                            renderHeaderActions();
                        };
                        list.appendChild(div);
                    });
                }
                
                function setMessages(messages) {
                    var container = document.getElementById('messages');
                    container.innerHTML = '';
                    lastVirtualTime = 0;
                    oldestMessageTime = 0;
                    if (messages.length > 0) oldestMessageTime = messages[0].time;
                    
                    messages.forEach(function(msg) {
                        addMessageToUI(msg);
                    });
                    scrollToBottom();
                    setupScrollListener();
                }

                function prependMessages(messages) {
                    isFetching = false;
                    if (!messages || messages.length === 0) return;
                    
                    var container = document.getElementById('messages');
                    // Save scroll height before prepend
                    var oldHeight = container.scrollHeight;
                    var oldTop = container.scrollTop;

                    // Update oldest time
                    if (messages[0].time && (oldestMessageTime === 0 || messages[0].time < oldestMessageTime)) {
                        oldestMessageTime = messages[0].time;
                    }

                    // We need to render these messages and insert them at the top
                    // Note: messages array is usually oldest -> newest. 
                    // So we iterate them in order, but insert them before the first child.
                    // Actually, simpler: render a temporary div with all new messages, then prepend children?
                    // But we used addMessageToUI which appends. Let's refactor or just allow targeted insert.
                    
                    // Reverse loop to insert right after the timestamp? No, addMessageToUI appends.
                    // Let's create a fragment
                    var fragment = document.createDocumentFragment();
                    var tempLastTime = 0; // Local tracking for this batch? 
                    // This is tricky because existing code tracks `lastVirtualTime` for append.
                    // For prepend, we might just ignore the time-gap display or try to be smart.
                    // For simplicity, let's just render them. Timestamps might look weird if we don't sort everything.
                    // But usually prepend is history.
                    
                    // Simple approach: Render to a temporary container string
                    var html = '';
                    messages.forEach(function(msg) { html += renderMessageHTML(msg); });
                    
                    // Insert at top
                    container.insertAdjacentHTML('afterbegin', html);
                    
                    // Restore scroll position
                    var newHeight = container.scrollHeight;
                    container.scrollTop = oldTop + (newHeight - oldHeight);
                }

                function setupScrollListener() {
                    var container = document.getElementById('messages');
                    container.onscroll = function() {
                        if (container.scrollTop < 50 && !isFetching && oldestMessageTime > 0) {
                            isFetching = true;
                            // Add small delay debounce
                            setTimeout(function() {
                                CYR_net.fetchMore(activeContactId, oldestMessageTime);
                            }, 200);
                        }
                    };
                }

                function renderMessageHTML(msg) {
                    msg.isMine = msg.sender == myID;
                    if (msg.sender == -1) msg.isMine = false;
                    
                    var bubbleClass = 'message-bubble ' + (msg.isMine ? 'mine' : '');
                    var rowClass = 'msg-row ' + (msg.isMine ? 'mine' : '');
                    
                    var html = '<div class="' + rowClass + '">';
                    
                    if (!msg.isMine) {
                        var avStyle = '';
                        if (msg.senderAvatar) avStyle = 'background-image:url(' + msg.senderAvatar + ');';
                        html += '<div class="msg-avatar" style="' + avStyle + '"></div>';
                    }

                    var text = (msg.text || "").replace(/</g, '&lt;').replace(/>/g, '&gt;');
                    text = parseEmojis(text);
                    var sender = msg.senderName || (msg.isMine ? 'You' : 'Them');
                    
                    html += '<div class="' + bubbleClass + '">';
                    html += '<div class="message-sender" style="font-size:0.8em; color:#888; margin-bottom:2px;">' + sender + '</div>';
                    html += '<div class="message-text">' + text + '</div>';
                    
                    if(msg.hasImageEmbed) {
                        html += '<img class="message-image" src="' + msg.hasImageEmbed + '">';
                    } else if(msg.type == 'image') {
                        html += '<img class="message-image" src="' + msg.text + '">';
                    }
                    
                    html += '</div></div>'; // Close bubble, Close row
                    
                    // Optional: Prepend timestamp? 
                    // For simplicity in this raw HTML builder, we skip dynamic timestamp gaps for history chunks. 
                    // Or we can just add one for the first message of the chunk.
                    if (msg.time) {
                         // html = '<div class="msg-timestamp">' + formatTime(msg.time) + '</div>' + html;
                    }
                    
                    return html;
                }
                
                function addMessage(msg) {
                    addMessageToUI(msg);
                    scrollToBottom();
                }
                
                function addMessageToUI(msg) {
                    var container = document.getElementById('messages');
                    var msgTime = msg.time || 0;

                    if (msgTime > lastVirtualTime) {
                         var ts = document.createElement('div');
                         ts.className = 'msg-timestamp';
                         ts.innerText = formatTime(msgTime);
                         container.appendChild(ts);
                         lastVirtualTime = msgTime + 300;
                    } else {
                         lastVirtualTime += 300;
                    }

                    if (msg.sender == -1) msg.isMine = false; // "Them" fake message
                    
                    var container = document.getElementById('messages');
                    var row = document.createElement('div');
                    row.className = 'msg-row ' + (msg.isMine ? 'mine' : '');

                    if (!msg.isMine) {
                        var av = document.createElement('div');
                        av.className = 'msg-avatar';
                        if (msg.senderAvatar) {
                            av.style.backgroundImage = 'url(' + msg.senderAvatar + ')';
                        }
                        row.appendChild(av);
                    }

                    var div = document.createElement('div');
                    div.className = 'message-bubble ' + (msg.isMine ? 'mine' : '');
                    
                    var text = (msg.text || "").replace(/</g, '&lt;').replace(/>/g, '&gt;');
                    text = parseEmojis(text);
                    var sender = msg.senderName || (msg.isMine ? 'You' : 'Them');
                    div.innerHTML = '<div class="message-sender" style="font-size:0.8em; color:#888; margin-bottom:2px;">' + sender + '</div><div class="message-text">' + text + '</div>';
                    
                    if(msg.hasImageEmbed) {
                         div.innerHTML += '<img class="message-image" src="' + msg.hasImageEmbed + '">';
                    } else if(msg.type == 'image') {
                         div.innerHTML += '<img class="message-image" src="' + msg.text + '">';
                    }

                    row.appendChild(div);
                    container.appendChild(row);
                }

                function forceSelectContact(id, name, avatar, handle) {
                    activeContactId = id;
                    var c = null;
                    for (var i=0;i<contactsCache.length;i++) if (String(contactsCache[i].id) === String(id)) { c = contactsCache[i]; break; }
                    
                    if (c) {
                        name = c.name;
                        avatar = c.avatar;
                        handle = c.handle;
                    }

                    var displayName = (handle && handle !== "") ? "@" + handle : (name || "Unknown");
                    document.getElementById('chat-header').innerText = displayName;
                    var headAv = document.getElementById('chat-header-avatar');
                    if (headAv) {
                            if(avatar) headAv.style.backgroundImage = 'url(' + avatar + ')';
                            else headAv.style.backgroundImage = 'none';
                    }
                    
                    document.querySelectorAll('.contact').forEach(el => el.classList.remove('active'));
                    renderHeaderActions();
                    CYR_net.selectContact(id);
                }
                
                function scrollToBottom() {
                    var container = document.getElementById('messages');
                    container.scrollTop = container.scrollHeight;
                }
                
                function send() {
                    var input = document.getElementById('msg-input');
                    var text = input.value;
                    if(text) {
                        CYR_net.sendMessage(text);
                        input.value = '';
                    }
                }

                function openNewChat() {
                    var body = '<div style="margin-bottom:10px; color:#aaa;">Select a user to message</div>';
                    body += '<div id="online-list" style="display:flex; flex-direction:column; gap:5px;">Loading...</div>';
                    openOverlay('New Chat', body, '');
                    CYR_net.fetchOnlinePlayers();
                }

                function updateOnlineList(players) {
                    var el = document.getElementById('online-list');
                    if (!el) return;
                    el.innerHTML = '';
                    if (!players || players.length === 0) {
                        el.innerHTML = '<div style="color:#666;">No valid users found nearby.</div>';
                        return;
                    }
                    
                    players.forEach(function(p) {
                         var div = document.createElement('div');
                         div.style.padding = '8px';
                         div.style.borderBottom = '1px solid #222';
                         div.style.cursor = 'pointer';
                         div.style.display = 'flex';
                         div.style.alignItems = 'center';
                         div.style.gap = '10px';
                         
                         var avatar = p.avatar || '';
                         var avStyle = 'width:24px; height:24px; border:1px solid #00f0ff; background:#333; background-size:cover; background-position:center;';
                         if (avatar) avStyle += 'background-image:url(' + avatar + ');';
                         
                         var displayName = (p.handle && p.handle !== "") ? "@" + p.handle : p.name;
                         
                         div.innerHTML = '<div style="' + avStyle + '"></div><div>' + displayName + '</div>';
                         var jsonP = JSON.stringify(p).replace(/"/g, '&quot;');
                         div.onclick = function() {
                             forceSelectContact(p.id, p.name, p.avatar, p.handle);
                             closeOverlay();
                         };
                         div.onmouseover = function() { this.style.background = '#222'; };
                         div.onmouseout = function() { this.style.background = 'transparent'; };
                         
                         el.appendChild(div);
                    });
                }
            </script>
        </body>
        </html>
    ]]
    html:SetHTML(page)
end