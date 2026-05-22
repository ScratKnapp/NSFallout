local SOCIAL = CYR.Net.Social
local CP_CYAN = CYR.COLORS.Primary
local CP_RED = CYR.COLORS.Secondary
local CP_BUBBLE_FILL = Color(10, 20, 25, 200)
hook.Add("CYR_ColorSchemeChanged", "CYR.Net.Pages.PostView3", function(self, post)
    CP_CYAN = CYR.COLORS.Primary
    CP_RED = CYR.COLORS.Secondary
end)

function SOCIAL:BuildSearchResults(profiles)
    profiles = profiles or {}
    for _, prof in ipairs(profiles) do
        if prof.avatar then prof.avatar = CYR.Net.ProxyImgur(prof.avatar) end
    end

    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    html:AddFunction("CYR_net", "goBack", function() self:Navigate("net://feed", "FEED") end)
    html:AddFunction("CYR_net", "openProfile", function(handle) netstream.Start("NetSocialGetProfileDetails", handle) end)
    local profilesJson = util.TableToJSON(profiles)
    local page = [[
    <!DOCTYPE html>
    <html>
    <head>
        ]] .. CYR.Net.HTML.CSS .. [[
        <style>
            .result {
                display:flex;
                gap: 10px;
                align-items:center;
                padding: 12px;
                background: rgba(0,0,0,0.35);
                border: 1px solid rgba(0, 240, 255, 0.25);
                margin-bottom: 10px;
                cursor: pointer;
            }
            .result:hover {
                background: rgba(0, 240, 255, 0.12);
            }
            .avatar {
                width: 38px;
                height: 38px;
                border: 1px solid #00f0ff;
                background: #333;
                background-size: cover;
                background-position: center;
                flex-shrink: 0;
            }
            .handle { color: #00f0ff; font-weight: bold; }
            .bio { color: #aaa; font-size: 0.9em; white-space: pre-wrap; }
        </style>
    </head>
    <body>
        <div class="container" style="max-width: 900px;">
            <div style="display:flex; justify-content: space-between; align-items:center; margin-bottom: 15px;">
                <button onclick="CYR_net.goBack()" style="width:auto;"><i class="fa fa-arrow-left"></i> Back</button>
                <div style="color:#00f0ff; font-weight:bold;">SEARCH RESULTS (<span id="count">0</span>)</div>
            </div>

            <div id="results"></div>
        </div>

        <script>
            var profiles = ]] .. profilesJson .. [[;
            document.getElementById('count').innerText = (profiles || []).length;
            var list = document.getElementById('results');
            if(!profiles || profiles.length === 0) {
                list.innerHTML = '<div style="text-align:center; padding: 20px;">No results.</div>';
            } else {
                profiles.forEach(function(p){
                    var row = document.createElement('div');
                    row.className = 'result';
                    var avatar = p.avatar || '';
                    var bio = (p.bio || '').replace(/</g,'&lt;').replace(/>/g,'&gt;');
                    row.innerHTML = `
                        <div class="avatar" style="background-image:url('${avatar}');"></div>
                        <div>
                            <div class="handle"><i class="fa fa-user"></i> @${p.handle}</div>
                            <div class="bio">${bio}</div>
                        </div>
                    `;
                    row.onclick = function(){ CYR_net.openProfile(p.handle); };
                    list.appendChild(row);
                });
            }
        </script>
    </body>
    </html>
    ]]
    html:SetHTML(page)
end