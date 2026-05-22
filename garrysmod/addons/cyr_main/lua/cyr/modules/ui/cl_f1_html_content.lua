CYR = CYR or {}
CYR.UI = CYR.UI or {}
CYR.UI.F1MenuHTML = [[
<!DOCTYPE html>
<html lang="en">
<head>
    <link href="https://fonts.cdnfonts.com/css/vcr-osd-mono" rel="stylesheet">
    <style>
        :root {
            --primary-color: #FFFFFF; 
            --secondary-color: #CCCCCC;
            --tertiary-color: #FF0000;
            
            --primary-dim: rgba(255, 255, 255, 0.2); 
            --bg-color: rgba(5, 5, 5, 0.9);
            --grid-color: rgba(255, 255, 255, 0.1);
            --accent-green: #4f4;
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

        .container {
            display: grid;
            grid-template-columns: 300px 1fr 300px;
            grid-template-rows: 60px 1fr 80px;
            gap: 20px;
            width: 90vw;
            height: 85vh;
            margin: 7.5vh auto;
            background-color: var(--bg-color);
            border: 1px solid var(--primary-color);
            padding: 20px;
            box-sizing: border-box;
            position: relative;
            
            background-image: 
                linear-gradient(var(--grid-color) 1px, transparent 1px),
                linear-gradient(90deg, var(--grid-color) 1px, transparent 1px);
            background-size: 40px 40px;
        }

        .corner {
            position: absolute;
            width: 15px; height: 15px;
            border: 2px solid var(--primary-color);
            z-index: 10;
        }
        .tl { top: -2px; left: -2px; border-right: none; border-bottom: none; }
        .tr { top: -2px; right: -2px; border-left: none; border-bottom: none; }
        .bl { bottom: -2px; left: -2px; border-right: none; border-top: none; }
        .br { bottom: -2px; right: -2px; border-left: none; border-top: none; }

        header {
            grid-column: 1 / 4;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid var(--primary-color);
            padding-bottom: 10px;
        }

        .title {
            font-size: 2.5rem;
            text-transform: uppercase;
            letter-spacing: 4px;
            background: var(--primary-color);
            color: #000;
            padding: 5px 20px;
            font-weight: bold;
        }

        /* Sidebar Tabs */
        .sidebar {
            grid-column: 1 / 2;
            grid-row: 2 / 3;
            border: 1px solid var(--primary-dim);
            background: rgba(0,0,0,0.5);
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .panel-header {
            background: var(--primary-dim);
            padding: 5px 10px;
            font-weight: bold;
            border-bottom: 1px solid var(--primary-dim);
            text-transform: uppercase;
        }

        .tab-list {
            flex: 1;
            overflow-y: auto;
            padding: 10px;
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .tab-item {
            padding: 12px;
            border: 1px solid var(--primary-dim);
            cursor: pointer;
            transition: all 0.2s;
            text-transform: uppercase;
            font-size: 1.1rem;
        }

        .tab-item:hover {
            border-color: var(--primary-color);
            background: rgba(255, 255, 255, 0.1);
        }

        .tab-item.active {
            background: var(--primary-color);
            color: #000;
            border-color: var(--primary-color);
            font-weight: bold;
        }

        /* Center Stage */
        .center-stage {
            grid-column: 2 / 3;
            grid-row: 2 / 3;
            border: 1px solid var(--primary-dim);
            position: relative;
            background: rgba(0,0,0,0.2);
            overflow-y: auto;
            padding: 20px;
        }

        .content-overlay {
            position: relative;
            z-index: 2;
        }

        /* Right Stats Panel */
        .stats-panel {
            grid-column: 3 / 4;
            grid-row: 2 / 3;
            border: 1px solid var(--primary-dim);
            background: rgba(0,0,0,0.8);
            padding: 15px;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .stat-row {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }
        .stat-label { font-size: 0.8rem; opacity: 0.7; }
        .stat-val { font-size: 1.1rem; border-bottom: 1px solid var(--primary-dim); padding-bottom: 2px;}

        /* Footer */
        .actions {
            grid-column: 1 / 4;
            grid-row: 3 / 4;
            border-top: 1px solid var(--primary-dim);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .footer-info {
            font-size: 0.9rem;
            opacity: 0.6;
        }

        /* Holo Effects */
        .holo-container {
            position: absolute;
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            pointer-events: none;
            z-index: -1;
            opacity: 0.3;
        }
        .holo-a {
            font-size: 300px;
            font-weight: bold;
            color: var(--primary-color);
            opacity: 0.1;
        }
        
        .vine-pixel {
            position: absolute;
            width: 4px; height: 4px;
            animation: grow 0.5s forwards;
            border-radius: 1px;
            z-index: 0;
        }
        @keyframes grow {
            0% { opacity: 0; transform: scale(0); }
            100% { opacity: 0.8; transform: scale(1); }
        }

        /* Identity Tab Styles */
        .info-section {
            margin-bottom: 30px;
        }

        .info-header {
            font-size: 1.2rem;
            border-bottom: 2px solid var(--primary-color);
            margin-bottom: 15px;
            padding-bottom: 5px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
            gap: 15px;
        }

        .stat-box {
            border: 1px solid var(--primary-dim);
            padding: 10px;
            background: rgba(255, 255, 255, 0.05);
            position: relative;
        }

        .stat-box-label { font-size: 0.7rem; opacity: 0.6; text-transform: uppercase; }
        .stat-box-val { font-size: 1.5rem; font-weight: bold; }
        .stat-box-boost { font-size: 0.8rem; color: var(--accent-green); position: absolute; top: 10px; right: 10px; }

        .skills-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px 30px;
        }

        .skill-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--grid-color);
            padding: 4px 0;
            font-size: 0.9rem;
        }

        .skill-name { text-transform: uppercase; }
        .skill-val { font-weight: bold; }

        .traits-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .trait-entry {
            border-left: 3px solid var(--primary-color);
            padding-left: 15px;
            background: rgba(255, 255, 255, 0.02);
            padding-top: 5px;
            padding-bottom: 10px;
        }

        .trait-entry-name { font-weight: bold; font-size: 1rem; color: var(--accent-green); }
        .trait-entry-desc { font-size: 0.8rem; opacity: 0.8; margin-top: 5px; }
        
        /* New Perk Styles */
        .perk-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 10px;
        }

        .perk-item {
            border: 1px solid var(--primary-dim);
            background: rgba(255, 255, 255, 0.05);
            padding: 10px;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 0.8rem;
            text-align: center;
            text-transform: uppercase;
        }

        .perk-item:hover {
            border-color: var(--primary-color);
            background: rgba(255, 255, 255, 0.1);
            box-shadow: 0 0 10px var(--primary-dim);
        }

        .respec-btn {
            background: transparent;
            border: 1px solid var(--tertiary-color);
            color: var(--tertiary-color);
            padding: 10px 20px;
            cursor: pointer;
            text-transform: uppercase;
            font-family: inherit;
            margin-top: 20px;
            transition: all 0.2s;
        }

        .respec-btn:hover {
            background: var(--tertiary-color);
            color: #fff;
            box-shadow: 0 0 10px rgba(255, 0, 0, 0.3);
        }

        .allocation-toggle {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--primary-dim);
            color: var(--primary-color);
            padding: 5px 15px;
            cursor: pointer;
            font-family: inherit;
            text-transform: uppercase;
            font-size: 0.7rem;
            transition: all 0.2s;
        }

        .allocation-toggle.active {
            background: var(--accent-green);
            color: #000;
            border-color: var(--accent-green);
            font-weight: bold;
        }

        .plus-btn {
            background: var(--accent-green);
            color: #000;
            border: none;
            width: 18px;
            height: 18px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 1.2rem;
            font-weight: bold;
            margin-left: 8px;
            border-radius: 2px;
            line-height: 1;
        }

        .plus-btn:hover {
            background: #fff;
        }

        .progress-bar-container {
            width: 100%;
            height: 10px;
            border: 1px solid var(--primary-dim);
            margin-top: 5px;
            background: #000;
        }

        .progress-bar-fill {
            height: 100%;
            background: var(--primary-color);
            width: 0%;
            transition: width 0.5s;
        }

        .business-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
            gap: 15px;
            padding: 10px;
        }
        
        .business-category-header {
            grid-column: 1 / -1;
            font-size: 1.2rem;
            border-bottom: 1px solid var(--primary-dim);
            margin-top: 10px;
            margin-bottom: 5px;
            padding-bottom: 2px;
            color: var(--primary-color);
        }

        .biz-item {
            background: rgba(0, 0, 0, 0.4);
            border: 1px solid var(--primary-dim);
            display: flex;
            flex-direction: column;
            aspect-ratio: 1; /* Square intersection */
            position: relative;
        }

        .biz-item:hover {
            border-color: var(--primary-color);
            background: rgba(255, 255, 255, 0.02);
        }

        .biz-icon {
            flex-grow: 1;
            width: 100%;
            min-height: 100px; /* Force visibility if aspect-ratio fails */
            background-size: contain;
            background-position: center;
            background-repeat: no-repeat;
            margin: 5px 0;
            position: relative;
        }

        .biz-info {
            background: rgba(0, 0, 0, 0.8);
            padding: 5px;
            text-align: center;
            display: flex;
            flex-direction: column;
            gap: 2px;
            border-top: 1px solid rgba(255,255,255,0.05);
        }

        .biz-name {
            font-size: 0.8rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            color: #fff;
            padding: 2px 5px;
            text-align: center;
            font-weight: bold;
        }

        .biz-price {
            font-size: 0.9rem;
            color: var(--accent-green);
            font-weight: bold;
        }
        
        .biz-controls {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 2px;
        }
        
        .biz-ctrl-btn {
            background: rgba(255,255,255,0.1);
            border: 1px solid var(--primary-dim);
            color: #fff;
            width: 24px;
            height: 24px;
            cursor: pointer;
            font-family: inherit;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .biz-ctrl-btn:hover {
            background: var(--primary-color);
            color: #000;
        }
        
        .biz-ctrl-count {
            font-size: 1rem;
            min-width: 20px;
            font-weight: bold;
        }

        /* Business Layout */
        .biz-layout {
            display: flex;
            height: 100%;
            gap: 0;
            overflow: hidden;
        }

        .biz-sidebar {
            width: 200px;
            background: rgba(0, 0, 0, 0.5);
            border-right: 1px solid var(--primary-dim);
            display: flex;
            flex-direction: column;
            padding-top: 10px;
            flex-shrink: 0;
        }

        .biz-cat-btn {
            background: transparent;
            border: none;
            color: var(--primary-dim);
            padding: 10px 15px;
            text-align: left;
            font-family: inherit;
            cursor: pointer;
            transition: all 0.2s;
            text-transform: uppercase;
            font-size: 0.9rem;
            border-left: 2px solid transparent;
        }

        .biz-cat-btn:hover {
            color: var(--primary-color);
            background: rgba(255, 255, 255, 0.05);
        }

        .biz-cat-btn.active {
            color: var(--primary-color);
            background: rgba(0, 255, 0, 0.05);
            border-left-color: var(--primary-color);
            font-weight: bold;
        }

        .biz-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            padding: 10px;
            overflow: hidden;
        }

        .biz-header {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
            flex-shrink: 0;
        }

        .biz-search-bar {
            flex-grow: 1;
            background: rgba(0, 0, 0, 0.5);
            border: 1px solid var(--primary-dim);
            color: #fff;
            padding: 8px 12px;
            font-family: inherit;
            font-size: 1rem;
        }
        
        .biz-search-bar:focus {
            outline: none;
            border-color: var(--primary-color);
        }

        .view-cart-btn {
            background: var(--primary-dim);
            color: #000;
            border: none;
            padding: 0 20px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.2s;
            font-family: inherit;
            display: flex;
            align-items: center;
        }

        .view-cart-btn:hover {
            background: var(--primary-color);
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.8);
            backdrop-filter: blur(5px);
        }

        .modal-content {
            background-color: #111;
            margin: 10% auto;
            padding: 0;
            border: 1px solid var(--primary-color);
            width: 500px;
            max-width: 90%;
            box-shadow: 0 0 20px rgba(0,255,0,0.2);
            display: flex;
            flex-direction: column;
            max-height: 80vh;
        }

        .modal-header {
            padding: 15px;
            background: rgba(0,255,0,0.1);
            border-bottom: 1px solid var(--primary-dim);
            color: var(--primary-color);
            font-size: 1.2rem;
            font-weight: bold;
            text-align: center;
        }

        .modal-cart-items {
            padding: 15px;
            overflow-y: auto;
            flex-grow: 1;
            min-height: 200px;
        }

        .modal-footer {
            padding: 15px;
            border-top: 1px solid var(--primary-dim);
            background: rgba(0,0,0,0.3);
        }

        .modal-total {
            text-align: right;
            font-size: 1.2rem;
            color: var(--accent-green);
            margin-bottom: 15px;
            font-weight: bold;
        }

        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .modal-btn {
            padding: 10px 20px;
            border: 1px solid var(--primary-dim);
            background: transparent;
            color: #fff;
            cursor: pointer;
            font-family: inherit;
            font-weight: bold;
            transition: all 0.2s;
        }

        .modal-btn.confirm {
            background: var(--primary-dim);
            color: #000;
            border-color: var(--primary-color);
        }

        .modal-btn.confirm:hover {
            background: var(--primary-color);
        }

        .modal-btn.cancel:hover {
            background: rgba(255,255,255,0.1);
        }

        .perk-item.selected {
            border-color: var(--accent-green);
            background: rgba(0, 255, 0, 0.1);
            color: var(--accent-green);
        }

        .plugin-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            transition: background 0.2s;
        }

        .plugin-item:hover {
            background: rgba(255, 255, 255, 0.02);
        }

        .plugin-info {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .plugin-name {
            font-weight: bold;
            color: var(--primary-color);
            font-size: 1.1rem;
        }

        .plugin-desc {
            font-size: 0.8rem;
            opacity: 0.7;
        }

        .status-toggle {
            padding: 5px 15px;
            font-family: inherit;
            font-size: 0.7rem;
            text-transform: uppercase;
            cursor: pointer;
            border: 1px solid var(--primary-dim);
            background: transparent;
            color: var(--primary-color);
            transition: all 0.2s;
        }

        .status-toggle.disabled {
            border-color: #f44;
            color: #f44;
        }

        .status-toggle.enabled {
            border-color: var(--accent-green);
            color: var(--accent-green);
        }

        .status-toggle:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        /* Config Editor */
        .config-editor {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .config-category {
            border: 1px solid var(--primary-dim);
            background: rgba(0,0,0,0.3);
            padding: 10px;
        }

        .config-category-title {
            font-size: 1.1rem;
            font-weight: bold;
            border-bottom: 2px solid var(--primary-color);
            margin-bottom: 10px;
            padding-bottom: 5px;
            color: var(--accent-green);
        }

        .config-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }

        .config-item:last-child {
            border-bottom: none;
        }

        .config-label-wrap {
            display: flex;
            flex-direction: column;
            max-width: 70%;
        }

        .config-key {
            font-weight: bold;
            font-size: 0.9rem;
        }

        .config-desc {
            font-size: 0.8rem;
            opacity: 0.6;
        }

        .config-input input:focus {
            outline: 1px solid var(--accent-green);
            background: rgba(0,0,0,0.8) !important;
        }

        /* Scrollbar */
        ::-webkit-scrollbar { width: 5px; }
        ::-webkit-scrollbar-track { background: #000; }
        ::-webkit-scrollbar-thumb { background: var(--primary-color); }
    </style>
</head>
<body>
    <div class="container">
        <div class="corner tl"></div>
        <div class="corner tr"></div>
        <div class="corner bl"></div>
        <div class="corner br"></div>

        <header>
            <div class="title">SYSTEM INTERFACE</div>
            <div style="text-align:right; font-size: 0.8rem;">
                USER: <span id="header-user">UNKNOWN</span><br>
                NETWORK: <span style="color:var(--accent-green)">SECURE</span>
            </div>
        </header>

        <div class="sidebar">
            <div class="panel-header">Directory</div>
            <div class="tab-list" id="tab-list">
                <!-- Tabs injected here -->
            </div>
        </div>

        <div class="center-stage">
            <div class="content-overlay" id="content-area">
                <!-- Content injected here -->
            </div>
            
            <div class="holo-container">
                <div class="holo-a">A</div>
                <div id="vine-layer"></div>
            </div>
        </div>

        <div class="stats-panel" id="stats-panel">
            <div class="panel-header">Core info</div>
            <!-- Stats injected here -->
        </div>

        <div class="actions">
            <div class="footer-info">AETHERSTONE OS v3.0 // CYR_MODULE_F1</div>
            <div id="footer-time" style="font-weight:bold">00:00:00</div>
        </div>
    </div>

    <script>
        const tabsContainer = document.getElementById('tab-list');
        const contentContainer = document.getElementById('content-area');
        const statsContainer = document.getElementById('stats-panel');

        function setTheme(data) {
            const root = document.documentElement;
            if (data.primary) root.style.setProperty('--primary-color', data.primary);
            if (data.bg) root.style.setProperty('--bg-color', data.bg);
            if (data.primaryDim) root.style.setProperty('--primary-dim', data.primaryDim);
            if (data.grid) root.style.setProperty('--grid-color', data.grid);
        }
        window.setTheme = setTheme;

        let allocationMode = false;

        function setAllocationMode(active) {
            allocationMode = active;
            const toggle = document.querySelector('.allocation-toggle');
            if (toggle) {
                if (allocationMode) toggle.classList.add('active');
                else toggle.classList.remove('active');
            }
        }
        window.setAllocationMode = setAllocationMode;

        function toggleAllocation() {
            allocationMode = !allocationMode;
            const toggle = document.querySelector('.allocation-toggle');
            if (toggle) {
                if (allocationMode) toggle.classList.add('active');
                else toggle.classList.remove('active');
            }
            if(window.gmod) gmod.webhook('toggleAllocation', { active: allocationMode });
        }
        window.toggleAllocation = toggleAllocation;

        function openCharacters() {
            if(window.gmod) gmod.webhook('openCharacters');
        }
        window.openCharacters = openCharacters;

        function togglePlugin(name, status) {
            if(window.gmod) gmod.webhook('togglePlugin', {name: name, status: status});
        }
        window.togglePlugin = togglePlugin;

        function setTabs(tabs) {
            tabsContainer.innerHTML = '';
            tabs.forEach(tab => {
                const el = document.createElement('div');
                el.className = 'tab-item';
                el.innerText = tab.name;
                el.onclick = () => {
                    document.querySelectorAll('.tab-item').forEach(i => i.classList.remove('active'));
                    el.classList.add('active');
                    if(window.gmod) gmod.webhook('tabClicked', { id: tab.id });
                };
                tabsContainer.appendChild(el);
            });
        }

        function setActiveTab(id) {
            Array.from(tabsContainer.children).forEach(el => {
                const name = el.innerText.toLowerCase();
                if(name === id.toLowerCase()) el.classList.add('active');
                else el.classList.remove('active');
            });
        }

        function setContent(html) {
            contentContainer.innerHTML = Array.isArray(html) ? html[0] : html;
            const toggle = document.querySelector('.allocation-toggle');
            if (toggle && allocationMode) {
                toggle.classList.add('active');
            }
        }

        function setStats(stats) {
            statsContainer.innerHTML = '<div class="panel-header">Core info</div>';
            stats.forEach(s => {
                const row = document.createElement('div');
                row.className = 'stat-row';
                row.innerHTML = `<span class="stat-label">${s.label}</span><span class="stat-val">${s.value}</span>`;
                statsContainer.appendChild(row);
            });
        }

        function statIncrease(id, val) {
            if(window.gmod) gmod.webhook('statIncrease', { id: id, val: val });
        }
        window.statIncrease = statIncrease;

        function skillIncrease(id, val) {
            if(window.gmod) gmod.webhook('skillIncrease', { id: id, val: val });
        }
        window.skillIncrease = skillIncrease;

        function perkAdd(id) {
            if(window.gmod) gmod.webhook('perkAdd', { id: id });
        }
        window.perkAdd = perkAdd;

        function updateConfig(key, val) {
            if(window.gmod) gmod.webhook('updateConfig', { key: key, val: val });
        }
        window.updateConfig = updateConfig;

        function updateConfig(key, val) {
            if(window.gmod) gmod.webhook('updateConfig', { key: key, val: val });
        }
        window.updateConfig = updateConfig;

        // Business Logic Refactored
        var cart = {};
        var currencySym = "$";
        var currentCategory = "all";
        var currentSearch = "";

        function initBusiness(sym) {
            cart = {};
            currencySym = sym;
            updateCartDisplay(); 
        }
        window.initBusiness = initBusiness;

        function adjustCardQty(id, name, price, delta) {
            if (!cart[id]) {
                cart[id] = { name: name, price: price, qty: 0 };
            }
            cart[id].qty += delta;
            
            if (cart[id].qty <= 0) {
                delete cart[id];
            }
            
            updateCardDisplay(id);
            updateCartDisplay();
        }
        window.adjustCardQty = adjustCardQty;
        
        function updateCardDisplay(id) {
            var qty = cart[id] ? cart[id].qty : 0;
            
            var countEl = document.getElementById("biz-count-" + id);
            if(countEl) countEl.innerText = qty;
            
            // Also highlight container if selected
            var container = countEl ? countEl.closest('.biz-item') : null;
            if(container) {
                if(qty > 0) container.style.borderColor = "var(--accent-green)";
                else container.style.borderColor = "";
            }
        }
        
        // Removed old addToCart as it's replaced by controls
        
        function updateCartDisplay() {
            var totalQty = 0;
            for(var id in cart) {
                if(cart[id].qty > 0) {
                    totalQty += cart[id].qty;
                    updateCardDisplay(id); // Ensure cards stay synced
                }
            }
            var countEl = document.getElementById("cart-count");
            if(countEl) countEl.innerText = totalQty;
            
            // Also update modal if open
            refreshModalCart();
        }

        // Filtering
        function filterItems(cat, btn) {
            currentCategory = cat;
            
            // Update buttons
            var btns = document.querySelectorAll(".biz-cat-btn");
            btns.forEach(b => b.classList.remove("active"));
            if(btn) btn.classList.add("active");
            
            applyFilters();
        }
        window.filterItems = filterItems;

        var businessItemBuffer = [];

        function clearBusinessItems() {
            businessItemBuffer = [];
            var grid = document.getElementById("biz-grid");
            if(grid) grid.innerHTML = "";
        }
        window.clearBusinessItems = clearBusinessItems;

        function addBusinessItems(items) {
            if(Array.isArray(items)) {
                businessItemBuffer = businessItemBuffer.concat(items);
            }
        }
        window.addBusinessItems = addBusinessItems;

        function renderBuffer() {
            renderBusinessItems(businessItemBuffer);
        }
        window.renderBuffer = renderBuffer;

        function renderBusinessItems(items) {
            var grid = document.getElementById("biz-grid");
            if(!grid) return;
            
            // clear if strictly resetting, but here we might just re-render
            grid.innerHTML = ""; 
            
            items.forEach(function(item) {
                var el = document.createElement("div");
                el.className = "biz-item";
                try {
                    el.setAttribute("data-category", item.cat);
                    el.setAttribute("data-name", item.name.toLowerCase());
                    
                    var safeName = item.name.replace(/'/g, "\\'"); // Escape for onclick
                    var safeID = item.id.replace(/'/g, "\\'");
                    
                    // Get quantity from current cart if exists
                    var currentQty = (cart[item.id] && cart[item.id].qty) || 0;
                    
                    el.innerHTML = `
                        <div class="biz-icon" id="icon-${item.id}" style="background-image: url('${item.icon}')"></div>
                        <img src="${item.icon}" style="display:none" onerror="handleIconError('${safeID}', '${item.model ? item.model.replace(/\\/g, '\\\\') : ''}')">
                        <div class="biz-name">${item.name}</div>
                        <div class="biz-info">
                            <div class="biz-price">${item.priceStr}</div>
                            <div class="biz-controls">
                                <button class="biz-ctrl-btn" onclick="adjustCardQty('${safeID}', '${safeName}', ${item.price}, -1)">-</button>
                                <span class="biz-ctrl-count" id="biz-count-${item.id}">${currentQty}</span>
                                <button class="biz-ctrl-btn" onclick="adjustCardQty('${safeID}', '${safeName}', ${item.price}, 1)">+</button>
                            </div>
                        </div>
                    `;
                    
                    // Highlight if in cart
                     if(currentQty > 0) el.style.borderColor = "var(--accent-green)";
                     
                    grid.appendChild(el);
                } catch(e) {
                    console.error("Error rendering item", item, e);
                }
            });
            applyFilters();
        }
        window.renderBusinessItems = renderBusinessItems;

        function handleIconError(id, model) {
            if(!model) return;
            // Only request once per session per item to avoid loops
            if(sessionStorage.getItem("icon_requested_" + id)) return;
            
            sessionStorage.setItem("icon_requested_" + id, "true");
            if(window.gmod) gmod.webhook("generateIcon", {id: id, model: model});
        }
        window.handleIconError = handleIconError;

        function updateIcon(id, path) {
            var el = document.getElementById("icon-" + id);
            if(el) {
                // Force reload by appending timestamp
                el.style.backgroundImage = "url('" + path + "?t=" + Date.now() + "')";
            }
        }
        window.updateIcon = updateIcon;
        
        function searchItems(query) {
            currentSearch = query.toLowerCase();
            applyFilters();
        }
        window.searchItems = searchItems;
        
        function applyFilters() {
            var items = document.querySelectorAll(".biz-item");
            items.forEach(item => {
                var itemCat = item.getAttribute("data-category");
                var itemName = item.getAttribute("data-name");
                
                var catMatch = (currentCategory === "all" || itemCat === currentCategory);
                var searchMatch = (!currentSearch || itemName.indexOf(currentSearch) > -1);
                
                if(catMatch && searchMatch) {
                    item.style.display = "flex";
                } else {
                    item.style.display = "none";
                }
            });
        }

        // Modal Logic
        function openCheckout() {
            var modal = document.getElementById("checkout-modal");
            if(modal) {
                modal.style.display = "block";
                refreshModalCart();
            }
        }
        window.openCheckout = openCheckout;
        
        function closeCheckout() {
             var modal = document.getElementById("checkout-modal");
            if(modal) modal.style.display = "none";
        }
        window.closeCheckout = closeCheckout;
        
        function refreshModalCart() {
            var container = document.getElementById("modal-cart-items");
            if (!container) return;
            
            container.innerHTML = "";
            var total = 0;
            
            for (var id in cart) {
                var item = cart[id];
                if (item.qty <= 0) continue;
                
                total += item.price * item.qty;
                
                var el = document.createElement("div");
                el.className = "cart-item";
                el.innerHTML = `
                    <div class="cart-item-name" title="${item.name}">${item.name}</div>
                    <div class="cart-item-controls">
                        <button class="cart-btn-small" onclick="adjustCart('${id}', -1)">-</button>
                        <span>${item.qty}</span>
                        <button class="cart-btn-small" onclick="adjustCart('${id}', 1)">+</button>
                    </div>
                    <div style="margin-left: 10px; color: var(--accent-green)">${currencySym}${item.price * item.qty}</div>
                `;
                container.appendChild(el);
            }
            
            var totalEl = document.getElementById("modal-total");
            if(totalEl) totalEl.innerText = currencySym + total;
        }

        function formAdjustCart(id, delta) {
            if (cart[id]) {
                cart[id].qty += delta;
                if (cart[id].qty <= 0) delete cart[id];
                
                updateCardDisplay(id); // Sync card view
                updateCartDisplay();
            }
        }
        // Override adjustCart to work for modal
        window.adjustCart = formAdjustCart;

        function confirmCheckout() {
            var finalCart = {};
            var hasItems = false;
            for (var id in cart) {
                if (cart[id].qty > 0) {
                    finalCart[id] = cart[id].qty;
                    hasItems = true;
                }
            }
            
            if (hasItems) {
                if (window.gmod) {
                    gmod.webhook('bizBuy', finalCart);
                    cart = {};
                    updateCartDisplay();
                    closeCheckout();
                }
            } else {
                 closeCheckout();
            }
        }
        window.confirmCheckout = confirmCheckout;
        window.checkout = function() {}; // Deprecate old function

        function respec() {
            if(window.gmod) {
                gmod.webhook('respec');
            }
        }
        window.respec = respec;

        function updateTime() {
            const now = new Date();
            document.getElementById('footer-time').innerText = now.toLocaleTimeString('en-US', { hour12: false });
        }
        setInterval(updateTime, 1000);
        updateTime();

        function setHeaderUser(name) {
            document.getElementById('header-user').innerText = name.toUpperCase();
        }

        window.onload = function() {
            if(window.gmod) gmod.webhook('js_ready');
            createGrowingVines();
        }

        function createGrowingVines() {
            const layer = document.getElementById('vine-layer');
            if(!layer) return;
            const paths = [
                { start: {x: -70, y: 110}, end: {x: -15, y: -90}, steps: 40 },
                { start: {x: 70, y: 110}, end: {x: 15, y: -90}, steps: 40 },
                { start: {x: -35, y: 15}, end: {x: 35, y: 15}, steps: 15 },
            ];
            paths.forEach(path => {
                const dx = (path.end.x - path.start.x) / path.steps;
                const dy = (path.end.y - path.start.y) / path.steps;
                for(let i=0; i<path.steps; i++) {
                    let bx = path.start.x + dx * i + (Math.random()-0.5)*15;
                    let by = path.start.y + dy * i + (Math.random()-0.5)*15;
                    const px = Math.floor(bx/4)*4;
                    const py = Math.floor(by/4)*4;
                    const p = document.createElement('div');
                    p.className = 'vine-pixel';
                    p.style.backgroundColor = '#4f4';
                    p.style.left = `calc(50% + ${px}px)`;
                    p.style.top = `calc(50% + ${py}px)`;
                    p.style.animationDelay = `${i * 100}ms`;
                    layer.appendChild(p);
                }
            });
        }
    </script>
</body>
</html>
]]