CYR = CYR or {}
CYR.UI = CYR.UI or {}
-- V.A.T.S. Targeting Tooltip HTML
local tooltipHTML = [[
<!DOCTYPE html>
<html>
<head>
    <link href="https://fonts.cdnfonts.com/css/vcr-osd-mono" rel="stylesheet">
    <link href="https://fonts.cdnfonts.com/css/share-tech-mono" rel="stylesheet">
    <style>
        :root {
            /* V.A.T.S. Phosphor Green */
            --primary: #15FF00;
            --primary-rgb: 21, 255, 0;
            --secondary: #B6FFB0;
            --bg: #020A02;
            --glow: 0 0 3px rgba(21,255,0,0.85), 0 0 7px rgba(21,255,0,0.45);
            --scan: rgba(21,255,0,0.06);
        }
        * { box-sizing: border-box; }
        body {
            margin: 0; padding: 0;
            font-family: 'Share Tech Mono', 'VCR OSD Mono', monospace;
            background: transparent;
            overflow: hidden;
            user-select: none;
            color: var(--primary);
        }
        .container {
            position: relative;
            width: 100vw; height: 100vh;
            background:
                radial-gradient(ellipse at center,
                    rgba(var(--primary-rgb), 0.10) 0%,
                    rgba(2, 10, 2, 0.96) 70%),
                var(--bg);
            border: 1px solid var(--primary);
            box-shadow:
                inset 0 0 18px rgba(var(--primary-rgb), 0.25),
                0 0 6px rgba(var(--primary-rgb), 0.35);
            display: flex; flex-direction: column;
            text-shadow: var(--glow);
            overflow: hidden;
            animation: flicker 7s infinite;
        }
        /* CRT scanlines */
        .container::before {
            content: "";
            position: absolute; inset: 0;
            background: repeating-linear-gradient(
                to bottom,
                transparent 0,
                transparent 2px,
                var(--scan) 2px,
                var(--scan) 3px
            );
            pointer-events: none;
            z-index: 5;
            animation: scanShift 14s linear infinite;
        }
        /* Vignette */
        .container::after {
            content: "";
            position: absolute; inset: 0;
            background: radial-gradient(ellipse at center,
                transparent 55%, rgba(0,0,0,0.65) 100%);
            pointer-events: none;
            z-index: 6;
        }
        @keyframes scanShift {
            0%   { background-position: 0 0; }
            100% { background-position: 0 90px; }
        }
        @keyframes flicker {
            0%, 96%, 100% { opacity: 1; }
            97%           { opacity: 0.88; }
            98%           { opacity: 1; }
            99%           { opacity: 0.82; }
        }
        @keyframes blink {
            50% { opacity: 0.15; }
        }

        /* Targeting brackets */
        .bracket {
            position: absolute;
            width: 14px; height: 14px;
            border: 2px solid var(--primary);
            box-shadow: 0 0 4px rgba(var(--primary-rgb), 0.7);
            z-index: 10;
        }
        .bracket.tl { top: 4px;    left: 4px;    border-right: none; border-bottom: none; }
        .bracket.tr { top: 4px;    right: 4px;   border-left:  none; border-bottom: none; }
        .bracket.bl { bottom: 4px; left: 4px;    border-right: none; border-top:    none; }
        .bracket.br { bottom: 4px; right: 4px;   border-left:  none; border-top:    none; }

        .topbar {
            display: flex; justify-content: space-between; align-items: center;
            padding: 7px 14px 3px 14px;
            font-size: 0.68rem;
            letter-spacing: 0.18em;
            text-transform: uppercase;
            opacity: 0.9;
            z-index: 7;
        }
        .topbar .left  { letter-spacing: 0.28em; }
        .topbar .right { display: flex; align-items: center; gap: 5px; }
        .topbar .dot {
            width: 7px; height: 7px;
            background: var(--primary);
            border-radius: 50%;
            box-shadow: 0 0 5px rgba(var(--primary-rgb), 0.9);
            animation: blink 1.1s steps(2, end) infinite;
        }

        .divider {
            height: 1px;
            margin: 2px 10px 0 10px;
            background: linear-gradient(to right,
                transparent 0%,
                rgba(var(--primary-rgb), 0.55) 15%,
                rgba(var(--primary-rgb), 0.55) 85%,
                transparent 100%);
            z-index: 7;
        }

        .header {
            padding: 6px 14px 4px 14px;
            font-size: 1.05rem;
            letter-spacing: 0.14em;
            text-transform: uppercase;
            font-weight: bold;
            position: relative;
            z-index: 7;
            display: flex; align-items: center;
        }
        .header .tick {
            opacity: 0.7;
            margin: 0 6px;
        }
        .header .name {
            flex-grow: 1;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .content {
            padding: 4px 14px 12px 14px;
            font-size: 0.82rem;
            flex-grow: 1;
            display: flex; flex-direction: column;
            position: relative;
            z-index: 7;
        }
        .stat-row {
            display: flex; align-items: baseline;
            gap: 4px;
            margin-bottom: 3px;
            line-height: 1.15;
        }
        .stat-label {
            white-space: nowrap;
            opacity: 0.9;
            text-transform: uppercase;
            letter-spacing: 0.06em;
        }
        .stat-dots {
            flex-grow: 1;
            border-bottom: 1px dotted rgba(var(--primary-rgb), 0.45);
            margin: 0 2px 4px 2px;
        }
        .stat-value {
            white-space: nowrap;
            font-weight: bold;
            letter-spacing: 0.05em;
        }
        .description {
            margin-top: 8px;
            padding-top: 6px;
            border-top: 1px solid rgba(var(--primary-rgb), 0.5);
            opacity: 0.85;
            line-height: 1.28;
            font-size: 0.76rem;
            color: var(--secondary);
            text-shadow: 0 0 3px rgba(var(--primary-rgb), 0.4);
        }
        .description:empty { display: none; }
    </style>
</head>
<body>
    <div class="container">
        <span class="bracket tl"></span>
        <span class="bracket tr"></span>
        <span class="bracket bl"></span>
        <span class="bracket br"></span>

        <div class="topbar">
            <span class="left">V.A.T.S.</span>
            <span class="right"><span class="dot"></span>ANALYZING</span>
        </div>
        <div class="divider"></div>

        <div class="header">
            <span class="tick">&gt;</span>
            <span class="name" id="item-name">LOADING...</span>
            <span class="tick">&lt;</span>
        </div>

        <div class="content">
            <div id="stats-container"></div>
            <div class="description" id="item-desc"></div>
        </div>
    </div>
    <script>
        function hexToRgb(hex) {
            var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
            return result ? {
                r: parseInt(result[1], 16),
                g: parseInt(result[2], 16),
                b: parseInt(result[3], 16)
            } : null;
        }

        function update(data) {
            // Color overrides still respected; defaults stay VATS green.
            if (data.colors) {
                const root = document.documentElement;
                if (data.colors.primary) {
                    root.style.setProperty('--primary', data.colors.primary);
                    const rgb = hexToRgb(data.colors.primary);
                    if (rgb) {
                        root.style.setProperty('--primary-rgb',
                            `${rgb.r}, ${rgb.g}, ${rgb.b}`);
                        root.style.setProperty('--glow',
                            `0 0 3px rgba(${rgb.r},${rgb.g},${rgb.b},0.85), ` +
                            `0 0 7px rgba(${rgb.r},${rgb.g},${rgb.b},0.45)`);
                        root.style.setProperty('--scan',
                            `rgba(${rgb.r},${rgb.g},${rgb.b},0.06)`);
                    }
                }
                if (data.colors.secondary) {
                    root.style.setProperty('--secondary', data.colors.secondary);
                }
            }

            document.getElementById('item-name').innerText = data.name || "UNKNOWN TARGET";
            document.getElementById('item-desc').innerHTML = (data.desc || "").replace(/\n/g, '<br>');

            const stats = document.getElementById('stats-container');
            stats.innerHTML = '';

            // data.stats expected as { "Weight": "5kg", "Value": "$100", ... }
            if (data.stats) {
                for (const [key, val] of Object.entries(data.stats)) {
                    const row = document.createElement('div');
                    row.className = 'stat-row';
                    row.innerHTML =
                        `<span class='stat-label'>${key}</span>` +
                        `<span class='stat-dots'></span>` +
                        `<span class='stat-value'>${val}</span>`;
                    stats.appendChild(row);
                }
            }
        }
    </script>
</body>
</html>
]]
local activeTooltip = nil
--- Creates or updates a DHTML tooltip at (x, y)
-- @param data Table containing { name="Name", desc="Description", stats={ Key="Value" } }
-- @param x Screen X position
-- @param y Screen Y position
function CYR.UI.ShowTooltip(data, x, y)
    -- If exists, remove (or potentially update position/content to avoid flicker)
    -- For simplicity, recreate to ensure clean state
    if IsValid(activeTooltip) then activeTooltip:Remove() end
    local w, h = 320, 220 -- Default size (sized for V.A.T.S. layout)
    local frame = vgui.Create("DFrame")
    frame:SetSize(w, h)
    frame:SetPos(x, y)
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    -- Follow Mouse Logic
    frame.Think = function(self)
        local mx, my = gui.MouseX(), gui.MouseY()
        local tx, ty = mx + 15, my + 15
        -- Flip if going off right edge
        if tx + w > ScrW() then tx = mx - w - 15 end
        -- Flip if going off bottom edge
        if ty + h > ScrH() then ty = my - h - 15 end
        -- Hard clamp
        tx = math.Clamp(tx, 0, ScrW() - w)
        ty = math.Clamp(ty, 0, ScrH() - h)
        self:SetPos(tx, ty)
    end

    -- Ensure it renders on top of the F1 menu (which is a Popup)
    frame:MakePopup()
    -- But disable input so it passes through
    frame:SetMouseInputEnabled(false)
    frame:SetKeyboardInputEnabled(false)
    frame.Paint = function() end -- Invisible frame, HTML handles bg
    local html = vgui.Create("DHTML", frame)
    html:Dock(FILL)
    html:SetHTML(tooltipHTML)
    html:SetMouseInputEnabled(false) -- Pass through
    html:SetKeyboardInputEnabled(false)
    -- Inject Data
    timer.Simple(0.05, function()
        if IsValid(html) then
            local json = util.TableToJSON(data or {})
            -- Escape basic issues
            json = json:gsub("\\", "\\\\"):gsub("\"", "\\\"")
            html:Call("update(JSON.parse(\"" .. json .. "\"))")
        end
    end)

    activeTooltip = frame
end

function CYR.UI.HideTooltip()
    if IsValid(activeTooltip) then activeTooltip:Remove() end
    activeTooltip = nil
end