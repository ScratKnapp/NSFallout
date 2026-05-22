local SOCIAL = CYR.Net.Social
local CP_CYAN = CYR.COLORS.Primary
local CP_RED = CYR.COLORS.Secondary
local CP_BG = Color(10, 10, 15, 250)
local CP_BUBBLE_FILL = Color(10, 20, 25, 200)
hook.Add("CYR_ColorSchemeChanged", "CYR.Net.Pages.PostView24", function(self, post)
    CP_CYAN = CYR.COLORS.Primary
    CP_RED = CYR.COLORS.Secondary
end)

function SOCIAL:BuildProfileView(data)
    local profile = data.profile
    local posts = data.posts
    local myID = LocalPlayer():getChar():getID()
    local isAdmin = LocalPlayer():IsAdmin()
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    self.feedPanel = html
    -- Expose data to JS
    if profile.avatar then profile.avatar = CYR.Net.ProxyImgur(profile.avatar) end
    if posts then
        for _, p in pairs(posts) do
            if p.avatar then p.avatar = CYR.Net.ProxyImgur(p.avatar) end
            if p.image then p.image = CYR.Net.ProxyImgur(p.image) end
        end
    end

    local profileJson = util.TableToJSON(profile)
    local postsJson = util.TableToJSON(posts)
    -- Callbacks
    html:AddFunction("CYR_net", "goBack", function() self:Navigate("net://feed", "FEED") end)
    html:AddFunction("CYR_net", "deleteProfile", function()
        Derma_Query("Delete this profile and all posts?", "Confirm Delete", "Yes", function()
            netstream.Start("NetSocialDeleteProfile", profile.handle)
            self:Navigate("net://feed", "FEED")
        end, "No", function() end)
    end)

    html:AddFunction("CYR_net", "followUser", function(wantToFollow) netstream.Start("NetSocialFollowUser", profile.handle, wantToFollow) end)
    html:AddFunction("CYR_net", "messageUser", function() self:Navigate("net://messages", "MESSAGES", tonumber(profile.id)) end)
    html:AddFunction("CYR_net", "updateProfile", function(newHandle, newBio, newAvatar)
        if newHandle ~= profile.handle then netstream.Start("NetSocialChangeHandle", newHandle) end
        netstream.Start("NetSocialUpdateProfile", newBio, newAvatar)
        timer.Simple(0.5, function()
            local target = newHandle ~= "" and newHandle or profile.handle
            netstream.Start("NetSocialGetProfileDetails", target)
        end)
    end)

    html:AddFunction("CYR_net", "getFollowers", function() netstream.Start("NetSocialGetFollowers", profile.handle) end)
    html:AddFunction("CYR_net", "getFollowing", function() netstream.Start("NetSocialGetFollowing", profile.handle) end)
    html:AddFunction("CYR_net", "openSteam", function(sid) gui.OpenURL("http://steamcommunity.com/profiles/" .. util.SteamIDTo64(sid)) end)
    html:AddFunction("CYR_net", "updateURL", function(url)
        if IsValid(self.urlEntry) then self.urlEntry:SetText(url) end
        self.currentURL = url
    end)

    -- Post functions
    html:AddFunction("CYR_net", "deletePost", function(postId)
        netstream.Start("NetSocialDeletePost", postId)
        -- Refresh profile after a bit
        timer.Simple(0.2, function() netstream.Start("NetSocialGetProfileDetails", profile.handle) end)
    end)

    html:AddFunction("CYR_net", "likePost", function(postId) netstream.Start("NetSocialLikePost", postId) end)
    html:AddFunction("CYR_net", "getComments", function(postId) netstream.Start("NetSocialGetComments", postId) end)
    html:AddFunction("CYR_net", "postComment", function(postId, content, imageUrl) netstream.Start("NetSocialCommentPost", postId, content, imageUrl or "") end)
    html:AddFunction("CYR_net", "openPost", function(postID) netstream.Start("NetSocialGetPostDetails", postID) end)
    html:AddFunction("CYR_net", "pinPost", function(postId)
        netstream.Start("NetSocialPinPost", postId)
        timer.Simple(0.2, function() netstream.Start("NetSocialGetProfileDetails", profile.handle) end)
    end)

    html:AddFunction("CYR_net", "unpinPost", function()
        netstream.Start("NetSocialUnpinPost")
        timer.Simple(0.2, function() netstream.Start("NetSocialGetProfileDetails", profile.handle) end)
    end)

    html:AddFunction("CYR_net", "visit", function(url)
        if IsValid(self.urlEntry) then
            self.urlEntry:SetText(url)
            self.urlEntry.OnEnter(self.urlEntry)
        end
    end)

    -- Reuse feed update function logic
    function html:SetPosts(updatedPosts)
        for _, p in pairs(updatedPosts) do
            if p.avatar then p.avatar = CYR.Net.ProxyImgur(p.avatar) end
            if p.image then p.image = CYR.Net.ProxyImgur(p.image) end
            if p.comments then
                for _, c in pairs(p.comments) do
                    if c.avatar then c.avatar = CYR.Net.ProxyImgur(c.avatar) end
                    if c.image then c.image = CYR.Net.ProxyImgur(c.image) end
                end
            end
        end

        local json = util.TableToJSON(updatedPosts)
        self:Call("updatePosts(" .. json .. ")")
    end

    -- Real-time single post update
    function SOCIAL:UpdatePost(post)
        if IsValid(self.feedPanel) then
            if post.avatar then post.avatar = CYR.Net.ProxyImgur(post.avatar) end
            if post.comments then
                for _, c in pairs(post.comments) do
                    if c.avatar then c.avatar = CYR.Net.ProxyImgur(c.avatar) end
                    if c.image then c.image = CYR.Net.ProxyImgur(c.image) end
                end
            end

            local json = util.TableToJSON(post)
            self.feedPanel:Call("updatePost(" .. json .. ")")
        end
    end

    function html:ShowComments(comments)
        if comments then
            for _, c in pairs(comments) do
                if c.avatar then c.avatar = CYR.Net.ProxyImgur(c.avatar) end
                if c.image then c.image = CYR.Net.ProxyImgur(c.image) end
            end
        end

        local json = util.TableToJSON(comments)
        self:Call("showCommentsData(" .. json .. ")")
    end

    local page = [[
    <!DOCTYPE html>
    <html>
    <head>
        ]] .. CYR.Net.HTML.CSS .. [[
        <style>
             body { overflow-y: scroll; }
             .profile-header {
                 background: rgba(10, 20, 25, 0.8);
                 border: 1px solid #00f0ff;
                 padding: 20px;
                 margin-bottom: 20px;
                 position: relative;
             }
             .top-bar {
                 display: flex;
                 justify-content: space-between;
                 margin-bottom: 15px;
             }
             .info-area {
                 display: flex;
                 gap: 20px;
             }
             .profile-avatar {
                 width: 80px; height: 80px;
                 background: #333;
                 border: 1px solid #00f0ff;
                 background-size: cover;
                 background-position: center;
             }
             .profile-details {
                 flex-grow: 1;
             }
             .profile-handle {
                 font-size: 1.5em;
                 color: #00f0ff;
                 font-weight: bold;
             }
             .profile-stats {
                 display: flex;
                 gap: 15px;
                 margin: 5px 0;
                 color: #bbb;
                 font-weight: bold;
                 font-size: 0.9em;
             }
             .stat-link {
                 cursor: pointer;
                 transition: color 0.2s;
             }
             .stat-link:hover { color: #fff; }
             .profile-bio {
                 background: rgba(0,0,0,0.4);
                 padding: 10px;
                 font-size: 0.9em;
                 white-space: pre-wrap;
             }
             .action-btn {
                 background: transparent;
                 border: 1px solid #00f0ff;
                 color: #00f0ff;
                 padding: 5px 10px;
                 cursor: pointer;
                 font-family: 'Rajdhani', sans-serif;
                 font-weight: bold;
                 display: flex;
                 align-items: center;
                 gap: 5px;
             }
             .action-btn:hover { background: rgba(0, 240, 255, 0.1); }
             .btn-red { border-color: #ff0055; color: #ff0055; }
             .btn-red:hover { background: rgba(255, 0, 85, 0.1); }
             
             .feed-item {
                 border-bottom: 1px solid #333;
                 padding: 15px;
                 margin-bottom: 15px;
                 background: rgba(0,0,0,0.3);
             }
             .feed-header {
                 display: flex;
                 align-items: center;
                 margin-bottom: 5px;
             }
             .feed-time { margin-left: auto; color: #666; font-size: 0.8em; }
             .feed-content { margin-bottom: 8px; white-space: pre-wrap; font-size: 0.95em; max-height: 300px; overflow-y: auto; }
             .feed-image { max-width: 100%; max-height: 300px; object-fit: contain; border: 1px solid #333; margin-top: 5px; }
             .feed-actions {
                 display: flex;
                 gap: 10px;
                 margin-top: 10px;
             }
             .feed-actions button {
                 width: auto;
                 display: flex;
                 align-items: center;
                 gap: 5px;
                 min-width: 0;
                 justify-content: center;
                 padding: 6px 8px;
                 border: none;
                 background: transparent;
             }
             .feed-actions button:hover { background: rgba(0, 240, 255, 0.12); }

             /* Modal logic */
             #edit-modal-overlay, #comments-modal-overlay {
                 position: fixed; top: 0; left: 0; width: 100%; height: 100%;
                 background: rgba(0,0,0,0.8);
                 display: none;
                 justify-content: center;
                 align-items: center;
                 z-index: 100;
             }
             .modal {
                 background: #111;
                 border: 2px solid #00f0ff;
                 padding: 20px;
                 width: 500px; /* Default width */
                 box-shadow: 0 0 20px rgba(0, 240, 255, 0.3);
                 max-height: 80vh;
                 display: flex;
                 flex-direction: column;
             }
             .modal-comments {
                 width: 85vw;
                 max-width: 1100px;
                 height: 80vh;
                 display: flex;
                 flex-direction: row;
                 gap: 20px;
             }
             .comment-left {
                 flex: 1;
                 overflow-y: auto;
                 border-right: 1px solid #333;
                 padding-right: 20px;
             }
             .comment-right {
                 flex: 1;
                 display: flex;
                 flex-direction: column;
             }
             .form-group { margin-bottom: 15px; }
             .form-group label { display: block; color: #00f0ff; margin-bottom: 5px; }
             .form-group input, .form-group textarea {
                 width: 100%;
                 background: #222;
                 border: 1px solid #444;
                 color: #fff;
                 padding: 5px;
                 font-family: 'Rajdhani', sans-serif;
             }
             .comment-list {
                 flex-grow: 1;
                 overflow-y: auto;
                 margin: 10px 0;
                 border: 1px solid #333;
                 padding: 10px;
             }
             .comment-item { margin-bottom: 10px; border-bottom: 1px solid #222; padding-bottom: 5px; }
             .comment-item div:nth-child(2) {
                 overflow-wrap: break-word;
                 word-break: break-word;
                 max-width: 100%;
                 max-height: 300px;
                 overflow-y: auto;
             }
             .comment-input-area {
                 display: flex;
                 gap: 10px;
                 margin-top: 10px;
             }
             .comment-input-area input {
                 flex-grow: 1;
                 background: #222;
                 border: 1px solid #444;
                 color: #fff;
                 padding: 8px;
                 font-family: 'Rajdhani', sans-serif;
             }
        </style>
    </head>
    <body>
        <!-- Edit Modal -->
        <div id="edit-modal-overlay">
            <div class="modal">
                <h2>EDIT PROFILE</h2>
                <div class="form-group">
                    <label>Handle (@)</label>
                    <input type="text" id="edit-handle">
                </div>
                <div class="form-group">
                    <label>Bio</label>
                    <textarea id="edit-bio" rows="3"></textarea>
                </div>
                <div class="form-group">
                    <label>Avatar URL</label>
                    <div style="display:flex; gap:10px; align-items:center;">
                         <input type="text" id="edit-avatar" oninput="updateEditPreview(this.value)">
                         <div id="edit-avatar-preview" style="width:40px; height:40px; background:#333; border:1px solid #00f0ff; background-size:cover; background-position:center; flex-shrink:0;"></div>
                    </div>
                </div>
                <div style="display: flex; gap: 10px; justify-content: flex-end;">
                    <button class="action-btn" onclick="saveProfile()">SAVE</button>
                    <button class="action-btn btn-red" onclick="document.getElementById('edit-modal-overlay').style.display='none'">CANCEL</button>
                </div>
            </div>
        </div>

        <!-- Comments Modal -->
        <div id="comments-modal-overlay" onclick="closeCommentsModal()">
             <div class="modal modal-comments" onclick="event.stopPropagation()">
                 <div class="comment-left">
                     <h2>Original Post</h2>
                     <div id="modal-post-preview"></div>
                 </div>
                 <div class="comment-right">
                     <h2>COMMENTS</h2>
                     <div id="comments-list" class="comment-list">Loading...</div>
                     
                     <div class="comment-input-area">
                         <input type="text" id="comment-input" placeholder="Write a comment..." onkeydown="if(event.key === 'Enter') submitComment()">
                         <button class="action-btn" onclick="submitComment()" style="width: 10%; min-width: 60px;"><i class="fa fa-paper-plane"></i> POST</button>
                     </div>
                 </div>
             </div>
        </div>

        <div class="container">
            <div class="profile-header">
                <div class="top-bar">
                    <button class="action-btn btn-red" onclick="CYR_net.goBack()"><i class="fa fa-arrow-left"></i> BACK</button>
                    <div id="profile-actions" style="display: flex; gap: 10px;"></div>
                </div>
                
                <div class="info-area">
                    <div class="profile-avatar" id="profile-avatar"></div>
                    <div class="profile-details">
                        <div class="profile-handle" id="profile-handle"></div>
                        <div class="profile-stats">
                            <span class="stat-link" onclick="CYR_net.getFollowers()"><span id="stat-followers">0</span> Followers</span>
                            |
                            <span class="stat-link" onclick="CYR_net.getFollowing()"><span id="stat-following">0</span> Following</span>
                        </div>
                        <div class="profile-bio" id="profile-bio"></div>
                    </div>
                </div>
            </div>
            
            <div id="pinned-post-container" style="display:none; margin-bottom: 20px;"></div>

            <div id="feed-list"></div>
        </div>

        <script>
            var profile = ]] .. profileJson .. [[;
            var myID = ]] .. myID .. [[;
            var isAdmin = ]] .. tostring(isAdmin) .. [[;
            var isMe = (profile.id == myID);
            var currentPostId = null;
            var postsCache = {};

            function formatTime(unixSeconds) {
                var d = new Date((unixSeconds || 0) * 1000);
                d.setFullYear(d.getFullYear() + 44);
                return d.toLocaleString();
            }
            
            // Followers map: key is ID as string
            profile.followers = profile.followers || {};
            var isFollowing = !!profile.followers[myID];
            
            function parseContent(text) {
                if(!text) return "";
                var safe = text.replace(/</g, '&lt;').replace(/>/g, '&gt;');
                safe = safe.replace(/@\{(\d+)\|([a-zA-Z0-9_]+)\}/g, function(match, id, handle) {
                    return `<span class="feed-handle" onclick="event.stopPropagation(); CYR_net.openProfile('${handle}')" style="display:inline; color:#00f0ff; cursor:pointer;">@${handle}</span>`;
                });
                safe = safe.replace(/@([a-zA-Z0-9_]+)/g, function(match, handle) {
                     if(match.startsWith('@{')) return match;
                     return `<span class="feed-handle" onclick="event.stopPropagation(); CYR_net.openProfile('${handle}')" style="display:inline; color:#00f0ff; cursor:pointer;">@${handle}</span>`;
                });
                safe = safe.replace(/net:\/\/([a-zA-Z0-9/._\-#?=]+)/g, function(match) {
                     return `<span onclick="event.stopPropagation(); CYR_net.visit('${match}')" style="display:inline; color:#ffaa00; cursor:pointer; text-decoration: underline;">${match}</span>`;
                });
                return safe;
            }

            function renderProfile() {
                document.getElementById('profile-handle').textContent = '@' + profile.handle;
                document.getElementById('profile-bio').innerHTML = parseContent(profile.bio || "No bio.");
                document.getElementById('profile-avatar').style.backgroundImage = 'url(' + (profile.avatar || '') + ')';
                document.getElementById('profile-avatar').style.backgroundSize = 'cover';
                document.getElementById('profile-avatar').style.backgroundPosition = 'center';
                
                var followersCount = Object.keys(profile.followers).length;
                var followingCount = Object.keys(profile.following || {}).length;
                document.getElementById('stat-followers').textContent = followersCount;
                document.getElementById('stat-following').textContent = followingCount;
                
                var actionsDiv = document.getElementById('profile-actions');
                actionsDiv.innerHTML = '';

                // Render Pinned Post
                var pinContainer = document.getElementById('pinned-post-container');
                if(profile.pinnedPostData) {
                    pinContainer.style.display = 'block';
                    var p = profile.pinnedPostData;
                     var imgHtml = '';
                    if(p.image) {
                        imgHtml = '<img src="' + p.image + '" class="feed-image">';
                    }
                    var content = parseContent(p.content);
                    
                    var pinAction = '';
                    if(isMe) {
                        pinAction = `<button class="action-btn" style="font-size:0.8em; border-color: #ffaa00; color: #ffaa00;" onclick="CYR_net.unpinPost()"><i class="fa fa-thumb-tack"></i> UNPIN</button>`;
                    }

                    pinContainer.innerHTML = `
                        <div style="font-size:0.8em; color:#ffaa00; margin-bottom:5px;"><i class="fa fa-thumb-tack"></i> PINNED POST</div>
                        <div class="feed-item" style="border-color: #ffaa00;">
                            <div class="feed-header">
                                <div class="feed-time">${formatTime(p.time)}</div>
                            </div>
                            <div class="feed-content" onclick="CYR_net.openPost('${p.id}')" style="cursor: pointer;">${content}</div>
                            ${imgHtml}
                            <div class="feed-actions">
                                <button class="action-btn" onclick="CYR_net.likePost('${p.id}')"><i class="fa fa-heart"></i> ${p.likeCount || 0}</button>
                                <button class="action-btn" onclick="openComments('${p.id}')"><i class="fa fa-comment"></i> ${p.commentCount || 0}</button>
                                ${pinAction}
                            </div>
                        </div>
                    `;
                } else {
                    pinContainer.style.display = 'none';
                    pinContainer.innerHTML = '';
                }
                
                if(isMe) {
                    actionsDiv.innerHTML += `<button class="action-btn" onclick="openEditModal()"><i class="fa fa-pencil"></i> EDIT</button>`;
                } else {
                    var followText = isFollowing ? "UNFOLLOW" : "FOLLOW";
                    var followClass = isFollowing ? "action-btn btn-red" : "action-btn";
                    var msgBtn = `<button class="action-btn" onclick="CYR_net.messageUser()"><i class="fa fa-envelope"></i> MESSAGE</button>`;
                    var followBtn = `<button class="${followClass}" onclick="toggleFollow()">${followText}</button>`;
                    actionsDiv.innerHTML += followBtn + msgBtn;
                }

                if(isAdmin) {
                    if(profile.steamID) {
                        actionsDiv.innerHTML += `<button class="action-btn" onclick="CYR_net.openSteam('${profile.steamID}')"><i class="fa fa-steam"></i> STEAM</button>`;
                    }
                    actionsDiv.innerHTML += `<button class="action-btn btn-red" style="margin-left: auto;" onclick="CYR_net.deleteProfile()"><i class="fa fa-trash"></i> DELETE</button>`;
                }
            }
            
            function openEditModal() {
                document.getElementById('edit-handle').value = profile.handle;
                document.getElementById('edit-bio').value = profile.bio || "";
                document.getElementById('edit-avatar').value = profile.avatar || "";
                updateEditPreview(profile.avatar || "");
                document.getElementById('edit-modal-overlay').style.display = 'flex';
            }

            function updateEditPreview(url) {
                var div = document.getElementById('edit-avatar-preview');
                if(url) {
                    div.style.backgroundImage = 'url(' + url + ')';
                } else {
                    div.style.backgroundImage = 'none';
                }
            }
            
            function saveProfile() {
                var h = document.getElementById('edit-handle').value;
                var b = document.getElementById('edit-bio').value;
                var a = document.getElementById('edit-avatar').value;
                CYR_net.updateProfile(h, b, a);
                document.getElementById('edit-modal-overlay').style.display = 'none';
            }
            
            function toggleFollow() {
                var wantToFollow = !isFollowing;
                CYR_net.followUser(wantToFollow);
                
                // Optimistic Update
                if(wantToFollow) {
                    profile.followers[myID] = true;
                } else {
                    delete profile.followers[myID];
                }
                isFollowing = wantToFollow;
                renderProfile();
            }

            function updatePost(post) {
                // Update cache
                postsCache[post.id] = post;
                // Update specific post in the feed if it exists
                var postDiv = document.getElementById('post-' + post.id);
                if(postDiv) {
                     var actionsDiv = postDiv.querySelector('.feed-actions');
                     var deleteBtn = '';
                            if(isAdmin || post.authorID == String(myID)) {
                                deleteBtn = `<button class="action-btn btn-red" style="font-size: 0.8em;" onclick="CYR_net.deletePost('${post.id}')"><i class="fa fa-trash"></i> DELETE</button>`;
                     }
                     actionsDiv.innerHTML = `
                                <button class="action-btn" onclick="CYR_net.likePost('${post.id}')"><i class="fa fa-heart"></i> ${post.likeCount || 0}</button>
                                <button class="action-btn" onclick="openComments('${post.id}')"><i class="fa fa-comment"></i> ${post.commentCount || 0}</button>
                        ${deleteBtn}
                     `; 
                }
                
                // If comment modal is open for this post, refresh comments
                if(document.getElementById('comments-modal-overlay').style.display !== 'none' && currentPostId == post.id && post.comments) {
                    showCommentsData(post.comments);
                }
            }
            
            function updatePosts(posts) {
                var list = document.getElementById('feed-list');
                list.innerHTML = '';
                if(!posts || posts.length === 0) {
                    list.innerHTML = '<div style="text-align:center; padding: 20px;">No posts found.</div>';
                    return;
                }
                
                posts.forEach(function(post) {
                    postsCache[post.id] = post;
                    var div = document.createElement('div');
                    div.className = 'feed-item';
                    div.id = 'post-' + post.id;
                    
                    var imgHtml = '';
                    if(post.image) {
                        imgHtml = '<img src="' + post.image + '" class="feed-image">';
                    }
                    var content = parseContent(post.content);
                    
                    var deleteBtn = '';
                    var pinBtn = '';
                    if(isMe) {
                         pinBtn = `<button class="action-btn" style="font-size: 0.8em;" onclick="CYR_net.pinPost('${post.id}')"><i class="fa fa-thumb-tack"></i> PIN</button>`;
                    }

                    if(isAdmin || post.authorID == String(myID)) {
                        deleteBtn = `<button class="action-btn btn-red" style="font-size: 0.8em;" onclick="CYR_net.deletePost('${post.id}')"><i class="fa fa-trash"></i> DELETE</button>`;
                    }
                    
                    div.innerHTML = `
                        <div class="feed-header">
                            <div class="feed-time">${formatTime(post.time)}</div>
                        </div>
                        <div class="feed-content" onclick="CYR_net.openPost('${post.id}')" style="cursor: pointer;">${content}</div>
                        ${imgHtml}
                        <div class="feed-actions">
                            <button class="action-btn" onclick="CYR_net.likePost('${post.id}')"><i class="fa fa-heart"></i> ${post.likeCount || 0}</button>
                            <button class="action-btn" onclick="openComments('${post.id}')"><i class="fa fa-comment"></i> ${post.commentCount || 0}</button>
                            ${pinBtn}
                            ${deleteBtn}
                        </div>
                    `;
                    list.appendChild(div);
                });
            }

            function submitComment() {
                var content = document.getElementById('comment-input').value;
                if(currentPostId && content) {
                     var img = "";
                     var match = content.match(/(https?:\/\/[^\s]+?\.(?:png|jpg|jpeg|gif|webp))/i);
                     if(match) { img = match[1]; }
                    CYR_net.postComment(currentPostId, content, img);
                    document.getElementById('comment-input').value = '';
                }
            }

            function openComments(postId) {
                CYR_net.openPost(postId);
            }
            
            function closeCommentsModal() {
                 document.getElementById('comments-modal-overlay').style.display = 'none';
                 currentPostId = null;
            }

            function showCommentsData(comments) {
                var list = document.getElementById('comments-list');
                list.innerHTML = '';
                if(!comments || comments.length == 0) {
                    list.innerHTML = 'No comments yet.';
                    return;
                }
                comments.forEach(function(c) {
                    var div = document.createElement('div');
                    div.className = 'comment-item';
                    var avatarStyle = c.avatar ? `background-image: url('${c.avatar}');` : 'background: #333;';
                    // User Request: Hide content if image exists
                    var content = c.image ? "" : (c.content || "").replace(/</g, '&lt;').replace(/>/g, '&gt;');
                    var imgHtml = '';
                    if(c.image) {
                        imgHtml = `<div style="margin-top:8px;"><img src="${c.image}" style="max-width:100%; border:1px solid #333;"></div>`;
                    }
                    var handle = c.handle || c.authorHandle || 'unknown';
                    div.innerHTML = `
                         <div style="display:flex; align-items:center; margin-bottom: 5px;">
                              <div style="width:20px; height:20px; border:1px solid #00f0ff; margin-right:5px; background-size:cover; background-position:center; ${avatarStyle}"></div>
                            <strong>@${handle}</strong>
                         </div>
                         <div>${content}</div>
                         ${imgHtml}`;
                    list.appendChild(div);
                });
            }

            renderProfile();
            updatePosts(]] .. postsJson .. [[);
        </script>
    </body>
    </html>
    ]]
    html:SetHTML(page)
end