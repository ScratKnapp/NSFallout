local SOCIAL = CYR.Net.Social
local CP_CYAN = CYR.COLORS.Primary
local CP_BUBBLE_FILL = Color(10, 20, 25, 200)
hook.Add("CYR_ColorSchemeChanged", "CYR.Net.Pages.PostView2", function(self, post)
    CP_CYAN = CYR.COLORS.Primary
    CP_RED = CYR.COLORS.Secondary
end)

function SOCIAL:BuildCreateProfile()
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    html:AddFunction("CYR_net", "createProfile", function(handle, bio) netstream.Start("NetSocialCreateProfile", handle, bio) end)
    local page = [[
        <!DOCTYPE html>
        <html>
        <head>
            ]] .. CYR.Net.HTML.CSS .. [[
            <style>
                textarea {
                    width: 100%;
                    padding: 10px;
                    background: rgba(0, 0, 0, 0.5);
                    border: 1px solid #00f0ff;
                    color: white;
                    font-family: 'Rajdhani', sans-serif;
                    font-size: 16px;
                    margin-bottom: 15px;
                    box-sizing: border-box;
                    resize: vertical;
                }
                body, html { height: 100%; }
            </style>
        </head>
        <body>
            <div class="container" style="display: flex; height: 100%; align-items: center; justify-content: center;">
                <div class="card" style="width: 400px; text-align: center;">
                    <h1>Create Net Profile</h1>
                    
                    <input type="text" id="handle" placeholder="Handle (Username)" />
                    <textarea id="bio" placeholder="Bio (Optional)" rows="3"></textarea>
                    
                    <button onclick="submitForm()">REGISTER</button>
                </div>
            </div>
            
            <script>
                function submitForm() {
                    var handle = document.getElementById('handle').value;
                    var bio = document.getElementById('bio').value;
                    CYR_net.createProfile(handle, bio);
                }
            </script>
        </body>
        </html>
    ]]
    html:SetHTML(page)
end