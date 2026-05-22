CYR.UI = CYR.UI or {}
print("[CYR DEBUG] Inside cl_f4_html_content.lua")
CYR.UI.InventoryHTML = [[
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

        /* CRT Effects - Toned down for clarity */
        .crt-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 1000;
            background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.1) 50%);
            background-size: 100% 2px;
        }

        .crt-scanline {
            width: 100%;
            height: 5px;
            background: rgba(255, 255, 255, 0.03);
            position: fixed;
            z-index: 1001;
            animation: scanline 8s linear infinite;
            opacity: 0.2;
            pointer-events: none;
        }

        @keyframes scanline {
            0% { top: -10%; }
            100% { top: 110%; }
        }

        /* Main Layout */
        .container {
            display: grid;
            grid-template-columns: 320px 1fr 340px;
            grid-template-rows: 50px 1fr 60px;
            gap: 10px;
            width: 96vw;
            height: 92vh;
            margin: 4vh auto;
            background-color: var(--bg-color);
            
            /* Technical Grid Pattern */
            background-image: 
                linear-gradient(var(--grid-color) 1px, transparent 1px),
                linear-gradient(90deg, var(--grid-color) 1px, transparent 1px);
            background-size: 40px 40px;
            
            border: 1px solid var(--primary-color);
            padding: 15px;
            box-sizing: border-box;
            position: relative;
        }

        /* Decorative Corners - Plus signs */
        .corner {
            position: absolute;
            width: 10px;
            height: 10px;
            background: transparent;
            z-index: 10;
        }
        /* Using pseudo-elements for crosshairs at corners */
        .corner::before, .corner::after {
            content: '';
            position: absolute;
            background: var(--primary-color);
        }
        .corner::before { width: 100%; height: 2px; top: 4px; left: 0; }
        .corner::after { width: 2px; height: 100%; top: 0; left: 4px; }
        
        .tl { top: -5px; left: -5px; }
        .tr { top: -5px; right: -5px; }
        .bl { bottom: -5px; left: -5px; }
        .br { bottom: -5px; right: -5px; }

        /* Header */
        header {
            grid-column: 1 / 4;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--primary-color);
            padding-bottom: 5px;
            margin-bottom: 5px;
        }

        .header-title {
            font-size: 2rem;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: var(--secondary-color);
            background: var(--primary-color); /* Tactical Label Style */
            padding: 2px 40px 2px 15px; /* Increased Right Padding */
            font-weight: bold;
            clip-path: polygon(0 0, 100% 0, 95% 100%, 0% 100%); /* Slight angle */
            color: #000;
        }

        .header-info {
            font-size: 1rem;
            text-align: right;
            display: flex;
            gap: 15px;
            align-items: center;
            font-weight: bold;
        }
        
        /* Settings Icon */
        .settings-btn {
            font-size: 1.2rem;
            cursor: pointer;
            color: var(--primary-color);
            border: 1px solid var(--primary-color);
            padding: 2px 6px;
        }
        .settings-btn:hover {
            color: #000;
            background: var(--primary-color);
        }

        /* Panels */
        .panel {
            border: 1px solid var(--primary-dim);
            background: rgba(10, 10, 10, 0.6);
            padding: 0; /* Removing padding to let internal elements hit edges if needed */
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .panel-title {
            position: relative; /* Inside now, like a header */
            top: 0; left: 0;
            background: transparent;
            border-bottom: 1px solid var(--primary-dim);
            padding: 5px 10px;
            color: var(--primary-color);
            font-size: 1.1rem;
            letter-spacing: 1px;
            width: 100%;
            box-sizing: border-box;
            background: linear-gradient(90deg, var(--primary-dim) 0%, transparent 50%);
        }

        /* Equipment Panel (Left) */
        .equipment-layout {
            display: flex;
            flex-direction: column;
            height: 100%;
            align-items: center;
            justify-content: space-around;
            padding: 10px;
        }
        
        .char-silhouette {
             position: absolute;
             top: 40px; /* Below title */
             left: 0;
             width: 100%;
             height: calc(100% - 40px);
            
            border: none; /* Removed border */
            opacity: 0.2;
            /* display: flex; REMOVED layout props */
            /* align-items: center; */
            /* justify-content: center; */
            /* margin: 10px 0; REMOVED margin */
            color: transparent; 
            
            background-color: transparent;
            background-image: url('asset://garrysmod/materials/cyr/ui/Steel5.png');
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
            
            overflow: hidden;
            z-index: 0;
        }

        /* Scanline effect for silhouettes */
        .char-silhouette::after, .cyber-silhouette::after {
            content: " ";
            display: block;
            position: absolute;
            top: 0;
            left: 0;
            bottom: 0;
            right: 0;
            background: linear-gradient(
                to bottom,
                rgba(255,255,255,0),
                rgba(255,255,255,0) 50%,
                rgba(0,0,0,0.2) 50%,
                rgba(0,0,0,0.2)
            );
            background-size: 100% 4px; /* Scanline spacing */
            z-index: 2;
            pointer-events: none;
        }

        .cyber-silhouette {
             position: absolute;
             top: 40px; /* Below title */
             left: 0;
             width: 100%;
             height: calc(100% - 40px);
             
             background-image: url('asset://garrysmod/materials/cyr/ui/Nerves.png');
             background-size: cover;
             background-repeat: no-repeat;
             background-position: center;
             opacity: 0.2; /* Subtle background */
             z-index: 0;
        }

        .slot-group {
            display: flex;
            gap: 8px;
            width: 100%;
            justify-content: center;
        }

        /* Slots */
        .slot {
            width: 60px;
            height: 60px;
            border: 1px solid var(--primary-dim);
            background: rgba(20, 20, 20, 0.9);
            position: relative;
            cursor: pointer;
            transition: all 0.1s;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .slot:hover {
            border-color: var(--primary-color);
            box-shadow: inset 0 0 10px var(--primary-dim);
            background: rgba(0,0,0,0.8);
        }
        .slot.active {
            border-color: var(--primary-color);
            background: var(--primary-dim);
        }

        .slot-label {
            position: absolute;
            top: 2px;
            left: 2px;
            font-size: 0.6rem;
            color: var(--primary-color);
            opacity: 0.7;
            pointer-events: none;
        }

        .stats-container {
            position: absolute;
            bottom: 10px;
            left: 10px;
            right: 10px;
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
            z-index: 10;
            justify-content: center;
        }

        .stat-item {
            background: rgba(0,0,0,0.8);
            border: 1px solid var(--primary-dim);
            padding: 2px 6px;
            font-size: 0.8rem;
            color: var(--primary-color);
            display: flex;
            gap: 5px;
            align-items: center;
            font-family: 'VCR OSD Mono', monospace;
        }
        
        .stat-val {
            font-weight: bold;
            color: #fff;
        }

        /* Inventory Panel (Center) */
        .inventory-tabs {
            display: flex;
            gap: 2px; 
            margin: 0;
            padding: 5px 10px;
            background: rgba(0,0,0,0.3);
            border-bottom: 1px solid var(--primary-dim);
        }

        .tab-btn {
            background: transparent;
            border: 1px solid var(--primary-dim); /* Default dim border */
            border-bottom: none;
            color: var(--primary-dim);
            padding: 4px 12px;
            font-family: 'VCR OSD Mono', monospace;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.1s;
            position: relative;
            top: 1px; /* Sit on line */
        }

        .tab-btn:hover {
            color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .tab-btn.active {
            background: var(--primary-color); 
            color: #000;
            border-color: var(--primary-color);
            font-weight: bold;
        }

        .inventory-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(64px, 1fr));
            grid-auto-rows: 64px;
            gap: 5px;
            overflow-y: auto;
            padding: 10px;
            flex-grow: 1;
        }

        /* Cyberware Panel (Right) */
        .cyber-layout {
            display: block;
            position: relative;
            height: 100%;
            width: 100%;
        }
        
        .cyber-column {
            display: flex;
            flex-direction: column;
            gap: 20px;
            align-items: center;
        }

        /* Footer */
        footer {
            grid-column: 1 / 4;
            border-top: 1px solid var(--primary-dim);
            padding-top: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 1rem;
            opacity: 0.7;
        }

        .status-bar {
            display: flex;
            gap: 20px;
        }
        .status-item { display: flex; gap: 5px; }

        .currency {
            font-size: 1.5rem;
            color: var(--tertiary-color); /* Uses Tertiary */
            /* text-shadow: 0 0 5px var(--tertiary-color); REMOVED GLOW */
        }

        /* Scrollbar */
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: rgba(0, 0, 0, 0.3); }
        ::-webkit-scrollbar-thumb { background: var(--primary-dim); }
        ::-webkit-scrollbar-thumb:hover { background: var(--primary-color); }
        
        .slot-count {
            position: absolute;
            bottom: 0;
            right: 0;
            font-size: 1.2rem;
            color: #fff;
            background: rgba(0, 0, 0, 0.8);
            border: 1px solid var(--primary-dim);
            padding: 1px 3px;
            z-index: 5;
            pointer-events: none;
            font-family: 'VCR OSD Mono', monospace;
            line-height: 1;
        }

        .slot.dragging {
            opacity: 0.4;
            border: 1px dashed var(--primary-color);
            transform: scale(0.95);
        }

        .slot.drag-over {
            border: 2px solid #fff;
            background: rgba(255, 255, 255, 0.1);
        }

        #drag-ghost {
            position: fixed;
            top: -100px; left: -100px;
            width: 64px; height: 64px;
            border: 2px solid var(--primary-color);
            background: rgba(0,0,0,0.8);
            pointer-events: none;
            z-index: 9999;
            display: none;
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
            box-shadow: 0 0 10px var(--primary-color);
        }

        /* Settings Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.8);
            z-index: 2000;
            justify-content: center;
            align-items: center;
        }
        .modal.open { display: flex; }
        
        .modal-content {
            background: #0a0a0f;
            border: 2px solid var(--primary-color);
            padding: 20px;
            width: 400px;
            box-shadow: 0 0 30px var(--primary-dim);
            position: relative;
        }

        .modal-header {
            font-size: 2rem;
            margin-bottom: 20px;
            border-bottom: 1px solid var(--primary-dim);
            padding-bottom: 10px;
            color: var(--primary-color);
        }

        .setting-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            font-size: 1.2rem;
        }



        input[type="color"] {
            background: none;
            border: 1px solid var(--primary-dim);
            width: 50px; height: 30px;
            cursor: pointer;
        }

        .close-modal {
            position: absolute;
            top: 10px; right: 10px;
            cursor: pointer;
            font-size: 1.5rem;
            color: #f00;
        }

    </style>
</head>
<body>
    <div class="crt-overlay"></div>
    <div class="crt-overlay"></div>
    <div class="crt-scanline"></div>
    <div id="drag-ghost"></div>

    <div class="container">
        <div class="corner tl"></div>
        <div class="corner tr"></div>
        <div class="corner bl"></div>
        <div class="corner br"></div>

        <header>
            <div class="header-title">Aetherstone // Equipment Manager  </div>
            <div class="header-info">
                <div class="settings-btn" onclick="toggleSettings()">⚙</div>
                <div>
                    REV: 2.5.0<br>
                    USER: <span id="player-name">UNKNOWN</span>
                </div>
            </div>
        </header>

        <!-- (Content Panels skipped for brevity, assuming standard layout) -->
        <!-- Left Panel: Equipment -->
        <div class="panel">
            <div class="panel-title">EQUIPMENT</div>
            <div class="char-silhouette"></div>
            <div class="equipment-layout" style="position: relative; z-index: 1;">
                <!-- Head: Top Center -->
                <div class="slot" data-slot="headgear" style="position: absolute; top: 10%; left: 50%; transform: translateX(-50%);">
                    <span class="slot-label">HEAD</span>
                </div>

                <!-- Body: Center Chest/Stomach -->
                <div class="slot" data-slot="body" style="position: absolute; top: 40%; left: 50%; transform: translateX(-50%);">
                    <span class="slot-label">BODY</span>
                </div>

                <!-- Primary: Under Left Hand -->
                <div class="slot" data-slot="primary" style="position: absolute; top: 50%; left: 5%;">
                    <span class="slot-label">PRIMARY</span>
                </div>

                <!-- Sidearm: Under Right Hand -->
                <div class="slot" data-slot="sidearm" style="position: absolute; top: 50%; right: 5%;">
                    <span class="slot-label">SIDEARM</span>
                </div>

                <!-- Utility: Under Primary -->
                <div class="slot" data-slot="utility" style="position: absolute; top: 70%; left: 5%;">
                    <span class="slot-label">UTIL</span>
                </div>

                <!-- Legs: Between Knees -->
                <div class="slot" data-slot="legs" style="position: absolute; top: 70%; left: 50%; transform: translateX(-50%);">
                    <span class="slot-label">LEGS</span>
                </div>
            </div>
            
            <!-- Stats Container -->
            <div class="stats-container" id="player-stats"></div>
        </div>

        <!-- Center Panel: Inventory -->
        <div class="panel">
            <div class="panel-title">INVENTORY</div>
            <div class="inventory-tabs">
                <button class="tab-btn active" onclick="setFilter('ALL')">ALL</button>
                <button class="tab-btn" onclick="setFilter('EQUIPMENT')">EQUIP</button>
                <button class="tab-btn" onclick="setFilter('WEAPONS')">WPNS</button>
                <button class="tab-btn" onclick="setFilter('CYBERWARE')">CYBER</button>
                <button class="tab-btn" onclick="setFilter('CONSUMABLES')">USE</button>
                <button class="tab-btn" onclick="setFilter('MISC / JUNK')">MISC</button>
            </div>
            <div class="inventory-grid" id="inventory-grid"></div>
        </div>

        <!-- Right Panel: Cyberware -->
        <div class="panel">
            <div class="panel-title">CYBERWARE</div>
<div class="cyber-silhouette"></div>
<div class="cyber-layout" style="position: relative; z-index: 1;">
  <div class="slot" data-slot="neural" style="position:absolute; top:10%; left:50%; transform:translateX(-50%);"><span class="slot-label">NEURAL</span></div>
  <div class="slot" data-slot="optics" style="position:absolute; top:10%; left:15%;"><span class="slot-label">OPTICS</span></div>

  <div class="slot" data-slot="skeleton" style="position:absolute; top:40%; left:50%; transform:translateX(-50%);"><span class="slot-label">SKEL</span></div>
  <div class="slot" data-slot="left arm" style="position:absolute; top:40%; left:20%;"><span class="slot-label">L.ARM</span></div>
  <div class="slot" data-slot="right arm" style="position:absolute; top:40%; right:20%;"><span class="slot-label">R.ARM</span></div>

  <div class="slot" data-slot="implant 1" style="position:absolute; top:65%; left:20%;"><span class="slot-label">IMP.I</span></div>
  <div class="slot" data-slot="implant 2" style="position:absolute; top:65%; right:20%;"><span class="slot-label">IMP.II</span></div>

  <div class="slot" data-slot="left leg" style="position:absolute; top:85%; left:20%;"><span class="slot-label">L.LEG</span></div>
  <div class="slot" data-slot="right leg" style="position:absolute; top:85%; right:20%;"><span class="slot-label">R.LEG</span></div>
</div>
        </div>

        <footer>
            <div class="status-bar">
                <div class="status-item">CONN: <span style="color:#0f0">SECURE</span></div>
                <div class="status-item">PING: 12ms</div>
            </div>
            <div class="currency" id="currency-display">]] .. (NWL and NWL.CurrencySymbol or "€$") .. [[ 0</div>
        </footer>
    </div>

    <!-- Settings Modal -->
    <div id="settings-modal" class="modal">
        <div class="modal-content">
            <div class="close-modal" onclick="toggleSettings()">X</div>
            <div class="modal-header">INTERFACE SETTINGS</div>
            
            <div class="setting-row">
                <span>Primary Color (Blue)</span>
                <input type="color" id="col-primary" value="#00f0ff" onchange="updateColor('primary', this.value)">
            </div>
            <div class="setting-row">
                <span>Secondary Color (Purple)</span>
                <input type="color" id="col-secondary" value="#d600ff" onchange="updateColor('secondary', this.value)">
            </div>
            <div class="setting-row">
                <span>Tertiary Color (Red)</span>
                <input type="color" id="col-tertiary" value="#FF0000" onchange="updateColor('tertiary', this.value)">
            </div>
            
            <div style="text-align:center; margin-top: 15px;">
                <button onclick="resetDefaults()" style="background:var(--primary-color); border:none; padding:5px 10px; font-family:inherit; cursor:pointer; font-weight:bold;">RESET DEFAULTS</button>
            </div>

            <div style="margin-top:10px; text-align:center; font-size:0.8rem; color:var(--primary-dim);">
                Changes saved automatically.
            </div>
        </div>
    </div>

    <script>
        var root = document.documentElement;

        function toggleSettings() {
            var m = document.getElementById('settings-modal');
            m.classList.toggle('open');
        }
        
        function resetDefaults() {
            var defs = {
                primary: "#FF4400",
                secondary: "#E0E0E0",
                tertiary: "#FF0000"
            };
            
            document.getElementById('col-primary').value = defs.primary;
            document.getElementById('col-secondary').value = defs.secondary;
            document.getElementById('col-tertiary').value = defs.tertiary;
            
            updateColor('primary', defs.primary);
            updateColor('secondary', defs.secondary);
            updateColor('tertiary', defs.tertiary);
        }

        function hexToRgb(hex) {
            var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
            hex = hex.replace(shorthandRegex, function(m, r, g, b) {
                return r + r + g + g + b + b;
            });
            var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
            return result ? {
                r: parseInt(result[1], 16),
                g: parseInt(result[2], 16),
                b: parseInt(result[3], 16)
            } : null;
        }

        function updateColor(type, hex) {
            if(type === 'primary') {
                root.style.setProperty('--primary-color', hex);
                var rgb = hexToRgb(hex);
                if(rgb) {
                    root.style.setProperty('--primary-dim', 'rgba(' + rgb.r + ', ' + rgb.g + ', ' + rgb.b + ', 0.3)');
                    root.style.setProperty('--grid-color', 'rgba(' + rgb.r + ', ' + rgb.g + ', ' + rgb.b + ', 0.1)');
                }
            } else if(type === 'secondary') {
                root.style.setProperty('--secondary-color', hex);
            } else if(type === 'tertiary') {
                root.style.setProperty('--tertiary-color', hex);
            }

            Webhooks.callLua('saveSettings', {
                primary: document.getElementById('col-primary').value,
                secondary: document.getElementById('col-secondary').value,
                tertiary: document.getElementById('col-tertiary').value
            });
        }

        // --- WEBHOOKS SYSTEM ---
        var Webhooks = {
            triggers: {},
            trigger: function(name, data) {
                if (typeof data === 'undefined') {
                    console.log("WEBHOOK TRIGGERED WITH UNDEFINED DATA: " + name);
                }
                if (this.triggers[name]) this.triggers[name](data);
            },
            callLua: function(hookName, data) {
                 if (window.gmod) {
                     var json = JSON.stringify(data || {});
                     gmod.webhook(hookName, json);
                 }
            },
            register: function(name, callback) {
                this.triggers[name] = callback;
            }
        };

        // Standard Logic
        var currentFilter = 'ALL';
        var inventoryData = [];
        var playerStats = { money: 0, name: "UNKNOWN" };

        // Drag State
        var isDragging = false;
        var dragSrcItem = null;
        var hasMoved = false;
        var dragGhost = null;

        function setFilter(filter) {
            currentFilter = filter;
            var btns = document.querySelectorAll('.tab-btn');
            for (var i = 0; i < btns.length; i++) {
                var b = btns[i];
                b.classList.remove('active');
                var txt = b.innerText;
                if (filter === 'ALL' && txt === 'ALL') b.classList.add('active');
                if (filter === 'EQUIPMENT' && txt === 'EQUIP') b.classList.add('active');
                if (filter === 'WEAPONS' && txt === 'WPNS') b.classList.add('active');
                if (filter === 'CYBERWARE' && txt === 'CYBER') b.classList.add('active');
                if (filter === 'CONSUMABLES' && txt === 'USE') b.classList.add('active');
                if (filter === 'MISC / JUNK' && txt === 'MISC') b.classList.add('active');
            }
            renderInventory();
        }

        function renderInventory() {
             var grid = document.getElementById('inventory-grid');
             grid.innerHTML = '';
             for (var idx = 0; idx < inventoryData.length; idx++) {
                 var item = inventoryData[idx];
                 var show = false;
                 var cat = (item.definition.category || "").toLowerCase();
                 var uid = (item.definition.uniqueID || "").toLowerCase();
                 if (currentFilter === 'ALL') show = true;
                 else if (currentFilter === 'EQUIPMENT' && cat.indexOf('armor') !== -1) show = true;
                 else if (currentFilter === 'WEAPONS' && cat.indexOf('weapon') !== -1) show = true;
                 else if (currentFilter === 'CYBERWARE' && cat.indexOf('augment') !== -1) show = true;
                 else if (currentFilter === 'CONSUMABLES' && uid.indexOf('food') !== -1) show = true;
                 else if (currentFilter === 'MISC / JUNK') {
                    if (cat.indexOf('armor') === -1 && cat.indexOf('weapon') === -1 && cat.indexOf('augment') === -1 && uid.indexOf('food') === -1) show = true;
                 }

                 if (show) {
                    var el = document.createElement('div');
                    el.className = 'slot';
                    el.title = item.definition.name;
                    el.setAttribute('data-item-id', String(item.id));
                    if (item.definition.iconPath) {
                        el.style.backgroundImage = "url('" + item.definition.iconPath + "')";
                        el.style.backgroundSize = "contain"; 
                        el.style.backgroundRepeat = "no-repeat";
                        el.style.backgroundPosition = "center";
                    } else if (item.definition.model) {
                         el.innerText = item.instances.length > 1 ? "x" + item.instances.length : "";
                    }
                    
                    if (item.amount > 1) {
                         var countLabel = document.createElement('div');
                         countLabel.className = 'slot-count';
                         countLabel.innerText = item.amount;
                         el.appendChild(countLabel);
                    }

                    var nameLabel = document.createElement('div');
                    nameLabel.className = 'slot-label';
                    nameLabel.innerText = item.definition.name;
                    el.appendChild(nameLabel);

                    // Bind events via closure
                    (function(theItem, theEl) {
                        theEl.oncontextmenu = function(e) { 
                            e.preventDefault(); 
                            Webhooks.callLua('contextMenu', { itemID: theItem.id }); 
                        };
                        theEl.onclick = function() {
                            if (hasMoved) return; // Don't fire click after drag
                            Webhooks.callLua('useItem', { itemID: theItem.id }); 
                        };
                        theEl.onmousedown = function(e) {
                            if (e.button !== 0) return;
                            onSlotMouseDown(e, theItem);
                        };
                        theEl.onmouseenter = function() {
                            var stats = {
                                "CATEGORY": (theItem.definition.category || "Misc").toUpperCase(),
                                "ID": theItem.definition.uniqueID,
                                "WEIGHT": (theItem.definition.weight || 0) + "kg",
                                "MAX_STACK": theItem.maxstack
                            };
                            if (theItem.amount > 1) stats["AMOUNT"] = theItem.amount;
                            Webhooks.callLua('showTooltip', {
                                name: theItem.definition.name,
                                desc: theItem.definition.desc || "No description available.",
                                stats: stats
                            });
                        };
                        theEl.onmouseleave = function() {
                            Webhooks.callLua('hideTooltip');
                        };
                    })(item, el);

                    grid.appendChild(el);
                 }
             }
        }

        function handleSlotClick(el) {
            var slot = el.getAttribute('data-slot');
            if(slot && el.classList.contains('active')) {
                 Webhooks.callLua('unequip', { slot: slot });
            }
        }

        // Events
        Webhooks.register('updateInventory', function(data) { 
            inventoryData = data.Inventory || []; 
            console.log("JS INVENTORY RECEIVED: " + inventoryData.length + " items");
            renderInventory(); 
        });
        Webhooks.register('updateStats', function(data) {
            playerStats = data;
            document.getElementById('player-name').innerText = data.name;
            var sym = data.currency || "\u20AC$";
            document.getElementById('currency-display').innerText = sym + " " + data.money;
            
            var statsContainer = document.getElementById('player-stats');
            if(statsContainer && data.attribs) {
                 statsContainer.innerHTML = '';
                 for (var i = 0; i < data.attribs.length; i++) {
                     var attr = data.attribs[i];
                     var div = document.createElement('div');
                     div.className = 'stat-item';
                     div.innerHTML = '<span style="opacity:0.7">' + attr.name.toUpperCase().substring(0,3) + '</span> <span class="stat-val">' + attr.val + '</span>';
                     div.title = attr.name; 
                     statsContainer.appendChild(div);
                 }
            }
        });
        Webhooks.register('updateEquipment', function(data) {
             var slots = document.querySelectorAll('.slot[data-slot]');
             for (var s = 0; s < slots.length; s++) {
                var el = slots[s];
                var slotName = el.getAttribute('data-slot');
                var item = data[slotName];

                el.style.backgroundImage = '';
                el.classList.remove('active');
                
                var oldLabel = el.querySelector('.slot-count');
                if (oldLabel) oldLabel.remove();
                
                el.onmouseenter = null;
                el.onmouseleave = null;
                el.oncontextmenu = null;
                
                (function(theEl) {
                    theEl.onclick = function() { handleSlotClick(theEl); };
                })(el);

                if (item) {
                    el.classList.add('active');
                    
                    if (item.definition.iconPath) {
                        el.style.backgroundImage = "url('" + item.definition.iconPath + "')";
                        el.style.backgroundSize = "contain"; 
                        el.style.backgroundRepeat = "no-repeat";
                        el.style.backgroundPosition = "center";
                    }

                    if (item.amount > 1) {
                         var countLabel = document.createElement('div');
                         countLabel.className = 'slot-count';
                         countLabel.innerText = item.amount;
                         el.appendChild(countLabel);
                    }

                    (function(theItem, theEl, theSlotName) {
                        theEl.onmouseenter = function() {
                            var stats = {
                                "CATEGORY": (theItem.definition.category || "Misc").toUpperCase(),
                                "ID": theItem.definition.uniqueID,
                                "SLOT": theSlotName.toUpperCase()
                            };
                            if (theItem.amount > 1) stats["AMOUNT"] = theItem.amount;
                            Webhooks.callLua('showTooltip', {
                                name: theItem.definition.name,
                                desc: theItem.definition.desc || "No description available.",
                                stats: stats
                            });
                        };
                        theEl.onmouseleave = function() {
                            Webhooks.callLua('hideTooltip');
                        };
                        theEl.oncontextmenu = function(e) { 
                            e.preventDefault(); 
                            Webhooks.callLua('contextMenu', { itemID: theItem.id }); 
                        };
                    })(item, el, slotName);
                }
             }
        });

        // Load Settings
        Webhooks.register('loadSettings', function(data) {
            if(data.primary) {
                 document.getElementById('col-primary').value = data.primary;
                 updateColor('primary', data.primary);
            }
            if(data.secondary) {
                 document.getElementById('col-secondary').value = data.secondary;
                 updateColor('secondary', data.secondary);
            }
            if(data.tertiary) {
                 document.getElementById('col-tertiary').value = data.tertiary;
                 updateColor('tertiary', data.tertiary);
            }
        });

        // Key Listeners
        document.addEventListener('keydown', function(e) {
            if (e.keyCode === 112 || e.keyCode === 115 || e.keyCode === 9) {
                e.preventDefault();
                Webhooks.callLua('closeMenu');
            }
        });
        
        console.log("UI + Settings Loaded");

        // --- DRAG AND DROP SYSTEM (ES5) ---
        function onSlotMouseDown(e, item) {
            if (e.button !== 0) return;
            console.log("DRAG: mousedown on " + item.id + " (" + (item.definition ? item.definition.name : "?") + ")");
            
            dragSrcItem = item;
            isDragging = true;
            hasMoved = false;

            if (!dragGhost) dragGhost = document.getElementById('drag-ghost');
            if (dragGhost) {
                if (item.definition.iconPath) {
                    dragGhost.style.backgroundImage = "url('" + item.definition.iconPath + "')";
                } else {
                    dragGhost.style.backgroundImage = 'none';
                    dragGhost.innerText = item.definition.name;
                }
                dragGhost.style.display = 'block';
                dragGhost.style.left = (e.clientX + 10) + 'px';
                dragGhost.style.top = (e.clientY + 10) + 'px';
            }

            var slot = e.currentTarget;
            if (slot) slot.classList.add('dragging');

            document.addEventListener('mousemove', onGlobalMouseMove);
            document.addEventListener('mouseup', onGlobalMouseUp);
            
            e.preventDefault();
        }

        function onGlobalMouseMove(e) {
            if (!isDragging) return;
            hasMoved = true;
            e.preventDefault();

            if (dragGhost) {
                dragGhost.style.left = (e.clientX + 15) + 'px';
                dragGhost.style.top = (e.clientY + 15) + 'px';
                
                dragGhost.style.display = 'none';
                var elemBelow = document.elementFromPoint(e.clientX, e.clientY);
                dragGhost.style.display = 'block';

                // Remove old hover highlights
                var oldOvers = document.querySelectorAll('.drag-over');
                for (var i = 0; i < oldOvers.length; i++) oldOvers[i].classList.remove('drag-over');
                
                if (elemBelow) {
                    var slot = elemBelow;
                    while (slot && !slot.classList.contains('slot')) {
                        slot = slot.parentElement;
                    }
                    if (slot && !slot.classList.contains('dragging')) {
                        slot.classList.add('drag-over');
                    }
                }
            }
        }

        function onGlobalMouseUp(e) {
            if (!isDragging) return;
            
            console.log("DRAG: mouseup");

            document.removeEventListener('mousemove', onGlobalMouseMove);
            document.removeEventListener('mouseup', onGlobalMouseUp);

            isDragging = false;
            
            if (dragGhost) dragGhost.style.display = 'none';
            
            var draggingEls = document.querySelectorAll('.dragging');
            for (var i = 0; i < draggingEls.length; i++) draggingEls[i].classList.remove('dragging');
            var overEls = document.querySelectorAll('.drag-over');
            for (var j = 0; j < overEls.length; j++) overEls[j].classList.remove('drag-over');

            if (!hasMoved) {
                dragSrcItem = null;
                return;
            }

            // Find what we dropped on
            var elemBelow = document.elementFromPoint(e.clientX, e.clientY);
            
            if (elemBelow) {
                // Walk up to find .slot
                var targetSlot = elemBelow;
                while (targetSlot && !targetSlot.classList.contains('slot')) {
                    targetSlot = targetSlot.parentElement;
                }
                
                if (targetSlot) {
                    var targetID = targetSlot.getAttribute('data-item-id');
                    var sourceID = dragSrcItem ? String(dragSrcItem.id) : null;

                    console.log("DRAG DROP: source=" + sourceID + " target=" + targetID);

                    if (sourceID && targetID && sourceID !== targetID) {
                        console.log("DRAG: Sending combineItems");
                        Webhooks.callLua('combineItems', { sourceID: sourceID, targetID: targetID });
                        Webhooks.callLua('playSound', { sound: "os/button_6.wav" });
                    } else if (sourceID === targetID) {
                        console.log("DRAG: Same item, ignoring");
                    } else {
                        console.log("DRAG: Missing source or target ID");
                    }
                } else {
                    console.log("DRAG: No target slot found");
                }
            } else {
                console.log("DRAG: No element below mouse");
            }
            
            dragSrcItem = null;
            // Keep hasMoved true briefly to suppress the click
            setTimeout(function() { hasMoved = false; }, 50);
        }
    </script>
</body>
</html>

]]
print("LOADED")