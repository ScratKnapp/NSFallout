local SOCIAL = CYR.Net.Social
function SOCIAL:BuildFeed(data)
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    self.feedPanel = html
    html.sortType = (data and data.sort) or "recent"
    function html:SetPosts(posts, offset)
        for k, v in pairs(posts) do
            if v.avatar then v.avatar = CYR.Net.ProxyImgur(v.avatar) end
            if v.image then v.image = CYR.Net.ProxyImgur(v.image) end
            if v.comments then
                for _, c in pairs(v.comments) do
                    if c.avatar then c.avatar = CYR.Net.ProxyImgur(c.avatar) end
                    if c.image then c.image = CYR.Net.ProxyImgur(c.image) end
                end
            end
        end

        local json = util.TableToJSON(posts)
        local isAppend = offset and offset > 0
        self:Call("updateFeed(" .. json .. ", " .. tostring(isAppend) .. ")")
        if isAppend then self:Call("updateOffset(" .. offset .. ")") end
    end

    function html:ShowComments(comments)
        for k, v in pairs(comments) do
            if v.avatar then v.avatar = CYR.Net.ProxyImgur(v.avatar) end
            if v.image then v.image = CYR.Net.ProxyImgur(v.image) end
        end

        local json = util.TableToJSON(comments)
        self:Call("showCommentsData(" .. json .. ")")
    end

    html:AddFunction("CYR_net", "refreshFeed", function(sort)
        if sort then self.sortType = sort end
        netstream.Start("NetSocialFetchPosts", self.sortType, 0)
    end)

    html:AddFunction("CYR_net", "loadMore", function(offset) netstream.Start("NetSocialFetchPosts", self.sortType, offset) end)
    html:AddFunction("CYR_net", "searchNet", function(query) netstream.Start("NetSocialSearchProfiles", query) end)
    html:AddFunction("CYR_net", "createPost", function(content, imgUrl, visibility)
        netstream.Start("NetSocialCreatePost", content, imgUrl, visibility)
        timer.Simple(0.5, function() netstream.Start("NetSocialFetchPosts", self.sortType, 0) end)
    end)

    html:AddFunction("CYR_net", "openProfile", function(handle) netstream.Start("NetSocialGetProfileDetails", handle) end)
    html:AddFunction("CYR_net", "deletePost", function(postId)
        netstream.Start("NetSocialDeletePost", postId)
        timer.Simple(0.2, function() netstream.Start("NetSocialFetchPosts", self.sortType, 0) end)
    end)

    html:AddFunction("CYR_net", "likePost", function(postId) netstream.Start("NetSocialLikePost", postId) end)
    html:AddFunction("CYR_net", "getComments", function(postId) netstream.Start("NetSocialGetComments", postId) end)
    html:AddFunction("CYR_net", "likeComment", function(postId, commentId) netstream.Start("NetSocialLikeComment", postId, commentId) end)
    html:AddFunction("CYR_net", "postComment", function(postId, content, imageUrl) netstream.Start("NetSocialCommentPost", postId, content, imageUrl or "") end)
    html:AddFunction("CYR_net", "getNotifications", function() netstream.Start("NetSocialGetNotifications") end)
    html:AddFunction("CYR_net", "markNotificationRead", function(notifId) netstream.Start("NetSocialMarkNotificationRead", notifId) end)
    html:AddFunction("CYR_net", "openPost", function(postId)
        if IsValid(self.urlEntry) then self.urlEntry:SetText("net://posts/" .. postId) end
        self.currentURL = "net://posts/" .. postId
        netstream.Start("NetSocialGetPostDetails", postId)
    end)

    html:AddFunction("CYR_net", "openMessages", function() self:Navigate("net://messages", "MESSAGES") end)
    html:AddFunction("CYR_net", "updateURL", function(url)
        if IsValid(self.urlEntry) then self.urlEntry:SetText(url) end
        self.currentURL = url
    end)

    html:AddFunction("CYR_net", "visit", function(url)
        if IsValid(self.urlEntry) then
            self.urlEntry:SetText(url)
            self.urlEntry.OnEnter(self.urlEntry)
        end
    end)

    function html:SetNotifications(notifs)
        local json = util.TableToJSON(notifs or {})
        self:Call("setNotifications(" .. json .. ")")
    end

    netstream.Start("NetSocialFetchPosts", html.sortType, 0)
    local myID = LocalPlayer():getChar():getID()
    local isAdmin = LocalPlayer():IsAdmin()
    local myHandle = (self.profile and self.profile.handle) or ""
    local page = [[
    <!DOCTYPE html>
    <html>
    <head>
        ]] .. CYR.Net.HTML.CSS .. [[
        <style>
             .feed-item {
                 border-bottom: 1px solid #333;
                 padding-bottom: 12px;
                 margin-bottom: 12px;
                 background: rgba(0,0,0,0.3);
                 padding: 12px;
             }
             .feed-header {
                 display: flex;
                 align-items: center;
                 margin-bottom: 10px;
             }
             .feed-avatar {
                 width: 40px; height: 40px;
                 background: #333;
                 margin-right: 10px;
                 border: 1px solid #00f0ff;
             }
             .feed-handle {
                 font-weight: bold;
                 color: #00f0ff;
                 cursor: pointer;
             }
             .feed-time {
                 margin-left: auto;
                 font-size: 0.8em;
                 color: #666;
             }
             .feed-content {
                 font-size: 0.95em;
                 margin-bottom: 8px;
                 white-space: pre-wrap;
                 overflow-wrap: break-word;
                 word-break: break-word;
                 max-width: 100%;
                 max-height: 300px;
                 overflow-y: auto;
             }
             .comment-item div:nth-child(2) {
                 overflow-wrap: break-word;
                 word-break: break-word;
                 max-width: 100%;
                 max-height: 300px;
                 overflow-y: auto;
             }
             .feed-image {
                 max-width: 100%;
                 max-height: 300px;
                 object-fit: contain;
                 border: 1px solid #333;
                 margin-top: 10px;
             }
             .feed-actions {
                 display: flex;
                 gap: 8px;
                 margin-top: 8px;
             }
             .feed-actions button {
                 width: auto;
                 display: flex;
                 align-items: center;
                 gap: 5px;
                 min-width: 0;
                 justify-content: center;
                 border: none !important;
                 background: transparent !important;
                 padding: 6px 8px;
             }
             .feed-actions button:hover {
                 background: rgba(0, 240, 255, 0.12) !important;
             }
             .feed-actions button.btn-danger,
             .feed-actions button.btn-danger:hover {
                 color: #ff0055 !important;
                 border: none !important;
                 background: transparent !important;
             }
             #modal-overlay, #comments-modal-overlay {
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
                 width: 500px;
                 box-shadow: 0 0 20px rgba(0, 240, 255, 0.3);
                 max-height: 90vh;
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
             .comment-list {
                 flex-grow: 1;
                 overflow-y: auto;
                 margin: 10px 0;
                 border: 1px solid #333;
                 padding: 10px;
                 background: rgba(0,0,0,0.2);
             }
             .comment-item {
                 margin-bottom: 10px;
                 border-bottom: 1px solid #222;
                 padding-bottom: 5px;
             }
             .search-wrapper {
                 display: flex;
                 align-items: center;
                 background: rgba(0,0,0,0.5);
                 border: 1px solid #00f0ff;
                 padding: 0 10px;
                 width: 260px;
                 height: 36px;
             }
             .search-wrapper input {
                 background: transparent;
                 border: none;
                 color: #00f0ff;
                 font-family: 'Rajdhani', sans-serif;
                 outline: none;
                 width: 100%;
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

             .navbar {
                 position: sticky;
                 top: 0;
                 z-index: 50;
                 background: rgba(0,0,0,0.85);
                 border-bottom: 1px solid rgba(0, 240, 255, 0.35);
                 padding: 10px;
                 margin-bottom: 12px;
             }
             .navbar-inner {
                 display: flex;
                 justify-content: space-between;
                 align-items: center;
                 gap: 12px;
             }
             .nav-left {
                 display: flex;
                 gap: 10px;
                 align-items: center;
             }
             .nav-right {
                 display: flex;
                 gap: 10px;
                 align-items: center;
             }
             .navbar select {
                 height: 36px;
                 padding: 0 10px;
             }
             .nav-right button {
                 height: 36px;
                 width: auto;
                 border: none !important;
                 background: transparent !important;
                 padding: 6px 8px;
             }
             .nav-right button:hover {
                 background: rgba(0, 240, 255, 0.12) !important;
             }
        </style>
    </head>
    <body>
        <div id="modal-overlay">
             <div class="modal">
                 <h2>New Post</h2>
                 <textarea id="post-content" rows="4" placeholder="What's on your mind?"></textarea>
                 
                 <select id="post-visibility" style="width:100%; padding: 10px; background: #222; color: #fff; border: 1px solid #00f0ff; margin-bottom: 15px;">
                     <option value="public">Public</option>
                     <option value="followers">Followers Only</option>
                 </select>
                 <div style="display: flex; gap: 10px;">
                     <button onclick="submitPost()">POST</button>
                     <button onclick="closeModal()" style="border-color: #f00; color: #f00;">CANCEL</button>
                 </div>
             </div>
        </div>

        <div id="comments-modal-overlay" onclick="closeCommentsModal()">
             <div class="modal modal-comments" onclick="event.stopPropagation()">
                 <div class="comment-left">
                     <h2>Original Post</h2>
                     <div id="modal-post-preview"></div>
                 </div>
                 <div class="comment-right">
                     <h2>Comments</h2>
                     <div id="comments-list" class="comment-list">Loading...</div>
                     
                     <div class="comment-input-area">
                         <input type="text" id="comment-input" placeholder="Write a comment..." onkeydown="if(event.key === 'Enter') submitComment()">
                         
                         <button onclick="submitComment()" style="width: 10%; min-width: 60px;"><i class="fa fa-paper-plane"></i> POST</button>
                     </div>
                 </div>
             </div>
        </div>

        <div id="image-modal-overlay" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.9); z-index:200; align-items:center; justify-content:center; flex-direction:column;">
            <img id="modal-image" src="" style="max-width:95%; max-height:90%; object-fit:contain; border: 1px solid #333;">
            <button onclick="closeImageModal()" style="margin-top:10px; width:auto; background: #000; border: 1px solid #00f0ff; color: #00f0ff; padding: 5px 20px;">CLOSE</button>
        </div>

        <div class="container" style="max-width: 1000px;">
            <div class="navbar">
                <div class="navbar-inner">
                    <div class="nav-left">
                        <label>SORT:</label>
                        <select id="sort-select" onchange="changeSort(this.value)" style="background: rgba(0, 0, 0, 0.5); border: 1px solid #00f0ff; color: #00f0ff; font-family: 'Rajdhani', sans-serif;">
                            <option value="likes">MOST LIKED</option>
                            <option value="recent">RECENT</option>
                            <option value="hot">HOT</option>
                        </select>
                        
                        <div class="search-wrapper">
                             <input type="text" placeholder="Search Net..." onkeydown="if(event.key === 'Enter') CYR_net.searchNet(this.value)">
                             <i class="fa fa-search"></i>
                        </div>
                    </div>
                    <div class="nav-right">
                         <button onclick="if(myHandle) CYR_net.openProfile(myHandle)"><i class="fa fa-user"></i></button>
                         <button onclick="CYR_net.openMessages()"><i class="fa fa-envelope"></i></button>
                         <button onclick="toggleNotifMenu()"><i class="fa fa-bell"></i></button>
                         <button onclick="openModal()"><i class="fa fa-plus"></i> NEW POST</button>
                         <button onclick="changeSort(currentSort)"><i class="fa fa-refresh"></i></button>
                    </div>
                </div>
            </div>

            <div id="notif-menu" style="display:none; position: fixed; top: 60px; right: 20px; width: 300px; z-index: 55; border:1px solid #00f0ff; background: rgba(0,0,0,0.95); padding: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.5);">
                <div style="display:flex; justify-content: space-between; align-items:center; margin-bottom: 8px;">
                    <strong><i class="fa fa-bell"></i> Notifications</strong>
                    <button onclick="toggleNotifMenu()" style="width:auto;"><i class="fa fa-times"></i></button>
                </div>
                <div id="notif-list" style="max-height: 220px; overflow-y:auto;">No notifications.</div>
            </div>
            
            <div id="feed-list"></div>
            <div id="loading" style="height: 50px; text-align:center; padding:10px; visibility: hidden;">Loading more...</div>
        </div>

        <script>
            var myID = ]] .. myID .. [[;
            var myHandle = "]] .. myHandle .. [[";
            var isAdmin = ]] .. tostring(isAdmin) .. [[;
            var currentSort = 'likes';
            var currentOffset = 0;
            var isLoading = false;
            var endReached = false;
            var postsCache = {}; // id -> post
            var currentPostId = null;
            var notifications = [];

            function formatTime(unixSeconds) {
                var d = new Date((unixSeconds || 0) * 1000);
                d.setFullYear(d.getFullYear() + 44);
                return d.toLocaleString();
            }
            
            window.addEventListener('scroll', function() {
                if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight - 50) {
                    if(!isLoading && !endReached) {
                        isLoading = true;
                        document.getElementById('loading').style.visibility = 'visible';
                        CYR_net.loadMore(currentOffset + 5);
                    }
                }
            });

            function updateOffset(off) {
                currentOffset = off;
                isLoading = false;
                document.getElementById('loading').style.visibility = 'hidden';
            }

            function changeSort(type) {
                currentSort = type;
                currentOffset = 0;
                endReached = false;
                isLoading = false;
                CYR_net.refreshFeed(type);
                document.getElementById('feed-list').innerHTML = '<div style="text-align:center; padding: 20px;">Loading...</div>';
                document.getElementById('loading').style.visibility = 'hidden';
            }
            
            function parseContent(text) {
                if(!text) return "";
                var safe = text.replace(/</g, '&lt;').replace(/>/g, '&gt;');
                
                // Parse Mentions @{id|handle} -> link
                safe = safe.replace(/@\{(\d+)\|([a-zA-Z0-9_]+)\}/g, function(match, id, handle) {
                    return '<span class="feed-handle" onclick="event.stopPropagation(); CYR_net.openProfile(\'' + handle + '\')" style="display:inline;">@' + handle + '</span>';
                });
                
                // Parse net:// links
                safe = safe.replace(/net:\/\/([a-zA-Z0-9/._\-#?=]+)/g, function(match) {
                     return '<span onclick="event.stopPropagation(); CYR_net.visit(\'' + match + '\')" style="display:inline; color:#ffaa00; cursor:pointer; text-decoration: underline;">' + match + '</span>';
                });

                // Parse legacy plain @handles that weren't caught by server (old posts)
                safe = safe.replace(/@([a-zA-Z0-9_]+)/g, function(match, handle) {
                    // Check if it's already inside a tag - naive check
                    if(match.startsWith('@{')) return match; 
                    return '<span class="feed-handle" onclick="event.stopPropagation(); CYR_net.openProfile(\'' + handle + '\')" style="display:inline;">@' + handle + '</span>';
                });
                
                // Parse emojis
                safe = parseEmojis(safe);
                
                return safe;
            }

            function updatePost(post) {
                // Update specific post in the feed if it exists
                postsCache[post.id] = post;
                var postDiv = document.getElementById('post-' + post.id);
                if(postDiv) {
                    // Just replace the action buttons to update counts
                     var actionsDiv = postDiv.querySelector('.feed-actions');
                     var deleteBtn = '';
                            if(isAdmin || post.authorID == String(myID)) {
                       deleteBtn = '<button class="btn-danger" onclick="CYR_net.deletePost(\'' + post.id + '\')"><i class="fa fa-trash"></i></button>';
                     }
                     actionsDiv.innerHTML = '<button onclick="CYR_net.likePost(\'' + post.id + '\')"><i class="fa fa-heart"></i> ' + (post.likeCount || 0) + '</button>' +
                            '<button onclick="openComments(\'' + post.id + '\')"><i class="fa fa-comment"></i> ' + (post.commentCount || 0) + '</button>' +
                            deleteBtn;
                }
                
                // If comment modal is open for this post, refresh comments
                if(document.getElementById('comments-modal-overlay').style.display !== 'none' && currentPostId == post.id && post.comments) {
                    showCommentsData(post.comments);
                }
            }
            
            function updateFeed(posts, isAppend) {
                var list = document.getElementById('feed-list');
                if(!isAppend) {
                     list.innerHTML = '';
                     currentOffset = 0;
                }
                
                if(!posts || posts.length === 0) {
                    if(!isAppend) list.innerHTML = '<div style="text-align:center; padding: 20px;">No posts found.</div>';
                    isLoading = false; 
                    // Empty state logic: if we received 0 posts, we are done.
                    document.getElementById('loading').style.visibility = 'hidden'; 
                    document.getElementById('loading').innerText = 'No more posts.';
                    return;
                }
                
                // If received fewer than requested (e.g. 5), end reached
                if(posts.length < 5) {
                    document.getElementById('loading').style.visibility = 'visible';
                    document.getElementById('loading').innerText = 'No more posts.';
                    // Prevent further scrolling triggers logic-wise (simple way: keep isLoading=true? no, just Set flag)
                    endReached = true;
                } else {
                    document.getElementById('loading').innerText = 'Loading more...';
                    endReached = false;
                }
                
                posts.forEach(function(post) {
                    postsCache[post.id] = post;
                    var div = document.createElement('div');
                    div.className = 'feed-item';
                    div.id = 'post-' + post.id;
                    
                    var imgHtml = '';
                    if(post.image) {
                        imgHtml = '<img src="' + post.image + '" class="feed-image" onclick="openImageModal(this.src)" style="cursor: pointer;">';
                    }
                    var content = parseContent(post.content);
                    
                    var deleteBtn = '';
                    if(isAdmin || post.authorID == String(myID)) {
                        deleteBtn = '<button class="btn-danger" onclick="CYR_net.deletePost(\'' + post.id + '\')"><i class="fa fa-trash"></i></button>';
                    }
                    
                    div.innerHTML = '<div class="feed-header">' +
                            '<div class="feed-avatar" style="background-image: url(\'' + (post.avatar || '') + '\'); background-size: cover; background-position: center;"></div>' +
                            '<div class="feed-handle" onclick="CYR_net.openProfile(\'' + post.handle + '\')">@' + post.handle + '</div>' +
                            '<div class="feed-time">' + formatTime(post.time) + '</div>' +
                        '</div>' +
                        '<div class="feed-content" style="cursor: pointer;" onclick="CYR_net.openPost(\'' + post.id + '\')">' + content + '</div>' +
                        imgHtml +
                        '<div class="feed-actions">' +
                            '<button onclick="CYR_net.likePost(\'' + post.id + '\')"><i class="fa fa-heart"></i> ' + (post.likeCount || 0) + '</button>' +
                            '<button onclick="openComments(\'' + post.id + '\')"><i class="fa fa-comment"></i> ' + (post.commentCount || 0) + '</button>' +
                            deleteBtn +
                        '</div>';
                    list.appendChild(div);
                });
            }
            
            function openImageModal(src) {
                document.getElementById('modal-image').src = src;
                document.getElementById('image-modal-overlay').style.display = 'flex';
            }
            function closeImageModal() {
                document.getElementById('image-modal-overlay').style.display = 'none';
            }
            
            function openModal() { document.getElementById('modal-overlay').style.display = 'flex'; }
            function closeModal() { document.getElementById('modal-overlay').style.display = 'none'; }
            function submitPost() {
                var content = document.getElementById('post-content').value;
                var img = "";
                var match = content.match(/(https?:\/\/[^\s]+?\.(?:png|jpg|jpeg|gif|webp))/i);
                if(match) {
                    img = match[1];
                }
                var vis = document.getElementById('post-visibility').value;
                if(content) {
                    CYR_net.createPost(content, img, vis);
                    closeModal();
                }
            }
            
            function submitComment() {
                var content = document.getElementById('comment-input').value;
                var img = "";
                var match = content.match(/(https?:\/\/[^\s]+?\.(?:png|jpg|jpeg|gif|webp))/i);
                if(match) {
                     img = match[1];
                }
                if(currentPostId && (content || img)) {
                    CYR_net.postComment(currentPostId, content, img);
                    document.getElementById('comment-input').value = '';
                }
            }
            
            function openComments(postId) {
                currentPostId = postId;
                CYR_net.updateURL("net://posts/" + postId);
                document.getElementById('comments-modal-overlay').style.display = 'flex';
                document.getElementById('comments-list').innerHTML = 'Loading comments...';
                
                // Render Original Post in Left Panel
                var p = postsCache[postId];
                var previewHtml = "Loading post...";
                if(p) {
                    var imgHtml = '';
                    if(p.image) {
                        imgHtml = '<img src="' + p.image + '" class="feed-image" onclick="openImageModal(this.src)" style="cursor: pointer;">';
                    }
                    var content = parseContent(p.content);
                    previewHtml = '<div class="feed-item" style="border:none; padding:0; background:none;">' +
                            '<div class="feed-header">' +
                                '<div class="feed-avatar" style="background-image: url(\'' + (p.avatar || '') + '\'); background-size: cover; background-position: center;"></div>' +
                                '<div class="feed-handle">@' + p.handle + '</div>' +
                                '<div class="feed-time">' + formatTime(p.time) + '</div>' +
                            '</div>' +
                            '<div class="feed-content">' + content + '</div>' +
                            imgHtml +
                         '</div>';
                }
                document.getElementById('modal-post-preview').innerHTML = previewHtml;

                CYR_net.getComments(postId);
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
                    
                    var avatarStyle = c.avatar ? 'background-image: url(\'' + c.avatar + '\');' : 'background: #333;';
                    // Hide content if image (User Request)
                    var content = c.image ? "" : parseContent(c.content);
                    var imgHtml = '';
                    if(c.image) {
                        imgHtml = '<div style="margin-top:8px;"><img src="' + c.image + '" onclick="openImageModal(this.src)" style="max-width:100%; border:1px solid #333; cursor: pointer;"></div>';
                    }
                    
                    var handle = c.handle || c.authorHandle || 'unknown';
                    
                    var likeCount = c.likes ? Object.keys(c.likes).length : 0;
                    var isLiked = c.likes && c.likes[String(myID)];
                    var likeColor = isLiked ? '#00f0ff' : '#666';
                    
                    div.innerHTML = '<div style="display:flex; align-items:center; margin-bottom: 5px;">' +
                              '<div style="width:20px; height:20px; border:1px solid #00f0ff; margin-right:5px; background-size:cover; background-position:center; ' + avatarStyle + '"></div>' +
                            '<strong>@' + handle + '</strong>' +
                         '</div>' +
                         '<div>' + content + '</div>' +
                         imgHtml +
                         '<div style="margin-top: 5px; display:flex; gap:10px;">' +
                             '<button onclick="CYR_net.likeComment(\'' + currentPostId + '\', \'' + c.id + '\')" style="background:none!important; border:none!important; padding:0; color:' + likeColor + '; cursor:pointer; font-size:0.8em;">' +
                                '<i class="fa fa-heart"></i> ' + likeCount +
                             '</button>' +
                         '</div>';
                    list.appendChild(div);
                });
            }

            function setNotifications(notifs) {
                notifications = notifs || [];
                var list = document.getElementById('notif-list');
                list.innerHTML = '';
                if(notifications.length === 0) {
                    list.innerHTML = 'No notifications.';
                    return;
                }
                notifications.sort(function(a,b){ return (b.time||0) - (a.time||0); });
                notifications.slice(0, 25).forEach(function(n){
                    var row = document.createElement('div');
                    row.style.padding = '8px';
                    row.style.borderBottom = '1px solid rgba(0,240,255,0.15)';
                    row.style.cursor = 'pointer';
                    var icon = 'bell';
                    if(n.type === 'message') icon = 'envelope';
                    if(n.type === 'comment') icon = 'comment';
                    if(n.type === 'mention') icon = 'at';
                    if(n.type === 'like') icon = 'heart';

                    var when = n.time ? formatTime(n.time||0) : '';
                    row.innerHTML = '<div><i class="fa fa-' + icon + '"></i> ' + (n.text || 'Notification') + '</div><div style="font-size: 0.85em; color:#888;">' + when + '</div>';
                    row.onclick = function(){
                        if(n.id) CYR_net.markNotificationRead(n.id);
                        row.style.opacity = '0.6';
                        if(n.data && n.data.postID) {
                            CYR_net.openPost(n.data.postID);
                        }
                    };
                    list.appendChild(row);
                });
            }

            function toggleNotifMenu(){
                var menu = document.getElementById('notif-menu');
                var isOpen = menu.style.display !== 'none';
                menu.style.display = isOpen ? 'none' : 'block';
                if(!isOpen) {
                    document.getElementById('notif-list').innerHTML = 'Loading...';
                    CYR_net.getNotifications();
                }
            }
        </script>
    </body>
    </html>
    ]]
    html:SetHTML(page)
end

function SOCIAL:SetPosts(posts, offset)
    if IsValid(self.feedPanel) then self.feedPanel:SetPosts(posts, offset) end
end

function SOCIAL:UpdatePost(post)
    if IsValid(self.feedPanel) then
        if post.avatar then post.avatar = CYR.Net.ProxyImgur(post.avatar) end
        if post.comments then
            for _, c in pairs(post.comments) do
                if c.avatar then c.avatar = CYR.Net.ProxyImgur(c.avatar) end
            end
        end

        local json = util.TableToJSON(post)
        self.feedPanel:Call("updatePost(" .. json .. ")")
    end
end

function SOCIAL:SetComments(comments)
    if IsValid(self.feedPanel) then self.feedPanel:ShowComments(comments) end
end