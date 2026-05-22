local CP_CYAN = color_white
local CP_RED = color_white
local CP_BG = Color(10, 10, 15, 250)
local CP_BUBBLE_FILL = Color(10, 20, 25, 200)
CYR.Net = CYR.Net or {}
CYR.COLORS = {
    Primary = Color(230, 230, 230),
    Secondary = Color(160, 160, 160),
    Background = Color(10, 10, 15, 250)
}

CYR.Net.Colors = {
    BG = CYR.COLORS.Background,
    BubbleFill = Color(10, 20, 25, 200)
}

-- MESSENGER PANEL
CYR.Net.Sites = CYR.Net.Sites or {}
CYR.Net.Pages = CYR.Net.Pages or {}
function CYR.Net.RegisterURL(prefix, handler)
    CYR.Net.Sites[prefix] = handler
end

function CYR.Net.RegisterPage(state, builder)
    CYR.Net.Pages[state] = builder
end

function CYR.Net.ProxyImgur(url)
    -- if not url or url == "" then return url end
    local id = url:match("imgur%.com/([%w%d]+)") or url:match("i%.imgur%.com/([%w%d]+)")
    if id then return "https://imgup.uk/proxy/?url=" .. url end
    return url
end

function pac.FixGMODUrl(url)
    -- to avoid "invalid url" errors
    -- gmod does not allow urls containing "10.", "172.16.", "192.168.", "127." or "://localhost"
    -- we escape 10. and 127. can occur (mydomain.com/model10.zip) and assume the server supports
    -- the escaped request
    local URL = url:Replace("10.", "%31%30%2e"):Replace("127.", "%31%32%37%2e")
    -- if url is imgur link, change it to  to mirror link to avoid gmod issues
    if URL:find("imgur.com") then return CYR.Net.ProxyImgur(URL) end
    return URL
end

include("cl_html_templates.lua")
-- MEDIA GALLERY
local function OpenMediaGallery(onSelect)
    local f = vgui.Create("DFrame")
    f:SetSize(600, 400)
    f:Center()
    f:SetTitle("Media Gallery")
    f:MakePopup()
    local scroll = f:Add("DScrollPanel")
    scroll:Dock(FILL)
    local layout = scroll:Add("DIconLayout")
    layout:Dock(FILL)
    layout:SetSpaceX(5)
    layout:SetSpaceY(5)
    local recent = cookie.GetString("CYR_net_recent_images", "")
    local images = string.Explode(";", recent)
    -- Add "Add New" button
    local addBtn = layout:Add("DButton")
    addBtn:SetSize(128, 128)
    addBtn:SetText("ADD NEW URL")
    addBtn.DoClick = function()
        Derma_StringRequest("Add Image", "Enter Image URL:", "", function(text)
            if text and text ~= "" then
                -- Add to cookie
                local current = cookie.GetString("CYR_net_recent_images", "")
                local new = text .. ";" .. current
                -- Limit to 16
                local parts = string.Explode(";", new)
                if #parts > 16 then table.remove(parts) end
                cookie.Set("CYR_net_recent_images", table.concat(parts, ";"))
                f:Close()
                OpenMediaGallery(onSelect)
            end
        end)
    end

    for _, imgUrl in ipairs(images) do
        if imgUrl and imgUrl ~= "" then
            local p = layout:Add("DPanel")
            p:SetSize(128, 128)
            local html = p:Add("DHTML")
            html:Dock(FILL)
            html:SetMouseInputEnabled(false)
            local url = CYR.Net.ProxyImgur(imgUrl)
            html:SetHTML([[
                <style>
                    body { margin: 0; padding: 0; overflow: hidden; background-color: #222; display: flex; justify-content: center; align-items: center; height: 100%; }
                    img { max-width: 100%; max-height: 100%; object-fit: cover; }
                </style>
                <img src="]] .. url .. [[" />
            ]])
            local btn = p:Add("DButton")
            btn:Dock(FILL)
            btn:SetText("")
            btn:SetPaintBackground(false)
            btn.DoClick = function()
                if onSelect then onSelect(imgUrl) end
                f:Close()
            end
        end
    end
end

-- SOCIAL PANEL
CYR.Net.Social = {}
local SOCIAL = CYR.Net.Social
function SOCIAL:Init()
    self.state = "LOADING"
    self.profile = nil
    self.posts = {}
    self.sortType = "recent"
    -- History Stacks
    self.history = {}
    self.forwardStack = {}
    self.currentURL = "net://feed"
    -- Navigation Bar
    self.navBar = self:Add("DPanel")
    self.navBar:Dock(TOP)
    self.navBar:SetTall(30)
    self.navBar:DockMargin(0, 0, 0, 5)
    self.navBar.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 100)
        surface.DrawRect(0, 0, w, h)
    end

    local backBtn = self.navBar:Add("DButton")
    backBtn:Dock(LEFT)
    backBtn:SetWide(30)
    backBtn:SetText("<")
    backBtn:SetTextColor(CP_CYAN)
    backBtn.Paint = function(s, w, h) end
    backBtn.DoClick = function()
        if #self.history > 0 then
            local prev = table.remove(self.history)
            table.insert(self.forwardStack, {
                url = self.currentURL,
                state = self.state,
                data = self.currentStateData
            })

            self:Navigate(prev.url, prev.state, prev.data, true)
        end
    end

    local fwdBtn = self.navBar:Add("DButton")
    fwdBtn:Dock(LEFT)
    fwdBtn:SetWide(30)
    fwdBtn:SetText(">")
    fwdBtn:SetTextColor(CP_CYAN)
    fwdBtn.Paint = function(s, w, h) end
    fwdBtn.DoClick = function()
        if #self.forwardStack > 0 then
            local next = table.remove(self.forwardStack)
            table.insert(self.history, {
                url = self.currentURL,
                state = self.state,
                data = self.currentStateData
            })

            self:Navigate(next.url, next.state, next.data, true)
        end
    end

    local refreshBtn = self.navBar:Add("DButton")
    refreshBtn:Dock(LEFT)
    refreshBtn:SetWide(30)
    refreshBtn:SetText("R")
    refreshBtn:SetTextColor(CP_CYAN)
    refreshBtn.Paint = function(s, w, h) end
    refreshBtn.DoClick = function()
        -- Refresh current state
        if self.state and CYR.Net.Pages[self.state] then
            -- If we have a builder, just re-run it with current data?
            -- Ideally we want to re-trigger the data fetch.
            -- We can check if the current handler has a "Reload" capability or just re-resolve the URL.
            self:ResolveURL(self.currentURL)
        else
            -- Fallback for legacy/hardcoded
            if self.state == "FEED" then
                -- Default to recent refresh
                netstream.Start("NetSocialFetchPosts", "recent", 0)
            elseif self.state == "PROFILE_VIEW" and self.currentStateData and self.currentStateData.profile then
                netstream.Start("NetSocialGetProfileDetails", self.currentStateData.profile.handle)
            end
        end
    end

    -- Notification Button
    local notifBtn = self.navBar:Add("DButton")
    notifBtn:Dock(RIGHT)
    notifBtn:SetWide(30)
    notifBtn:SetText("!")
    notifBtn:SetTextColor(CP_RED)
    notifBtn.Paint = function(s, w, h) end
    notifBtn.DoClick = function() netstream.Start("NetSocialGetNotifications") end
    self.urlEntry = self.navBar:Add("DTextEntry")
    self.urlEntry:Dock(FILL)
    self.urlEntry:DockMargin(5, 5, 5, 5)
    self.urlEntry:SetFont("CYR_Notify_Text")
    self.urlEntry:SetTextColor(CP_CYAN)
    self.urlEntry:SetPaintBackground(false)
    self.urlEntry.Paint = function(s, w, h)
        surface.SetDrawColor(CP_CYAN)
        surface.DrawOutlinedRect(0, 0, w, h)
        s:DrawTextEntryText(CP_CYAN, Color(0, 200, 255), CP_CYAN)
    end

    self.urlEntry.OnEnter = function(s) self:ResolveURL(s:GetValue()) end
    self.container = self:Add("DPanel")
    self.container:Dock(FILL)
    self.container.Paint = function() end
    -- Initial Fetch
    timer.Simple(0, function() netstream.Start("NetSocialGetProfile") end)
end

function SOCIAL:ResolveURL(url)
    if not url or url == "" then return end
    url = string.Trim(url)
    local lowerUrl = string.lower(url)
    print("[CYR NET] Resolving URL: " .. url)
    -- NeonCities Wildcard Support - Check FIRST before generic registry
    -- Catches: neoncities.net, foo.neoncities.net, net://neoncities.net, net://neoncities
    if string.find(lowerUrl, "neoncities") then
        print("[CYR NET] NeonCities match found, routing to handler")
        if CYR.Net.Sites["net://neoncities"] then
            CYR.Net.Sites["net://neoncities"](self, url)
            return
        else
            print("[CYR NET] ERROR: NeonCities handler not registered!")
        end
    end

    -- Iterate registry
    local bestMatch = nil
    local bestLen = 0
    for prefix, handler in pairs(CYR.Net.Sites) do
        local lowerPrefix = string.lower(prefix)
        if string.StartWith(lowerUrl, lowerPrefix) then
            if #prefix > bestLen then
                bestMatch = handler
                bestLen = #prefix
            end
        end
    end

    if bestMatch then
        bestMatch(self, url)
        return
    end

    -- Legacy/Fallback handling
    if string.StartWith(lowerUrl, "http") then
        self:Navigate(url, "ExternalBrowser", {
            url = url
        })
    else
        print("[CYR NET] URL not recognized: " .. lowerUrl)
        self:Navigate(url, "ERROR", {
            error = "404 NOT FOUND: THE REQUESTED ADDRESS COULD NOT BE REACHED."
        })
    end
end

function SOCIAL:Navigate(url, state, data, isHistoryAction)
    print("[CYR DEBUG] Navigate called: " .. tostring(url) .. " -> " .. tostring(state))
    if not isHistoryAction then
        -- Push current state to history
        if self.state and self.state ~= "LOADING" then
            table.insert(self.history, {
                url = self.currentURL,
                state = self.state,
                data = self.currentStateData
            })

            -- Limit history size?
            if #self.history > 20 then table.remove(self.history, 1) end
        end

        -- Clear forward stack on new navigation
        self.forwardStack = {}
    end

    self.currentURL = url
    if IsValid(self.urlEntry) then self.urlEntry:SetValue(url) end
    -- Always call SetState directly on self
    print("[CYR DEBUG] Calling SetState for: " .. tostring(state))
    self.state = state
    self.currentStateData = data
    if IsValid(self.container) then
        self.container:Clear()
    else
        print("[CYR DEBUG] ERROR: self.container is invalid!")
        return
    end

    -- Check registered pages first
    if CYR.Net.Pages[state] then
        print("[CYR DEBUG] Found page builder for: " .. state)
        CYR.Net.Pages[state](self, data)
        return
    end

    -- Convert STATE_NAME to StateName for legacy builder lookup
    -- e.g. PROFILE_VIEW -> ProfileView, FEED -> Feed
    local function toPascalCase(str)
        local result = ""
        for word in string.gmatch(str, "[^_]+") do
            result = result .. word:sub(1, 1):upper() .. word:sub(2):lower()
        end
        return result
    end

    local legacyName = "Build" .. toPascalCase(state)
    if self[legacyName] then
        print("[CYR DEBUG] Found legacy builder: " .. legacyName)
        self[legacyName](self, data)
        return
    end

    print("[CYR DEBUG] WARNING: No builder for state: " .. tostring(state) .. " (tried " .. legacyName .. ")")
end

function SOCIAL:SetState(state, data)
    print("[CYR DEBUG] SetState called for: " .. tostring(state))
    self.state = state
    self.currentStateData = data
    self.container:Clear()
    -- Check registered pages first
    if CYR.Net.Pages[state] then
        print("[CYR DEBUG] Registry found for " .. state .. ", executing builder.")
        CYR.Net.Pages[state](self, data)
        return
    end

    -- Convert STATE_NAME to StateName for legacy builder lookup
    local function toPascalCase(str)
        local result = ""
        for word in string.gmatch(str, "[^_]+") do
            result = result .. word:sub(1, 1):upper() .. word:sub(2):lower()
        end
        return result
    end

    local legacyName = "Build" .. toPascalCase(state)
    if self[legacyName] then
        print("[CYR DEBUG] Legacy builder found: " .. legacyName)
        self[legacyName](self, data)
        return
    end

    print("[CYR NET] Warning: No builder found for state " .. tostring(state))
end

-- REGISTER DEFAULT SITES
CYR.Net.RegisterURL("net://feed", function(panel, url)
    local sort = "recent"
    if string.find(url, "#") then sort = string.sub(url, string.find(url, "#") + 1) end
    panel:Navigate(url, "FEED", {
        sort = sort
    })
end)

CYR.Net.RegisterURL("net://profile/", function(panel, url)
    local handle = string.sub(url, 15)
    netstream.Start("NetSocialGetProfileDetails", handle)
end)

CYR.Net.RegisterURL("net://posts/", function(panel, url)
    local postID = string.sub(url, 13)
    netstream.Start("NetSocialGetPostDetails", postID)
end)

CYR.Net.RegisterURL("net://search/", function(panel, url)
    local query = string.sub(url, 14)
    netstream.Start("NetSocialSearchProfiles", query)
end)

CYR.Net.RegisterURL("net://messages", function(panel, url) panel:Navigate(url, "MESSAGES") end)
CYR.Net.RegisterURL("net://melinoe", function(panel, url) panel:Navigate("net://melinoe", "MELINOE") end)
CYR.Net.RegisterURL("net://free-eddies", function(panel, url) panel:Navigate(url, "FREE_EDDIES") end)
CYR.Net.RegisterURL("net://free-the-files", function(panel, url) panel:Navigate(url, "FREE_THE_FILES") end)
CYR.Net.RegisterURL("net://bomb.df", function(panel, url) panel:Navigate(url, "BOMB_DF") end)
CYR.Net.RegisterURL("net://junglebook.evt", function(panel, url) panel:Navigate(url, "JUNGLEBOOK_EVT") end)
CYR.Net.RegisterURL("net://soviet.files", function(panel, url) panel:Navigate(url, "SOVIET_FILES") end)
CYR.Net.RegisterURL("net://the-sad-banana.bd", function(panel, url) panel:Navigate(url, "SAD_BANANA") end)
CYR.Net.RegisterURL("ssh://krasue", function(panel, url)
    -- Check for Datachip
    local hasChip = false
    local char = LocalPlayer():getChar()
    if char then
        local inv = char:getInv()
        local items = {}
        if type(inv) == "table" and inv.getItems then
            items = inv:getItems()
        elseif (type(inv) == "number" or type(inv) == "string") and nut.item.inventories[tonumber(inv)] then
            items = nut.item.inventories[tonumber(inv)]:getItems()
        end

        for _, item in pairs(items) do
            if item.uniqueID == "krasuekissradio" or item.uniqueID == "krasurekissradio" then
                hasChip = true
                break
            end
        end
    end

    if hasChip then
        panel:Navigate(url, "KRASUES_KISS")
    else
        panel:Navigate("net://404", "ERROR", {
            error = "ACCESS DENIED: ENCRYPTED CONNECTION REJECTED. DATACHIP REQUIRED."
        })
    end
end)

CYR.Net.RegisterURL("net://coolmath.games", function(panel, url)
    -- Remove "net://coolmath.games" prefix
    local sub = string.sub(url, 21)
    if string.Left(sub, 1) == "/" then sub = string.sub(sub, 2) end
    if sub == "" then
        panel:Navigate(url, "COOLMATH_HUB")
    elseif sub == "minesweeper" then
        panel:Navigate(url, "COOLMATH_MINESWEEPER")
    elseif sub == "pong" then
        panel:Navigate(url, "COOLMATH_PONG")
    elseif sub == "tetris" then
        panel:Navigate(url, "COOLMATH_TETRIS")
    elseif sub == "snake" then
        panel:Navigate(url, "COOLMATH_SNAKE")
    elseif sub == "solitaire" then
        panel:Navigate(url, "COOLMATH_SOLITAIRE")
    elseif sub == "balatro" then
        panel:Navigate(url, "COOLMATH_BALATRO")
    elseif sub == "chess" then
        panel:Navigate(url, "COOLMATH_CHESS")
    else
        panel:Navigate(url, "COOLMATH_HUB")
    end
end)

-- REGISTER PAGES (MAPPING TO EXISTING FUNCTIONS FOR NOW)
-- We'll refactor the Build functions later to simply be inline here or we keep them as methods.
-- For now, we just map them so SetState works.
CYR.Net.RegisterPage("KRASUES_KISS", function(panel, data) panel:BuildKrasuesKiss() end)
CYR.Net.RegisterPage("MELINOE", function(panel, data) panel:BuildMelinoe() end)
CYR.Net.RegisterPage("ERROR", function(panel, data) panel:BuildError(data) end)
CYR.Net.RegisterPage("ExternalBrowser", function(panel, data) panel:BuildExternalBrowser(data) end)
CYR.Net.RegisterPage("SOVIET_FILES", function(panel, data) panel:BuildSovietFiles() end)
CYR.Net.RegisterPage("BOMB_DF", function(panel, data) panel:BuildBombDF() end)
CYR.Net.RegisterPage("JUNGLEBOOK_EVT", function(panel, data) panel:BuildJungleBook() end)
CYR.Net.RegisterPage("SAD_BANANA", function(panel, data) panel:BuildSadBanana() end)
CYR.Net.RegisterPage("COOLMATH_HUB", function(panel, data) panel:BuildCoolMathHub() end)
CYR.Net.RegisterPage("COOLMATH_MINESWEEPER", function(panel, data) panel:BuildCoolMathMinesweeper() end)
CYR.Net.RegisterPage("COOLMATH_PONG", function(panel, data) panel:BuildCoolMathPong() end)
CYR.Net.RegisterPage("COOLMATH_TETRIS", function(panel, data) panel:BuildCoolMathTetris() end)
-- Snake, Solitaire, Balatro, Chess need checking if they exist.
-- I saw `BuildCoolMathHub` and `BuildCoolMathMinesweeper` and `BuildCoolMathPong` and `BuildCoolMathTetris`.
-- I did NOT see Balatro/Chess implemented in this file in the snippets (I saw Navigate calls though).
-- Wait, there is `CYR.Net.RegisterPage("COOLMATH_CHESS", ...)`?
-- I'll map them if they exist in `SOCIAL`. For now I will map them assuming they will be there or I will add them.
-- If they aren't there, it will error when called. But they were being calledByKey before anyway (presumably).
-- Actually, before it was `self:Navigate(url, "COOLMATH_BALATRO")`.
-- If `BuildCoolMathBalatro` didn't exist, it would crash or do nothing.
-- I'll register them to call `Build...` assuming they exist or self-implement.
CYR.Net.RegisterPage("COOLMATH_SNAKE", function(panel, data)
    if panel.BuildCoolMathSnake then
        panel:BuildCoolMathSnake()
    else
        panel:BuildError({
            error = "Under Construction"
        })
    end
end)

CYR.Net.RegisterPage("COOLMATH_SOLITAIRE", function(panel, data)
    if panel.BuildCoolMathSolitaire then
        panel:BuildCoolMathSolitaire()
    else
        panel:BuildError({
            error = "Under Construction"
        })
    end
end)

CYR.Net.RegisterPage("COOLMATH_BALATRO", function(panel, data)
    if panel.BuildCoolMathBalatro then
        panel:BuildCoolMathBalatro()
    else
        panel:BuildError({
            error = "Under Construction"
        })
    end
end)

CYR.Net.RegisterPage("COOLMATH_CHESS", function(panel, data)
    if panel.BuildCoolMathChess then
        panel:BuildCoolMathChess()
    else
        panel:BuildError({
            error = "Under Construction"
        })
    end
end)

CYR.Net.RegisterPage("FREE_EDDIES", function(panel, data)
    if panel.BuildFreeEddies then
        panel:BuildFreeEddies()
    else
        panel:BuildError({
            error = "Coming Soon"
        })
    end
end)

CYR.Net.RegisterPage("FREE_THE_FILES", function(panel, data)
    if panel.BuildFreeTheFiles then
        panel:BuildFreeTheFiles()
    else
        panel:BuildError({
            error = "Coming Soon"
        })
    end
end)


SOCIAL = CYR.Net.Social
function SOCIAL:BuildKrasuesKiss()
    self.container:Clear()
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    html:SetHTML([[
<!DOCTYPE html>
<html>
<head>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Nosifer&family=Share+Tech+Mono&display=swap');
        
        body {
            background-color: #050000;
            color: #d00;
            font-family: 'Share Tech Mono', monospace;
            margin: 0;
            padding: 0;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }

        .blood-drip {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(180deg, rgba(50,0,0,0.2) 0%, transparent 100%);
            pointer-events: none;
            z-index: 1;
        }

        h1 {
            font-family: 'Nosifer', cursive;
            font-size: 60px;
            color: #ff0000;
            text-shadow: 0 0 10px #500;
            margin-bottom: 20px;
            text-align: center;
        }

        .content {
            z-index: 2;
            text-align: center;
        }

        p {
            font-size: 18px;
            color: #a00;
            max-width: 600px;
            text-align: center;
            line-height: 1.5;
            margin: 10px 0;
        }

        .band-members {
            margin-top: 30px;
            border-top: 1px solid #500;
            padding-top: 20px;
        }

        .member {
            font-size: 20px;
            color: #ff0000;
            margin: 5px 0;
            text-transform: uppercase;
        }

        .role {
            font-size: 14px;
            color: #500;
            text-transform: lowercase;
        }

        #distorter {
            transition: filter 0.1s;
        }
    </style>
</head>
<body>
    <svg style="position: absolute; width: 0; height: 0;">
        <filter id="distortionFilter">
            <feTurbulence type="fractalNoise" baseFrequency="0.01" numOctaves="3" result="noise" />
            <feDisplacementMap in="SourceGraphic" in2="noise" scale="0" />
        </filter>
    </svg>

    <div class="blood-drip"></div>
    <div class="content" id="distorter">
        <h1>KRASUE'S KISS</h1>
        <p>
            YOU HAVE FOUND THE FREQUENCY.<br>
            WE ARE WATCHING.<br>
            LISTENING.<br>
            FEEDING.
        </p>
        
        <div class="band-members">
            <div class="member">Melinoe <span class="role">// lead singer</span></div>
            <div class="member">Vex <span class="role">// guitarist</span></div>
            <div class="member">Amelia <span class="role">// bass</span></div>
            <div class="member">Shei <span class="role">// 2nd guitarist</span></div>
            <div class="member">Persephone <span class="role">// drummer</span></div>
        </div>

        <br>
        <p style="font-size: 12px; color: #500;">// CONNECTION ESTABLISHED VIA DATACHIP //</p>
    </div>

    <script>
        const distorter = document.getElementById('distorter');
        const filter = document.querySelector('#distortionFilter feDisplacementMap');
        const turbulence = document.querySelector('#distortionFilter feTurbulence');

        document.addEventListener('mousemove', (e) => {
            const x = e.clientX / window.innerWidth;
            const y = e.clientY / window.innerHeight;
            
            const dx = Math.abs(x - 0.5);
            const dy = Math.abs(y - 0.5);
            const dist = Math.sqrt(dx*dx + dy*dy);
            
            // Apply distortion based on distance from center
            filter.setAttribute('scale', dist * 60);
            turbulence.setAttribute('baseFrequency', 0.01 + (dist * 0.04));
            
            // Slight tilt and jitter
            distorter.style.transform = `translate(${Math.random() * dist * 5}px, ${Math.random() * dist * 5}px)`;
            distorter.style.filter = 'url(#distortionFilter)';
        });
    </script>
</body>
</html>
    ]])
end

function SOCIAL:BuildMelinoe()
    self.container:Clear()
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    html:OpenURL("https://privatelyownedspiralgalaxy.com/THPD/")
end

function SOCIAL:BuildError(data)
    self.container:Clear()
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    local err = data and data.error or "Unknown Error"
    html:SetHTML([[
<!DOCTYPE html>
<html>
<head>
    <style>
        body {
            background-color: #050000;
            color: #ff0000;
            font-family: 'Share Tech Mono', monospace;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            overflow: hidden;
        }
        .error-box {
            border: 2px solid #f00;
            padding: 40px;
            text-align: center;
            box-shadow: 0 0 20px #f00;
            background: rgba(50, 0, 0, 0.1);
        }
        h1 {
            font-size: 60px;
            margin: 0 0 20px 0;
            text-shadow: 0 0 10px #f00;
        }
        p {
            font-size: 20px;
            color: #a00;
        }
        .back-link {
            margin-top: 30px;
            color: #555;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="error-box">
        <h1>ACCESS ERROR</h1>
        <p>]] .. err .. [[</p>
        <div class="back-link">// RE-ESTABLISHING SECURE CONNECTION FAILED //</div>
    </div>
</body>
</html>
    ]])
end

function SOCIAL:BuildExternalBrowser(data)
    self.container:Clear()
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    local targetUrl = data and data.url or "https://google.com"
    print("[CYR NET] Opening External Browser: " .. targetUrl)
    html:OpenURL(targetUrl)
end

function SOCIAL:BuildSovietFiles()
    self.container:Clear()
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    html:SetHTML([[
<!DOCTYPE html>
<html>
<head>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Rubik+Glitch&family=Share+Tech+Mono&display=swap');
        
        body {
            background-color: #000;
            color: #ff0000;
            font-family: 'Share Tech Mono', monospace;
            margin: 0;
            padding: 20px;
            overflow-x: hidden;
            animation: flash-bg 0.1s infinite;
        }

        @keyframes flash-bg {
            0% { background-color: #000; }
            45% { background-color: #0a0000; }
            50% { background-color: #1a0000; }
            55% { background-color: #0a0000; }
            100% { background-color: #000; }
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            border: 2px solid #ff0000;
            padding: 20px;
            background: rgba(0, 0, 0, 0.9);
            box-shadow: 0 0 20px #ff0000;
            position: relative;
        }

        h1 {
            font-family: 'Rubik Glitch', cursive;
            font-size: 64px;
            text-align: center;
            margin: 0;
            text-shadow: 4px 4px 0 #fff;
            animation: shake 0.5s infinite;
        }

        @keyframes shake {
            0% { transform: translate(1px, 1px) rotate(0deg); }
            10% { transform: translate(-1px, -2px) rotate(-1deg); }
            20% { transform: translate(-3px, 0px) rotate(1deg); }
            30% { transform: translate(3px, 2px) rotate(0deg); }
            40% { transform: translate(1px, -1px) rotate(1deg); }
            50% { transform: translate(-1px, 2px) rotate(-1deg); }
            60% { transform: translate(-3px, 1px) rotate(0deg); }
            70% { transform: translate(3px, 1px) rotate(-1deg); }
            80% { transform: translate(-1px, -1px) rotate(1deg); }
            90% { transform: translate(1px, 2px) rotate(0deg); }
            100% { transform: translate(1px, -2px) rotate(-1deg); }
        }

        h2 {
            font-size: 32px;
            border-bottom: 2px solid red;
            padding-bottom: 10px;
            text-transform: uppercase;
        }

        p {
            font-size: 18px;
            line-height: 1.4;
            margin-bottom: 15px;
        }

        .highlight {
            background-color: #ff0000;
            color: #000;
            padding: 0 5px;
            font-weight: bold;
        }

        .ransom-box {
            border: 4px dashed #ff0000;
            padding: 20px;
            margin-top: 40px;
            text-align: center;
            font-size: 24px;
            animation: pulse 1s infinite;
        }

        @keyframes pulse {
            0% { border-color: #ff0000; box-shadow: 0 0 10px #ff0000; }
            50% { border-color: #fff; box-shadow: 0 0 30px #ff0000; }
            100% { border-color: #ff0000; box-shadow: 0 0 10px #ff0000; }
        }

        .evidence-img {
            width: 100%;
            height: 200px;
            background-color: #330000;
            margin: 10px 0;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid red;
            overflow: hidden;
            position: relative;
        }
        
        .evidence-img:after {
            content: "CONFIDENTIAL";
            position: absolute;
            font-size: 40px;
            color: rgba(255,0,0,0.5);
            transform: rotate(-15deg);
            border: 4px solid rgba(255,0,0,0.5);
            padding: 10px;
        }

        ul {
            list-style-type: square;
        }

        li {
            margin-bottom: 10px;
            font-size: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>SOVOIL LIES</h1>
        
        <p>THEY THINK THEY CAN HIDE THE TRUTH. THEY THINK BLOOD WASHES OFF WITH OIL.</p>
        
        <h2>THE EVIDENCE</h2>
        <div class="evidence-img">
            REPORT #492-X [REDACTED]
        </div>
        
        <p>SovOil's "New Energy" initiative is a COVER UP. We have documents proving specific <span class="highlight">chemical dumping operations</span> in the N5 district water supply.</p>
        
        <ul>
            <li>PROJECT WINTER: Failed. 200 casualties.</li>
            <li>PIPELINE 7: Built on STOLEN LAND.</li>
            <li>EXECUTION ORDER 66: Signed by CEO K. V.</li>
            <li><strong>KIDNAPPING of [REDACTED]</strong>: WE HAVE HIM.</li>
        </ul>

        <p>They are poisoning the restless poor to fuel their empires of glass and chrome. <span class="highlight">WE KNOW WHAT YOU DID IN NOVOSIBIRSK.</span></p>

        <div class="ransom-box">
            WARNING TO SOVOIL EXECUTIVES<br><br>
            WE HAVE THE ENCRYPTED DRIVES.<br>
            TRANSFER <strong>5,000,000 EDDIES</strong> TO THE SECURE ACCOUNT.<br>
            OR THE WORLD SEES EVERYTHING.<br><br>
            TIME IS TICKING.
        </div>
        
        <p style="text-align: center; margin-top: 20px; font-size: 12px;">// UPLOAD COMPLETE // TRACING BLOCKED // FREE THE FILES //</p>
    </div>
</body>
</html>
    ]])
end

function SOCIAL:BuildSadBanana()
    self.container:Clear()
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    html:SetHTML([[
<!DOCTYPE html>
<html>
<head>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Comic+Neue:wght@700&display=swap');
        
        body {
            background: linear-gradient(180deg, #1a0a1a 0%, #0d0d0d 50%, #1a0505 100%);
            color: #ff69b4;
            font-family: 'Comic Neue', cursive, sans-serif;
            margin: 0;
            padding: 10px;
            overflow-x: hidden;
            cursor: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32"><text y="24" font-size="24">🍌</text></svg>'), auto;
        }
        
        .header {
            background: linear-gradient(90deg, #ff00ff, #ff6600, #ffff00, #ff00ff);
            background-size: 400% 100%;
            animation: rainbow 3s linear infinite;
            padding: 15px;
            text-align: center;
            border: 5px dashed #ff0000;
            margin-bottom: 15px;
        }
        
        @keyframes rainbow {
            0% { background-position: 0% 50%; }
            100% { background-position: 400% 50%; }
        }
        
        @keyframes blink {
            0%, 100% { opacity: 1; }
            50% { opacity: 0; }
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }
        
        .logo {
            font-size: 42px;
            color: #000;
            text-shadow: 2px 2px #ffff00, -2px -2px #ff00ff;
            animation: shake 0.3s infinite;
        }
        
        .tagline {
            color: #ffff00;
            font-size: 18px;
            text-shadow: 1px 1px #ff0000;
        }
        
        .warning {
            background: #ff0000;
            color: #fff;
            padding: 5px;
            text-align: center;
            animation: blink 0.5s infinite;
            font-size: 14px;
            margin-bottom: 15px;
        }
        
        .main-content {
            display: flex;
            gap: 15px;
        }
        
        .products {
            flex: 2;
        }
        
        .sidebar {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        
        .product-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
        }
        
        .product {
            background: linear-gradient(135deg, #2a0a2a, #1a051a);
            border: 3px solid #ff00ff;
            padding: 10px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .product:hover {
            border-color: #00ffff;
            box-shadow: 0 0 20px #ff00ff;
        }
        
        .product-title {
            color: #ffff00;
            font-size: 16px;
            margin-bottom: 5px;
        }
        
        .product-desc {
            color: #ff69b4;
            font-size: 11px;
            margin-bottom: 8px;
        }
        
        .price {
            background: #ff0000;
            color: #fff;
            padding: 3px 8px;
            display: inline-block;
            font-size: 14px;
        }
        
        .old-price {
            text-decoration: line-through;
            color: #888;
            font-size: 12px;
        }
        
        .hot-tag {
            position: absolute;
            top: 5px;
            right: -25px;
            background: #ff0000;
            color: #fff;
            padding: 2px 30px;
            font-size: 10px;
            transform: rotate(45deg);
        }
        
        .ad-box {
            background: linear-gradient(135deg, #ff6600, #ff0066);
            border: 3px dashed #ffff00;
            padding: 12px;
            text-align: center;
            animation: shake 0.2s infinite;
        }
        
        .ad-box:nth-child(odd) {
            background: linear-gradient(135deg, #00ff00, #006600);
        }
        
        .ad-title {
            color: #fff;
            font-size: 16px;
            text-shadow: 2px 2px #000;
            margin-bottom: 5px;
        }
        
        .ad-text {
            color: #ffff00;
            font-size: 12px;
        }
        
        .ad-btn {
            background: #ff0000;
            color: #fff;
            border: none;
            padding: 5px 15px;
            margin-top: 8px;
            cursor: pointer;
            animation: blink 1s infinite;
            font-family: inherit;
        }
        
        .footer {
            margin-top: 20px;
            text-align: center;
            border-top: 2px solid #ff00ff;
            padding-top: 10px;
        }
        
        .footer-text {
            color: #666;
            font-size: 10px;
        }
        
        .visitor-counter {
            background: #000;
            color: #00ff00;
            padding: 5px 10px;
            display: inline-block;
            font-family: monospace;
            margin-top: 5px;
        }
        
        marquee {
            background: #ffff00;
            color: #ff0000;
            padding: 5px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .emoji {
            font-size: 24px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">🍌 THE SAD BANANA 🍌</div>
        <div class="tagline">Night City's #1 Premium BD Experience Since 2077</div>
    </div>
    
    <div class="warning">⚠️ WARNING: YOU MUST BE 18+ TO ENTER ⚠️ ARASAKA APPROVED SITE ⚠️ NO REFUNDS ⚠️</div>
    
    <marquee>🔥 FLASH SALE 🔥 USE CODE "SADSACK" FOR 10% OFF 🔥 NEW BDS ADDED DAILY 🔥 REAL AUTHENTIC RECORDINGS 🔥 SATISFACTION GUARANTEED* 🔥</marquee>
    
    <div class="main-content">
        <div class="products">
            <div class="product-grid">
                <div class="product">
                    <div class="hot-tag">HOT!</div>
                    <div class="product-title">🍌 Lonely Banana Vol. 1</div>
                    <div class="product-desc">Experience what it's like to be a sad banana in Watson. 4K neural quality.</div>
                    <div class="old-price">500 €$</div>
                    <div class="price">299 €$</div>
                </div>
                
                <div class="product">
                    <div class="product-title">🍌 Peeled & Ready</div>
                    <div class="product-desc">Our most downloaded BD! Warning: May cause existential dread.</div>
                    <div class="price">199 €$</div>
                </div>
                
                <div class="product">
                    <div class="hot-tag">NEW!</div>
                    <div class="product-title">🍌 Banana Split Special</div>
                    <div class="product-desc">Two bananas. One wreath. Premium content only.</div>
                    <div class="old-price">800 €$</div>
                    <div class="price">449 €$</div>
                </div>
                
                <div class="product">
                    <div class="product-title">🍌 Ripe & Waiting</div>
                    <div class="product-desc">Fresh from Pacifica! Uncut neural capture.</div>
                    <div class="price">349 €$</div>
                </div>
                
                <div class="product">
                    <div class="product-title">🍌 Fruit Salad Deluxe</div>
                    <div class="product-desc">Featuring special guest appearances! Group experience BD.</div>
                    <div class="price">599 €$</div>
                </div>
                
                <div class="product">
                    <div class="hot-tag">SALE!</div>
                    <div class="product-title">🍌 Bruised But Beautiful</div>
                    <div class="product-desc">For the connoisseur. Vintage 2074 recording.</div>
                    <div class="old-price">1200 €$</div>
                    <div class="price">399 €$</div>
                </div>
            </div>
        </div>
        
        <div class="sidebar">
            <div class="ad-box">
                <div class="ad-title">🔥 42 CHROMED HOTTIES IN YOUR AREA 🔥</div>
                <div class="ad-text">Lonely solos with full-body conversions want to meet YOU tonight!</div>
                <button class="ad-btn">CLICK NOW!</button>
            </div>
            
            <div class="ad-box">
                <div class="ad-title">💊 TIRED? TRY SYNTHCOKE! 💊</div>
                <div class="ad-text">Stay awake for 72 hours straight! No side effects!*</div>
                <button class="ad-btn">ORDER NOW!</button>
            </div>
            
            <div class="ad-box">
                <div class="ad-title">🦾 CHEAP CHROME! 🦾</div>
                <div class="ad-text">Back alley ripperdoc special! Arms from 500€$! Probably clean!</div>
                <button class="ad-btn">GET CHROME!</button>
            </div>
            
            <div class="ad-box">
                <div class="ad-title">💀 MILITECH HATES THIS! 💀</div>
                <div class="ad-text">Local netrunner discovers ONE WEIRD TRICK to hack any system!</div>
                <button class="ad-btn">LEARN MORE!</button>
            </div>
            
            <div class="ad-box">
                <div class="ad-title">🎰 PACIFICA CASINO ONLINE 🎰</div>
                <div class="ad-text">Turn 100€$ into 1 MILLION! Guaranteed wins!**</div>
                <button class="ad-btn">PLAY NOW!</button>
            </div>
        </div>
    </div>
    
    <div class="footer">
        <div class="footer-text">
            *Satisfaction not actually guaranteed. All sales final. Not responsible for cyberpsychosis, data breaches, or NCPD raids.<br>
            **Casino odds: 0.0001%. House always wins. Gambling addiction hotline: 1-800-FLATLINE<br>
            © 2077 The Sad Banana LLC. A Definitely Legitimate Business. Night City, NUSA.
        </div>
        <div class="visitor-counter">VISITORS: 69,420,666</div>
    </div>
</body>
</html>
    ]])
end

function SOCIAL:BuildBombDF()
    self.container:Clear()
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    html:AddFunction("CYR", "playExplosion", function() surface.PlaySound("ambient/explosions/explode_9.wav") end)
    html:AddFunction("CYR", "playBeep", function() surface.PlaySound("buttons/button15.wav") end)
    html:AddFunction("CYR", "playSuccess", function() surface.PlaySound("buttons/button3.wav") end)
    html:AddFunction("CYR", "playFail", function() surface.PlaySound("buttons/button10.wav") end)
    html:SetHTML([[
<!DOCTYPE html>
<html>
<head>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap');

        body {
            background-color: #000;
            color: #ff0000;
            font-family: 'Share Tech Mono', monospace;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            overflow: hidden;
            user-select: none;
        }
        
        .bomb-container {
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 20px;
        }
        
        h1 {
            font-size: 40px;
            margin: 0;
            text-transform: uppercase;
            text-shadow: 0 0 10px #ff0000;
            letter-spacing: 2px;
        }
        
        #timer {
            font-size: 80px;
            font-weight: bold;
            color: #ff0000;
            text-shadow: 0 0 20px #ff0000;
            background: #110000;
            padding: 10px 40px;
            border: 2px solid #500;
            border-radius: 10px;
            min-width: 300px;
        }
        
        .numpad {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            background: #111;
            padding: 20px;
            border: 2px solid #333;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.8);
        }

        .display-screen {
            grid-column: 1 / -1;
            background: #0a0a0a;
            color: #0f0;
            font-size: 32px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid #333;
            margin-bottom: 10px;
            text-shadow: 0 0 5px #0f0;
            letter-spacing: 5px;
        }
        
        button {
            background: #222;
            color: #ddd;
            border: 1px solid #444;
            font-family: inherit;
            font-size: 24px;
            padding: 20px;
            cursor: pointer;
            transition: all 0.1s;
            border-radius: 5px;
        }
        
        button:hover { background: #333; border-color: #666; color: #fff; }
        button:active { background: #555; transform: scale(0.95); }
        
        .btn-clear { background: #420; border-color: #630; color: #f88; }
        .btn-clear:hover { background: #630; }
        
        .btn-enter { background: #030; border-color: #050; color: #8f8; }
        .btn-enter:hover { background: #050; }

        .explosion-bg {
            background-color: white !important;
            color: black !important;
        }
        
        .defused-bg {
            background-color: #001100;
            color: #00ff00;
        }

        .blink { animation: blinker 0.5s linear infinite; }
        @keyframes blinker { 50% { opacity: 0; } }
        
        .hidden { display: none !important; }
    </style>
</head>
<body>
    <div class="bomb-container" id="bomb">
        <h1>ARMED SYSTEM</h1>
        <div id="timer">15.00</div>
        
        <div class="numpad">
            <div class="display-screen" id="code-display"></div>
            
            <button onclick="press(1)">1</button>
            <button onclick="press(2)">2</button>
            <button onclick="press(3)">3</button>
            
            <button onclick="press(4)">4</button>
            <button onclick="press(5)">5</button>
            <button onclick="press(6)">6</button>
            
            <button onclick="press(7)">7</button>
            <button onclick="press(8)">8</button>
            <button onclick="press(9)">9</button>
            
            <button onclick="clearCode()" class="btn-clear">C</button>
            <button onclick="press(0)">0</button>
            <button onclick="submitCode()" class="btn-enter">E</button>
        </div>
    </div>
    
    <div id="defused-msg" class="hidden" style="text-align: center;">
        <h1 style="color: #0f0; text-shadow: 0 0 20px #0f0; font-size: 60px;">BOMB DEFUSED</h1>
        <p style="font-size: 24px; color: #0a0;">SYSTEM SECURE</p>
    </div>

    <!-- Background Music -->
    <audio id="bg-music" autoplay loop>
        <source src="https://dl.dropboxusercontent.com/scl/fi/co3b3nb3ovn0bqtas93f9/Splinter-Cell-Chaos-Theory-Bathhouse-Defusal.mp3?rlkey=gakr1njygnti59uk2lh5api9w&st=w6x5ub40&dl=0" type="audio/mpeg">
    </audio>

    <script>
        // Countdown logic
        let timeLeft = 15.00;
        let isDefused = false;
        let isExploded = false;
        let currentCode = "";
        
        const timerEl = document.getElementById('timer');
        const bombEl = document.getElementById('bomb');
        const musicEl = document.getElementById('bg-music');
        const displayEl = document.getElementById('code-display');
        const defusedMsgEl = document.getElementById('defused-msg');
        
        if(musicEl) musicEl.volume = 0.5;

        const interval = setInterval(() => {
            if(isDefused || isExploded) return;
            
            timeLeft -= 0.01;
            if (timeLeft <= 0) {
                timeLeft = 0;
                explode();
            }
            timerEl.innerText = timeLeft.toFixed(2);
            
            // Panic mode visuals
            if(timeLeft < 5.0 && timeLeft > 0) {
                timerEl.style.color = (timeLeft * 10) % 2 > 1 ? "#fff" : "#f00";
            }
        }, 10);
        
        function press(num) {
            if(isDefused || isExploded) return;
            if(currentCode.length < 5) {
                currentCode += num;
                CYR.playBeep();
                updateDisplay();
            }
        }
        
        function clearCode() {
            if(isDefused || isExploded) return;
            currentCode = "";
            CYR.playBeep();
            updateDisplay();
        }
        
        function updateDisplay() {
            displayEl.innerText = currentCode;
        }
        
        function submitCode() {
            if(isDefused || isExploded) return;
            
            if(currentCode === "58008") {
                defuse();
            } else {
                // Punishment for wrong code
                timeLeft -= 5.0;
                flashError();
                CYR.playFail();
                currentCode = "";
                updateDisplay();
            }
        }
        
        function flashError() {
            displayEl.style.backgroundColor = "#500";
            setTimeout(() => { displayEl.style.backgroundColor = "#0a0a0a"; }, 200);
        }

        function defuse() {
            isDefused = true;
            clearInterval(interval);
            if(musicEl) musicEl.pause();
            
            CYR.playSuccess();
            document.body.classList.add('defused-bg');
            bombEl.classList.add('hidden');
            defusedMsgEl.classList.remove('hidden');
        }

        function explode() {
            isExploded = true;
            clearInterval(interval);
            
            if(musicEl) musicEl.pause();

            document.body.classList.add('explosion-bg');
            bombEl.style.display = 'none';
            
            CYR.playExplosion();
            
            setTimeout(() => {
                document.body.innerHTML = '<div style="display:flex; justify-content:center; align-items:center; height:100vh; color:black; font-family:monospace; font-size:24px; font-weight:bold;">CONNECTION LOST</div>';
            }, 2000);
        }
    </script>
</body>
</html>
    ]])
end

function SOCIAL:BuildCoolMathHub()
    self.container:Clear()
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    html:AddFunction("CYR", "nav", function(dest) self:ResolveURL("net://coolmath.games/" .. dest) end)
    html:SetHTML([[
<!DOCTYPE html>
<html>
<head>
    <style>
        body { background: #000; color: #fff; font-family: 'Verdana', sans-serif; height: 100vh; margin: 0; display:flex; flex-direction:column; justify-content:center; align-items:center; }
        h1 { font-family: 'Courier New', monospace; font-size: 60px; color: #00ff00; text-shadow: 4px 4px #ff00ff; margin-bottom: 40px; }
        .grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
        .card { 
            background: #111; border: 2px solid #333; padding: 20px; width: 150px; height: 150px;
            display:flex; flex-direction:column; justify-content:center; align-items:center; cursor:pointer; 
            transition: all 0.2s;
        }
        .card:hover { transform: scale(1.1); background: #222; border-color: #00ff00; }
        .icon { font-size: 40px; margin-bottom: 10px; }
        .title { font-weight: bold; text-transform:uppercase; color: #ccc; }
    </style>
</head>
<body>
    <h1>COOLMATH.GAMES</h1>
    <div class="grid">
        <div class="card" onclick="CYR.nav('minesweeper')"><div class="icon">ðŸ’£</div><div class="title">Minesweeper</div></div>
        <div class="card" onclick="CYR.nav('pong')"><div class="icon">ðŸ“</div><div class="title">Pong</div></div>
        <div class="card" onclick="CYR.nav('tetris')"><div class="icon">ðŸ§±</div><div class="title">Tetris</div></div>
        <div class="card" onclick="CYR.nav('snake')"><div class="icon">ðŸ</div><div class="title">Snake</div></div>
        <div class="card" onclick="CYR.nav('solitaire')"><div class="icon">ðŸƒ</div><div class="title">Solitaire</div></div>
        <div class="card" onclick="CYR.nav('balatro')"><div class="icon">ðŸƒðŸ”¥</div><div class="title">Balatro (Lite)</div></div>
        <div class="card" onclick="CYR.nav('chess')"><div class="icon">â™Ÿï¸</div><div class="title">Multiplayer Chess</div></div>
    </div>
</body>
</html>
    ]])
end

function SOCIAL:BuildCoolMathMinesweeper()
    self.container:Clear()
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    html:SetHTML([[
<!DOCTYPE html>
<html>
<head>
<style>
  body { background: #c0c0c0; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; font-family: system-ui; }
  .window { background: #c0c0c0; border: 3px solid #fff; border-right-color: #808080; border-bottom-color: #808080; padding: 5px; box-shadow: 5px 5px 10px rgba(0,0,0,0.5); }
  .header { background: #000080; color: white; padding: 2px 5px; font-weight: bold; margin-bottom: 5px; display:flex; justify-content:space-between;}
  .board { border: 3px solid #808080; border-right-color: #fff; border-bottom-color: #fff; display: grid; grid-template-columns: repeat(10, 25px); }
  .cell { width: 25px; height: 25px; background: #c0c0c0; border: 2px solid #fff; border-right-color: #808080; border-bottom-color: #808080; display: flex; justify-content: center; align-items: center; font-weight: bold; cursor: pointer; user-select: none; font-size: 14px;}
  .cell:active { border: 1px solid #808080; }
  .revealed { border: 1px solid #808080; background: #c0c0c0; }
  .mine { background: red; }
  .status { margin-bottom: 5px; font-family: monospace; font-size: 20px; background: #000; color: red; padding: 5px; text-align: right; border: 2px solid #808080; border-right-color: #fff; border-bottom-color: #fff; }
</style>
</head>
<body>
<div class="window">
    <div class="header"><span>Minesweeper</span><span>_ X</span></div>
    <div class="status" id="timer">000</div>
    <div class="board" id="board"></div>
</div>
<script>
    const rows = 10, cols = 10, mines = 15;
    let grid = [], revealed = [], gameOver = false;
    
    function init() {
        grid = Array(rows).fill().map(() => Array(cols).fill(0));
        revealed = Array(rows).fill().map(() => Array(cols).fill(false));
        let m = 0;
        while(m < mines) {
            let r = Math.floor(Math.random()*rows), c = Math.floor(Math.random()*cols);
            if(grid[r][c] !== 'M') { grid[r][c] = 'M'; m++; }
        }
        for(let r=0; r<rows; r++) {
            for(let c=0; c<cols; c++) {
                if(grid[r][c] === 'M') continue;
                let count = 0;
                for(let i=-1; i<=1; i++) for(let j=-1; j<=1; j++) {
                    if(r+i>=0 && r+i<rows && c+j>=0 && c+j<cols && grid[r+i][c+j] === 'M') count++;
                }
                grid[r][c] = count;
            }
        }
        render();
    }
    
    function render() {
        const b = document.getElementById('board');
        b.innerHTML = '';
        for(let r=0; r<rows; r++) {
            for(let c=0; c<cols; c++) {
                let div = document.createElement('div');
                div.className = 'cell';
                if(revealed[r][c]) {
                    div.className += ' revealed';
                    if(grid[r][c] === 'M') { div.className += ' mine'; div.innerText = 'ðŸ’£'; }
                    else if(grid[r][c] > 0) { 
                        div.innerText = grid[r][c]; 
                        const colors = ['blue','green','red','darkblue','brown','cyan','black','gray'];
                        div.style.color = colors[grid[r][c]-1];
                    }
                }
                div.onmousedown = (e) => {
                    if(gameOver) { init(); gameOver=false; return; }
                    if(e.button === 0) click(r,c);
                };
                b.appendChild(div);
            }
        }
    }
    
    function click(r,c) {
        if(revealed[r][c]) return;
        revealed[r][c] = true;
        if(grid[r][c] === 'M') { gameOver = true; revealAll(); }
        else if(grid[r][c] === 0) {
            for(let i=-1; i<=1; i++) for(let j=-1; j<=1; j++) {
                if(r+i>=0 && r+i<rows && c+j>=0 && c+j<cols) click(r+i, c+j);
            }
        }
        render();
    }
    
    function revealAll() {
        for(let r=0; r<rows; r++) for(let c=0; c<cols; c++) revealed[r][c] = true;
        render();
    }
    
    init();
</script>
</body>
</html>
    ]])
end

function SOCIAL:BuildCoolMathPong()
    self.container:Clear()
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    html:SetHTML([[
<!DOCTYPE html>
<html>
<head>
<style>
    body { background: black; color: white; display:flex; justify-content:center; align-items:center; height:100vh; margin:0; overflow:hidden; font-family:'Courier New'; }
    canvas { border: 2px solid white; box-shadow: 0 0 20px rgba(255,255,255,0.2); }
    h1 { position:absolute; top:20px; font-size:40px; margin:0; text-transform: uppercase; letter-spacing: 5px; opacity:0.5; }
</style>
</head>
<body>
    <h1>PONG</h1>
    <canvas id="game" width="800" height="600"></canvas>
    <script>
        const canvas = document.getElementById('game');
        const ctx = canvas.getContext('2d');
        
        const ball = { x: 400, y: 300, r: 10, dx: 5, dy: 5 };
        const paddleH = 100, paddleW = 15;
        const p1 = { x: 20, y: 250, score: 0 };
        const p2 = { x: 765, y: 250, score: 0, dy: 4 }; // AI
        
        canvas.addEventListener('mousemove', e => {
            let rect = canvas.getBoundingClientRect();
            p1.y = e.clientY - rect.top - paddleH/2;
            // clamp
            if(p1.y < 0) p1.y = 0;
            if(p1.y > canvas.height - paddleH) p1.y = canvas.height - paddleH;
        });

        function update() {
            // Ball movement
            ball.x += ball.dx;
            ball.y += ball.dy;
            
            // Wall collision
            if(ball.y + ball.r > canvas.height || ball.y - ball.r < 0) ball.dy *= -1;
            
            // Paddle collision
            if(ball.x - ball.r < p1.x + paddleW && ball.y > p1.y && ball.y < p1.y + paddleH) {
                ball.dx = Math.abs(ball.dx); // Bounce right
                ball.dx *= 1.05; // Speed up
            }
            if(ball.x + ball.r > p2.x && ball.y > p2.y && ball.y < p2.y + paddleH) {
                ball.dx = -Math.abs(ball.dx); // Bounce left
                ball.dx *= 1.05; // Speed up
            }
            
            // Score
            if(ball.x < 0) { p2.score++; reset(); }
            if(ball.x > canvas.width) { p1.score++; reset(); }
            
            // AI
            let targetY = ball.y - paddleH/2;
            if(p2.y < targetY) p2.y += p2.dy;
            if(p2.y > targetY) p2.y -= p2.dy;
            // AI clamp
            if(p2.y < 0) p2.y = 0;
            if(p2.y > canvas.height - paddleH) p2.y = canvas.height - paddleH;
        }
        
        function reset() {
            ball.x = canvas.width/2; 
            ball.y = canvas.height/2;
            ball.dx = 5 * (Math.random() > 0.5 ? 1 : -1);
            ball.dy = 5 * (Math.random() > 0.5 ? 1 : -1);
        }
        
        function draw() {
            // Bg
            ctx.fillStyle = 'black';
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            
            // Net
            ctx.setLineDash([10, 15]);
            ctx.beginPath();
            ctx.moveTo(canvas.width/2, 0);
            ctx.lineTo(canvas.width/2, canvas.height);
            ctx.strokeStyle = 'white';
            ctx.stroke();
            
            // Ball
            ctx.fillStyle = 'white';
            ctx.beginPath();
            ctx.arc(ball.x, ball.y, ball.r, 0, Math.PI*2);
            ctx.fill();
            
            // Paddles
            ctx.fillRect(p1.x, p1.y, paddleW, paddleH);
            ctx.fillRect(p2.x, p2.y, paddleW, paddleH);
            
            // Scores
            ctx.font = '50px Courier New';
            ctx.fillText(p1.score, canvas.width/4, 80);
            ctx.fillText(p2.score, canvas.width*0.75, 80);
        }
        
        function loop() {
            update();
            draw();
            requestAnimationFrame(loop);
        }
        
        loop();
    </script>
</body>
</html>
    ]])
end

function SOCIAL:BuildCoolMathTetris()
    self.container:Clear()
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    -- Use [=[ ]=] string delimiter to avoid conflict with ]] in JS array access
    html:SetHTML([=[
<!DOCTYPE html>
<html>
<head>
<style>
    * { box-sizing: border-box; }
    body { 
        background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%); 
        color: #fff; 
        display: flex; 
        align-items: center; 
        justify-content: center; 
        height: 100vh; 
        margin: 0; 
        font-family: 'Segoe UI', Tahoma, sans-serif;
        overflow: hidden;
    }
    .game-container {
        display: flex;
        align-items: flex-start;
        gap: 20px;
        padding: 20px;
        background: rgba(0,0,0,0.3);
        border-radius: 15px;
        box-shadow: 0 0 40px rgba(0,150,255,0.2);
    }
    .main-board {
        position: relative;
    }
    #tetris { 
        border: 3px solid #4a9eff;
        border-radius: 5px;
        box-shadow: 0 0 30px rgba(74,158,255,0.4), inset 0 0 20px rgba(0,0,0,0.5);
        background: #0a0a15;
    }
    .side-panel {
        display: flex;
        flex-direction: column;
        gap: 15px;
        min-width: 120px;
    }
    .panel-box {
        background: rgba(0,0,0,0.4);
        border: 2px solid #4a9eff;
        border-radius: 10px;
        padding: 15px;
        text-align: center;
    }
    .panel-title {
        font-size: 12px;
        text-transform: uppercase;
        letter-spacing: 2px;
        color: #4a9eff;
        margin-bottom: 8px;
    }
    .panel-value {
        font-size: 28px;
        font-weight: bold;
        text-shadow: 0 0 10px rgba(74,158,255,0.8);
    }
    #nextPiece {
        background: #0a0a15;
        border-radius: 5px;
        margin-top: 5px;
    }
    .controls {
        font-size: 11px;
        opacity: 0.7;
        line-height: 1.8;
    }
    .controls span {
        color: #4a9eff;
        font-weight: bold;
    }
    /* Tetris flash effect */
    .tetris-flash {
        position: fixed;
        top: 0; left: 0; right: 0; bottom: 0;
        background: rgba(255,255,255,0.8);
        pointer-events: none;
        animation: flash 0.5s ease-out forwards;
        z-index: 1000;
    }
    @keyframes flash {
        0% { opacity: 1; }
        100% { opacity: 0; }
    }
    .tetris-text {
        position: fixed;
        top: 50%; left: 50%;
        transform: translate(-50%, -50%);
        font-size: 60px;
        font-weight: bold;
        color: #ff0;
        text-shadow: 0 0 20px #ff0, 0 0 40px #f80, 0 0 60px #f00;
        animation: tetrisText 1s ease-out forwards;
        z-index: 1001;
        pointer-events: none;
    }
    @keyframes tetrisText {
        0% { transform: translate(-50%, -50%) scale(0.5); opacity: 1; }
        50% { transform: translate(-50%, -50%) scale(1.2); }
        100% { transform: translate(-50%, -50%) scale(1); opacity: 0; }
    }
    .level-display {
        font-size: 20px;
    }
</style>
</head>
<body>
    <div class="game-container">
        <div class="main-board">
            <canvas id="tetris" width="240" height="400"></canvas>
        </div>
        <div class="side-panel">
            <div class="panel-box">
                <div class="panel-title">Score</div>
                <div class="panel-value" id="score">0</div>
            </div>
            <div class="panel-box">
                <div class="panel-title">Level</div>
                <div class="panel-value level-display" id="level">1</div>
            </div>
            <div class="panel-box">
                <div class="panel-title">Lines</div>
                <div class="panel-value level-display" id="lines">0</div>
            </div>
            <div class="panel-box">
                <div class="panel-title">Next</div>
                <canvas id="nextPiece" width="80" height="80"></canvas>
            </div>
            <div class="panel-box controls">
                <span>←→</span> Move<br>
                <span>↓</span> Soft Drop<br>
                <span>SPACE</span> Hard Drop<br>
                <span>Q/W</span> Rotate
            </div>
        </div>
    </div>
    
    <audio id="bgm" loop>
        <source src="https://jetta.vgmtreasurechest.com/soundtracks/tetris-gb/zdwyaiow/03.%20A-Type%20Music%20%28Korobeiniki%29.mp3" type="audio/mpeg">
    </audio>

<script>
    const canvas = document.getElementById('tetris');
    const context = canvas.getContext('2d');
    const nextCanvas = document.getElementById('nextPiece');
    const nextContext = nextCanvas.getContext('2d');
    
    const BLOCK_SIZE = 20;
    const COLS = 12;
    const ROWS = 20;

    // Start music at 10% volume
    const audio = document.getElementById('bgm');
    if(audio) {
        audio.volume = 0.10;
        // Try to play (may need user interaction)
        document.addEventListener('click', () => audio.play(), { once: true });
        document.addEventListener('keydown', () => audio.play(), { once: true });
        audio.play().catch(() => {});
    }

    // Gradient colors for pieces
    const pieceGradients = {
        1: ['#FF1744', '#D50000'],     // I - Red
        2: ['#00E5FF', '#00B8D4'],     // L - Cyan  
        3: ['#FF9100', '#FF6D00'],     // J - Orange
        4: ['#FFEA00', '#FFD600'],     // O - Yellow
        5: ['#00E676', '#00C853'],     // Z - Green
        6: ['#E040FB', '#AA00FF'],     // S - Purple
        7: ['#448AFF', '#2962FF']      // T - Blue
    };

    let totalLines = 0;
    let level = 1;
    let nextPiece = null;

    function createGradient(ctx, x, y, color1, color2) {
        const grad = ctx.createLinearGradient(x, y, x + 1, y + 1);
        grad.addColorStop(0, color1);
        grad.addColorStop(1, color2);
        return grad;
    }

    function arenaSweep() {
        let rowCount = 0;
        let rowsCleared = [];
        
        outer: for (let y = arena.length - 1; y > 0; --y) {
            for (let x = 0; x < arena[y].length; ++x) {
                if (arena[y][x] === 0) continue outer;
            }
            rowsCleared.push(y);
            rowCount++;
        }
        
        // Remove cleared rows
        for (let i = rowsCleared.length - 1; i >= 0; i--) {
            const row = arena.splice(rowsCleared[i], 1)[0].fill(0);
            arena.unshift(row);
        }
        
        if (rowCount > 0) {
            // Scoring: 100, 300, 500, 800 for 1,2,3,4 lines
            const points = [0, 100, 300, 500, 800];
            player.score += points[rowCount] * level;
            totalLines += rowCount;
            
            // Level up every 10 lines
            level = Math.floor(totalLines / 10) + 1;
            dropInterval = Math.max(100, 1000 - (level - 1) * 80);
            
            // TETRIS effect (4 lines)
            if (rowCount === 4) {
                triggerTetrisEffect();
            }
            
            updateScore();
        }
    }

    function triggerTetrisEffect() {
        // Flash
        const flash = document.createElement('div');
        flash.className = 'tetris-flash';
        document.body.appendChild(flash);
        setTimeout(() => flash.remove(), 500);
        
        // Text
        const text = document.createElement('div');
        text.className = 'tetris-text';
        text.textContent = 'TETRIS!';
        document.body.appendChild(text);
        setTimeout(() => text.remove(), 1000);
    }

    function collide(arena, player) {
        const m = player.matrix;
        const o = player.pos;
        for (let y = 0; y < m.length; ++y) {
            for (let x = 0; x < m[y].length; ++x) {
                if (m[y][x] !== 0 && (arena[y + o.y] && arena[y + o.y][x + o.x]) !== 0) return true;
            }
        }
        return false;
    }

    function createMatrix(w, h) {
        const matrix = [];
        while (h--) matrix.push(new Array(w).fill(0));
        return matrix;
    }

    function createPiece(type) {
        if (type === 'I') return [[0, 1, 0, 0], [0, 1, 0, 0], [0, 1, 0, 0], [0, 1, 0, 0]];
        if (type === 'L') return [[0, 2, 0], [0, 2, 0], [0, 2, 2]];
        if (type === 'J') return [[0, 3, 0], [0, 3, 0], [3, 3, 0]];
        if (type === 'O') return [[4, 4], [4, 4]];
        if (type === 'Z') return [[5, 5, 0], [0, 5, 5], [0, 0, 0]];
        if (type === 'S') return [[0, 6, 6], [6, 6, 0], [0, 0, 0]];
        if (type === 'T') return [[0, 7, 0], [7, 7, 7], [0, 0, 0]];
    }

    function draw() {
        // Clear with dark background
        context.fillStyle = '#0a0a15';
        context.fillRect(0, 0, canvas.width, canvas.height);
        
        // Draw grid
        context.strokeStyle = 'rgba(74, 158, 255, 0.1)';
        context.lineWidth = 1;
        for (let x = 0; x <= COLS; x++) {
            context.beginPath();
            context.moveTo(x * BLOCK_SIZE, 0);
            context.lineTo(x * BLOCK_SIZE, canvas.height);
            context.stroke();
        }
        for (let y = 0; y <= ROWS; y++) {
            context.beginPath();
            context.moveTo(0, y * BLOCK_SIZE);
            context.lineTo(canvas.width, y * BLOCK_SIZE);
            context.stroke();
        }
        
        // Draw ghost piece (preview where piece will land)
        drawGhostPiece();
        
        // Draw arena (placed pieces)
        drawMatrix(arena, {x: 0, y: 0}, context, BLOCK_SIZE);
        
        // Draw current piece
        drawMatrix(player.matrix, player.pos, context, BLOCK_SIZE);
    }

    function drawGhostPiece() {
        const ghost = { pos: { x: player.pos.x, y: player.pos.y }, matrix: player.matrix };
        while (!collide(arena, ghost)) {
            ghost.pos.y++;
        }
        ghost.pos.y--;
        
        // Draw ghost with transparency
        ghost.matrix.forEach((row, y) => {
            row.forEach((value, x) => {
                if (value !== 0) {
                    context.fillStyle = 'rgba(255, 255, 255, 0.15)';
                    context.fillRect(
                        (x + ghost.pos.x) * BLOCK_SIZE,
                        (y + ghost.pos.y) * BLOCK_SIZE,
                        BLOCK_SIZE - 1,
                        BLOCK_SIZE - 1
                    );
                }
            });
        });
    }

    function drawMatrix(matrix, offset, ctx, size) {
        matrix.forEach((row, y) => {
            row.forEach((value, x) => {
                if (value !== 0) {
                    const px = (x + offset.x) * size;
                    const py = (y + offset.y) * size;
                    
                    // Gradient fill
                    const colors = pieceGradients[value];
                    const gradient = ctx.createLinearGradient(px, py, px + size, py + size);
                    gradient.addColorStop(0, colors[0]);
                    gradient.addColorStop(1, colors[1]);
                    ctx.fillStyle = gradient;
                    ctx.fillRect(px, py, size - 1, size - 1);
                    
                    // Highlight (top-left)
                    ctx.fillStyle = 'rgba(255,255,255,0.3)';
                    ctx.fillRect(px, py, size - 1, 3);
                    ctx.fillRect(px, py, 3, size - 1);
                    
                    // Shadow (bottom-right)
                    ctx.fillStyle = 'rgba(0,0,0,0.3)';
                    ctx.fillRect(px, py + size - 4, size - 1, 3);
                    ctx.fillRect(px + size - 4, py, 3, size - 1);
                }
            });
        });
    }

    function drawNextPiece() {
        nextContext.fillStyle = '#0a0a15';
        nextContext.fillRect(0, 0, nextCanvas.width, nextCanvas.height);
        
        if (nextPiece) {
            const size = 18;
            const offsetX = (nextCanvas.width - nextPiece[0].length * size) / 2 / size;
            const offsetY = (nextCanvas.height - nextPiece.length * size) / 2 / size;
            
            nextPiece.forEach((row, y) => {
                row.forEach((value, x) => {
                    if (value !== 0) {
                        const px = (x + offsetX) * size;
                        const py = (y + offsetY) * size;
                        
                        const colors = pieceGradients[value];
                        const gradient = nextContext.createLinearGradient(px, py, px + size, py + size);
                        gradient.addColorStop(0, colors[0]);
                        gradient.addColorStop(1, colors[1]);
                        nextContext.fillStyle = gradient;
                        nextContext.fillRect(px, py, size - 1, size - 1);
                        
                        // Highlight
                        nextContext.fillStyle = 'rgba(255,255,255,0.3)';
                        nextContext.fillRect(px, py, size - 1, 2);
                        nextContext.fillRect(px, py, 2, size - 1);
                    }
                });
            });
        }
    }

    function merge(arena, player) {
        player.matrix.forEach((row, y) => {
            row.forEach((value, x) => {
                if (value !== 0) arena[y + player.pos.y][x + player.pos.x] = value;
            });
        });
    }

    function rotate(matrix, dir) {
        for (let y = 0; y < matrix.length; ++y) {
            for (let x = 0; x < y; ++x) {
                [matrix[x][y], matrix[y][x]] = [matrix[y][x], matrix[x][y]];
            }
        }
        if (dir > 0) matrix.forEach(row => row.reverse());
        else matrix.reverse();
    }

    function playerDrop() {
        player.pos.y++;
        if (collide(arena, player)) {
            player.pos.y--;
            merge(arena, player);
            playerReset();
            arenaSweep();
            updateScore();
        }
        dropCounter = 0;
    }

    function playerHardDrop() {
        while (!collide(arena, player)) {
            player.pos.y++;
        }
        player.pos.y--;
        merge(arena, player);
        playerReset();
        arenaSweep();
        updateScore();
        dropCounter = 0;
    }

    function playerMove(dir) {
        player.pos.x += dir;
        if (collide(arena, player)) player.pos.x -= dir;
    }

    function playerReset() {
        const pieces = 'ILJOTSZ';
        
        // Use next piece if available, otherwise generate new
        if (nextPiece) {
            player.matrix = nextPiece;
        } else {
            player.matrix = createPiece(pieces[pieces.length * Math.random() | 0]);
        }
        
        // Generate next piece
        nextPiece = createPiece(pieces[pieces.length * Math.random() | 0]);
        drawNextPiece();
        
        player.pos.y = 0;
        player.pos.x = (arena[0].length / 2 | 0) - (player.matrix[0].length / 2 | 0);
        
        if (collide(arena, player)) {
            arena.forEach(row => row.fill(0));
            player.score = 0;
            totalLines = 0;
            level = 1;
            dropInterval = 1000;
            updateScore();
        }
    }

    function playerRotate(dir) {
        const pos = player.pos.x;
        let offset = 1;
        rotate(player.matrix, dir);
        while (collide(arena, player)) {
            player.pos.x += offset;
            offset = -(offset + (offset > 0 ? 1 : -1));
            if (offset > player.matrix[0].length) {
                rotate(player.matrix, -dir);
                player.pos.x = pos;
                return;
            }
        }
    }

    let dropCounter = 0;
    let dropInterval = 1000;
    let lastTime = 0;

    function update(time = 0) {
        const deltaTime = time - lastTime;
        lastTime = time;
        dropCounter += deltaTime;
        if (dropCounter > dropInterval) playerDrop();
        draw();
        requestAnimationFrame(update);
    }

    function updateScore() {
        document.getElementById('score').innerText = player.score;
        document.getElementById('level').innerText = level;
        document.getElementById('lines').innerText = totalLines;
    }

    const arena = createMatrix(COLS, ROWS);
    const player = { pos: {x: 0, y: 0}, matrix: null, score: 0 };

    document.addEventListener('keydown', event => {
        if (event.keyCode === 37) playerMove(-1);          // Left
        else if (event.keyCode === 39) playerMove(1);       // Right
        else if (event.keyCode === 40) playerDrop();        // Down
        else if (event.keyCode === 32) playerHardDrop();    // Space - Hard drop
        else if (event.keyCode === 81) playerRotate(-1);    // Q
        else if (event.keyCode === 87) playerRotate(1);     // W
    });

    playerReset();
    updateScore();
    update();
</script>
</body>
</html>
    ]=])
end

function SOCIAL:BuildCoolMathSnake()
    self.container:Clear()
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    html:SetHTML([[
<!DOCTYPE html>
<html>
<head>
<style>
  html, body { height: 100%; margin: 0; }
  body { background: black; display: flex; align-items: center; justify-content: center; }
  canvas { border: 1px solid white; }
</style>
</head>
<body>
<canvas width="400" height="400" id="game"></canvas>
<script>
var canvas = document.getElementById('game');
var context = canvas.getContext('2d');
var grid = 16;
var count = 0;

var snake = {
  x: 160,
  y: 160,
  dx: grid,
  dy: 0,
  cells: [],
  maxCells: 4
};
var apple = {
  x: 320,
  y: 320
};

function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min)) + min;
}

function loop() {
  requestAnimationFrame(loop);
  if (++count < 4) return;
  count = 0;
  context.clearRect(0,0,canvas.width,canvas.height);

  snake.x += snake.dx;
  snake.y += snake.dy;

  if (snake.x < 0) snake.x = canvas.width - grid;
  else if (snake.x >= canvas.width) snake.x = 0;
  if (snake.y < 0) snake.y = canvas.height - grid;
  else if (snake.y >= canvas.height) snake.y = 0;

  snake.cells.unshift({x: snake.x, y: snake.y});
  if (snake.cells.length > snake.maxCells) snake.cells.pop();

  context.fillStyle = 'red';
  context.fillRect(apple.x, apple.y, grid-1, grid-1);

  context.fillStyle = 'green';
  snake.cells.forEach(function(cell, index) {
    context.fillRect(cell.x, cell.y, grid-1, grid-1);
    if (cell.x === apple.x && cell.y === apple.y) {
      snake.maxCells++;
      apple.x = getRandomInt(0, 25) * grid;
      apple.y = getRandomInt(0, 25) * grid;
    }
    for (var i = index + 1; i < snake.cells.length; i++) {
      if (cell.x === snake.cells[i].x && cell.y === snake.cells[i].y) {
        snake.x = 160; snake.y = 160; snake.cells = []; snake.maxCells = 4; snake.dx = grid; snake.dy = 0;
        apple.x = getRandomInt(0, 25) * grid;
        apple.y = getRandomInt(0, 25) * grid;
      }
    }
  });
}

document.addEventListener('keydown', function(e) {
  if (e.which === 37 && snake.dx === 0) { snake.dx = -grid; snake.dy = 0; }
  else if (e.which === 38 && snake.dy === 0) { snake.dy = -grid; snake.dx = 0; }
  else if (e.which === 39 && snake.dx === 0) { snake.dx = grid; snake.dy = 0; }
  else if (e.which === 40 && snake.dy === 0) { snake.dy = grid; snake.dx = 0; }
});
requestAnimationFrame(loop);
</script>
</body>
</html>
    ]])
end

function SOCIAL:BuildCoolMathSolitaire()
    self.container:Clear()
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    html:SetHTML([[
<!DOCTYPE html>
<html>
<head>
<style>
    body { background: #008000; font-family: sans-serif; height: 100vh; margin: 0; overflow: hidden; display: flex; flex-direction: column; align-items: center; justify-content: center; color: white; }
    h1 { margin-top: 0; }
    .msg { font-size: 20px; }
</style>
</head>
<body>
    <h1>SOLITAIRE</h1>
    <div class="msg">Currently undergoing maintenance by the digital janitor.</div>
    <div class="msg">Use a real deck of cards for now.</div>
    <div style="font-size: 100px; margin-top: 50px;">ðŸƒ</div>
</body>
</html>
    ]])
end

function SOCIAL:BuildCoolMathBalatro()
    print("[BALATRO LUA] BuildCoolMathBalatro called!")
    self.container:Clear()
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    html:AddFunction("CYR", "playSound", function(snd) surface.PlaySound(snd) end)
    html:AddFunction("CYR", "saveGame", function(json)
        print("[BALATRO LUA] saveGame called with " .. #tostring(json) .. " bytes")
        file.Write("balatro_save.txt", json)
    end)

    html:AddFunction("CYR", "loadGame", function()
        print("[BALATRO LUA] loadGame called")
        local data = file.Read("balatro_save.txt", "DATA")
        if data then
            print("[BALATRO LUA] Found save data: " .. #data .. " bytes. Calling loadData...")
            -- Escape data for JS string
            local escaped = data:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\n", "\\n")
            timer.Simple(0.5, function() if IsValid(html) then html:RunJavascript("console.log('Lua invokes loadData'); window.loadData(\"" .. escaped .. "\");") end end)
        else
            print("[BALATRO LUA] No save data found. Calling initNewRun...")
            timer.Simple(0.5, function() if IsValid(html) then html:RunJavascript("console.log('Lua invokes initNewRun'); if(window.initNewRun) { window.initNewRun(); } else { console.log('initNewRun not found on window'); }") end end)
        end
    end)

    html:AddFunction("CYR", "log", function(msg) print("[BALATRO JS] " .. tostring(msg)) end)
    html:SetHTML([=[
<!DOCTYPE html>
<html>
<head>
    <script>
        // Bridge console.log to CYR.log for debugging
        window.console = {
            log: function(msg) { if(window.CYR && window.CYR.log) CYR.log(msg); },
            error: function(msg) { if(window.CYR && window.CYR.log) CYR.log("ERROR: " + msg); }
        };
        window.onerror = function(msg, url, line) {
            console.error(msg + " @ " + line);
        };
        
        // Wait for bridge
        var bridgeAttempts = 0;
        var bridgeCheck = setInterval(function() {
            bridgeAttempts++;
            if(window.CYR && window.CYR.log) {
                CYR.log("JS Bridge connected after " + bridgeAttempts + " checks!");
                clearInterval(bridgeCheck);
            }
        }, 100);
    </script>
<style>
    /* LAYOUT & SIDEBAR */
    body { display: flex; flex-direction: row; align-items: stretch; background: #1a1a1a; color: white; height: 100vh; margin: 0; font-family: 'Courier New', monospace; user-select: none; overflow: hidden; }
    canvas { position: absolute; top:0; left:0; width:100%; height:100%; z-index: -1; }

    .sidebar {
        width: 25%;
        min-width: 280px;
        max-width: 350px;
        background: #2a2a2a;
        display: flex; flex-direction: column;
        padding: 15px;
        box-shadow: 5px 0 15px rgba(0,0,0,0.5);
        z-index: 10;
        gap: 15px;
        overflow-y: auto;
    }
    
    .game-area {
        flex: 1;
        position: relative;
        display: flex; flex-direction: column;
        align-items: center;
        justify-content: space-between;
        padding: 2vh;
    }
    
    /* SIDEBAR PANELS */
    .panel { background: #333; border-radius: 10px; padding: 10px; width: 100%; box-sizing: border-box; display:flex; flex-direction:column; align-items:center; }
    
    .blind-panel { background: #e69138; padding: 0; overflow: hidden; border: 2px solid #333; }
    .blind-header-bar { background: #e69138; width: 100%; text-align: center; font-weight: bold; color: white; padding: 5px; font-size: 24px; text-shadow: 2px 2px 0 #a44; }
    .blind-body { background: #222; width: 100%; padding: 15px; display: flex; align-items: center; justify-content: space-between; gap: 10px; }
    .blind-icon-circle { width: 70px; height: 70px; background: #e69138; border-radius: 50%; display: flex; align-items: center; justify-content: center; text-align: center; font-size: 14px; font-weight: bold; color: #333; border: 3px solid #b45f06; box-shadow: inset 0 0 10px rgba(0,0,0,0.5); }
    
    .score-panel { margin-top: 5px; }
    .score-label { color: #aaa; text-transform: uppercase; font-size: 14px; margin-bottom: 5px; }
    .score-val { font-size: 32px; color: white; text-shadow: 2px 2px 0 black; font-weight: bold; }
    
    .hand-calc-panel { background: #222; border: 2px solid #444; margin-top: 10px; padding: 15px; }
    .hand-name-label { color: white; font-size: 22px; margin-bottom: 10px; font-weight: bold; }
    .calc-row { display: flex; align-items: center; gap: 5px; background: #111; padding: 10px; border-radius: 8px; }
    .calc-box { padding: 5px 15px; border-radius: 5px; font-size: 28px; font-weight: bold; color: white; min-width: 60px; text-align: center; }
    .calc-blue { background: #0099ff; border-bottom: 4px solid #0066aa; }
    .calc-red { background: #ff4444; border-bottom: 4px solid #aa2222; }
    .calc-x { color: #ff4444; font-size: 24px; font-weight: bold; }
    
    /* STATS GRID */
    .stats-grid { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 8px; width: 100%; margin-top: auto; }
    .stat-btn { grid-column: 1; height: 60px; border-radius: 8px; font-weight: bold; color: white; font-size: 18px; cursor: pointer; border: none; }
    .btn-red { background: #ff4444; border-bottom: 4px solid #aa2222; }
    .btn-orange { background: #ff9900; border-bottom: 4px solid #cc7700; }
    
    .stat-box { background: #333; border-radius: 8px; display: flex; flex-direction: column; align-items: center; justify-content: center; height: 60px; border-bottom: 4px solid #222; }
    .stat-label { color: #aaa; font-size: 12px; font-weight: bold; }
    .stat-val { font-size: 24px; font-weight: bold; }
    .val-blue { color: #0099ff; }
    .val-red { color: #ff4444; }
    .val-yellow { color: #feea00; }
    .val-orange { color: #ff9900; }
    
    .stat-money { grid-column: 2 / span 2; display: flex; flex-direction: column; align-items: center; justify-content: center; font-size: 32px; color: #feea00; background: #333; border-radius: 8px; border-bottom: 4px solid #222; font-weight: bold; text-shadow: 2px 2px 0 black; }

    /* CARD SPRITES */
    .card { 
        width: 13.5vh; height: 18vh;
        background-color: white; 
        background-image: url('https://i.ibb.co/8DJxx6d4/i-there-somewhere-i-could-find-the-hd-version-of-ballatros-v0-rxm6i717eauc1.webp');
        background-size: 1300% 400%;
        background-repeat: no-repeat;
        border-radius: 5px; 
        box-shadow: 2px 2px 5px rgba(0,0,0,0.5);
        cursor: pointer; 
        transition: transform 0.2s, filter 0.2s;
        position: relative; 
        -webkit-user-drag: element;
    }
    .card:hover { transform: translateY(-15px); z-index: 10; }
    .card.selected { transform: translateY(-30px); box-shadow: 0 0 15px #ffcc00; z-index: 10; filter: brightness(1.2); }
    .card.scoring { animation: popActive 0.3s forwards; border: 2px solid #fff; }
    .card.unused { filter: grayscale(1) opacity(0.5); }
    .card.discarding { animation: throwAway 0.5s forwards; }
    
    @keyframes popActive { 0%{transform:scale(1);} 50%{transform:scale(1.3);} 100%{transform:scale(1);} }
    @keyframes throwAway { 100% { transform: translateY(200px) rotate(20deg); opacity: 0; } }
    @keyframes shake { 0% { transform: translate(1px, 1px) rotate(0deg); } 10% { transform: translate(-1px, -2px) rotate(-1deg); } 20% { transform: translate(-3px, 0px) rotate(1deg); } 30% { transform: translate(3px, 2px) rotate(0deg); } 40% { transform: translate(1px, -1px) rotate(1deg); } 50% { transform: translate(-1px, 2px) rotate(-1deg); } 60% { transform: translate(-3px, 1px) rotate(0deg); } 70% { transform: translate(3px, 1px) rotate(-1deg); } 80% { transform: translate(-1px, -1px) rotate(1deg); } 90% { transform: translate(1px, 2px) rotate(0deg); } 100% { transform: translate(1px, -2px) rotate(-1deg); } }
    .shaking { animation: shake 0.5s; color: #ffeb3b !important; }
    
    .joker-area { width: 100%; display: flex; justify-content: center; gap: 10px; margin-top: 20px; z-index:5; }
    .joker-card { width: 80px; height: 110px; background: #222; border: 2px solid #a8f; border-radius: 8px; display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; padding: 5px; cursor: pointer; transition: transform 0.2s; position: relative; box-shadow: 0 0 10px rgba(0,0,0,0.5); }
    .joker-card:hover { transform: translateY(-5px) scale(1.05); z-index: 10; }
    .joker-sell-btn { position: absolute; bottom: -25px; background: #f44; color: white; border: none; padding: 3px 8px; border-radius: 4px; font-size: 11px; cursor: pointer; display: none; z-index: 20; }
    .joker-card.selling .joker-sell-btn { display: block; }
    
    .rarity-1 { border-color: #888; background: #333; } /* Common */
    .rarity-2 { border-color: #0099ff; background: #001f33; } /* Uncommon */
    .rarity-3 { border-color: #ff4444; background: #330000; } /* Rare */
    .rarity-4 { border-color: #fcee0a; background: #333300; } /* Legendary */
    .joker-trigger { animation: popActive 0.3s forwards; box-shadow: 0 0 20px #fff; }
    
    /* DECK & ANIMATIONS */
    .deck-area { 
        position: absolute; bottom: 30px; right: 30px; left: auto;
        width: 80px; height: 110px; 
        cursor: pointer; z-index: 5;
    }
    .deck-pile {
        width: 13.5vh; height: 18vh;
        background: url('https://files.catbox.moe/bbnih3.png');
        background-position: 16.66% 100%;
        background-size: 1300% 400%;
        background-color: #f55;
        border-radius: 5px;
        border: 2px solid white;
        box-shadow: 2px 2px 0 #a00, 4px 4px 0 #a00, 6px 6px 5px rgba(0,0,0,0.5);
        transition: transform 0.1s;
    }
    .deck-pile:hover { transform: translateY(-2px); }
    .deck-count {
        position: absolute; bottom: -25px; left: 0; width: 100%; text-align: center;
        color: white; font-weight: bold; background: rgba(0,0,0,0.5); border-radius: 4px; padding: 2px;
    }
    
    .flyer {
        position: fixed; width: 71px; height: 95px;
        background-color: white; 
        background-image: url('https://i.ibb.co/8DJxx6d4/i-there-somewhere-i-could-find-the-hd-version-of-ballatros-v0-rxm6i717eauc1.webp');
        background-size: 923px 380px;
        border-radius: 5px;
        z-index: 20;
        transition: all 0.4s ease-out;
        box-shadow: 0 10px 20px rgba(0,0,0,0.5);
    }
    
    /* MODAL DECK VIEW */
    .deck-grid {
        display: grid; grid-template-columns: repeat(13, 1fr); gap: 5px;
        max-width: 1000px; background: #222; padding: 20px; border-radius: 10px; border: 2px solid #555;
    }
    .mini-card {
        width: 4.5vh; height: 6vh;
        background-image: url('https://i.ibb.co/8DJxx6d4/i-there-somewhere-i-could-find-the-hd-version-of-ballatros-v0-rxm6i717eauc1.webp');
        background-size: 1300% 400%;
        border-radius: 3px;
    }

    /* SORT CONTROLS */
    .sort-bar {
        position: absolute; top: -40px; width: 100%; display: flex; justify-content: center; gap: 10px; pointer-events: auto;
    }
    .sort-btn {
        background: #333; color: white; border: 1px solid #555; padding: 5px 15px;
        font-family: inherit; font-size: 14px; cursor: pointer; border-radius: 4px;
    }
    .sort-btn:hover { background: #555; }
    
    .hand-area { width: 100%; display: flex; justify-content: center; gap: 10px; align-items: flex-end; height: 160px; margin-bottom: 20px; margin-top: auto; position: relative; }
    .controls { display: flex; gap: 20px; z-index:5; } /* Reused only for style basics */

    .screen-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.9); z-index: 50; display: none; flex-direction: column; align-items: center; justify-content: center; }
    .action-panel {
        position: absolute;
        right: 20px;
        bottom: 250px; /* Above Deck */
        display: flex; flex-direction: column;
        gap: 15px;
        z-index: 10;
    }
    .action-btn {
        width: 180px;
        padding: 15px 0;
        font-family: 'Courier New', monospace;
        font-size: 24px;
        font-weight: bold;
        color: white;
        text-shadow: 2px 2px 0 rgba(0,0,0,0.5);
        border: none;
        cursor: pointer;
        transition: transform 0.1s, filter 0.1s;
        text-transform: uppercase;
        position: relative;
    }
    .action-btn:active { transform: translateY(4px); box-shadow: 0 0 0 transparent !important; }
    .action-btn:hover { filter: brightness(1.2); }
    
    .btn-play {
        background: #0099ff;
        box-shadow: 0 6px 0 #0066aa, 0 10px 10px rgba(0,0,0,0.3);
        border-radius: 8px;
    }
    .btn-discard {
        background: #ff4444;
        box-shadow: 0 6px 0 #aa2222, 0 10px 10px rgba(0,0,0,0.3);
        border-radius: 8px;
    }

    /* Dragging Visuals */
    .card.dragging { opacity: 0.4; }

    /* GAME SCREENS (Blind, Shop, Pack) */
    .game-screen {
        position: absolute;
        top: 25vh; /* Leave room for Jokers */
        left: 0;
        width: 100%;
        bottom: 0;
        z-index: 20;
        display: none;
        flex-direction: column;
        align-items: center;
        justify-content: flex-start;
        padding-top: 20px;
        /* background: rgba(0,0,0,0.5);  Optional: darker background for contrast */
    }
    
    .screen-overlay { 
        position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
        background: rgba(0,0,0,0.9); z-index: 50; 
        display: none; flex-direction: column; align-items: center; justify-content: center; 
    }
    .shop-main-panel {
        background: #333;
        border: 4px solid #555;
        border-radius: 15px;
        padding: 20px;
        display: grid;
        grid-template-columns: 220px 1fr;
        gap: 20px;
        box-shadow: 0 0 30px rgba(0,0,0,0.8);
    }
    .shop-col-buttons { display: flex; flex-direction: column; gap: 15px; }
    .shop-col-items { display: flex; flex-direction: column; gap: 20px; background: #222; padding: 20px; border-radius: 10px; border: 2px solid #444; }
    
    .shop-section-row { display: flex; gap: 20px; min-height: 200px; align-items: center; }
    
    .shop-btn {
        width: 100%; height: 120px;
        border: none; border-radius: 8px;
        color: white; font-family: inherit; font-size: 28px; font-weight: bold;
        text-transform: uppercase; cursor: pointer;
        text-shadow: 2px 2px 0 rgba(0,0,0,0.5);
        transition: transform 0.1s;
    }
    .shop-btn:active { transform: translateY(4px); box-shadow: none !important; }
    
    .btn-next { background: #ff4444; box-shadow: 0 8px 0 #aa2222; }
    .btn-reroll { background: #5c5; box-shadow: 0 8px 0 #383; }
    
    .shop-slot { position: relative; width: 140px; height: 190px; border: 2px dashed #444; border-radius: 10px; display: flex; justify-content: center; align-items: center; }
    .shop-slot-wide { position: relative; width: 180px; height: 190px; border: 2px dashed #444; border-radius: 10px; display: flex; justify-content: center; align-items: center; }
    
    .shop-item {
        width: 100%; height: 100%;
        background: #333; border: 2px solid white;
        border-radius: 8px;
        display: flex; flex-direction: column; align-items: center; justify-content: space-between;
        padding: 10px; box-sizing: border-box;
        cursor: pointer;
        transition: transform 0.2s;
        box-shadow: 0 5px 15px rgba(0,0,0,0.5);
    }
    .shop-item:hover { transform: translateY(-10px) scale(1.05); z-index: 10; border-color: #fea; }
    
    .price-tag {
        position: absolute; top: -15px; right: -5px;
        background: #fea; color: #333;
        font-weight: bold; font-size: 20px;
        padding: 2px 10px; border-radius: 10px;
        border: 2px solid white;
        box-shadow: 2px 2px 0 rgba(0,0,0,0.5);
        z-index: 20;
    }
    
    .shop-info-panel { background: #222; border-radius: 8px; padding: 10px; text-align: center; border: 2px solid #444; margin-top: auto; }
</style>
<script id="fs" type="x-shader/x-fragment">
    precision mediump float;
    uniform float u_time;
    uniform vec2 u_resolution;
    uniform vec4 u_c1; uniform vec4 u_c2;
    
    #define PIXEL_SIZE_FAC 700.
    #define BLACK vec4(0.18, 0.23, 0.24, 1.0)
    
    vec4 easing(vec4 t, float power) { return vec4(pow(t.x, power), pow(t.y, power), pow(t.z, power), pow(t.w, power)); }
    void main() {
        vec2 uv = gl_FragCoord.xy / u_resolution.xy;
        uv -= 0.5; uv.x *= u_resolution.x / u_resolution.y;
        vec2 orig_uv = uv;
        
        uv = floor(uv * (PIXEL_SIZE_FAC/2.)) / (PIXEL_SIZE_FAC/2.);
        float uv_len = length(uv);
        float speed = u_time * 1.0;
        float new_angle = atan(uv.y, uv.x) + (2.2 + 0.4*min(6.,speed))*uv_len - 1. - speed*0.05;
        vec2 mid = vec2(0.0);
        vec2 sv = vec2((uv_len * cos(new_angle) + mid.x), (uv_len * sin(new_angle) + mid.y)) - mid;
        sv *= 30.;
        vec2 uv2 = vec2(sv.x+sv.y);
        for(int i=0; i<5; i++) {
            uv2 += sin(max(sv.x, sv.y)) + sv;
            sv += 0.5*vec2(cos(5.1 + 0.353*uv2.y + speed*0.13), sin(uv2.x - 0.113*speed));
            sv -= 1.0*cos(sv.x + sv.y) - 1.0*sin(sv.x*0.711 - sv.y);
        }
        float smoke = min(2., max(-2., 1.5 + length(sv)*0.12 - 0.17*(min(10.,u_time*1.2))));
        if (smoke < 0.2) smoke = (smoke - 0.2)*0.6 + 0.2;
        float c1p = max(0.,1. - 2.*abs(1.-smoke));
        float c2p = max(0.,1. - 2.*smoke);
        float cb = 1. - min(1., c1p + c2p);
        vec4 col = u_c1*c1p + u_c2*c2p + vec4(cb*BLACK.rgb, 1.0);
        gl_FragColor = easing(col, 1.5);
    }
</script>
</head>
<body>
    <canvas id="bg-canvas"></canvas>
    
    <div class="sidebar">
        <!-- BLIND INFO -->
        <div class="panel blind-panel">
            <div class="blind-header-bar" id="blind-name">Small Blind</div>
            <div class="blind-body">
                <div class="blind-icon-circle">SCORE<br>AT LEAST</div>
                <div style="text-align: right;">
                    <div style="color:#aaa; font-size:12px;">Score at least</div>
                    <div style="font-size:32px; color:#ff4444; font-weight:bold; text-shadow:2px 2px 0 black;" id="blind-goal">300</div>
                    <div style="color:#aaa; font-size:12px;">to earn <span style="color:#feea00; font-weight:bold;">$$$</span></div>
                </div>
            </div>
        </div>
        
        <!-- ROUND SCORE -->
        <div class="panel score-panel">
            <div class="score-label">Round Score</div>
            <div class="score-val" id="round-score">0</div>
        </div>
        
        <!-- HAND PREVIEW -->
        <div class="panel hand-calc-panel" id="score-preview">
            <div class="hand-name-label" id="hand-name-display">High Card</div>
            <div class="calc-row">
                <div class="calc-box calc-blue" id="prev-chips">10</div>
                <div class="calc-x">X</div>
                <div class="calc-box calc-red" id="prev-mult">2</div>
            </div>
        </div>
        
        <!-- STATS GRID -->
        <div class="stats-grid">
            <button class="stat-btn btn-red">Run<br>Info</button>
            <div class="stat-box"><div class="stat-label">Hands</div><div class="stat-val val-blue" id="hands-left">4</div></div>
            <div class="stat-box"><div class="stat-label">Discards</div><div class="stat-val val-red" id="discards-left">3</div></div>
            
            <button class="stat-btn btn-orange">Options</button>
            <div class="stat-money">$<span id="money">4</span></div>
            
            <div class="stat-box" style="background:none;"><div class="stat-btn btn-orange" style="margin:0; width:100%; height:100%; font-size:12px; display:flex; flex-direction:column; justify-content:center; align-items:center;"></div></div>
             <div class="stat-box"><div class="stat-label">Ante</div><div class="stat-val val-orange"><span id="ante">1</span>/8</div></div>
            <div class="stat-box"><div class="stat-label">Round</div><div class="stat-val val-orange" id="round-num">1</div></div>
        </div>
    </div>
    
    <div class="game-area">
        <div class="joker-area" id="joker-area"></div>
        
        <!-- PLAY CONTROLS CONTAINER -->
        <div id="play-controls" style="display:flex; flex-direction:column; width:100%; flex:1; align-items:center;">
            <div style="flex:1; width:100%; display:flex; align-items:center; justify-content:center; border: 2px dashed rgba(255,255,255,0.05); border-radius:10px; margin: 20px 0;">
                <!-- Played cards area spacer -->
            </div>

            <div class="sort-bar" style="position:relative; top:0; margin-bottom:10px; width:auto; gap:10px;">
                <button class="sort-btn" onclick="sortHand('rank')">Sort Rank</button>
                <button class="sort-btn" onclick="sortHand('suit')">Sort Suit</button>
            </div>

            <div class="hand-area" id="hand-area">
                <!-- Cards injected here -->
            </div>
            
            <div class="action-panel">
                <button class="action-btn btn-play" onclick="playHand()">PLAY HAND</button>
                <div style="height:10px"></div>
                <button class="action-btn btn-discard" onclick="discardHand()">DISCARD</button>
            </div>
        </div>
        
        <!-- DECK AREA (Bottom Right) -->
        <div class="deck-area" onclick="showDeckView()">
            <div class="deck-pile" id="deck-pile"></div>
            <div class="deck-count" style="right:0; left:auto;"><span id="deck-count">52</span>/52</div>
        </div>

        <!-- IN-GAME SCREENS -->
        <div class="game-screen" id="screen-blind" style="display:flex;">
             <!-- Blind content injected here -->
             <div class="blind-container" id="blind-container" style="display:flex; gap:20px"></div>
        </div>

        <div class="game-screen" id="screen-shop" style="display:none; align-items: center;">
            <div style="width: 95%; max-width:1000px;">
                <!-- Header moved to Sidebar update or managed visually -->
                <div class="shop-main-panel">
                    <!-- COLUMN 1: BUTTONS -->
                    <div class="shop-col-buttons">
                        <button class="shop-btn btn-next" onclick="finishShop()">Next<br>Round</button>
                        <button class="shop-btn btn-reroll" onclick="rerollShop()">Reroll<br><span style="font-size:32px">$5</span></button>
                        <div class="shop-info-panel">
                             <div style="color:#aaa; font-size:12px;">REROLL PRICE</div>
                             <div style="color:white; font-size:24px; font-weight:bold;">$5</div>
                        </div>
                    </div>

                    <!-- COLUMN 2: ITEMS -->
                    <div class="shop-col-items">
                        <!-- ROW 1: JOKERS -->
                        <div class="shop-section-row">
                            <div class="shop-slot" id="shop-joker-1"></div>
                            <div class="shop-slot" id="shop-joker-2"></div>
                        </div>
                        <!-- ROW 2: VOUCHER & PACKS -->
                        <div class="shop-section-row">
                            <div class="shop-slot-wide" id="shop-voucher"></div>
                            <div class="shop-slot" id="shop-pack-1"></div>
                            <div class="shop-slot" id="shop-pack-2"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="game-screen" id="screen-pack" style="display:none;">
            <h1 style="margin-top:0;">CHOOSE ONE</h1>
            <div class="pack-view" id="pack-content"></div>
            <button style="margin-top:20px" onclick="closePack()">SKIP</button>
        </div>
        
        <!-- Screen Deck Overlay (Global) -->
        <div class="screen-overlay" id="screen-deck" style="display:none;" onclick="if(event.target===this) this.style.display='none'">
            <div style="text-align:center;">
                 <h1 style="color:white; margin-bottom:10px;">REMAINING CARDS</h1>
                 <div class="deck-grid" id="deck-grid-content"></div>
                 <button style="margin-top:20px; padding:10px 30px;" onclick="document.getElementById('screen-deck').style.display='none'">CLOSE</button>
            </div>
        </div>

    </div>

    <audio id="bgm" loop><source src="https://lambda.vgmtreasurechest.com/soundtracks/balatro-2024/bkwegtxh/01.%20Main%20Theme.mp3" type="audio/mpeg"></audio>
    <audio id="bgm-tarot" loop><source src="https://lambda.vgmtreasurechest.com/soundtracks/balatro-2024/fqoyyxql/03.%20Tarot%20Pack%20Theme.mp3" type="audio/mpeg"></audio>

<script>
    // --- SHADER SYSTEM ---
    // --- SHADER SYSTEM ---
    const canvas = document.getElementById('bg-canvas');
    let gl = canvas.getContext('webgl') || canvas.getContext('experimental-webgl');
    let ctx2d = null;
    let pid = null;
    let uTime, uRes, uC1, uC2;
    
    function showError(msg) {
        let err = document.createElement('div');
        err.style.color = 'red'; err.style.position = 'fixed'; err.style.top = '10px'; err.style.left = '10px';
        err.style.background = 'rgba(0,0,0,0.8)'; err.style.padding = '10px'; err.style.zIndex='1000';
        err.innerText = "Shader Error: " + msg;
        document.body.appendChild(err);
    }

    if(!gl) {
        // FALLBACK: CANVAS 2D
        ctx2d = canvas.getContext('2d');
    } else {
        try {
            pid = gl.createProgram();
            const shaderSource = document.getElementById('fs').text;
            const vs = gl.createShader(gl.VERTEX_SHADER);
            const fs = gl.createShader(gl.FRAGMENT_SHADER);
            
            gl.shaderSource(vs, 'attribute vec4 pos; void main() { gl_Position = pos; }');
            gl.shaderSource(fs, shaderSource);
            
            gl.compileShader(vs);
            if(!gl.getShaderParameter(vs, gl.COMPILE_STATUS)) throw "VS: " + gl.getShaderInfoLog(vs);
            
            gl.compileShader(fs);
            if(!gl.getShaderParameter(fs, gl.COMPILE_STATUS)) throw "FS: " + gl.getShaderInfoLog(fs);
            
            gl.attachShader(pid, vs); gl.attachShader(pid, fs);
            gl.linkProgram(pid);
            if(!gl.getProgramParameter(pid, gl.LINK_STATUS)) throw "Link: " + gl.getProgramInfoLog(pid);
            
            gl.useProgram(pid);
            
            const buf = gl.createBuffer();
            gl.bindBuffer(gl.ARRAY_BUFFER, buf);
            gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1,-1,1,-1,-1,1,-1,1,1,-1,1,1]), gl.STATIC_DRAW);
            const posLoc = gl.getAttribLocation(pid, 'pos');
            gl.enableVertexAttribArray(posLoc);
            gl.vertexAttribPointer(posLoc, 2, gl.FLOAT, false, 0, 0);

            uTime = gl.getUniformLocation(pid, "u_time");
            uRes = gl.getUniformLocation(pid, "u_resolution");
            uC1 = gl.getUniformLocation(pid, "u_c1");
            uC2 = gl.getUniformLocation(pid, "u_c2");
            
        } catch(e) {
            showError(e);
            gl = null;
            ctx2d = canvas.getContext('2d');
        }
    }
    
    let colorMode = 0; // 0=Base, 1=Shop, 2=Boss
    let c1_target = [0.2, 0.4, 0.8, 1.0];
    let c2_target = [0.0, 0.1, 0.3, 1.0];
    let c1_curr = [...c1_target], c2_curr = [...c2_target];
    
    function updateShaderMode() {
        if(colorMode === 0) { c1_target=[0.2,0.4,0.8,1]; c2_target=[0.0,0.1,0.3,1]; } // Base Blue
        if(colorMode === 1) { c1_target=[0.8,0.5,0.2,1]; c2_target=[0.3,0.2,0.0,1]; } // Shop Gold
        if(colorMode === 2) { c1_target=[0.8,0.2,0.2,1]; c2_target=[0.3,0.0,0.0,1]; } // Boss Red
    }
    
    function lerp(a,b,t) { return a + (b-a)*t; }
    
    function render(time) {
        // Update Colors
        for(let i=0; i<4; i++) {
            c1_curr[i] = lerp(c1_curr[i], c1_target[i], 0.05);
            c2_curr[i] = lerp(c2_curr[i], c2_target[i], 0.05);
        }

        if(gl) {
            canvas.width = window.innerWidth; canvas.height = window.innerHeight;
            gl.viewport(0, 0, canvas.width, canvas.height);
            gl.uniform1f(uTime, time * 0.001);
            gl.uniform2f(uRes, canvas.width, canvas.height);
            gl.uniform4fv(uC1, c1_curr);
            gl.uniform4fv(uC2, c2_curr);
            gl.drawArrays(gl.TRIANGLES, 0, 6);
        } else if(ctx2d) {
            // SOFTWARE RENDERER (Ported GLSL logic)
            // Render at low res for performance, scale up via CSS
            const W = 160; 
            const H = 90;
            if(canvas.width !== W) { 
                canvas.width = W; canvas.height = H; 
                canvas.style.imageRendering = "pixelated";
            }
            
            const imgData = ctx2d.getImageData(0, 0, W, H);
            const data = imgData.data;
            const t = time * 0.001; 
            const speed = t * 1.0;
            
            // Pre-calculate constants for the frame
            const aspect = W / H;
            const BLACK = [46, 59, 61]; // 0.18, 0.23, 0.24 * 255
            
            let idx = 0;
            for(let y = 0; y < H; y++) {
                // Normalized Y approx (-0.5 to 0.5)
                const vy = (y / H) - 0.5;
                
                for(let x = 0; x < W; x++) {
                    // Normalized X approx (-0.5 to 0.5), corrected for aspect
                    const vx = ((x / W) - 0.5) * aspect;
                    
                    // --- SHADER LOGIC PORT ---
                    // uv = floor(uv * (PIXEL_SIZE_FAC/2.)) / (PIXEL_SIZE_FAC/2.); 
                    // (Skipped floor calc since we are already low-res pixelated)
                    
                    const len = Math.sqrt(vx*vx + vy*vy);
                    const angle = Math.atan2(vy, vx) + (2.2 + 0.4 * Math.min(6.0, speed)) * len - 1.0 - speed * 0.05;
                    
                    // vec2 sv = vec2((uv_len * cos(new_angle)), (uv_len * sin(new_angle))) * 30.0;
                    let svx = len * Math.cos(angle) * 30.0;
                    let svy = len * Math.sin(angle) * 30.0;
                    
                    let uv2x = svx + svy;
                    let uv2y = svx + svy; // vec2 uv2 = vec2(sv.x+sv.y) implicit
                    
                    // Loop unrolled 5 times
                    for(let i=0; i<5; i++) {
                        // uv2 += sin(max(sv.x, sv.y)) + sv;
                        const maxSv = (svx > svy) ? svx : svy;
                        const sinMax = Math.sin(maxSv);
                        uv2x += sinMax + svx;
                        uv2y += sinMax + svy;
                        
                        // sv += 0.5*vec2(cos(5.1 + 0.353*uv2.y + speed*0.13), sin(uv2.x - 0.113*speed));
                        svx += 0.5 * Math.cos(5.1 + 0.353 * uv2y + speed * 0.13);
                        svy += 0.5 * Math.sin(uv2x - 0.113 * speed);
                        
                        // sv -= 1.0*cos(sv.x + sv.y) - 1.0*sin(sv.x*0.711 - sv.y);
                        const subTerm = 1.0 * Math.cos(svx + svy) - 1.0 * Math.sin(svx * 0.711 - svy);
                        svx -= subTerm;
                        svy -= subTerm;
                    }
                    
                    // float smoke = min(2., max(-2., 1.5 + length(sv)*0.12 - 0.17*(min(10.,u_time*1.2))));
                    var lenSv = Math.sqrt(svx*svx + svy*svy);
                    var smoke = 1.5 + lenSv * 0.12 - 0.17 * Math.min(10.0, t * 1.2);
                    if(smoke > 2.0) smoke = 2.0;
                    if(smoke < -2.0) smoke = -2.0;
                    
                    if(smoke < 0.2) smoke = (smoke - 0.2) * 0.6 + 0.2;
                    
                    var c1p = 1.0 - 2.0 * Math.abs(1.0 - smoke);
                    if(c1p < 0) c1p = 0;
                    
                    var c2p = 1.0 - 2.0 * smoke;
                    if(c2p < 0) c2p = 0;
                    
                    var sumP = c1p + c2p;
                    if(sumP > 1.0) sumP = 1.0;
                    var cb = 1.0 - sumP;
                    
                    var r = c1_curr[0]*c1p + c2_curr[0]*c2p + (BLACK[0]/255.0)*cb;
                    r = Math.pow(r, 1.5) * 255;
                    
                    var g = c1_curr[1]*c1p + c2_curr[1]*c2p + (BLACK[1]/255.0)*cb;
                    g = Math.pow(g, 1.5) * 255;
                    
                    var b = c1_curr[2]*c1p + c2_curr[2]*c2p + (BLACK[2]/255.0)*cb;
                    b = Math.pow(b, 1.5) * 255;
                    
                    data[idx++] = r;
                    data[idx++] = g;
                    data[idx++] = b;
                    data[idx++] = 255; // Alpha
                }
            }
            ctx2d.putImageData(imgData, 0, 0);
        }

        requestAnimationFrame(render);
    }
    requestAnimationFrame(render);

    // --- AUDIO ---
    // --- AUDIO ---
    var bgmMain = document.getElementById('bgm');
    var bgmTarot = document.getElementById('bgm-tarot');
    bgmMain.volume = 0.4; bgmTarot.volume = 0.4;
    function playMusic(type) {
        if(type === 'main') { bgmTarot.pause(); bgmMain.play().catch(function(){}); }
        else { bgmMain.pause(); bgmTarot.currentTime = 0; bgmTarot.play().catch(function(){}); }
    }
    playMusic('main');
    function sfx(n) {
        var sounds = { score: "buttons/blip1.wav", select: "buttons/lightswitch2.wav", buy: "buttons/button15.wav", win: "buttons/bell1.wav", reroll: "buttons/lever7.wav" };
        if(sounds[n] && typeof CYR !== 'undefined') CYR.playSound(sounds[n]);
    }

    // --- DATA ---
    var suits = ['â™ ', 'â™¥', 'â™£', 'â™¦'];
    var ranks = ['2','3','4','5','6','7','8','9','10','J','Q','K','A'];
    var values = { '2':2, '3':3, '4':4, '5':5, '6':6, '7':7, '8':8, '9':9, '10':10, 'J':10, 'Q':10, 'K':10, 'A':11 };

    var deck=[], hand=[], selectedIndices=[], jokers=[], vouchers=[];
    var score=0, goal=300, handsLeft=4, discardsLeft=3, money=4, ante=1, roundType=0, currentReward=0;
    var isAnimating=false;
    
    // DBs
    var jokerDB = [
        { name: "Joker", desc: "+4 Mult", cost: 2, rarity: 1, type:'mult', val: 4, img: 'https://balatrogame.fandom.com/wiki/Special:FilePath/Joker.png' },
        { name: "Greedy Joker", desc: "+30 Chips to â™¦", cost: 5, rarity: 1, type:'suit_chip', suit:'â™¦', val: 30, img: 'https://balatrogame.fandom.com/wiki/Special:FilePath/Greedy_Joker.png' },
        { name: "Lusty Joker", desc: "+30 Chips to â™¥", cost: 5, rarity: 1, type:'suit_chip', suit:'â™¥', val: 30, img: 'https://balatrogame.fandom.com/wiki/Special:FilePath/Lusty_Joker.png' },
        { name: "Wrathful Joker", desc: "+30 Chips to â™ ", cost: 5, rarity: 1, type:'suit_chip', suit:'â™ ', val: 30, img: 'https://balatrogame.fandom.com/wiki/Special:FilePath/Wrathful_Joker.png' },
        { name: "Gluttonous Joker", desc: "+30 Chips to â™£", cost: 5, rarity: 1, type:'suit_chip', suit:'â™£', val: 30, img: 'https://balatrogame.fandom.com/wiki/Special:FilePath/Gluttonous_Joker.png' },
        { name: "Sly Joker", desc: "+50 Chips if Pair", cost: 4, rarity: 2, type:'hand_chip', hand:'Pair', val: 50, img: 'https://balatrogame.fandom.com/wiki/Special:FilePath/Sly_Joker.png' },
        { name: "Crazy Joker", desc: "+12 Mult if Straight", cost: 6, rarity: 2, type:'hand_mult', hand:'Straight', val: 12, img: 'https://balatrogame.fandom.com/wiki/Special:FilePath/Crazy_Joker.png' },
        { name: "Droll Joker", desc: "+10 Mult if Flush", cost: 6, rarity: 2, type:'hand_mult', hand:'Flush', val: 10, img: 'https://balatrogame.fandom.com/wiki/Special:FilePath/Droll_Joker.png' },
        { name: "Big Joker", desc: "+25 Chips", cost: 4, rarity: 1, type:'chip', val: 25, img: 'https://balatrogame.fandom.com/wiki/Special:FilePath/Big_Joker.png' },
        { name: "Abstract Joker", desc: "+3 Mult per Joker", cost: 6, rarity: 3, type:'meta_mult', val: 3, img: 'https://balatrogame.fandom.com/wiki/Special:FilePath/Abstract_Joker.png' },
    ];
    
    var voucherDB = [
        { name: "Overstock", desc: "+1 Shop Slot", cost: 10, id: 'overstock' },
        { name: "Clearance", desc: "25% Off Shop", cost: 10, id: 'clearance' },
        { name: "Hone", desc: "Foils appear 2x", cost: 10, id: 'hone' },
        { name: "Wasteful", desc: "+1 Discard", cost: 10, id: 'wasteful' },
        { name: "Grabber", desc: "+1 Hand", cost: 10, id: 'grabber' },
    ];

    function getJokerEffect(j, stats, cards, handType) {
        if(j.type === 'mult') { stats.mult += j.val; return true; }
        if(j.type === 'chip') { stats.chips += j.val; return true; }
        if(j.type === 'suit_chip') { if(cards.some(function(x){ return x.suit===j.suit; })) { stats.chips += j.val * cards.filter(function(x){ return x.suit===j.suit; }).length; return true;} }
        if(j.type === 'hand_chip' && handType.name.includes(j.hand)) { stats.chips += j.val; return true; }
        if(j.type === 'hand_mult' && handType.name.includes(j.hand)) { stats.mult += j.val; return true; }
        if(j.type === 'meta_mult') { stats.mult += (j.val * jokers.length); return true; }
        return false;
    }

    // --- CORE LOGIC ---
    function initGame() { 
        console.log("initGame called");
        
        // Expose to window for Lua Call
        window.initNewRun = initNewRun;
        window.loadData = loadData;
        window.saveAll = saveAll;
        window.showBlindSelect = showBlindSelect;

        // Try load
        if(typeof CYR !== 'undefined' && CYR.loadGame) CYR.loadGame();
        else { console.log("CYR.loadGame missing, local init"); initNewRun(); }
    }
    
    function initNewRun() {
        console.log("initNewRun called");
        money = 4;
        ante = 1; roundType = 0;
        jokers = []; vouchers = [];
        initDeck(); 
        showBlindSelect();
    }
    
    function loadData(jsonStr) {
        console.log("loadData called");
        try {
            if(!jsonStr) { console.log("No Save Data - Calling initNewRun"); initNewRun(); return; }
            let data = JSON.parse(jsonStr);
            if(!data) { console.log("Parsed Data Empty - Calling initNewRun"); initNewRun(); return; }
            
            console.log("Found Save Data: Ante " + data.ante + ", Shop: " + data.inShop);
            
            if(confirm("Found saved run (Ante " + data.ante + "). Continue?")) {
                money = data.money;
                ante = data.ante;
                roundType = data.roundType;
                handsLeft = data.handsLeft;
                discardsLeft = data.discardsLeft;
                score = data.score;
                goal = data.goal;
                currentReward = data.currentReward;
                
                deck = data.deck || [];
                jokers = data.jokers || [];
                vouchers = data.vouchers || [];
                
                // If loaded mid-round vs shop? 
                // We'll assume saved at 'showBlindSelect' state or 'Shop' state.
                // If saved at Shop, show Shop.
                if(data.inShop) {
                     console.log("Restoring Shop State");
                     showShop();
                } else {
                     console.log("Restoring Blind Select State");
                     showBlindSelect();
                }
                updateHUD();
                renderJokers();
            } else {
                console.log("User Declined Save - Calling initNewRun");
                initNewRun();
            }
        } catch(e) { console.log("Load Error: " + e); initNewRun(); }
    }
    
    function saveAll(inShop) {
        console.log("Saving Game... InShop: " + !!inShop);
        if(typeof CYR !== 'undefined' && CYR.saveGame) {
            let data = {
                money: money,
                ante: ante,
                roundType: roundType,
                handsLeft: handsLeft,
                discardsLeft: discardsLeft,
                score: score,
                goal: goal,
                currentReward: currentReward,
                deck: deck,
                jokers: jokers,
                vouchers: vouchers,
                inShop: !!inShop
            };
            CYR.saveGame(JSON.stringify(data));
        }
    }
    function initDeck() {
        deck = [];
        suits.forEach(s => ranks.forEach(r => deck.push({ suit: s, rank: r, val: values[r] })));
        for(let i=deck.length-1; i>0; i--) { const j=Math.floor(Math.random()*(i+1)); [deck[i],deck[j]]=[deck[j],deck[i]]; }
    }
    
    // [Old showBlindSelect function removed to fix duplication]
    
    // Tag System
    var tags = [
        { name: "Investment Tag", desc: "+$15" },
        { name: "Coupon Tag", desc: "Free Shop Items" },
        { name: "D6 Tag", desc: "Free Reroll" },
        { name: "Standard Tag", desc: "Free Basic Pack" },
        { name: "Charm Tag", desc: "Free Arcana Pack" }
    ];
    function getRandomTag() { return tags[Math.floor(Math.random() * tags.length)]; }

    function selectBlind(t, r, n) {
        goal = t; score = 0; currentReward = r;
        // Blind Name Update
        document.getElementById('blind-name').innerText = n || "Blind";
        document.getElementById('blind-goal').innerText = t;
        
        handsLeft = 4 + (vouchers.some(v=>v.id==='grabber')?1:0);
        discardsLeft = 3 + (vouchers.some(v=>v.id==='wasteful')?1:0);
        document.getElementById('screen-blind').style.display = 'none';
        document.getElementById('play-controls').style.display = 'flex';
        // Reset sidebar header
        // document.getElementById('blind-name').innerText = n || "Blind" (already done above)
        // But maybe we want the Blind Name to persist as "Small Blind" during play? Yes.
        
        initDeck(); hand = []; 
        updateHUD();
        setTimeout(drawHand, 500); 
        
        if(roundType === 2) { colorMode = 2; updateShaderMode(); }
        else { colorMode = 0; updateShaderMode(); }
    }
    
    function skipBlind(tagName) {
        if(confirm("Skip Blind for " + tagName + "?")) {
            // Apply Tag Effect
            if(tagName === "Investment Tag") { money += 15; alert("Investment Yielded $15!"); }
            else if(tagName === "Coupon Tag") { vouchers.push({id:'coupon', name:'Coupon', desc:'Free Shop', cost:0}); alert("Items in next shop are free!"); }
            else if(tagName === "D6 Tag") { money += 10; alert("Rerolls are free (not really, just +$10 for now)"); }
            else if(tagName === "Standard Tag") { openPackScreen('card'); return; } // Special flow
            else if(tagName === "Charm Tag") { openPackScreen('tarot'); return; }
            
            finishRound(true);
        }
    }
    
    function showBlindSelect() {
        console.log("showBlindSelect called");
        var screenBlind = document.getElementById('screen-blind');
        var screenShop = document.getElementById('screen-shop');
        var playControls = document.getElementById('play-controls');
        
        console.log("Blind: " + (screenBlind ? screenBlind.style.display : "null"));
        console.log("Controls: " + (playControls ? playControls.style.display : "null"));

        if(screenBlind) screenBlind.style.display = 'flex';
        if(screenShop) screenShop.style.display = 'none';
        if(playControls) playControls.style.display = 'none';
        
        console.log("After Set - Blind: " + (screenBlind ? screenBlind.style.display : "null") + ", Controls: " + (playControls ? playControls.style.display : "null"));

        document.getElementById('blind-name').innerText = "Choose Blind";
        document.getElementById('blind-goal').innerText = "---";
        
        colorMode = (roundType === 2) ? 2 : 0; updateShaderMode();
        
        var container = document.getElementById('blind-container');
        container.innerHTML = '';
        var base = 300 * Math.pow(1.5, ante-1);
        var blinds = [
            { name: "Small Blind", score: Math.floor(base), reward: 3, tag: getRandomTag() },
            { name: "Big Blind", score: Math.floor(base * 1.5), reward: 4, tag: getRandomTag() },
            { name: "Boss Blind", score: Math.floor(base * 2), reward: 5, tag: null }
        ];
        
        blinds.forEach(function(b, i) {
            var el = document.createElement('div');
            el.className = 'blind-card';
            let btnHtml = '';
            
            if (i < roundType) {
                 el.style.opacity = '0.5';
                 el.style.filter = 'grayscale(1)';
                 btnHtml = `<div class="blind-status">DEFEATED</div>`;
            } else if (i === roundType) {
                 el.style.border = '2px solid #fcee0a';
                 // Update selectBlind to pass name
                 if(i === 2) btnHtml = `<button class="blind-btn btn-select" onclick="selectBlind(${b.score}, ${b.reward}, '${b.name}')">SELECT</button>`;
                 else btnHtml = `<button class="blind-btn btn-select" onclick="selectBlind(${b.score}, ${b.reward}, '${b.name}')">SELECT</button><div style="height:10px"></div><button class="blind-btn btn-skip" onclick="skipBlind('${b.tag.name}')">SKIP</button>`;
            } else {
                 el.style.opacity = '0.7';
                 btnHtml = `<div class="blind-status">LOCKED</div>`;
            }
            
            el.innerHTML = `<div class="blind-header" style="${i===2?'color:red':''}">${b.name}</div><div class="blind-score">Score: ${b.score}</div><div class="blind-reward">Reward: $${b.reward}</div><div style="margin-top:auto; width:100%">${btnHtml}</div>`;
            container.appendChild(el);
        });
    }

    function updateHUD() {
        var setTxt = function(id, val) { var e = document.getElementById(id); if(e) e.innerText = val; };
        
        setTxt('round-score', score);
        setTxt('money', money);
        setTxt('hands-left', handsLeft);
        setTxt('discards-left', discardsLeft);
        setTxt('ante', ante);
        setTxt('round-num', roundType + 1);
        
        // Blind goal might be different or needed?
        setTxt('blind-goal', goal);
        
        updateDeckPile();
        renderJokers();
    }

    function updateDeckPile() {
        const pile = document.getElementById('deck-pile');
        const count = document.getElementById('deck-count');
        if(!pile || !count) return;
        
        count.innerText = deck.length;
        
        // Visual Thickness
        var shadow = '';
        var thick = Math.min(Math.floor(deck.length / 5), 10);
        for(var i=1; i<=thick; i++) {
            shadow += i*2 + 'px ' + i*2 + 'px 0 #a00, ';
        }
        shadow += (thick*2 + 2) + 'px ' + (thick*2 + 2) + 'px 5px rgba(0,0,0,0.5)';
        pile.style.boxShadow = shadow;
    }
    
    function showDeckView() {
        document.getElementById('screen-deck').style.display = 'flex';
        const grid = document.getElementById('deck-grid-content'); grid.innerHTML = '';
        
        // Sort deck
        var sorted = deck.slice().sort(function(a,b) {
             if(a.suit !== b.suit) return suits.indexOf(a.suit) - suits.indexOf(b.suit);
             return values[a.rank] - values[b.rank];
        });
        
        sorted.forEach(function(c) {
             var el = document.createElement('div'); el.className = 'mini-card';
             var suitIdx = (c.suit === 'â™£') ? 1 : (c.suit === 'â™¦') ? 2 : (c.suit === 'â™ ') ? 3 : 0;
             var rankIdx = ranks.indexOf(c.rank);
             
             var bgX = (rankIdx / 12) * 100;
             var bgY = (suitIdx / 3) * 100;
             el.style.backgroundPosition = bgX + '% ' + bgY + '%';
             grid.appendChild(el);
        });
    }
    
    function sortHand(method) {
        if(isAnimating) return;
        sfx('select');
        if(method === 'rank') {
            hand.sort(function(a,b) { return values[b.rank] - values[a.rank]; });
        } else if(method === 'suit') {
            hand.sort(function(a,b) {
                if(a.suit !== b.suit) return suits.indexOf(a.suit) - suits.indexOf(b.suit);
                return values[b.rank] - values[a.rank];
            });
        }
        // Remap selection? No, clear it.
        selectedIndices = [];
        renderHand();
    }
    
    function closeDeckView() {
        document.getElementById('screen-deck').style.display = 'none';
    }
    
    function renderJokers() {
        var area = document.getElementById('joker-area');
        if(!area) return;
        area.innerHTML = '';
        jokers.forEach(function(j, i) {
             var el = document.createElement('div');
             el.className = 'joker-card rarity-' + (j.rarity || 1);
             el.id = 'joker-inst-' + i;
             
            // Image Support
            if(j.img) {
               el.style.backgroundImage = 'url(' + j.img + ')';
               el.style.backgroundSize = 'cover';
               el.style.backgroundPosition = 'center';
            } else {
               el.innerText = j.name; // Fallback
            }
            
             var tip = document.createElement('div'); tip.className = 'joker-tooltip';
             tip.innerHTML = '<b>' + j.name + '</b><br>' + j.desc;
             el.appendChild(tip);
             
             el.onclick = function() {
                 if(confirm("Sell " + j.name + " for $" + Math.floor(j.cost/2) + "?")) {
                     money += Math.floor(j.cost/2);
                     jokers.splice(i, 1);
                     sfx('buy');
                     saveAll(data.inShop || false); 
                     renderJokers();
                     updateHUD();
                 }
             };
             area.appendChild(el);
        });
    }


    function drawHand() {
        var needed = 8 - hand.length + (vouchers.some(function(v){return v.id==='grabber';})?1:0); 
        needed = 8 - hand.length; 
        
        if(deck.length === 0) return;
        
        var added = 0;
        function drawNext() {
            if(deck.length > 0 && hand.length < 8) {
                var c = deck.pop();
                hand.push(c);
                sfx('select'); 
                renderHand();
                updateHUD();
                added++;
                if(added < needed && deck.length > 0) setTimeout(drawNext, 100);
            }
        }
        drawNext();
    }
    
    function renderHand() {
        var area = document.getElementById('hand-area'); area.innerHTML = '';
        
        hand.forEach(function(c, i) {
            var el = document.createElement('div');
            el.className = 'card' + (selectedIndices.includes(i) ? ' selected' : '');
            
            var suitIdx = 0;
            if(c.suit === 'â™£') suitIdx = 1;
            if(c.suit === 'â™¦') suitIdx = 2;
            if(c.suit === 'â™ ') suitIdx = 3;
            
            var rankIdx = ranks.indexOf(c.rank);
            
            var bgX = (rankIdx / 12) * 100;
            var bgY = (suitIdx / 3) * 100;
            el.style.backgroundPosition = bgX + '% ' + bgY + '%';
            
            var rot = selectedIndices.includes(i) ? '0deg' : (Math.random()*4-2+'deg');
            el.style.transform = 'rotate(' + rot + ')';
            if(selectedIndices.includes(i)) { el.style.transform = 'rotate(0deg) translateY(-30px)'; }

            // Drag Attributes
            el.setAttribute('draggable', true);
            el.dataset.idx = i;
            
            // Events
            el.onclick = function() { if(!isAnimating) { sfx('select'); toggleSelect(i); } };
            
            el.addEventListener('dragstart', handleDragStart, false);
            el.addEventListener('dragover', handleDragOver, false);
            el.addEventListener('drop', handleDrop, false);
            el.addEventListener('dragend', handleDragEnd, false);
            
            if(selectedIndices.includes(i)) { 
                // Fix for unsaved changes in previous steps, ensuring class is applied
            }
            
            area.appendChild(el);
        });
        updatePreview();
    }


    
    function toggleSelect(i) {
        if(selectedIndices.includes(i)) selectedIndices=selectedIndices.filter(function(x){return x!==i;});
        else if(selectedIndices.length<5) selectedIndices.push(i);
        renderHand();
    }

    // --- DRAG AND DROP ---
    var dragSrc = null;
    function handleDragStart(e) {
        dragSrc = this;
        e.dataTransfer.effectAllowed = 'move';
        e.dataTransfer.setData('text/html', this.innerHTML);
        this.classList.add('dragging');
    }
    
    function handleDragOver(e) {
        if (e.preventDefault) e.preventDefault();
        e.dataTransfer.dropEffect = 'move';
        return false;
    }
    
    function handleDrop(e) {
        if (e.stopPropagation) e.stopPropagation();
        if (dragSrc !== this) {
            var srcIdx = parseInt(dragSrc.dataset.idx);
            var targetIdx = parseInt(this.dataset.idx);
            
            // Swap in data
            var temp = hand[srcIdx];
            hand[srcIdx] = hand[targetIdx];
            hand[targetIdx] = temp;
            
            var newSel = [];
            selectedIndices.forEach(function(s) {
                if(s === srcIdx) newSel.push(targetIdx);
                else if(s === targetIdx) newSel.push(srcIdx);
                else newSel.push(s);
            });
            selectedIndices = newSel;
            
            renderHand();
            sfx('select');
        }
        return false;
    }

    function handleDragEnd(e) {
        this.classList.remove('dragging');
    }

    function playHand() {
        if(isAnimating || handsLeft <= 0 || selectedIndices.length === 0) return;
        isAnimating = true; sfx('score');
        
        var sel = selectedIndices.map(function(i){ return hand[i]; });
        var type = evaluate(sel);
        
        // Setup Base State for Animation
        var currentChips = 0; // Starts at 0, builds up
        var currentMult = 0;
        
        // Use the Preview boxes for the animation
        var prevBox = document.getElementById('score-preview');
        var chipEl = document.getElementById('prev-chips');
        var multEl = document.getElementById('prev-mult');
        var totalEl = document.getElementById('round-score');
        
        // Force visibility
        prevBox.classList.add('visible');
        chipEl.innerText = "0"; multEl.innerText = "0";
        
        var step = 0;
        
        // Function to process each step of scoring
        function processNext() {
            // Step 1: Process individual cards (Chips calculation)
            if(step < sel.length) {
                var card = sel[step];
                var isScoring = type.scoring.includes(card);
                
                // Find the DOM element for this card (it's the i-th selected card)
                var cardElems = document.querySelectorAll('.card.selected');
                var cardEl = cardElems[step];
                
                if(cardEl) {
                    if(isScoring) {
                        cardEl.classList.add('scoring'); // Trigger pop animation
                        
                        // Add Chips logic
                        currentChips += card.val;
                        chipEl.innerText = currentChips;
                        
                        // Shake effect on Chip Box
                        chipEl.classList.remove('shaking'); 
                        void chipEl.offsetWidth; // Trigger reflow
                        chipEl.classList.add('shaking');
                        
                        sfx('score'); 
                    } else {
                        cardEl.classList.add('unused');
                    }
                }
                
                step++;
                setTimeout(processNext, isScoring ? 600 : 100);
            } 
            // Step 2: Add Hand Type Base Stats
            else if(step === sel.length) {
                 currentChips += type.chips; 
                 currentMult += type.mult;
                 
                 chipEl.innerText = currentChips;
                 multEl.innerText = currentMult;
                 
                 // Shake both boxes
                 chipEl.classList.remove('shaking'); multEl.classList.remove('shaking');
                 void chipEl.offsetWidth; 
                 chipEl.classList.add('shaking'); multEl.classList.add('shaking');
                 
                 showPopup(0, type.name); 
                 
                 step++;
                 setTimeout(processNext, 800);
            }
            // Step 3: Jokers (Simplified: just add their effects all at once for now, or TODO loop them)
            else if(step === sel.length + 1) {
                var stats = { chips: currentChips, mult: currentMult };
                
                jokers.forEach(function(j, i) {
                    var triggered = getJokerEffect(j, stats, sel, type);
                    if(triggered) {
                         var el = document.getElementById('joker-inst-' + i);
                         if(el) {
                             el.classList.remove('joker-trigger');
                             void el.offsetWidth;
                             el.classList.add('joker-trigger');
                         }
                    }
                });
                
                currentChips = stats.chips;
                currentMult = stats.mult;
                
                chipEl.innerText = currentChips;
                multEl.innerText = currentMult;
                
                step++;
                setTimeout(processNext, 600);
            }
            // Step 4: Final Total
            else {
                 var finalScore = currentChips * currentMult;
                 score += finalScore;
                 
                 totalEl.innerText = score;
                 totalEl.classList.add('shaking');
                 setTimeout(function(){totalEl.classList.remove('shaking'); }, 500);
                 
                 sfx('win'); 
                 
                 handsLeft--;
                 
                 // Cleanup after delay
                 setTimeout(function() {
                    hand = hand.filter(function(_, i){ return !selectedIndices.includes(i); });
                    selectedIndices = []; 
                    drawHand(); 
                    isAnimating = false; 
                    updateHUD();
                    
                    if(score >= goal) { setTimeout(function(){ finishRound(false); }, 1000); } 
                    else if (handsLeft === 0) { alert("GAME OVER!"); location.reload(); }
                 }, 1500);
            }
        }
        
        processNext();
        updateHUD(); // Validates handsLeft display
    }
    
    function updatePreview() {
        var sel = selectedIndices.map(function(i){ return hand[i]; }).sort(function(a,b){ return ranks.indexOf(a.rank) - ranks.indexOf(b.rank); });
        var type = evaluate(sel);
        
        var nameEl = document.getElementById('hand-name-display');
        if(nameEl) nameEl.innerText = (sel.length>0 ? type.name : "");
        
        var stats = { chips: type.chips, mult: type.mult };
        jokers.forEach(function(j) { getJokerEffect(j, stats, sel, type); });
        
        var cEl = document.getElementById('prev-chips'); if(cEl) cEl.innerText = stats.chips;
        var mEl = document.getElementById('prev-mult'); if(mEl) mEl.innerText = stats.mult;
        
        var prev = document.getElementById('score-preview');
        if(prev) { if(sel.length > 0) prev.classList.add('visible'); else prev.classList.remove('visible'); }
    }
    
    function evaluate(cards) {
        if(cards.length === 0) return { name: "", mult: 0, chips: 0, scoring: [] };
        
        var rankCounts = {};
        var flush = cards.length >= 5 && cards.every(function(c){ return c.suit === cards[0].suit; });
        cards.forEach(function(c){ rankCounts[c.rank] = (rankCounts[c.rank] || 0) + 1; });
        
        // Sort counts desc
        var counts = Object.values(rankCounts).sort(function(a,b){return b-a;});
        
        // Helper to find ranks by count
        var getRanksByCount = function(n) { return Object.keys(rankCounts).filter(function(r){ return rankCounts[r] === n; }); };
        
        // Straight Check
        var isStraight = false; 
        if(cards.length === 5) {
            var idxs = cards.map(function(c){ return ranks.indexOf(c.rank); }).sort(function(a,b){return a-b;});
            var seq = true; for(var i=0; i<4; i++) if(idxs[i+1] !== idxs[i]+1) seq = false;
            // Low Straight: A,2,3,4,5 -> 12,0,1,2,3. Sorted: 0,1,2,3,12.
            if(!seq && idxs[4]===12 && idxs[0]===0 && idxs[3]===3) { 
                 seq=true; 
            }
            isStraight = seq;
        }

        var baseName = "High Card";
        var baseChips = 5;
        var baseMult = 1;
        var scoring = [];

        if(isStraight && flush) {
            baseName = "Straight Flush"; baseChips=100; baseMult=8;
            scoring = cards;
        } else if(counts[0] === 4) {
            baseName = "Four of a Kind"; baseChips=60; baseMult=7;
            var r = getRanksByCount(4)[0];
            scoring = cards.filter(function(c){ return c.rank === r; });
        } else if(counts[0] === 3 && counts[1] === 2) {
            baseName = "Full House"; baseChips=40; baseMult=4;
            scoring = cards;
        } else if(flush) {
            baseName = "Flush"; baseChips=35; baseMult=4;
            scoring = cards;
        } else if(isStraight) {
            baseName = "Straight"; baseChips=30; baseMult=4;
            scoring = cards;
        } else if(counts[0] === 3) {
            baseName = "Three of a Kind"; baseChips=30; baseMult=3;
            var r = getRanksByCount(3)[0];
            scoring = cards.filter(function(c){ return c.rank === r; });
        } else if(counts[0] === 2 && counts[1] === 2) {
            baseName = "Two Pair"; baseChips=20; baseMult=2;
            var rs = getRanksByCount(2); 
            scoring = cards.filter(function(c){ return rs.includes(c.rank); });
        } else if(counts[0] === 2) {
            baseName = "Pair"; baseChips=10; baseMult=2;
            var r = getRanksByCount(2)[0];
            scoring = cards.filter(function(c){ return c.rank === r; });
        } else {
            // High Card: Score highest value card
            var maxVal = -1;
            cards.forEach(function(c){ if(c.val > maxVal) maxVal = c.val; });
            var sorted = cards.slice().sort(function(a,b){ return ranks.indexOf(b.rank) - ranks.indexOf(a.rank); });
            scoring = [sorted[0]];
        }
        
        var cardChips = 0; scoring.forEach(function(c){ cardChips += c.val; });
        return { name: baseName, chips: baseChips + cardChips, mult: baseMult, scoring: scoring };
    }
    

    
    function discardHand() {
        if(isAnimating || discardsLeft <= 0 || selectedIndices.length === 0) return;
        isAnimating = true; discardsLeft--; sfx('select');
        document.querySelectorAll('.card.selected').forEach(function(e){ e.classList.add('discarding'); });
        setTimeout(function() { hand = hand.filter(function(_, i){ return !selectedIndices.includes(i); }); selectedIndices = []; drawHand(); isAnimating = false; updateHUD(); }, 500);
    }
    
    function finishRound(skipped) {
        if(!skipped) money += currentReward + handsLeft + discardsLeft;
        roundType++; if(roundType > 2) { roundType = 0; ante++; }
        saveAll(true); // Save entering shop
        showShop();
    }
    
    // --- SHOP ---
    function showShop() {
        colorMode = 1; updateShaderMode();
        document.getElementById('screen-shop').style.display = 'flex';
        document.getElementById('play-controls').style.display = 'none';
        document.getElementById('blind-name').innerText = "VMP Shop";
        renderShop();
    }
    
    function renderShop() {
        // Items are ephemeral in this shop logic, regen only if needed? For now straightforward reroll
        // Top Row: 2 Jokers.
        ['shop-joker-1', 'shop-joker-2'].forEach(function(id) {
            var container = document.getElementById(id); container.innerHTML = '';
            var j = jokerDB[Math.floor(Math.random()*jokerDB.length)];
            var el = document.createElement('div'); el.className = 'shop-item';
            
            // Rarity Color
            var rColors = ['#888', '#888', '#0099ff', '#ff4444', '#fcee0a'];
            el.style.borderColor = rColors[j.rarity||1];
            
            var cost = j.cost; if(vouchers.some(function(v){return v.id==='clearance';})) cost = Math.floor(cost * 0.75);
            
            
            el.innerHTML = `
                <div class="price-tag">$${cost}</div>
                <div style="width:100%; height:80px; background: url('${j.img||''}') center/contain no-repeat; margin-top:5px;"></div>
                <div style="font-weight:bold; text-align:center; font-size:12px;">${j.name}</div>
                <div style="font-size:10px;color:#ccc; text-align:center; display:flex; align-items:center; justify-content:center; flex:1; line-height:1.1;">${j.desc}</div>
                <div style="font-size:10px; color:#666">JOKER</div>
            `;
            el.onclick = function() { if(money>=cost && jokers.length<5) { money-=cost; jokers.push(j); sfx('buy'); saveAll(true); renderJokers(); updateHUD(); container.innerHTML=''; } else sfx('select'); };
            container.appendChild(el);
        });
        
        // Mid Row: Voucher + Packs
        var vContainer = document.getElementById('shop-voucher'); vContainer.innerHTML = '';
        if(!vouchers.some(function(v){return v.bought_this_ante;})) { // Simple logic: random voucher not owned
            var v = voucherDB[Math.floor(Math.random()*voucherDB.length)];
            if(!vouchers.some(function(owned){return owned.id===v.id;})) {
                var el = document.createElement('div'); el.className = 'shop-item';
                // Voucher styling
                el.style.background = '#400080'; el.style.borderColor = '#a0f';
                el.innerHTML = `
                    <div class="price-tag">$${v.cost}</div>
                    <div style="font-weight:bold; color:#fff;">${v.name}</div>
                    <div style="font-size:11px; color:#ccc;">${v.desc}</div>
                    <div style="font-size:10px; color:#888">VOUCHER</div>
                `;
                el.onclick = function() { if(money>=v.cost) { money-=v.cost; v.bought_this_ante=true; vouchers.push(v); sfx('buy'); updateHUD(); vContainer.innerHTML=''; } else sfx('select'); };
                vContainer.appendChild(el);
            }
        }
        
        // Packs (Right of voucher)
        ['shop-pack-1', 'shop-pack-2'].forEach(function(id) {
             var container = document.getElementById(id); container.innerHTML = '';
             // Random Pack Logic
             var isTarot = Math.random()>0.5;
             var cost = isTarot ? 6 : 4;
             var name = isTarot ? "Arcana Pack" : "Standard Pack";
             var type = isTarot ? 'tarot' : 'card';
             
             var el = document.createElement('div'); el.className = 'shop-item';
             el.style.background = isTarot ? '#3a1e52' : '#2a2a2a';
             el.style.borderColor = isTarot ? '#a8f' : '#fff';
             
             el.innerHTML = `
                 <div class="price-tag">$${cost}</div>
                 <div style="font-weight:bold;">${name}</div>
                 <div style="font-size:10px;">${isTarot?'3 Cards':'5 Cards'}</div>
                 <div style="font-size:10px; color:#888">PACK</div>
             `;
             el.onclick = function() { if(money>=cost) { money-=cost; sfx('buy'); updateHUD(); openPackScreen(type); container.innerHTML=''; } else sfx('select'); };
             container.appendChild(el);
        });
    }
    
    function rerollShop() {
        if(money >= 5) { money -= 5; updateHUD(); sfx('reroll'); renderShop(); } else sfx('select');
    }
    
    function finishShop() {
        document.getElementById('screen-shop').style.display = 'none';
        saveAll(false); // Save starting round
        showBlindSelect();
    }
    

    
    function openPackScreen(type) {
        document.getElementById('screen-shop').style.display = 'none';
        document.getElementById('screen-pack').style.display = 'flex';
        playMusic('tarot');
        var cont = document.getElementById('pack-content'); cont.innerHTML = '';
        for(var i=0; i<3; i++) {
            var el = document.createElement('div'); el.className = 'pack-card';
            if(type === 'tarot') {
                var tarots = ["Fool", "Magician", "Priestess", "Empress", "Emperor", "Hierophant", "Lovers", "Chariot", "Justice", "Hermit", "Wheel", "Strength", "Hanged", "Death", "Temperance", "Devil", "Tower", "Star", "Moon", "Sun", "Judge", "World"];
                var t = tarots[Math.floor(Math.random()*tarots.length)];
                el.innerHTML = `<div style="font-size:18px; color:purple">${t}</div>`;
                el.onclick = function() { sfx('buy'); alert("Tarot not implemented, +$2 refund"); money+=2; updateHUD(); closePack(); };
            } else if(type === 'card') {
                var s = suits[Math.floor(Math.random()*4)]; var r = ranks[Math.floor(Math.random()*13)];
                el.innerHTML = `<div style="font-size:30px">${s}${r}</div>`;
                el.onclick = function() { 
                    sfx('buy'); 
                    deck.push({ suit: s, rank: r, val: values[r] }); 
                    alert("Card added to deck!"); 
                    closePack(); 
                };
            } else {
                el.innerHTML = `<div style="font-size:18px; color:cyan">Spectral</div>`;
                el.onclick = function() { sfx('buy'); alert("Spectral not implemented, +$2 refund"); money+=2; updateHUD(); closePack(); };
            }
            cont.appendChild(el);
        }
    }
    
    function closePack() {
        document.getElementById('screen-pack').style.display = 'none';
        document.getElementById('screen-shop').style.display = 'flex';
        playMusic('main');
    }
    
    function showPopup(val, text) {
        let el = document.createElement('div'); el.className = 'score-popup';
        el.innerHTML = `<div style='font-size:32px; color:white; text-shadow:0 0 5px black'>${text}</div><div style='color:#fea; font-size:40px'>+${val}</div>`;
        el.style.position='fixed'; el.style.left = '50%'; el.style.top = '40%'; el.style.transform = 'translate(-50%, -50%)'; el.style.zIndex='100';
        document.body.appendChild(el); setTimeout(() => el.remove(), 1000);
    }
    


    initGame();
</script>
</body>
</html>
    ]=])
end

function SOCIAL:BuildCoolMathChess()
    self.container:Clear()
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    -- Bridge for sending moves
    html:AddFunction("CYR", "joinLobby", function(lobbyID) netstream.Start("NetChessJoin", lobbyID) end)
    html:AddFunction("CYR", "sendMove", function(lobbyID, fen, moveSan) netstream.Start("NetChessMove", lobbyID, fen, moveSan) end)
    html:AddFunction("CYR", "invite", function(playerName, lobbyID) netstream.Start("NetChessInvite", playerName, lobbyID) end)
    -- Bridge for receiving updates (called from net hooks)
    netstream.Hook("NetChessJoined", function(lobbyID, count) if IsValid(html) then html:RunJavascript("onJoinedLobby('" .. lobbyID .. "', " .. count .. ");") end end)
    netstream.Hook("NetChessPlayerJoined", function(plyName) if IsValid(html) then html:RunJavascript("onPlayerJoined('" .. plyName .. "');") end end)
    netstream.Hook("NetChessUpdate", function(fen, moveSan) if IsValid(html) then html:RunJavascript("onRemoteMove('" .. fen .. "', '" .. (moveSan or "") .. "');") end end)
    html:SetHTML([[
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/chessboard-js/1.0.0/chessboard-1.0.0.min.css">
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/chess.js/0.10.3/chess.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/chessboard-js/1.0.0/chessboard-1.0.0.min.js"></script>
    <style>
        body { background: #222; color: #eee; font-family: monospace; display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100vh; margin: 0; }
        #board { width: 400px; margin-bottom: 20px; box-shadow: 0 0 20px rgba(0,0,0,0.5); }
        .controls { display: flex; gap: 10px; margin-bottom: 20px; }
        input { background: #333; border: 1px solid #555; color: white; padding: 5px; font-family: inherit; }
        button { background: #444; color: white; border: 1px solid #666; padding: 5px 15px; cursor: pointer; font-family: inherit; }
        button:hover { background: #555; }
        #status { font-size: 18px; margin-bottom: 10px; color: #aaa; }
        #lobby-ui { text-align: center; }
        #game-ui { display: none; flex-direction: column; align-items: center; }
        .log-box { width: 400px; height: 100px; background: #111; border: 1px solid #333; overflow-y: auto; font-size: 12px; padding: 5px; margin-top: 10px; }
        .log-entry { margin-bottom: 2px; border-bottom: 1px solid #222; }
        .invite-box { margin-bottom: 15px; display: flex; gap: 5px; }
    </style>
</head>
<body>
    <h1 style="color:#00ff00; text-shadow:2px 2px #ff00ff">CHESS.NET</h1>
    
    <div id="lobby-ui">
        <h2>ENTER LOBBY</h2>
    <div id="lobby-ui">
        <h2>ENTER LOBBY</h2>
        <div class="controls">
            <input type="text" id="lobby-in" placeholder="Lobby Name (e.g. 'Test')" value="Global">
        </div>
        <div class="controls">
            <button onclick="join('w')">PLAY AS WHITE</button>
            <button onclick="join('b')">PLAY AS BLACK</button>
            <button onclick="join('s')">SPECTATE</button>
        </div>
    </div>
    </div>
    
    <div id="game-ui">
        <div id="status">Waiting for opponent...</div>
        <div class="invite-box">
             <input type="text" id="invite-name" placeholder="Player Name to Invite">
             <button onclick="invitePlayer()">INVITE</button>
        </div>
        <div id="board"></div>
        <div class="controls">
            <button onclick="game.reset(); board.start(); updateStatus(); log('Board Reset'); CYR.sendMove(currentLobby, game.fen());">RESET BOARD</button>
            <button onclick="board.flip()">FLIP VIEW</button>
        </div>
        <div class="log-box" id="log"></div>
    </div>

    <script>
        var board = null;
        var game = new Chess();
        var currentLobby = "";
        var mySide = 's'; // 'w', 'b', or 's'
        
        function onDragStart (source, piece, position, orientation) {
            if (game.game_over()) return false;
            if (mySide === 's') return false;
            // Only pick up pieces for my side
            if ((mySide === 'w' && piece.search(/^b/) !== -1) ||
                (mySide === 'b' && piece.search(/^w/) !== -1)) {
                return false;
            }
            // Only pick up if it's my turn
            if ((game.turn() === 'w' && mySide !== 'w') ||
                (game.turn() === 'b' && mySide !== 'b')) {
                return false;
            }
        }

        function onDrop (source, target) {
            var move = game.move({
                from: source,
                to: target,
                promotion: 'q'
            });

            if (move === null) return 'snapback';

            updateStatus();
            CYR.sendMove(currentLobby, game.fen(), move.san);
            log("State: " + move.san);
        }

        function onSnapEnd () {
            board.position(game.fen());
        }

        function updateStatus () {
            var status = '';
            var moveColor = 'White';
            if (game.turn() === 'b') { moveColor = 'Black'; }

            if (game.in_checkmate()) {
                status = 'Game over, ' + moveColor + ' is in checkmate.';
            } else if (game.in_draw()) {
                status = 'Game over, drawn position';
            } else {
                status = moveColor + ' to move';
                if (game.in_check()) {
                    status += ', ' + moveColor + ' is in check';
                }
            }
            document.getElementById('status').innerText = status;
        }

        var config = {
            draggable: true,
            position: 'start',
            onDragStart: onDragStart,
            onDrop: onDrop,
            onSnapEnd: onSnapEnd,
            pieceTheme: 'https://chessboardjs.com/img/chesspieces/wikipedia/{piece}.png'
        };
        
        function join(side) {
            var l = document.getElementById('lobby-in').value;
            if(!l) return;
            currentLobby = l;
            mySide = side || 's';
            CYR.joinLobby(l);
            document.getElementById('lobby-ui').style.display = 'none';
            document.getElementById('game-ui').style.display = 'flex';
            
            if(!board) {
                board = Chessboard('board', config);
                updateStatus();
                if(mySide === 'b') board.flip();
                // Fix layout issue where board might render size incorrectly if hidden initially
                setTimeout(() => window.dispatchEvent(new Event('resize')), 200);
            }
        }
        
        function log(msg) {
            var d = document.createElement('div');
            d.className = 'log-entry';
            d.innerText = msg;
            var l = document.getElementById('log');
            l.appendChild(d);
            l.scrollTop = l.scrollHeight;
        }
        
        function onJoinedLobby(id, count) {
            log("Joined lobby: " + id + ". Users: " + count);
        }
        
        function onPlayerJoined(name) {
            log("Player joined: " + name);
        }
        
        function onRemoteMove(fen, moveSan) {
            game.load(fen);
            board.position(fen);
            updateStatus();
            log((moveSan || "Remote Move"));
        }

        function invitePlayer() {
            var name = document.getElementById('invite-name').value;
            if(!name) return;
            CYR.invite(name, currentLobby);
            log("Inviting " + name + "...");
            document.getElementById('invite-name').value = "";
        }
    </script>
</body>
</html>
    ]])
end

function SOCIAL:BuildJungleBook()
    self.container:Clear()
    local html = self.container:Add("DHTML")
    html:Dock(FILL)
    html:SetHTML([[
<!DOCTYPE html>
<html>
<head>
    <style>
        body {
            background-color: black;
            color: white;
            font-family: monospace;
            margin: 0;
            height: 100vh;
            overflow: hidden;
            position: relative;
        }
        #top-gif {
            display: block;
            margin: 20px auto 0;
            max-width: 100%;
        }
        #center-text {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 24px;
            cursor: pointer;
            transition: color 0.3s;
            text-align: center;
        }
        #center-text:hover {
            color: #ccc;
            text-decoration: underline;
        }
        #final-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: black;
            display: none;
            justify-content: center;
            align-items: center;
        }
        #final-image {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }
    </style>
</head>
<body>
    <img id="top-gif" src="https://files.catbox.moe/rtquho.gif" alt="gif">
    <div id="center-text">Come along, man-cub.</div>
    
    <div id="final-container">
        <img id="final-image" src="https://files.catbox.moe/jateow.png">
    </div>

    <script>
        document.getElementById('center-text').addEventListener('click', function() {
            document.getElementById('final-container').style.display = 'flex';
            // Hide original elements
            document.getElementById('top-gif').style.display = 'none';
            document.getElementById('center-text').style.display = 'none';
        });
    </script>
</body>
</html>
    ]])
end


function SOCIAL:SetState(state, data)
    self.state = state
    self.currentStateData = data
    self.container:Clear()
    if state == "CREATE_PROFILE" then
        self:BuildCreateProfile()
    elseif state == "FEED" then
        self:BuildFeed(data)
    elseif state == "PROFILE_VIEW" then
        self:BuildProfileView(data)
    elseif state == "SEARCH_RESULTS" then
        self:BuildSearchResults(data)
    elseif state == "POST_VIEW" then
        self:BuildPostView(data)
    elseif state == "MESSAGES" then
        self:BuildMessages(data)
    elseif state == "FREE_EDDIES" then
        self:BuildFreeEddies()
    elseif state == "FREE_THE_FILES" then
        self:BuildFreeTheFiles()
    elseif state == "MELINOE" then
        self:BuildMelinoe()
    elseif state == "KRASUES_KISS" then
        self:BuildKrasuesKiss()
    elseif state == "BOMB_DF" then
        self:BuildBombDF()
    elseif state == "JUNGLEBOOK_EVT" then
        self:BuildJungleBook()
    elseif state == "SOVIET_FILES" then
        self:BuildSovietFiles()
    elseif state == "SAD_BANANA" then
        self:BuildSadBanana()
    elseif state == "ERROR" then
        self:BuildError(data)
    elseif state == "COOLMATH_HUB" then
        self:BuildCoolMathHub()
    elseif state == "COOLMATH_MINESWEEPER" then
        self:BuildCoolMathMinesweeper()
    elseif state == "COOLMATH_PONG" then
        self:BuildCoolMathPong()
    elseif state == "COOLMATH_TETRIS" then
        self:BuildCoolMathTetris()
    elseif state == "COOLMATH_SNAKE" then
        self:BuildCoolMathSnake()
    elseif state == "COOLMATH_SOLITAIRE" then
        self:BuildCoolMathSolitaire()
    elseif state == "COOLMATH_BALATRO" then
        self:BuildCoolMathBalatro()
    elseif state == "COOLMATH_CHESS" then
        self:BuildCoolMathChess()
    elseif state == "ExternalBrowser" then
        self:BuildExternalBrowser(data)
    end
end

include("pages/messages.lua")
include("pages/free_eddies.lua")
include("pages/free_the_files.lua")
-- Converts imgur links to kageurufu proxy for UK users
function CYR.Net.CreateAvatar(parent, url, size)
    url = CYR.Net.ProxyImgur(url)
    local p = parent:Add("DPanel")
    p:SetSize(size, size)
    p.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(CP_CYAN)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    if url and url ~= "" then
        if string.StartWith(url, "http") then
            local html = p:Add("DHTML")
            html:Dock(FILL)
            html:SetHTML([[
                <style>
                    body { margin: 0; padding: 0; overflow: hidden; background-color: black; }
                    img { width: 100%; height: 100%; object-fit: cover; }
                </style>
                <img src="]] .. url .. [[" />
            ]])
            html:SetMouseInputEnabled(false)
        else
            -- Assume material
            local img = p:Add("DImage")
            img:Dock(FILL)
            img:SetImage(url)
        end
    else
        -- Placeholder
        local lbl = p:Add("DLabel")
        lbl:Dock(FILL)
        lbl:SetText("?")
        lbl:SetFont("DermaLarge")
        lbl:SetContentAlignment(5)
        lbl:SetTextColor(Color(50, 50, 50))
    end
    return p
end

include("pages/create_profile.lua")
include("pages/feed.lua")
include("pages/profile_view.lua")
include("pages/post_view.lua")
include("pages/search_results.lua")
vgui.Register("CYRNetSocialPanel", SOCIAL, "DPanel")
netstream.Hook("NetMsgContacts", function(data) if IsValid(CYR_NET_FRAME) and IsValid(CYR_NET_FRAME.socialPanel) and IsValid(CYR_NET_FRAME.socialPanel.messengerPanel) then CYR_NET_FRAME.socialPanel.messengerPanel:SetContacts(data) end end)
netstream.Hook("NetMsgHistory", function(targetID, messages, isPagination)
    if IsValid(CYR_NET_FRAME) and IsValid(CYR_NET_FRAME.socialPanel) and IsValid(CYR_NET_FRAME.socialPanel.messengerPanel) then
        local panel = CYR_NET_FRAME.socialPanel.messengerPanel
        if panel.activeContact ~= targetID then return end
        if panel.OnHistoryReceived then
            panel:OnHistoryReceived(messages, isPagination)
            return
        end

        if IsValid(panel.chatHistory) then
            panel.chatHistory:Clear()
            local myID = LocalPlayer():getChar():getID()
            for _, msg in ipairs(messages) do
                panel:AddMessage(msg)
                -- If messaging self, show both sides for testing
                if targetID == myID and msg.sender == myID then
                    local fakeMsg = table.Copy(msg)
                    fakeMsg.sender = -1 -- Force "Them" side
                    panel:AddMessage(fakeMsg)
                end
            end

            timer.Simple(0.2, function()
                if IsValid(CYR_NET_FRAME) and IsValid(CYR_NET_FRAME.socialPanel) and IsValid(panel) then
                    local hist = panel.chatHistory
                    if IsValid(hist) then
                        hist:InvalidateLayout(true)
                        hist:GetVBar():SetScroll(hist:GetVBar().CanvasSize)
                    end
                end
            end)
        end
    end
end)

netstream.Hook("NetMsgOnlinePlayers", function(data)
    print("[CYR] NetMsgOnlinePlayers received data:", data)
    if IsValid(CYR_NET_FRAME) and IsValid(CYR_NET_FRAME.socialPanel) then
        print("[CYR] SocialPanel valid. MessengerPanel:", CYR_NET_FRAME.socialPanel.messengerPanel)
        if IsValid(CYR_NET_FRAME.socialPanel.messengerPanel) then
            print("[CYR] Calling SetOnlinePlayers")
            CYR_NET_FRAME.socialPanel.messengerPanel:SetOnlinePlayers(data)
        end
    else
        print("[CYR] Panel invalid")
    end
end)

-- Notification System
CYR.Net.Notifications = {}
function CYR.Net.ShowNotification(name, text, partnerID, groupName, notifType, data)
    table.insert(CYR.Net.Notifications, {
        name = name,
        text = text,
        partnerID = partnerID,
        groupName = groupName,
        type = notifType,
        data = data,
        duration = 8
    })

    -- If this is the only notification, start it immediately
    if #CYR.Net.Notifications == 1 then
        CYR.Net.Notifications[1].startTime = CurTime()
        surface.PlaySound("buttons/blip1.wav")
    end
end

hook.Add("HUDPaint", "CYR_Net_Notification", function()
    if #CYR.Net.Notifications == 0 then return end
    local notif = CYR.Net.Notifications[1]
    -- Start timer if not started (for queued items)
    if not notif.startTime then
        notif.startTime = CurTime()
        surface.PlaySound("buttons/blip1.wav")
    end

    local elapsed = CurTime() - notif.startTime
    if elapsed > notif.duration then
        table.remove(CYR.Net.Notifications, 1)
        return
    end

    local scrW, scrH = ScrW(), ScrH()
    local w, h = 400, 120
    -- Animation
    local fadeIn = 0.5
    local fadeOut = 0.5
    local x = -w -- Start off-screen
    local alpha = 255
    if elapsed < fadeIn then
        local t = math.ease.OutCubic(elapsed / fadeIn)
        x = -w + (w + 50) * t -- Slide to x=50
        alpha = 255 * t
    elseif elapsed > notif.duration - fadeOut then
        local t = (elapsed - (notif.duration - fadeOut)) / fadeOut
        x = 50
        alpha = 255 * (1 - t)
    else
        x = 50
    end

    local y = (scrH / 2) - (h / 2)
    -- Header
    surface.SetFont("CYR_Notify_Header")
    local header = "NEW MESSAGE"
    surface.SetAlphaMultiplier(alpha / 255)
    draw.SimpleText(header, "CYR_Notify_Header", x, y, CYR.COLORS.PrimaryBright)
    local nameY = y + 20
    if notif.groupName then
        draw.SimpleText(string.upper(notif.groupName), "CYR_Notify_Text", x, nameY, Color(150, 150, 150))
        nameY = nameY + 15
    end

    draw.SimpleText(string.upper(notif.name), "CYR_Notify_Name", x, nameY, CYR.COLORS.Secondary)
    -- Box
    local boxY = nameY + 30
    local boxH = 50
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(x, boxY, w, boxH)
    surface.SetDrawColor(CYR.COLORS.PrimaryBright)
    surface.DrawOutlinedRect(x, boxY, w, boxH)
    -- Message Text
    local msgText = notif.text
    if notif.data and notif.data.isImage then msgText = "[IMAGE]" end
    if #msgText > 45 then msgText = string.sub(msgText, 1, 45) .. "..." end
    draw.SimpleText(msgText, "CYR_Notify_Text", x + 10, boxY + boxH / 2, CYR.COLORS.PrimaryBright, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    -- Footer
    draw.SimpleText("READ MESSAGE [F6]", "CYR_Notify_Footer", x + w, boxY + boxH + 5, CYR.COLORS.Secondary, TEXT_ALIGN_RIGHT)
    -- Queue count if > 1
    if #CYR.Net.Notifications > 1 then draw.SimpleText("+" .. (#CYR.Net.Notifications - 1) .. " MORE", "CYR_Notify_Footer", x, boxY + boxH + 5, CYR.COLORS.Secondary, TEXT_ALIGN_LEFT) end
    surface.SetAlphaMultiplier(1)
end)

hook.Add("PlayerButtonDown", "CYR_Net_OpenMessage", function(ply, button)
    if button == KEY_F6 and #CYR.Net.Notifications > 0 then
        local notif = CYR.Net.Notifications[1]
        if not IsValid(CYR_NET_FRAME) then CYR_NET_FRAME = vgui.Create("CYRNetMenu") end
        if IsValid(CYR_NET_FRAME) and IsValid(CYR_NET_FRAME.socialPanel) then
            if notif.type == "comment" or notif.type == "mention" or notif.type == "like" then
                if notif.data and notif.data.postID then netstream.Start("NetSocialGetPostDetails", notif.data.postID) end
            elseif notif.type == "chess_invite" then
                CYR_NET_FRAME.socialPanel:Navigate("net://coolmath.games/chess", "COOLMATH_CHESS")
                -- Slight delay to allow DHTML to load before injecting JS
                local lobbyID = notif.data.lobbyID
                if lobbyID then
                    timer.Simple(1, function()
                        if IsValid(CYR_NET_FRAME) and IsValid(CYR_NET_FRAME.socialPanel) then
                            -- Find the DHTML control. Assuming container's first child is DHTML
                            local dhtml = CYR_NET_FRAME.socialPanel.container:GetChildren()[1]
                            if IsValid(dhtml) and dhtml.RunJavascript then dhtml:RunJavascript("document.getElementById('lobby-in').value = '" .. lobbyID .. "';") end
                        end
                    end)
                end
            else
                local partnerID = notif.partnerID
                CYR_NET_FRAME.socialPanel:Navigate("net://messages", "MESSAGES", partnerID)
            end
        end

        -- Remove current notification
        table.remove(CYR.Net.Notifications, 1)
    end
end)

netstream.Hook("NetChessInvited", function(senderName, lobbyID)
    surface.PlaySound("buttons/blip1.wav")
    CYR.Net.ShowNotification(senderName, "Invited you to play Chess", 0, "GAME INVITE", "chess_invite", {
        lobbyID = lobbyID
    })
end)

concommand.Add("CYR_sim_msg", function(ply, cmd, args)
    local text = table.concat(args, " ")
    if text == "" then text = "Hey! Letting you know I got a job for you." end
    CYR.Net.ShowNotification("Regina Jones", text, 0)
end)

netstream.Hook("NetMsgReceive", function(partnerID, msgData)
    if IsValid(CYR_NET_FRAME) and IsValid(CYR_NET_FRAME.socialPanel) and IsValid(CYR_NET_FRAME.socialPanel.messengerPanel) and CYR_NET_FRAME.socialPanel.messengerPanel.activeContact == partnerID then
        CYR_NET_FRAME.socialPanel.messengerPanel:AddMessage(msgData)
        -- If messaging self, show both sides for testing
        local myID = LocalPlayer():getChar():getID()
        if partnerID == myID and msgData.sender == myID then
            local fakeMsg = table.Copy(msgData)
            fakeMsg.sender = -1 -- Force "Them" side
            CYR_NET_FRAME.socialPanel.messengerPanel:AddMessage(fakeMsg)
        end
    else
        -- Notification
        local name = msgData.senderName or "Unknown"
        local text = msgData.text
        local isImage = (msgData.type == "image") or (text:find("^http") and (text:find(".jpg") or text:find(".png") or text:find(".gif") or text:find(".jpeg")))
        CYR.Net.ShowNotification(name, text, partnerID, msgData.groupName, "message", {
            isImage = isImage
        })
    end
end)

netstream.Hook("NetSocialProfileData", function(data)
    if IsValid(CYR_NET_FRAME) and IsValid(CYR_NET_FRAME.socialPanel) then
        CYR_NET_FRAME.socialPanel.profile = data
        if data then
            if CYR_NET_FRAME.socialPanel.state == "LOADING" or CYR_NET_FRAME.socialPanel.state == "CREATE_PROFILE" then CYR_NET_FRAME.socialPanel:Navigate("net://feed", "FEED") end
        else
            CYR_NET_FRAME.socialPanel:Navigate("net://create_profile", "CREATE_PROFILE")
        end
    end
end)

netstream.Hook("NetSocialSendPosts", function(posts, offset) if IsValid(CYR_NET_FRAME) and IsValid(CYR_NET_FRAME.socialPanel) then CYR_NET_FRAME.socialPanel:SetPosts(posts, offset) end end)
netstream.Hook("NetSocialSendComments", function(comments) if IsValid(CYR_NET_FRAME) and IsValid(CYR_NET_FRAME.socialPanel) then CYR_NET_FRAME.socialPanel:SetComments(comments) end end)
netstream.Hook("NetSocialPostUpdate", function(post) if IsValid(CYR_NET_FRAME) and IsValid(CYR_NET_FRAME.socialPanel) then CYR_NET_FRAME.socialPanel:UpdatePost(post) end end)
netstream.Hook("NetSocialProfileDetails", function(profile, posts)
    if IsValid(CYR_NET_FRAME) and IsValid(CYR_NET_FRAME.socialPanel) then
        CYR_NET_FRAME.socialPanel:Navigate("net://profile/" .. profile.handle, "PROFILE_VIEW", {
            profile = profile,
            posts = posts
        })
    end
end)

netstream.Hook("NetSocialPostDetails", function(post) if IsValid(CYR_NET_FRAME) and IsValid(CYR_NET_FRAME.socialPanel) then CYR_NET_FRAME.socialPanel:Navigate("net://posts/" .. post.id, "POST_VIEW", post) end end)
netstream.Hook("NetSocialSearchResults", function(results) if IsValid(CYR_NET_FRAME) and IsValid(CYR_NET_FRAME.socialPanel) then CYR_NET_FRAME.socialPanel:Navigate("net://search", "SEARCH_RESULTS", results) end end)
netstream.Hook("NetSocialSendNotifications", function(notifs)
    -- If the Feed DHTML is active, populate its dropdown instead of opening a separate VGUI window.
    if IsValid(CYR_NET_FRAME) and IsValid(CYR_NET_FRAME.socialPanel) and IsValid(CYR_NET_FRAME.socialPanel.feedPanel) and CYR_NET_FRAME.socialPanel.feedPanel.SetNotifications then
        CYR_NET_FRAME.socialPanel.feedPanel:SetNotifications(notifs)
        return
    end

    local f = vgui.Create("DFrame")
    f:SetSize(400, 500)
    f:Center()
    f:SetTitle("Notifications")
    f:MakePopup()
    local scroll = f:Add("DScrollPanel")
    scroll:Dock(FILL)
    for _, n in ipairs(notifs) do
        local p = scroll:Add("DPanel")
        p:Dock(TOP)
        p:SetTall(60)
        p:DockMargin(0, 0, 0, 5)
        p.Paint = function(s, w, h)
            surface.SetDrawColor(0, 0, 0, 200)
            surface.DrawRect(0, 0, w, h)
            if not n.read then
                surface.SetDrawColor(CP_RED)
                surface.DrawOutlinedRect(0, 0, w, h)
            else
                surface.SetDrawColor(CP_CYAN)
                surface.DrawOutlinedRect(0, 0, w, h)
            end
        end

        local lbl = p:Add("DLabel")
        lbl:Dock(FILL)
        lbl:DockMargin(10, 5, 10, 5)
        lbl:SetText(n.text)
        lbl:SetWrap(true)
        lbl:SetTextColor(CP_CYAN)
        local btn = p:Add("DButton")
        btn:Dock(FILL)
        btn:SetText("")
        btn:SetPaintBackground(false)
        btn.DoClick = function()
            netstream.Start("NetSocialMarkNotificationRead", n.id)
            f:Close()
            if n.type == "mention" or n.type == "comment" then if n.data and n.data.postID then netstream.Start("NetSocialGetPostDetails", n.data.postID) end end
        end
    end
end)

local FRAME = {}
function FRAME:Init()
    local w, h = ScrW(), ScrH()
    self:SetSize(w - 100, h - 100)
    self:SetPos(50, 50)
    self:MakePopup()
    self:SetTitle("")
    self:ShowCloseButton(false)
    self.activeTab = "SOCIAL"
    self.subHeader = nil
    -- Compact Layout
    self.content = self:Add("DPanel")
    self.content:Dock(FILL)
    self.content:DockMargin(20, 50, 20, 20) -- Push down below header
    self.content.Paint = function() end
    -- Only Social Panel now
    self.socialPanel = self.content:Add("CYRNetSocialPanel")
    self.socialPanel:Dock(FILL)
    self.socialPanel:SetVisible(true)
    -- Minimize Button
    local minBtn = self:Add("DButton")
    minBtn:SetText("_")
    minBtn:SetPos(w - 100 - 80, 10)
    minBtn:SetSize(30, 30)
    minBtn:SetColor(CP_CYAN)
    minBtn.Paint = function() end
    minBtn.DoClick = function()
        self:SetVisible(false)
        self:SetMouseInputEnabled(false)
        self:SetKeyboardInputEnabled(false)
    end

    -- Close Button
    local closeBtn = self:Add("DButton")
    closeBtn:SetText("X")
    closeBtn:SetPos(w - 100 - 40, 10)
    closeBtn:SetSize(30, 30)
    closeBtn:SetColor(CP_RED)
    closeBtn.Paint = function() end
    closeBtn.DoClick = function() self:Close() end
    -- Title
    local title = self:Add("DLabel")
    title:SetText("THE NET")
    title:SetPos(30, 15)
    title:SetFont("DermaLarge")
    title:SetTextColor(CP_CYAN)
    title:SizeToContents()
end

function FRAME:SetSubHeader(text)
    self.subHeader = text
end

function FRAME:Paint(w, h)
    -- Background
    surface.SetDrawColor(CP_BG)
    surface.DrawRect(0, 0, w, h)
    -- Header Line
    surface.SetDrawColor(CP_CYAN)
    surface.DrawRect(20, 48, w - 40, 2)
    -- Right Red Line
    surface.SetDrawColor(CP_RED)
    surface.DrawRect(w - 5, 60, 2, h - 120)
    -- Sub Header
    if self.subHeader and self.activeTab == "MESSENGER" then
        draw.SimpleText(" > ", "DermaLarge", 250, 15, Color(150, 150, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(string.upper(self.subHeader), "DermaLarge", 280, 15, CP_CYAN, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
end

vgui.Register("CYRNetMenu", FRAME, "DFrame")
netstream.Hook("NetOpen", function(targetHandle)
    print("[CYR DEBUG] NetOpen called with handle: " .. tostring(targetHandle))
    if IsValid(CYR_NET_FRAME) then
        if CYR_NET_FRAME:IsVisible() and not targetHandle then
            print("[CYR DEBUG] Frame visible and no handle, hiding.")
            CYR_NET_FRAME:SetVisible(false)
            CYR_NET_FRAME:SetMouseInputEnabled(false)
            CYR_NET_FRAME:SetKeyboardInputEnabled(false)
            return
        end

        print("[CYR DEBUG] Showing existing frame.")
        CYR_NET_FRAME:SetVisible(true)
        CYR_NET_FRAME:MakePopup()
    else
        print("[CYR DEBUG] Creating new CYRNetMenu frame.")
        CYR_NET_FRAME = vgui.Create("CYRNetMenu")
    end

    if targetHandle then
        if string.find(targetHandle, "net://") or string.find(targetHandle, "ssh://") then
            if IsValid(CYR_NET_FRAME.socialPanel) then CYR_NET_FRAME.socialPanel:ResolveURL(targetHandle) end
        else
            netstream.Start("NetSocialGetProfileDetails", targetHandle)
        end
    end
end)

netstream.Hook("NetSocialProfileData", function(data)
    print("[CYR DEBUG] NetSocialProfileData received. Data: " .. tostring(data))
    if IsValid(CYR_NET_FRAME) then
        print("[CYR DEBUG] CYR_NET_FRAME is valid.")
        if IsValid(CYR_NET_FRAME.socialPanel) then
            print("[CYR DEBUG] socialPanel is valid. Setting profile data.")
            CYR_NET_FRAME.socialPanel.profile = data
            if not data then
                print("[CYR DEBUG] No profile data, navigating to CREATE_PROFILE.")
                CYR_NET_FRAME.socialPanel:Navigate("net://create_profile", "CREATE_PROFILE")
            else
                print("[CYR DEBUG] Profile data found, navigating to FEED.")
                CYR_NET_FRAME.socialPanel:Navigate("net://feed", "FEED")
            end
        else
            print("[CYR DEBUG] ERROR: socialPanel is INVALID.")
        end
    else
        print("[CYR DEBUG] ERROR: CYR_NET_FRAME is INVALID.")
    end
end)

CYR.Net.NeonCities = CYR.Net.NeonCities or {}
CYR.Net.NeonCities.MySites = {} -- Cache of user's sites
-- HTML Sanitizer
-- Strips script tags, javascript protocols, and event handlers.
function CYR.Net.NeonCities.SanitizeHTML(html)
    local clean = html
    clean = string.gsub(clean, "<script.-[^>]*>.-</script>", "")
    clean = string.gsub(clean, "<script.-[^>]*>", "")
    clean = string.gsub(clean, "</script>", "")
    clean = string.gsub(clean, " on%w+=\"[^\"]*\"", "")
    clean = string.gsub(clean, " on%w+='[^']*'", "")
    clean = string.gsub(clean, "javascript:", "")
    clean = string.gsub(clean, "vbscript:", "")
    clean = string.gsub(clean, "data:", "")
    clean = string.gsub(clean, "<iframe.-[^>]*>.-</iframe>", "")
    clean = string.gsub(clean, "<object.-[^>]*>.-</object>", "")
    clean = string.gsub(clean, "<embed.-[^>]*>.-</embed>", "")
    clean = string.gsub(clean, "<applet.-[^>]*>.-</applet>", "")
    clean = string.gsub(clean, "<meta.-[^>]*>", "")
    return clean
end

-- Network Receivers
net.Receive("NetNeonCitiesData", function()
    local handle = net.ReadString()
    local content = net.ReadString()
    local panel = CYR_NET_FRAME and CYR_NET_FRAME.socialPanel
    if IsValid(panel) then
        if panel.state == "NEONCITIES_VIEW" and panel.currentNeonHandle == handle then
            panel:RenderNeonPage(content)
        elseif panel.state == "NEONCITIES_EDITOR" and panel.currentNeonHandle == handle then
            -- Load content into editor
            if panel.neonEditorLoadContent then panel.neonEditorLoadContent(content) end
        end
    end
end)

net.Receive("NetNeonCitiesError", function()
    local msg = net.ReadString()
    if string.StartWith(msg, "SUCCESS:") then
        chat.AddText(Color(0, 255, 0), "[NEONCITIES] " .. string.sub(msg, 10))
        -- Refresh dashboard if open
        local panel = CYR_NET_FRAME and CYR_NET_FRAME.socialPanel
        if IsValid(panel) and panel.state == "NEONCITIES_HOME" then
            net.Start("NetNeonCitiesFetch")
            net.WriteString("my_sites")
            net.SendToServer()
        end
    else
        chat.AddText(Color(255, 0, 0), "[NEONCITIES] " .. msg)
    end
end)

net.Receive("NetNeonCitiesMySites", function()
    local sites = net.ReadTable()
    CYR.Net.NeonCities.MySites = sites
    -- Refresh dashboard if open
    local panel = CYR_NET_FRAME and CYR_NET_FRAME.socialPanel
    if IsValid(panel) and panel.state == "NEONCITIES_HOME" and panel.RefreshDashboard then panel.RefreshDashboard() end
end)

-- Create Site Modal
function CYR.Net.NeonCities.OpenCreateModal(onSuccess)
    local frame = vgui.Create("DFrame")
    frame:SetSize(400, 200)
    frame:Center()
    frame:SetTitle("")
    frame:MakePopup()
    frame:ShowCloseButton(false)
    frame.Paint = function(s, w, h)
        surface.SetDrawColor(10, 10, 15, 250)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(0, 255, 255)
        surface.DrawOutlinedRect(0, 0, w, h, 2)
        draw.SimpleText("CREATE NEW NODE", "DermaLarge", w / 2, 20, Color(0, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    local info = frame:Add("DLabel")
    info:SetPos(20, 60)
    info:SetSize(360, 20)
    info:SetText("Enter a unique handle for your site:")
    info:SetTextColor(Color(100, 100, 150))
    local entry = frame:Add("DTextEntry")
    entry:SetPos(20, 85)
    entry:SetSize(360, 30)
    entry:SetFont("DermaDefaultBold")
    entry:SetPlaceholderText("my_cool_site")
    entry.Paint = function(s, w, h)
        surface.SetDrawColor(20, 20, 30)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(0, 255, 255)
        surface.DrawOutlinedRect(0, 0, w, h)
        s:DrawTextEntryText(Color(0, 255, 255), Color(0, 200, 255), Color(0, 255, 255))
    end

    local preview = frame:Add("DLabel")
    preview:SetPos(20, 120)
    preview:SetSize(360, 20)
    preview:SetText("URL: net://.neoncities.net")
    preview:SetTextColor(Color(80, 80, 120))
    entry.OnChange = function(s)
        local val = s:GetValue():lower():gsub("[^%w_]", "")
        preview:SetText("URL: net://" .. val .. ".neoncities.net")
    end

    local cancelBtn = frame:Add("DButton")
    cancelBtn:SetPos(20, 150)
    cancelBtn:SetSize(170, 35)
    cancelBtn:SetText("CANCEL")
    cancelBtn:SetTextColor(Color(255, 100, 100))
    cancelBtn.Paint = function(s, w, h)
        surface.SetDrawColor(30, 20, 20)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(255, 100, 100)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    cancelBtn.DoClick = function() frame:Close() end
    local createBtn = frame:Add("DButton")
    createBtn:SetPos(210, 150)
    createBtn:SetSize(170, 35)
    createBtn:SetText("INITIALIZE")
    createBtn:SetTextColor(Color(0, 255, 255))
    createBtn.Paint = function(s, w, h)
        surface.SetDrawColor(20, 30, 30)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(0, 255, 255)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    createBtn.DoClick = function()
        local handle = entry:GetValue():lower():gsub("[^%w_]", "")
        if handle == "" or #handle < 3 then
            chat.AddText(Color(255, 0, 0), "[NEONCITIES] Handle must be at least 3 characters.")
            return
        end

        if #handle > 24 then
            chat.AddText(Color(255, 0, 0), "[NEONCITIES] Handle too long (max 24).")
            return
        end

        -- Send create request with default content
        local defaultContent = [[<!DOCTYPE html>
<html>
<head>
<style>
    body { background: #111; color: #0f0; font-family: monospace; padding: 40px; }
    h1 { border-bottom: 2px solid #0f0; padding-bottom: 10px; }
</style>
</head>
<body>
    <h1>]] .. handle .. [[.neoncities.net</h1>
    <p>Welcome to my corner of the net.</p>
    <p>This page is under construction.</p>
</body>
</html>]]
        net.Start("NetNeonCitiesSave")
        net.WriteString(handle)
        net.WriteString(defaultContent)
        net.SendToServer()
        frame:Close()
        if onSuccess then onSuccess(handle) end
    end
end

-- WYSIWYG Editor
function CYR.Net.NeonCities.OpenEditor(parent, handle, panel)
    parent:Clear()
    panel.currentNeonHandle = handle
    local editorMode = "split" -- "split", "code", "preview"
    local editor, previewHTML
    -- Toolbar
    local toolbar = parent:Add("DPanel")
    toolbar:Dock(TOP)
    toolbar:SetTall(50)
    toolbar.Paint = function(s, w, h)
        surface.SetDrawColor(15, 15, 20)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(0, 255, 255, 100)
        surface.DrawLine(0, h - 1, w, h - 1)
    end

    local titleLbl = toolbar:Add("DLabel")
    titleLbl:Dock(LEFT)
    titleLbl:SetWide(350)
    titleLbl:DockMargin(15, 0, 0, 0)
    titleLbl:SetText("EDITING: " .. handle .. ".neoncities.net")
    titleLbl:SetFont("DermaLarge")
    titleLbl:SetTextColor(Color(0, 255, 255))
    local backBtn = toolbar:Add("DButton")
    backBtn:Dock(RIGHT)
    backBtn:SetWide(80)
    backBtn:DockMargin(5, 10, 10, 10)
    backBtn:SetText("< BACK")
    backBtn:SetTextColor(Color(150, 150, 150))
    backBtn.Paint = function(s, w, h)
        surface.SetDrawColor(30, 30, 35)
        surface.DrawRect(0, 0, w, h)
    end

    backBtn.DoClick = function() panel:Navigate("net://neoncities.net", "NEONCITIES_HOME", {}) end
    local saveBtn = toolbar:Add("DButton")
    saveBtn:Dock(RIGHT)
    saveBtn:SetWide(100)
    saveBtn:DockMargin(5, 10, 5, 10)
    saveBtn:SetText("PUBLISH")
    saveBtn:SetTextColor(Color(0, 255, 0))
    saveBtn.Paint = function(s, w, h)
        surface.SetDrawColor(20, 40, 20)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(0, 255, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    -- View mode buttons
    local modePanel = toolbar:Add("DPanel")
    modePanel:Dock(RIGHT)
    modePanel:SetWide(250)
    modePanel:DockMargin(5, 10, 5, 10)
    modePanel.Paint = function() end
    local splitBtn, codeBtn, previewOnlyBtn
    local function updateModeButtons()
        if IsValid(splitBtn) then splitBtn:SetTextColor(editorMode == "split" and Color(0, 255, 255) or Color(100, 100, 100)) end
        if IsValid(codeBtn) then codeBtn:SetTextColor(editorMode == "code" and Color(0, 255, 255) or Color(100, 100, 100)) end
        if IsValid(previewOnlyBtn) then previewOnlyBtn:SetTextColor(editorMode == "preview" and Color(0, 255, 255) or Color(100, 100, 100)) end
    end

    splitBtn = modePanel:Add("DButton")
    splitBtn:Dock(LEFT)
    splitBtn:SetWide(80)
    splitBtn:SetText("SPLIT")
    splitBtn:SetTextColor(Color(0, 255, 255))
    splitBtn.Paint = function(s, w, h)
        surface.SetDrawColor(25, 25, 30)
        surface.DrawRect(0, 0, w, h)
        if editorMode == "split" then
            surface.SetDrawColor(0, 255, 255)
            surface.DrawOutlinedRect(0, 0, w, h)
        end
    end

    codeBtn = modePanel:Add("DButton")
    codeBtn:Dock(LEFT)
    codeBtn:SetWide(80)
    codeBtn:DockMargin(5, 0, 0, 0)
    codeBtn:SetText("RAW")
    codeBtn:SetTextColor(Color(100, 100, 100))
    codeBtn.Paint = function(s, w, h)
        surface.SetDrawColor(25, 25, 30)
        surface.DrawRect(0, 0, w, h)
        if editorMode == "code" then
            surface.SetDrawColor(0, 255, 255)
            surface.DrawOutlinedRect(0, 0, w, h)
        end
    end

    previewOnlyBtn = modePanel:Add("DButton")
    previewOnlyBtn:Dock(LEFT)
    previewOnlyBtn:SetWide(80)
    previewOnlyBtn:DockMargin(5, 0, 0, 0)
    previewOnlyBtn:SetText("PREVIEW")
    previewOnlyBtn:SetTextColor(Color(100, 100, 100))
    previewOnlyBtn.Paint = function(s, w, h)
        surface.SetDrawColor(25, 25, 30)
        surface.DrawRect(0, 0, w, h)
        if editorMode == "preview" then
            surface.SetDrawColor(0, 255, 255)
            surface.DrawOutlinedRect(0, 0, w, h)
        end
    end

    -- Main content area
    local contentArea = parent:Add("DPanel")
    contentArea:Dock(FILL)
    contentArea.Paint = function() end
    -- Left side: Format toolbar + editor
    local leftPanel = contentArea:Add("DPanel")
    leftPanel:Dock(LEFT)
    leftPanel.Paint = function(s, w, h)
        surface.SetDrawColor(20, 20, 25)
        surface.DrawRect(0, 0, w, h)
    end

    -- Format toolbar
    local formatBar = leftPanel:Add("DPanel")
    formatBar:Dock(TOP)
    formatBar:SetTall(35)
    formatBar.Paint = function(s, w, h)
        surface.SetDrawColor(25, 25, 30)
        surface.DrawRect(0, 0, w, h)
    end

    local formatBtns = {
        {
            text = "B",
            tag = "b",
            tip = "Bold"
        },
        {
            text = "I",
            tag = "i",
            tip = "Italic"
        },
        {
            text = "U",
            tag = "u",
            tip = "Underline"
        },
        {
            text = "H1",
            tag = "h1",
            tip = "Heading 1"
        },
        {
            text = "H2",
            tag = "h2",
            tip = "Heading 2"
        },
        {
            text = "H3",
            tag = "h3",
            tip = "Heading 3"
        },
        {
            text = "P",
            tag = "p",
            tip = "Paragraph"
        },
        {
            text = "DIV",
            tag = "div",
            tip = "Div Container"
        },
        {
            text = "BR",
            tag = "br",
            tip = "Line Break"
        },
        {
            text = "HR",
            tag = "hr",
            tip = "Horizontal Line"
        },
        {
            text = "A",
            tag = "a",
            tip = "Link"
        },
        {
            text = "IMG",
            tag = "img",
            tip = "Image"
        },
        {
            text = "UL",
            tag = "ul",
            tip = "Unordered List"
        },
        {
            text = "LI",
            tag = "li",
            tip = "List Item"
        },
    }

    -- Create editor
    local editorScroll = leftPanel:Add("DScrollPanel")
    editorScroll:Dock(FILL)
    editorScroll:DockMargin(5, 5, 5, 5)
    editor = editorScroll:Add("DTextEntry")
    editor:Dock(TOP)
    editor:SetMultiline(true)
    editor:SetTall(2000) -- Large enough to scroll
    editor:SetFont("DermaDefault")
    editor:SetTextColor(Color(0, 255, 200))
    editor.Paint = function(s, w, h)
        surface.SetDrawColor(10, 10, 15)
        surface.DrawRect(0, 0, w, h)
        s:DrawTextEntryText(Color(0, 255, 200), Color(0, 200, 255), Color(0, 255, 200))
    end

    editor:SetText("Loading content...")
    -- Add format buttons
    for i, btn in ipairs(formatBtns) do
        local fb = formatBar:Add("DButton")
        fb:Dock(LEFT)
        fb:SetWide(32)
        fb:DockMargin(1, 2, 0, 2)
        fb:SetText(btn.text)
        fb:SetFont("DermaDefaultBold")
        fb:SetTextColor(Color(0, 255, 255))
        fb:SetTooltip(btn.tip)
        fb.Paint = function(s, w, h)
            surface.SetDrawColor(35, 35, 40)
            surface.DrawRect(0, 0, w, h)
            if s:IsHovered() then
                surface.SetDrawColor(0, 255, 255, 50)
                surface.DrawRect(0, 0, w, h)
            end
        end

        fb.DoClick = function()
            local tag = btn.tag
            local curText = editor:GetValue()
            local insert = ""
            if tag == "hr" or tag == "br" then
                insert = "<" .. tag .. ">\n"
            elseif tag == "a" then
                Derma_StringRequest("Insert Link", "Enter URL:", "https://", function(url) Derma_StringRequest("Link Text", "Enter display text:", "Click Here", function(text) editor:SetText(curText .. '<a href="' .. url .. '">' .. text .. '</a>') end) end)
                return
            elseif tag == "img" then
                Derma_StringRequest("Insert Image", "Enter image URL:", "", function(url) editor:SetText(curText .. '<img src="' .. url .. '" style="max-width:100%;">') end)
                return
            elseif tag == "ul" then
                insert = "<ul>\n    <li>Item 1</li>\n    <li>Item 2</li>\n</ul>\n"
            else
                insert = "<" .. tag .. ">" .. "</" .. tag .. ">"
            end

            editor:SetText(curText .. insert)
        end
    end

    -- Right side: Live preview
    local rightPanel = contentArea:Add("DPanel")
    rightPanel:Dock(FILL)
    rightPanel.Paint = function(s, w, h)
        surface.SetDrawColor(5, 5, 10)
        surface.DrawRect(0, 0, w, h)
    end

    local previewLabel = rightPanel:Add("DLabel")
    previewLabel:Dock(TOP)
    previewLabel:SetTall(25)
    previewLabel:SetText("  LIVE PREVIEW")
    previewLabel:SetTextColor(Color(100, 100, 120))
    previewLabel.Paint = function(s, w, h)
        surface.SetDrawColor(15, 15, 20)
        surface.DrawRect(0, 0, w, h)
    end

    previewHTML = rightPanel:Add("DHTML")
    previewHTML:Dock(FILL)
    previewHTML:DockMargin(5, 5, 5, 5)
    previewHTML:SetHTML("<html><body style='background:#111;color:#0f0;font-family:monospace;padding:20px;'>Loading...</body></html>")
    -- Function to update layout based on mode
    local function updateLayout()
        if editorMode == "split" then
            leftPanel:SetVisible(true)
            rightPanel:SetVisible(true)
            leftPanel:SetWide(contentArea:GetWide() / 2)
        elseif editorMode == "code" then
            leftPanel:SetVisible(true)
            rightPanel:SetVisible(false)
            leftPanel:SetWide(contentArea:GetWide())
        elseif editorMode == "preview" then
            leftPanel:SetVisible(false)
            rightPanel:SetVisible(true)
        end

        updateModeButtons()
    end

    splitBtn.DoClick = function()
        editorMode = "split"
        updateLayout()
    end

    codeBtn.DoClick = function()
        editorMode = "code"
        updateLayout()
    end

    previewOnlyBtn.DoClick = function()
        editorMode = "preview"
        -- Update preview first
        if IsValid(previewHTML) and IsValid(editor) then
            local safe = CYR.Net.NeonCities.SanitizeHTML(editor:GetValue())
            previewHTML:SetHTML(safe)
        end

        updateLayout()
    end

    -- Initial layout after a frame
    timer.Simple(0, function() if IsValid(leftPanel) and IsValid(contentArea) then leftPanel:SetWide(contentArea:GetWide() / 2) end end)
    -- Load content callback
    panel.neonEditorLoadContent = function(content)
        if IsValid(editor) then
            editor:SetText(content)
            -- Auto-size editor based on content
            local lines = select(2, string.gsub(content, "\n", "")) + 1
            editor:SetTall(math.max(2000, lines * 20))
        end

        if IsValid(previewHTML) then
            local safe = CYR.Net.NeonCities.SanitizeHTML(content)
            previewHTML:SetHTML(safe)
        end
    end

    -- Update preview on change with debounce
    local updateTimer = nil
    editor.OnChange = function(s)
        if updateTimer then timer.Remove(updateTimer) end
        updateTimer = "neon_preview_" .. CurTime()
        timer.Create(updateTimer, 0.3, 1, function()
            if IsValid(previewHTML) and IsValid(editor) then
                local safe = CYR.Net.NeonCities.SanitizeHTML(editor:GetValue())
                previewHTML:SetHTML(safe)
            end
        end)
    end

    saveBtn.DoClick = function()
        local content = editor:GetValue()
        net.Start("NetNeonCitiesSave")
        net.WriteString(handle)
        net.WriteString(content)
        net.SendToServer()
        chat.AddText(Color(0, 255, 255), "[NEONCITIES] Publishing changes...")
    end

    -- Fetch existing content
    net.Start("NetNeonCitiesFetch")
    net.WriteString(handle)
    net.SendToServer()
end

-- Registration
CYR.Net.RegisterURL("net://neoncities", function(panel, url)
    print("[CYR NET] NeonCities handler executing for: " .. tostring(url))
    local lower = string.lower(url)
    local handle = ""
    -- Internal Edit Route
    if string.find(lower, "net://neoncities/edit") then
        local parts = string.Explode("/edit/", url)
        local h = parts[2]
        if h and h ~= "" then
            panel:Navigate(url, "NEONCITIES_EDITOR", {
                handle = h
            })
        else
            panel:Navigate(url, "NEONCITIES_EDITOR", {
                handle = nil
            })
        end
        return
    end

    -- Parsing Logic Handles:
    -- net://neoncities -> Home
    -- net://neoncities.net -> Home
    -- net://foo.neoncities.net -> Site "foo"
    local clean = string.Replace(lower, "net://", "")
    if string.EndsWith(clean, "/") then clean = string.sub(clean, 1, #clean - 1) end
    if clean == "neoncities" or clean == "neoncities.net" then
        handle = ""
    elseif string.EndsWith(clean, ".neoncities.net") then
        handle = string.Replace(clean, ".neoncities.net", "")
    elseif string.StartWith(clean, "neoncities/") then
        -- Support for net://neoncities/mypage
        handle = string.sub(clean, 12)
    end

    print("[CYR NET] NeonCities parsed handle: '" .. tostring(handle) .. "'")
    if handle == "" then
        print("[CYR NET] Navigating to NEONCITIES_HOME")
        panel:Navigate(url, "NEONCITIES_HOME", {})
    else
        print("[CYR NET] Navigating to NEONCITIES_VIEW for handle: " .. handle)
        net.Start("NetNeonCitiesFetch")
        net.WriteString(handle)
        net.SendToServer()
        panel:Navigate(url, "NEONCITIES_VIEW", {
            handle = handle
        })
    end
end)

CYR.Net.RegisterPage("NEONCITIES_VIEW", function(panel, data)
    panel.container:Clear()
    panel.currentNeonHandle = data.handle
    local html = panel.container:Add("DHTML")
    html:Dock(FILL)
    panel.RenderNeonPage = function(pnl, content)
        if not IsValid(html) then return end
        if content == "" or content == nil then content = "<h1>404 - No Content</h1>" end
        -- Fix black screen by ensuring basic body style if not present
        if not string.find(content, "<body") then content = "<html><body style='background:#111;color:#0f0;font-family:monospace;'>" .. content .. "</body></html>" end
        local safeContent = CYR.Net.NeonCities.SanitizeHTML(content)
        html:SetHTML(safeContent)
    end

    html:SetHTML("<html><body style='background:#000;color:#fff;'>Loading...</body></html>")
end)

CYR.Net.RegisterPage("NEONCITIES_EDITOR", function(panel, data)
    if not data.handle then
        -- No handle provided, go back to home
        panel:Navigate("net://neoncities.net", "NEONCITIES_HOME", {})
        return
    end

    CYR.Net.NeonCities.OpenEditor(panel.container, data.handle, panel)
end)

CYR.Net.RegisterPage("NEONCITIES_HOME", function(panel, data)
    print("[CYR DEBUG] Building NEONCITIES_HOME")
    panel.container:Clear()
    -- Request user's sites
    net.Start("NetNeonCitiesFetch")
    net.WriteString("my_sites")
    net.SendToServer()
    -- Main container
    local main = panel.container:Add("DPanel")
    main:Dock(FILL)
    main.Paint = function(s, w, h)
        surface.SetDrawColor(10, 10, 15)
        surface.DrawRect(0, 0, w, h)
    end

    -- Header
    local header = main:Add("DPanel")
    header:Dock(TOP)
    header:SetTall(120)
    header.Paint = function(s, w, h)
        surface.SetDrawColor(5, 5, 10)
        surface.DrawRect(0, 0, w, h)
        draw.SimpleText("NEONCITIES", "DermaLarge", w / 2, 30, Color(0, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Host Your Truth. No Scripts. No Tracking.", "DermaDefault", w / 2, 60, Color(100, 100, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        surface.SetDrawColor(0, 255, 255, 50)
        surface.DrawLine(50, 90, w - 50, 90)
    end

    -- Sites list container
    local sitesPanel = main:Add("DPanel")
    sitesPanel:Dock(FILL)
    sitesPanel:DockMargin(50, 20, 50, 20)
    sitesPanel.Paint = function() end
    -- Title row
    local titleRow = sitesPanel:Add("DPanel")
    titleRow:Dock(TOP)
    titleRow:SetTall(40)
    titleRow.Paint = function() end
    local titleLabel = titleRow:Add("DLabel")
    titleLabel:Dock(LEFT)
    titleLabel:SetText("YOUR NODES")
    titleLabel:SetFont("DermaLarge")
    titleLabel:SetTextColor(Color(0, 255, 255))
    titleLabel:SizeToContents()
    local createBtn = titleRow:Add("DButton")
    createBtn:Dock(RIGHT)
    createBtn:SetWide(180)
    createBtn:SetText("+ CREATE NEW NODE")
    createBtn:SetTextColor(Color(0, 255, 0))
    createBtn.Paint = function(s, w, h)
        surface.SetDrawColor(20, 40, 20)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(0, 255, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    createBtn.DoClick = function()
        local siteCount = #CYR.Net.NeonCities.MySites
        if siteCount >= 3 then
            chat.AddText(Color(255, 0, 0), "[NEONCITIES] Maximum nodes reached (3/3). Delete one to create more.")
            return
        end

        CYR.Net.NeonCities.OpenCreateModal(function(handle)
            -- Will auto-refresh from server response
        end)
    end

    -- Scroll panel for sites
    local scroll = sitesPanel:Add("DScrollPanel")
    scroll:Dock(FILL)
    scroll:DockMargin(0, 10, 0, 0)
    local siteList = scroll:Add("DPanel")
    siteList:Dock(FILL)
    siteList.Paint = function() end
    -- Function to refresh the dashboard
    panel.RefreshDashboard = function()
        if not IsValid(siteList) then return end
        siteList:Clear()
        local sites = CYR.Net.NeonCities.MySites
        if #sites == 0 then
            local empty = siteList:Add("DPanel")
            empty:Dock(TOP)
            empty:SetTall(100)
            empty.Paint = function(s, w, h) draw.SimpleText("No nodes initialized yet.", "DermaDefault", w / 2, h / 2, Color(80, 80, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
        else
            for i, handle in ipairs(sites) do
                local siteRow = siteList:Add("DPanel")
                siteRow:Dock(TOP)
                siteRow:SetTall(60)
                siteRow:DockMargin(0, 5, 0, 0)
                siteRow.Paint = function(s, w, h)
                    surface.SetDrawColor(20, 20, 25)
                    surface.DrawRect(0, 0, w, h)
                    surface.SetDrawColor(0, 255, 255, 50)
                    surface.DrawOutlinedRect(0, 0, w, h)
                end

                local siteName = siteRow:Add("DLabel")
                siteName:Dock(LEFT)
                siteName:SetWide(400)
                siteName:DockMargin(15, 0, 0, 0)
                siteName:SetText(handle .. ".neoncities.net")
                siteName:SetFont("DermaDefaultBold")
                siteName:SetTextColor(Color(0, 255, 255))
                local visitBtn = siteRow:Add("DButton")
                visitBtn:Dock(RIGHT)
                visitBtn:SetWide(80)
                visitBtn:DockMargin(5, 15, 10, 15)
                visitBtn:SetText("VISIT")
                visitBtn:SetTextColor(Color(0, 200, 255))
                visitBtn.Paint = function(s, w, h)
                    surface.SetDrawColor(20, 30, 35)
                    surface.DrawRect(0, 0, w, h)
                end

                visitBtn.DoClick = function()
                    panel:Navigate("net://" .. handle .. ".neoncities.net", "NEONCITIES_VIEW", {
                        handle = handle
                    })

                    net.Start("NetNeonCitiesFetch")
                    net.WriteString(handle)
                    net.SendToServer()
                end

                local editBtn = siteRow:Add("DButton")
                editBtn:Dock(RIGHT)
                editBtn:SetWide(80)
                editBtn:DockMargin(5, 15, 5, 15)
                editBtn:SetText("EDIT")
                editBtn:SetTextColor(Color(255, 200, 0))
                editBtn.Paint = function(s, w, h)
                    surface.SetDrawColor(35, 30, 20)
                    surface.DrawRect(0, 0, w, h)
                end

                editBtn.DoClick = function()
                    panel:Navigate("net://neoncities/edit/" .. handle, "NEONCITIES_EDITOR", {
                        handle = handle
                    })
                end
            end
        end

        -- Site count indicator
        local countLabel = siteList:Add("DLabel")
        countLabel:Dock(TOP)
        countLabel:SetTall(30)
        countLabel:DockMargin(0, 20, 0, 0)
        countLabel:SetText("Nodes: " .. #sites .. " / 3")
        countLabel:SetTextColor(Color(80, 80, 100))
        countLabel:SetContentAlignment(5)
    end

    -- Initial render (will update when server responds)
    panel.RefreshDashboard()
end)

concommand.Add("CYR_net", function()
    if IsValid(CYR_NET_FRAME) then
        CYR_NET_FRAME:Remove()
        CYR_NET_FRAME = nil
    end

    CYR_NET_FRAME = vgui.Create("CYRNetMenu")
    CYR_NET_FRAME:SetVisible(true)
    CYR_NET_FRAME:MakePopup()
    chat.AddText(Color(0, 255, 0), "[CYR NET] Interface Rebuilt.")
end)
