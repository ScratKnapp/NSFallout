local SOCIAL = CYR.Net.Social
function SOCIAL:BuildPostView(post)
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    self.feedPanel = html
    -- Pre-process data
    if post.avatar then post.avatar = CYR.Net.ProxyImgur(post.avatar) end
    if post.image then post.image = CYR.Net.ProxyImgur(post.image) end
    if post.comments then
        for _, c in pairs(post.comments) do
            if c.avatar then c.avatar = CYR.Net.ProxyImgur(c.avatar) end
            if c.image then c.image = CYR.Net.ProxyImgur(c.image) end
        end
    end

    local postJson = util.TableToJSON(post)
    -- Functions
    html:AddFunction("CYR_net", "goBack", function()
        self:Navigate("net://feed", "FEED")
        netstream.Start("NetSocialFetchPosts", "recent", 0)
    end)

    html:AddFunction("CYR_net", "openProfile", function(handle) netstream.Start("NetSocialGetProfileDetails", handle) end)
    html:AddFunction("CYR_net", "likePost", function(postId) netstream.Start("NetSocialLikePost", postId) end)
    html:AddFunction("CYR_net", "likeComment", function(postId, commentId) netstream.Start("NetSocialLikeComment", postId, commentId) end)
    html:AddFunction("CYR_net", "postComment", function(postId, content, imageUrl) netstream.Start("NetSocialCommentPost", postId, content, imageUrl or "") end)
    html:AddFunction("CYR_net", "deletePost", function(postId)
        netstream.Start("NetSocialDeletePost", postId)
        -- After delete, go back
        timer.Simple(0.2, function()
            self:Navigate("net://feed", "FEED")
            netstream.Start("NetSocialFetchPosts", "recent", 0)
        end)
    end)

    function html:ShowComments(comments)
        local postID = self.postID -- Assuming we need to verify? Or just update
        -- Pre-process
        for _, c in pairs(comments) do
            if c.avatar then c.avatar = CYR.Net.ProxyImgur(c.avatar) end
            if c.image then c.image = CYR.Net.ProxyImgur(c.image) end
        end

        local json = util.TableToJSON(comments)
        self:Call("updateComments(" .. json .. ")")
    end

    local myID = LocalPlayer():getChar():getID()
    local isAdmin = LocalPlayer():IsAdmin()
    local page = [[
    <!DOCTYPE html>
    <html>
    <head>
        ]] .. CYR.Net.HTML.CSS .. [[

        <style>
             body { overflow: hidden; display: flex; flex-direction: column; background: transparent; }
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
             
             .post-container {
                 display: flex;
                 flex-direction: row;
                 gap: 20px;
                 height: calc(100vh - 50px);
                 padding: 20px;
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
             
             #image-modal-overlay {
                 position: fixed; top: 0; left: 0; width: 100%; height: 100%;
                 background: rgba(0,0,0,0.9);
                 z-index: 200;
                 display: none;
                 align-items: center;
                 justify-content: center;
                 flex-direction: column;
             }
        </style>
    </head>
    <body>
        <div id="image-modal-overlay">
            <img id="modal-image" src="" style="max-width:95%; max-height:90%; object-fit:contain; border: 1px solid #333;">
            <button onclick="document.getElementById('image-modal-overlay').style.display='none'" style="margin-top:10px; width:auto; background: #000; border: 1px solid #00f0ff; color: #00f0ff; padding: 5px 20px;">CLOSE</button>
        </div>

        <button onclick="CYR_net.goBack()" style="background:transparent; border:none; color:#ff0055; font-size:1.1em; text-align:left; padding:10px;"><i class="fa fa-arrow-left"></i> BACK TO FEED</button>

        <div class="post-container">
             <div class="comment-left">
                 <h2 style="color:#00f0ff; margin-top:0;">ORIGINAL POST</h2>
                 <div id="post-view"></div>
             </div>
             <div class="comment-right">
                 <h2 style="color:#00f0ff; margin-top:0;">COMMENTS</h2>
                 <div id="comments-list" class="comment-list">Loading...</div>
                 
                 <div class="comment-input-area">
                     <input type="text" id="comment-input" placeholder="Write a comment..." onkeydown="if(event.key === 'Enter') submitComment()">
                     <button onclick="submitComment()" style="width: 10%; min-width: 60px; background: transparent; border: 1px solid #00f0ff; color: #00f0ff;"><i class="fa fa-paper-plane"></i> POST</button>
                 </div>
             </div>
        </div>

        <script>
            var post = ]] .. postJson .. [[;
            var myID = ]] .. myID .. [[;
            var isAdmin = ]] .. tostring(isAdmin) .. [[;
            
            function formatTime(unixSeconds) {
                var d = new Date((unixSeconds || 0) * 1000);
                d.setFullYear(d.getFullYear() + 44);
                return d.toLocaleString();
            }

            function parseContent(text) {
                if(!text) return "";
                var safe = text.replace(/</g, '&lt;').replace(/>/g, '&gt;');
                safe = safe.replace(/@\{(\d+)\|([a-zA-Z0-9_]+)\}/g, function(match, id, handle) {
                    return '<span class="feed-handle" onclick="CYR_net.openProfile(\'' + handle + '\')" style="display:inline;">@' + handle + '</span>';
                });
                safe = safe.replace(/@([a-zA-Z0-9_]+)/g, function(match, handle) {
                    if(match.startsWith('@{')) return match; 
                    return '<span class="feed-handle" onclick="CYR_net.openProfile(\'' + handle + '\')" style="display:inline;">@' + handle + '</span>';
                });
                return parseEmojis(safe);
            }

            function openImageModal(src) {
                document.getElementById('modal-image').src = src;
                document.getElementById('image-modal-overlay').style.display = 'flex';
            }

            function renderPost() {
                var div = document.getElementById('post-view');
                var imgHtml = '';
                if(post.image) {
                    imgHtml = '<img src="' + post.image + '" class="feed-image" onclick="openImageModal(this.src)" style="cursor: pointer;">';
                }
                var content = parseContent(post.content);
                var deleteBtn = '';
                if(isAdmin || post.authorID == String(myID)) {
                   deleteBtn = '<button class="btn-danger" onclick="CYR_net.deletePost(\'' + post.id + '\')"><i class="fa fa-trash"></i></button>';
                }

                div.innerHTML = `
                    <div class="feed-item" style="border:none; padding:0; background:none;">
                        <div class="feed-header">
                            <div class="feed-avatar" style="background-image: url('${post.avatar || ''}'); background-size: cover; background-position: center;"></div>
                            <div class="feed-handle" onclick="CYR_net.openProfile('${post.handle}')">@${post.handle}</div>
                            <div class="feed-time">${formatTime(post.time)}</div>
                        </div>
                        <div class="feed-content">${content}</div>
                        ${imgHtml}
                        <div class="feed-actions">
                            <button onclick="CYR_net.likePost('${post.id}')"><i class="fa fa-heart"></i> ${post.likeCount || 0}</button>
                            ${deleteBtn}
                        </div>
                    </div>
                `;
            }

            function renderComments() {
                var list = document.getElementById('comments-list');
                list.innerHTML = '';
                var comments = post.comments || [];
                if(comments.length == 0) {
                    list.innerHTML = 'No comments yet.';
                    return;
                }
                comments.forEach(function(c) {
                    var div = document.createElement('div');
                    div.className = 'comment-item';
                    var avatarStyle = c.avatar ? 'background-image: url(\'' + c.avatar + '\');' : 'background: #333;';
                    // Hide content if image (Same logic as Feed)
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
                             '<button onclick="CYR_net.likeComment(\'' + post.id + '\', \'' + c.id + '\')" style="background:none!important; border:none!important; padding:0; color:' + likeColor + '; cursor:pointer; font-size:0.8em;">' +
                                '<i class="fa fa-heart"></i> ' + likeCount +
                             '</button>' +
                         '</div>';
                    list.appendChild(div);
                });
            }

            function submitComment() {
                var content = document.getElementById('comment-input').value;
                if(content) {
                     var img = "";
                     var match = content.match(/(https?:\/\/[^\s]+?\.(?:png|jpg|jpeg|gif|webp))/i);
                     if(match) { img = match[1]; }
                    CYR_net.postComment(post.id, content, img);
                    document.getElementById('comment-input').value = '';
                }
            }

            // Init
            renderPost();
            renderComments();
            
            // Allow updating from server (real-time)
            function updatePost(updatedPost) {
                post = updatedPost;
                renderPost();
                renderComments();
            }
            
            function updateComments(comments) {
                post.comments = comments || [];
                renderComments();
            }
        </script>
    </body>
    </html>
    ]]
    html:SetHTML(page)
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