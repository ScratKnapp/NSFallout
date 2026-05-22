CYR = CYR or {}
CYR.UI = CYR.UI or {}
CYR.UI.SafeboxHTML = [[
<!DOCTYPE html>
<html lang="en">
<head>
    <link href="https://fonts.cdnfonts.com/css/vcr-osd-mono" rel="stylesheet">
    <style>
        :root {
            /* Tactical Orange */
            --primary-color: #FF4400; 
            /* White/Grey Text */
            --secondary-color: #E0E0E0;
            /* Alert Red (Tertiary) */
            --tertiary-color: #FF0000;

            --primary-dim: rgba(255, 68, 0, 0.2); 
            --bg-color: #050505;
            --grid-color: rgba(255, 68, 0, 0.15);
        }

        body {
            margin: 0;
            padding: 0;
            background-color: transparent;
            font-family: 'VCR OSD Mono', monospace;
            color: var(--primary-color);
            overflow: hidden;
            width: 100vw;
            height: 100vh;
            user-select: none;
        }

        /* CRT Effects */
        .crt-overlay {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%; pointer-events: none; z-index: 1000;
            background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.1) 50%);
            background-size: 100% 2px;
        }
        .crt-scanline {
            width: 100%; height: 5px; background: rgba(255, 255, 255, 0.03); position: fixed; z-index: 1001;
            animation: scanline 8s linear infinite; opacity: 0.2; pointer-events: none;
        }
        @keyframes scanline { 0% { top: -10%; } 100% { top: 110%; } }

        /* Main Layout */
        .container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            grid-template-rows: 50px 1fr 40px;
            gap: 15px;
            width: 90vw;
            height: 85vh;
            margin: 7.5vh auto;
            background-color: var(--bg-color);
            
            background-image: 
                linear-gradient(var(--grid-color) 1px, transparent 1px),
                linear-gradient(90deg, var(--grid-color) 1px, transparent 1px);
            background-size: 40px 40px;
            
            border: 1px solid var(--primary-color);
            padding: 15px;
            box-sizing: border-box;
            position: relative;
        }

        /* Decorative Corners */
        .corner { position: absolute; width: 10px; height: 10px; background: transparent; z-index: 10; }
        .corner::before, .corner::after { content: ''; position: absolute; background: var(--primary-color); }
        .corner::before { width: 100%; height: 2px; top: 4px; left: 0; }
        .corner::after { width: 2px; height: 100%; top: 0; left: 4px; }
        .tl { top: -5px; left: -5px; } .tr { top: -5px; right: -5px; }
        .bl { bottom: -5px; left: -5px; } .br { bottom: -5px; right: -5px; }

        /* Header */
        header {
            grid-column: 1 / 3;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--primary-color);
            padding-bottom: 5px;
            margin-bottom: 5px;
        }
        .header-title {
            font-size: 1.8rem; text-transform: uppercase; letter-spacing: 2px;
            color: #000; background: var(--primary-color); padding: 2px 40px 2px 15px;
            font-weight: bold; clip-path: polygon(0 0, 100% 0, 95% 100%, 0% 100%);
        }
        .header-info { font-size: 1rem; text-align: right; font-weight: bold; display: flex; gap: 15px; align-items: center; }
        .close-btn { cursor: pointer; color: var(--primary-color); border: 1px solid var(--primary-color); padding: 2px 8px; font-weight:bold; }
        .close-btn:hover { background: var(--primary-color); color: #000; }

        /* Panels */
        .panel {
            border: 1px solid var(--primary-dim);
            background: rgba(10, 10, 10, 0.6);
            display: flex; flex-direction: column; position: relative;
        }
        .panel-title {
            background: linear-gradient(90deg, var(--primary-dim) 0%, transparent 50%);
            border-bottom: 1px solid var(--primary-dim);
            padding: 5px 10px; color: var(--primary-color); font-size: 1.1rem; letter-spacing: 1px;
            display: flex; justify-content: space-between; align-items: center;
        }
        .panel-meta { font-size: 0.8rem; opacity: 0.7; }

        /* Grids */
        .inventory-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(64px, 1fr));
            grid-auto-rows: 64px;
            gap: 5px;
            overflow-y: auto; padding: 10px; flex-grow: 1;
            align-content: start;
        }

        /* Slots */
        .slot {
            width: 64px; height: 64px;
            border: 1px solid var(--primary-dim);
            background: rgba(20, 20, 20, 0.9);
            position: relative; cursor: pointer; transition: all 0.1s;
            display: flex; align-items: center; justify-content: center;
        }
        .slot:hover { border-color: var(--primary-color); box-shadow: inset 0 0 10px var(--primary-dim); background: rgba(0,0,0,0.8); }
        .slot-count { position: absolute; bottom: 2px; right: 2px; font-size: 0.8rem; color: #fff; text-shadow: 1px 1px 0 #000; font-weight: bold; }
        .slot-label {
            position: absolute; bottom: 2px; left: 2px; right: 2px; 
            font-size: 0.6rem; color: var(--primary-color); opacity: 0.8; 
            white-space: nowrap; overflow: hidden; text-overflow: ellipsis; text-align: center; pointer-events: none;
            background: rgba(0,0,0,0.5);
        }

        /* Scrollbar */
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: rgba(0, 0, 0, 0.3); }
        ::-webkit-scrollbar-thumb { background: var(--primary-dim); }
        ::-webkit-scrollbar-thumb:hover { background: var(--primary-color); }

        footer {
            grid-column: 1 / 3;
            border-top: 1px solid var(--primary-dim);
            padding-top: 5px;
            display: flex; justify-content: space-between; align-items: center; opacity: 0.7; font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="crt-overlay"></div>
    <div class="crt-scanline"></div>

    <div class="container">
        <div class="corner tl"></div><div class="corner tr"></div><div class="corner bl"></div><div class="corner br"></div>

        <header>
            <div class="header-title">SECURE STORAGE // SAFEBOX</div>
            <div class="header-info">
                <span>STATUS: <span style="color:#0f0">CONNECTED</span></span>
                <div class="close-btn" onclick="closeMenu()">[ X ]</div>
            </div>
        </header>

        <!-- Player Inventory -->
        <div class="panel">
            <div class="panel-title">
                LOCAL INVENTORY
                <span class="panel-meta" id="local-weight">0 / 0kg</span>
            </div>
            <div class="inventory-grid" id="local-grid"></div>
        </div>

        <!-- External (Safebox) Inventory -->
        <div class="panel">
            <div class="panel-title">
                REMOTE STORAGE
                <span class="panel-meta" id="remote-weight">0 / 0kg</span>
            </div>
            <div class="inventory-grid" id="remote-grid"></div>
        </div>

        <footer>
            <span>SYSTEM: ONLINE</span>
            <span>TRANSFER MODE: ACTIVE</span>
        </footer>
    </div>

    <script>
        const root = document.documentElement;
        
        // --- WEBHOOKS SYSTEM ---
        const Webhooks = {
            triggers: {},
            trigger: function(name, data) { if (this.triggers[name]) this.triggers[name](data); },
            callLua: function(hookName, data) { if (window.gmod) gmod.webhook(hookName, data); },
            register: function(name, callback) { this.triggers[name] = callback; }
        };

        function closeMenu() { Webhooks.callLua('closeMenu'); }

        function renderItem(item, container, isRemote) {
            const el = document.createElement('div');
            el.className = 'slot';
            el.title = item.name + "\n" + (item.desc || "");
            
            if (item.icon) {
                el.style.backgroundImage = `url('${item.icon}')`;
                el.style.backgroundSize = "contain"; 
                el.style.backgroundRepeat = "no-repeat";
                el.style.backgroundPosition = "center";
            } else {
                el.innerText = item.name.substring(0, 3);
            }

            if (item.count > 1) {
                const count = document.createElement('div');
                count.className = 'slot-count';
                count.innerText = "x" + item.count;
                el.appendChild(count);
            }

            const label = document.createElement('div');
            label.className = 'slot-label';
            label.innerText = item.name;
            // el.appendChild(label); // Optional: Hide label if desired, tooltip is safer for layout

            // Interactions
            el.onclick = () => {
                // Transfer Logic
                // If local -> transfer to remote
                // If remote -> transfer to local
                const action = isRemote ? "take" : "give";
                Webhooks.callLua('transferItem', { itemID: item.id, action: action });
            };
            
            el.oncontextmenu = (e) => {
                e.preventDefault();
                // Maybe open context menu for specific actions?
                Webhooks.callLua('contextMenu', { itemID: item.id, isRemote: isRemote });
            };

            // Tooltip handled by Lua usually, but simple title works for now
            el.onmouseenter = () => {
                Webhooks.callLua('showTooltip', {
                    name: item.name,
                    desc: item.desc,
                    stats: { "WEIGHT": item.weight + "kg", "CATEGORY": item.category }
                });
            };
            el.onmouseleave = () => Webhooks.callLua('hideTooltip');

            container.appendChild(el);
        }

        function updateGrid(gridId, items, weightId, weightData) {
            const grid = document.getElementById(gridId);
            grid.innerHTML = '';
            items.forEach(item => renderItem(item, grid, gridId === 'remote-grid'));
            
            if (weightId && weightData) {
                document.getElementById(weightId).innerText = `${weightData.current} / ${weightData.max}kg`;
            }
        }

        Webhooks.register('updateLocal', (data) => {
            updateGrid('local-grid', data.items, 'local-weight', data.weight);
        });

        Webhooks.register('updateRemote', (data) => {
            updateGrid('remote-grid', data.items, 'remote-weight', data.weight);
        });
        
        Webhooks.register('loadSettings', (data) => {
            if(data.primary) root.style.setProperty('--primary-color', data.primary);
            if(data.secondary) root.style.setProperty('--secondary-color', data.secondary);
            if(data.tertiary) root.style.setProperty('--tertiary-color', data.tertiary);
            
            // Recalc dims
             if(data.primary) {
                // Simple hex to rgb
                let c = data.primary.substring(1);      // strip #
                let rgb = parseInt(c, 16);   // convert rrggbb to decimal
                let r = (rgb >> 16) & 0xff;  // extract red
                let g = (rgb >>  8) & 0xff;  // extract green
                let b = (rgb >>  0) & 0xff;  // extract blue
                
                root.style.setProperty('--primary-dim', `rgba(${r}, ${g}, ${b}, 0.2)`);
                root.style.setProperty('--grid-color', `rgba(${r}, ${g}, ${b}, 0.15)`);
             }
        });

    </script>
</body>
</html>
]]