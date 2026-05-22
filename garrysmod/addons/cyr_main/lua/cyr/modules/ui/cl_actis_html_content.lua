CYR = CYR or {}
CYR.UI = CYR.UI or {}
CYR.UI.ActisCombatHTML = [[
<!DOCTYPE html>
<html lang="en">
<head>
    <link href="https://fonts.cdnfonts.com/css/vcr-osd-mono" rel="stylesheet">
    <style>
        :root {
            /* Mirrors the AP / Active Effects HUD palette in nut_cswep.lua's
               DrawHUD so this menu reads as the same widget family. */
            --hud-bg:    rgba(0, 47, 0, 0.59);   /* Color(0,47,0,150)  */
            --hud-line:  rgba(0, 238, 0, 0.59);  /* Color(0,238,0,150) */
            --hud-text:  rgba(0, 238, 0, 0.85);
            --hud-bright:#00EE00;
            --hud-inv:   #001004;
            --hud-dim:   rgba(0, 100, 0, 0.35);
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            padding: 0;
            background: transparent;
            font-family: 'VCR OSD Mono', monospace;
            color: var(--hud-text);
            overflow: hidden;
            width: 100vw;
            height: 100vh;
            user-select: none;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* === Outer HUD panel === */
        .screen {
            position: relative;
            width: 100%;
            height: 100%;
            background: var(--hud-bg);
            border: 1px solid var(--hud-line);
            padding: 10px 12px 10px 12px;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        /* === [ACTIONS] header === */
        .header {
            text-align: center;
            color: var(--hud-text);
            letter-spacing: 2px;
            font-size: 1.0em;
            padding-bottom: 6px;
            border-bottom: 1px solid var(--hud-line);
            margin-bottom: 8px;
        }

        /* Close button: simple bordered "X" */
        .close-btn {
            position: absolute;
            top: 6px;
            right: 10px;
            cursor: pointer;
            padding: 1px 7px;
            border: 1px solid var(--hud-line);
            background: var(--hud-bg);
            color: var(--hud-text);
            font-size: 0.85em;
        }
        .close-btn:hover {
            background: var(--hud-line);
            color: var(--hud-inv);
        }

        /* === Reusable HUD box (matches the AP / BUFFS / COOLDOWNS rects) === */
        .hud-box {
            position: relative;
            background: var(--hud-bg);
            border: 1px solid var(--hud-line);
            padding: 8px 10px;
            margin: 4px 2px;
        }
        .hud-box .box-title {
            text-align: center;
            color: var(--hud-text);
            letter-spacing: 2px;
            font-size: 0.95em;
            padding-bottom: 4px;
            margin-bottom: 6px;
            border-bottom: 1px solid var(--hud-line);
        }

        /* === Target dropdown row === */
        .target-panel { display: flex; align-items: center; gap: 10px; }
        .target-panel label {
            color: var(--hud-text);
            letter-spacing: 2px;
        }
        select {
            background: var(--hud-bg);
            color: var(--hud-text);
            border: 1px solid var(--hud-line);
            font-family: 'VCR OSD Mono', monospace;
            padding: 3px 8px;
            outline: none;
            flex-grow: 1;
            letter-spacing: 1px;
        }
        select option { background: #001004; color: var(--hud-text); }

        /* === Action list panel === */
        .list-panel { flex-grow: 1; display: flex; flex-direction: column; min-height: 0; }
        .list-panel .scroll {
            flex-grow: 1;
            overflow-y: auto;
            scrollbar-width: thin;
            scrollbar-color: var(--hud-line) transparent;
            padding-right: 4px;
        }
        .list-panel .scroll::-webkit-scrollbar { width: 8px; }
        .list-panel .scroll::-webkit-scrollbar-track { background: var(--hud-bg); }
        .list-panel .scroll::-webkit-scrollbar-thumb { background: var(--hud-line); }

        /* "[CATEGORY]" divider centered between two dim lines */
        .category {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 10px 0 4px 0;
            color: var(--hud-text);
            letter-spacing: 2px;
            font-size: 0.95em;
        }
        .category .label { white-space: nowrap; }
        .category .rule {
            flex-grow: 1;
            height: 1px;
            background: var(--hud-line);
            opacity: 0.6;
        }

        /* Action rows. Default = outlined HUD box; hover = dim fill;
           active = solid line fill with inverted text (same way the buttons
           on the AP HUD highlight in nut_cswep). */
        .action-btn {
            padding: 4px 8px;
            margin: 2px 0;
            border: 1px solid var(--hud-line);
            background: var(--hud-bg);
            color: var(--hud-text);
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            letter-spacing: 1px;
        }
        .action-btn:hover {
            background: var(--hud-dim);
            color: var(--hud-bright);
        }
        .action-btn.active {
            background: var(--hud-line);
            color: var(--hud-inv);
            border-color: var(--hud-line);
        }
        .action-btn.active .action-cost { color: var(--hud-inv); opacity: 0.85; }
        .action-name { font-weight: normal; }
        .action-cost { font-size: 0.9em; opacity: 0.75; }

        /* === Tooltip === */
        .tooltip {
            position: absolute;
            background: var(--hud-bg);
            border: 1px solid var(--hud-line);
            padding: 6px 9px;
            z-index: 100;
            pointer-events: none;
            display: none;
            max-width: 280px;
            font-size: 0.85em;
            line-height: 1.4;
            color: var(--hud-text);
        }
    </style>
</head>
<body>
    <div class="screen">
        <span class="close-btn" onclick="Webhooks.trigger('closeMenu')">X</span>

        <div class="header">[ACTIONS]</div>

        <div class="hud-box target-panel">
            <label>TARGET ::</label>
            <select id="part-select" onchange="Webhooks.trigger('selectPart', this.value)">
                <!-- Parts injected here -->
            </select>
        </div>

        <div class="hud-box list-panel">
            <div class="box-title">[DIRECTORY]</div>
            <div class="scroll" id="action-list">
                <!-- Actions injected here -->
            </div>
        </div>
    </div>

    <div id="custom-tooltip" class="tooltip"></div>

    <script>
        const Webhooks = {
            trigger: (name, data) => {
                if (data === undefined) data = {};
                if (window.gmod && window.gmod.webhook) {
                    window.gmod.webhook(name, typeof data === 'string' ? data : JSON.stringify(data));
                } else {
                    console.log('Webhook Triggered: ' + name, data);
                }
            }
        };

        function transparentize(hex, alpha) {
            const r = parseInt(hex.slice(1, 3), 16);
            const g = parseInt(hex.slice(3, 5), 16);
            const b = parseInt(hex.slice(5, 7), 16);
            return 'rgba(' + r + ', ' + g + ', ' + b + ', ' + alpha + ')';
        }

        function setColors(primary, secondary, tertiary) {
            // Recolour the HUD palette from the user-configured tint. The line
            // colour stays translucent (mirrors the 150 alpha on the HUD).
            document.documentElement.style.setProperty('--hud-line', transparentize(primary, 0.59));
            document.documentElement.style.setProperty('--hud-text', transparentize(primary, 0.85));
            document.documentElement.style.setProperty('--hud-bright', primary);
            // Background: same hue at ~31% of intensity, mostly transparent.
            const r = Math.floor(parseInt(primary.slice(1,3), 16) * 0.18);
            const g = Math.floor(parseInt(primary.slice(3,5), 16) * 0.18);
            const b = Math.floor(parseInt(primary.slice(5,7), 16) * 0.18);
            document.documentElement.style.setProperty('--hud-bg', 'rgba(' + r + ', ' + g + ', ' + b + ', 0.59)');
        }

        function updateParts(parts, current) {
            const select = document.getElementById('part-select');
            select.innerHTML = '';
            parts.forEach(p => {
                const opt = document.createElement('option');
                opt.value = p;
                opt.textContent = p.toUpperCase();
                if (p === current) opt.selected = true;
                select.appendChild(opt);
            });
        }

        function updateActions(categories) {
            const list = document.getElementById('action-list');
            list.innerHTML = '';
            for (const catName in categories) {
                const catDiv = document.createElement('div');
                catDiv.className = 'category';
                catDiv.innerHTML =
                    '<span class="rule"></span>' +
                    '<span class="label">[' + catName.toUpperCase() + ']</span>' +
                    '<span class="rule"></span>';
                list.appendChild(catDiv);

                categories[catName].forEach(action => {
                    const btn = document.createElement('div');
                    btn.className = 'action-btn' + (action.active ? ' active' : '');
                    btn.innerHTML =
                        '<span class="action-name">' + action.name.toUpperCase() + '</span>' +
                        '<span class="action-cost">' + (action.cost || '') + '</span>';

                    btn.onclick = () => Webhooks.trigger('selectAction', action.id);
                    btn.onmouseenter = (e) => showTooltip(e, action.desc);
                    btn.onmouseleave = hideTooltip;
                    list.appendChild(btn);
                });
            }
        }

        function showTooltip(e, text) {
            if (!text) return;
            const tt = document.getElementById('custom-tooltip');
            tt.textContent = text;
            tt.style.display = 'block';
            tt.style.left = (e.pageX + 12) + 'px';
            tt.style.top  = (e.pageY + 12) + 'px';
        }

        function hideTooltip() {
            document.getElementById('custom-tooltip').style.display = 'none';
        }
    </script>
</body>
</html>
]]
