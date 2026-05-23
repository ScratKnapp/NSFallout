CYR = CYR or {}
CYR.UI = CYR.UI or {}
CYR.UI.CharMenuHTML = [[
<!DOCTYPE html>
<html lang="en">
<head>
    <link href="https://fonts.cdnfonts.com/css/vcr-osd-mono" rel="stylesheet">
    <style>
        :root {
            /* Fallout Terminal Theme (RobCo green-on-black) */
            --primary-color: #33ff66;
            --secondary-color: #1faa44;
            --tertiary-color: #ff5050; /* danger / terminate */

            --primary-dim: rgba(51, 255, 102, 0.22);
            --primary-glow: rgba(51, 255, 102, 0.55);
            --bg-color: #020a04;
            --grid-color: rgba(51, 255, 102, 0.08);
            --amber-color: #ffb83d; /* secondary accent */
        }

        html, body { background-color: #001a05; }

        body {
            margin: 0;
            padding: 0;
            background-color: #001a05;
            font-family: 'VCR OSD Mono', monospace;
            color: var(--primary-color);
            text-shadow: 0 0 6px var(--primary-glow);
            overflow: hidden;
            width: 100vw;
            height: 100vh;
            user-select: none;
        }

        /* Subtle screen curvature / vignette */
        body::before {
            content: "";
            position: fixed;
            inset: 0;
            pointer-events: none;
            z-index: 999;
            background: radial-gradient(ellipse at center, rgba(0,0,0,0) 55%, rgba(0,0,0,0.85) 100%);
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
            height: 6px;
            background: linear-gradient(rgba(51,255,102,0) 0%, rgba(51,255,102,0.15) 50%, rgba(51,255,102,0) 100%);
            position: fixed;
            z-index: 1001;
            animation: scanline 6s linear infinite;
            opacity: 0.6;
            pointer-events: none;
        }

        @keyframes scanline {
            0% { top: -10%; }
            100% { top: 110%; }
        }

        /* Holo Effect */
                <div class="holo-container">
                    <div class="holo-ring"></div>
                    <div class="holo-inner"></div>
                    <div class="holo-a">A</div>
                    <canvas id="holo-vines" width="400" height="400"></canvas>
                </div>

        @keyframes rotate {
            0% { transform: translate(-50%, -50%) rotate(0deg); }
            100% { transform: translate(-50%, -50%) rotate(360deg); }
        }

        @keyframes pulse {
            0%, 100% { transform: translate(-50%, -50%) scale(0.95); opacity: 0.5; }
            50% { transform: translate(-50%, -50%) scale(1.05); opacity: 0.8; }
        }

        /* Layout */
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
            
             /* Technical Grid Pattern */
            background-image: 
                linear-gradient(var(--grid-color) 1px, transparent 1px),
                linear-gradient(90deg, var(--grid-color) 1px, transparent 1px);
            background-size: 40px 40px;
        }

        /* Corners */
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
            color: #001a05;
            padding: 5px 20px;
            font-weight: bold;
            text-shadow: none;
            box-shadow: 0 0 18px var(--primary-glow);
        }

        /* Character List (Left) */
        .char-list-panel {
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
        }

        .char-list {
            flex: 1;
            overflow-y: auto;
            padding: 10px;
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .char-item {
            padding: 10px;
            border: 1px solid var(--primary-dim);
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            flex-direction: column;
        }

        .char-item:hover {
            border-color: var(--primary-color);
            background: rgba(255, 255, 255, 0.1);
        }

        .char-item.active {
            background: var(--primary-color);
            color: #001a05;
            border-color: var(--primary-color);
        }

        .char-name { font-size: 1.2rem; font-weight: bold; }
        .char-faction { font-size: 0.8rem; opacity: 0.7; }

        .create-btn {
            background: transparent;
            border: 1px dashed var(--primary-dim);
            color: var(--primary-dim);
            padding: 10px;
            text-align: center;
            cursor: pointer;
            margin-top: 10px;
            text-transform: uppercase;
        }
        .create-btn:hover {
            border-color: var(--primary-color);
            color: var(--primary-color);
            background: rgba(255,255,255,0.1);
        }

        /* Center Display (Model info eventually?) */
        .center-stage {
            grid-column: 2 / 3;
            grid-row: 2 / 3;
            border: 1px solid var(--primary-dim);
            position: relative;
            background: rgba(0,0,0,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .center-bg-text {
            font-size: 5rem;
            opacity: 0.05;
            transform: rotate(-45deg);
            white-space: nowrap;
        }

        /* Details Panel (Right) */
        .details-panel {
            grid-column: 3 / 4;
            grid-row: 2 / 3;
            border: 1px solid var(--primary-dim);
            background: rgba(0,0,0,0.8);
            padding: 15px;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .detail-row {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }
        .detail-label { font-size: 0.8rem; opacity: 0.7; }
        .detail-val { font-size: 1.1rem; border-bottom: 1px solid var(--primary-dim); padding-bottom: 2px;}

        /* Footer / Actions */
        .actions {
            grid-column: 1 / 4;
            grid-row: 3 / 4;
            border-top: 1px solid var(--primary-dim);
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 40px;
        }

        .action-btn {
            background: #000;
            border: 1px solid var(--primary-color);
            color: var(--primary-color);
            font-family: inherit;
            font-size: 1.5rem;
            padding: 10px 40px;
            cursor: pointer;
            text-transform: uppercase;
            transition: all 0.2s;
            clip-path: polygon(10px 0, 100% 0, 100% calc(100% - 10px), calc(100% - 10px) 100%, 0 100%, 0 10px);
        }

        .action-btn:hover:not(:disabled) {
            background: var(--primary-color);
            color: #001a05;
            box-shadow: 0 0 15px var(--primary-dim);
        }

        .action-btn:disabled {
            border-color: #555;
            color: #555;
            cursor: not-allowed;
            opacity: 0.5;
        }
        
        .delete-btn {
            border-color: var(--tertiary-color);
            color: var(--tertiary-color);
            font-size: 1rem;
            padding: 10px 20px;
        }
        .delete-btn:hover:not(:disabled) {
            background: var(--tertiary-color);
            color: #fff;
            box-shadow: 0 0 15px rgba(255, 0, 0, 0.4);
        }

        .disconnect-btn {
             position: absolute;
             bottom: 20px;
             right: 20px;
             background: transparent;
             border: none;
             color: #666;
             cursor: pointer;
             font-family: inherit;
        }
        .disconnect-btn:hover { color: #fff; }

        ::-webkit-scrollbar { width: 5px; }
        ::-webkit-scrollbar-track { background: #000; }
        ::-webkit-scrollbar-thumb { background: var(--primary-color); }
        
        /* Modal Styles */
        .modal-overlay {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.85);
            z-index: 2000;
            display: none;
            justify-content: center;
            align-items: center;
        }
        
        .modal {
            background: #000;
            border: 2px solid var(--primary-color);
            padding: 20px;
            width: 400px;
            box-shadow: 0 0 30px rgba(255, 255, 255, 0.1);
            position: relative;
        }
        
        .modal-title {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 20px;
            border-bottom: 1px solid var(--primary-dim);
            padding-bottom: 10px;
        }
        
        .modal-content {
            margin-bottom: 30px;
            opacity: 0.9;
        }
        
        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        
        .modal-btn {
            background: transparent;
            border: 1px solid var(--primary-dim);
            color: var(--primary-color);
            padding: 8px 16px;
            cursor: pointer;
            text-transform: uppercase;
            font-family: inherit;
        }
        
        .modal-btn:hover {
            background: var(--primary-dim);
        }
        
        .modal-btn.confirm {
            border-color: var(--tertiary-color);
            color: var(--tertiary-color);
        }
        
        .modal-btn.confirm:hover {
            background: var(--tertiary-color);
            color: #fff;
        }

        /* Creation Wizard Styles */
        .creation-view {
            display: none; /* Hidden by default */
            grid-column: 1 / 4;
            grid-row: 2 / 4;
            background: rgba(0,0,0,0.9);
            border: 1px solid var(--primary-color);
            padding: 20px;
            flex-direction: column;
            gap: 20px;
            z-index: 100;
        }

        .step-container {
            flex: 1;
            display: flex;
            flex-direction: row;
            gap: 20px;
            overflow: hidden;
        }

        .step-list {
            width: 250px;
            border-right: 1px solid var(--primary-dim);
            display: flex;
            flex-direction: column;
            gap: 10px;
            padding-right: 20px;
        }

        .step-content {
            flex: 1;
            overflow-y: auto;
            position: relative;
        }

        .step-item {
            padding: 10px;
            border: 1px solid transparent;
            cursor: pointer;
            opacity: 0.5;
        }
        .step-item.active {
            border-color: var(--primary-color);
            opacity: 1;
            font-weight: bold;
        }

        /* Faction/Model Grids */
        .grid-select {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            gap: 10px;
        }

        .grid-item {
            border: 1px solid var(--primary-dim);
            padding: 10px;
            cursor: pointer;
            text-align: center;
        }
        .grid-item:hover { background: rgba(255,255,255,0.1); }
        .grid-item.selected { border-color: var(--primary-color); background: rgba(255,255,255,0.2); }
        
        /* Attribute Rows */
        .attrib-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--primary-dim);
            padding: 10px 0;
        }
        .attrib-info {
            display: flex;
            flex-direction: column;
        }
        .attrib-name { font-weight: bold; }
        .attrib-desc { font-size: 0.8rem; opacity: 0.6; }
        .attrib-ctrl {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .btn-small {
            background: transparent;
            border: 1px solid var(--primary-dim);
            color: var(--primary-color);
            width: 30px; height: 30px;
            cursor: pointer;
        }
        .btn-small:hover:not(:disabled) { background: var(--primary-dim); }
        .attrib-val { width: 30px; text-align: center; }

        /* Form Inputs */
        .input-group {
            margin-bottom: 20px;
        }
        .input-label { display: block; margin-bottom: 5px; opacity: 0.8; }
        .text-input {
            width: 100%;
            background: transparent;
            border: 1px solid var(--primary-dim);
            color: var(--primary-color);
            padding: 10px;
            font-family: inherit;
            font-size: 1.1rem;
            user-select: text; /* Fix for typing */
            cursor: text;
        }
        .text-input:focus { outline: none; border-color: var(--primary-color); background: rgba(255,255,255,0.05); }
        
        .wizard-actions {
            display: flex;
            justify-content: space-between;
            margin-top: auto;
            border-top: 1px solid var(--primary-dim);
            padding-top: 20px;
        }

        
        /* Vine Pixel */
        .vine-pixel {
            position: absolute;
            width: 4px;
            height: 4px;
            opacity: 0; /* Hidden initially */
            pointer-events: none;
            z-index: 3;
            animation: grow 0.5s forwards; /* 'forwards' keeps it visible */
            border-radius: 1px;
        }

        @keyframes grow {
            0% { opacity: 0; transform: scale(0); }
            100% { opacity: 0.8; transform: scale(1); }
        }

        .holo-a {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-family: 'VCR OSD Mono', monospace;
            font-size: 250px;
            line-height: 1;
            font-weight: bold;
            color: var(--primary-color);
            text-shadow:
                0 0 18px var(--primary-glow),
                6px 6px 0px var(--primary-dim);
            z-index: 2;
            pointer-events: none;
            opacity: 0.9;
            image-rendering: pixelated;
            animation: flicker 4s infinite;
        }

        @keyframes flicker {
            0%, 100% { opacity: 0.92; }
            45%      { opacity: 0.85; }
            46%      { opacity: 0.55; }
            47%      { opacity: 0.92; }
            70%      { opacity: 0.7; }
            71%      { opacity: 0.95; }
        }
    </style>
</head>
<body>
    <div class="crt-overlay"></div>
    <div class="crt-scanline"></div>
    
    <div class="container">
        <div class="corner tl"></div>
        <div class="corner tr"></div>
        <div class="corner bl"></div>
        <div class="corner br"></div>

        <header>
            <div class="title">ROBCO INDUSTRIES (TM) TERMLINK</div>
            <div style="text-align:right; font-size:0.9rem; line-height:1.4;">
                ROBCO INDUSTRIES UNIFIED OPERATING SYSTEM<br>
                -SERVER LINK ESTABLISHED-
            </div>
        </header>

        <!-- Main Menu View -->
        <div id="main-view" style="display: contents;">
            <div class="char-list-panel">
                <div class="panel-header">[ REGISTERED DWELLERS ]</div>
                <div class="char-list" id="char-list">
                    <!-- Char Items -->
                </div>
                <div class="create-btn" onclick="showCreation()">> REGISTER NEW DWELLER</div>
            </div>

            <div class="center-stage">
                <div class="center-bg-text">VAULT-TEC</div>
            </div>

            <div class="details-panel" id="details-panel">
                <div class="panel-header">[ DWELLER RECORD ]</div>
                <div class="detail-row">
                    <span class="detail-label">NAME</span>
                    <span class="detail-val" id="det-name">---</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">FACTION</span>
                    <span class="detail-val" id="det-faction">---</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">MONEY</span>
                    <span class="detail-val" id="det-money">---</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">ID</span>
                    <span class="detail-val" id="det-id">---</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">LAST OUTFIT</span>
                    <span class="detail-val" id="det-pac">---</span>
                </div>
                <div class="detail-row" style="margin-top:auto">
                     <span class="detail-label">DESCRIPTION</span>
                     <div style="font-size:0.8rem; height:80px; overflow-y:auto; opacity:0.8;" id="det-desc">
                         Select an identity to view record details.
                     </div>
                </div>
            </div>

            <div class="actions">
                <button class="action-btn delete-btn" id="btn-delete" disabled onclick="triggerDelete()">PURGE RECORD</button>
                <button class="action-btn" id="btn-play" disabled onclick="triggerPlay()">RUN PROGRAM</button>
            </div>
            
            <button class="disconnect-btn" onclick="triggerDisconnect()">DISCONNECT</button>
        </div>

        <!-- Creation Wizard View -->
        <div id="creation-view" class="creation-view">
            <div class="panel-header">[ DWELLER REGISTRATION PROTOCOL ]</div>
            
            <div class="step-container">
                <div class="step-list">
                    <div class="step-item active" id="step-btn-1">1. AFFILIATION</div>
                    <div class="step-item" id="step-btn-2">2. VISUAL</div>
                    <div class="step-item" id="step-btn-3">3. DATA</div>
                    <div class="step-item" id="step-btn-4">4. ATTRIBUTES</div>
                    <div class="step-item" id="step-btn-5">5. TRAITS</div>
                </div>
                
                <div class="step-content" id="step-1">
                    <h3>SELECT FACTION</h3>
                    <div class="grid-select" id="faction-grid"></div>
                    <p id="faction-desc" style="opacity:0.7; margin-top:20px;"></p>
                </div>
                
                <div class="step-content" id="step-2" style="display:none; overflow: hidden;">
                    <div style="display: flex; flex-direction: row; gap: 20px; height: 100%;">
                        <div style="width: 300px; display: flex; flex-direction: column;">
                            <h3>VISUAL</h3>
                            <div id="model-preview-area" style="width: 300px; height: 400px; border: 1px solid var(--primary-dim); background: rgba(0,0,0,0.5);">
                                <!-- Lua renders here -->
                            </div>
                        </div>
                        <div style="flex: 1; display: flex; flex-direction: column; height: 100%; overflow: hidden;">
                            <h3>SELECT MODEL</h3>
                            <div style="flex: 1; overflow-y: auto; padding-right: 5px;">
                                <div class="grid-select" id="model-grid"></div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="step-content" id="step-3" style="display:none;">
                    <h3>IDENTITY DATA</h3>
                    <div class="input-group">
                        <span class="input-label">FULL NAME</span>
                        <input type="text" class="text-input" id="input-name" placeholder="John Doe" onclick="this.focus()">
                    </div>
                    <div class="input-group">
                        <span class="input-label">DESCRIPTION</span>
                        <textarea class="text-input" id="input-desc" rows="4" placeholder="Physical description..." onclick="this.focus()"></textarea>
                    </div>
                </div>

                <div class="step-content" id="step-4" style="display:none;">
                    <h3>ATTRIBUTES (<span id="attrib-points">10</span> POINTS REMAINING)</h3>
                    <div id="attrib-list" style="display:flex; flex-direction:column; overflow-y:auto; height: 100%;"></div>
                </div>

                <div class="step-content" id="step-5" style="display:none;">
                    <h3>TRAITS (<span id="trait-points">2</span> POINTS REMAINING)</h3>
                    <div class="grid-select" id="trait-grid"></div>
                    <p id="trait-desc" style="opacity:0.7; margin-top:20px; min-height: 40px;"></p>
                </div>
            </div>

            <div class="wizard-actions">
                <button class="modal-btn" onclick="cancelCreation()">CANCEL</button>
                <div>
                    <button class="modal-btn" id="btn-prev" onclick="prevStep()" disabled>PREVIOUS</button>
                    <button class="modal-btn confirm" id="btn-next" onclick="nextStep()">NEXT</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Overlay -->
    <div class="modal-overlay" id="modal-overlay">
        <div class="modal">
            <div class="modal-title" id="modal-title">TITLE</div>
            <div class="modal-content" id="modal-text">Content goes here...</div>
            <div class="modal-actions">
                <button class="modal-btn" onclick="closeModal()">CANCEL</button>
                <button class="modal-btn confirm" id="modal-confirm-btn">CONFIRM</button>
            </div>
        </div>
    </div>

    <script>
        // --- DATA ---
        let characters = [];
        let factions = []; 
        let traits = []; 
        let attributes = []; // New
        
        // --- STATE ---
        let selectedCharID = null;
        let createData = {
            factionIndex: null,
            model: null,
            name: "",
            desc: "",
            traits: {} // New: { traitUID: true/false }
        };
        let currentStep = 1;
        let maxTraitPoints = 2;
        let usedTraitPoints = 0;

        // --- INIT & BRIDGE ---
        function setCharacters(data) {
            characters = data || [];
            renderList();
        }
        
        function setFactions(data) {
            factions = data || [];
        }

        function setTraits(data, points) {
            traits = data || [];
            if(points) maxTraitPoints = points;
        }

        function setAttributes(data, points) {
            attributes = data || [];
            if(points) maxAttribPoints = points;
        }

        window.setAttributes = setAttributes;

        window.setCharacters = setCharacters;
        window.setFactions = setFactions;
        window.setTraits = setTraits;

        // --- MAIN MENU LOGIC ---
        function renderList() {
            const list = document.getElementById('char-list');
            list.innerHTML = '';
            
            characters.forEach(char => {
                const el = document.createElement('div');
                el.className = 'char-item';
                if(char.id === selectedCharID) el.classList.add('active');
                
                el.innerHTML = `
                    <span class="char-name">${char.name}</span>
                    <span class="char-faction">${char.factionName}</span>
                `;
                
                el.onclick = () => selectChar(char.id);
                list.appendChild(el);
            });
        }

        function selectChar(id) {
            selectedCharID = id;
            renderList(); 
            
            const char = characters.find(c => c.id === id);
            if(char) {
                document.getElementById('det-name').innerText = char.name;
                document.getElementById('det-faction').innerText = char.factionName;
                document.getElementById('det-money').innerText = char.money; 
                document.getElementById('det-id').innerText = "REC-" + char.id;
                document.getElementById('det-pac').innerText = char.lastPac || "N/A";
                document.getElementById('det-desc').innerText = char.desc || "No record data.";
                
                document.getElementById('btn-play').disabled = false;
                document.getElementById('btn-delete').disabled = false;
                
                if(window.gmod) {
                     gmod.webhook('selectChar', { id: id });
                     // Signal to HIDE model if it was showing
                     gmod.webhook('hideModel');
                }
            }
        }
        
        function triggerPlay() {
            if(selectedCharID && window.gmod) {
                gmod.webhook('play', { id: selectedCharID });
            }
        }

        function triggerDelete() {
             if(selectedCharID) {
                 showModal(
                     "TERMINATE IDENTITY?",
                     "Are you sure you want to permanently delete this identity? This action cannot be reversed.",
                     function() {
                         if(window.gmod) gmod.webhook('delete', { id: selectedCharID });
                         closeModal();
                     }
                 );
             }
        }
        
        function triggerDisconnect() {
            if(window.gmod) gmod.webhook('disconnect');
        }

        // --- CREATION WIZARD LOGIC ---

        // --- CREATION WIZARD LOGIC ---
        function showCreation() {
            document.getElementById('main-view').style.display = 'none';
            document.getElementById('creation-view').style.display = 'flex';
            if(window.gmod) gmod.webhook('enteredCreation'); // Signal to show DModelPanel if needed

            // Reset state
            createData = { factionIndex: null, model: null, name: "", desc: "", traits: {}, attribs: {} };
            currentStep = 1;
            usedTraitPoints = 0;
            usedAttribPoints = 0;
            updateWizardUI();
            
            // Render Factions
            const fGrid = document.getElementById('faction-grid');
            fGrid.innerHTML = '';
            factions.forEach(fac => {
                const el = document.createElement('div');
                el.className = 'grid-item';
                el.innerText = fac.name;
                el.style.borderLeft = `3px solid rgb(${fac.color.r},${fac.color.g},${fac.color.b})`;
                el.onclick = () => {
                   createData.factionIndex = fac.index;
                   createData.model = null; // Reset model
                   renderFactions(); // update selection
                   document.getElementById('faction-desc').innerText = fac.desc;
                };
                if(createData.factionIndex === fac.index) el.classList.add('selected');
                fGrid.appendChild(el);
            });
        }
        
        function renderFactions() {
             const fGrid = document.getElementById('faction-grid');
             Array.from(fGrid.children).forEach((el, idx) => {
                 el.classList.toggle('selected', factions[idx].index === createData.factionIndex);
             });
        }
        
        function renderAttributes() {
            const list = document.getElementById('attrib-list');
            list.innerHTML = '';
            document.getElementById('attrib-points').innerText = maxAttribPoints - usedAttribPoints;
            
            attributes.forEach(attr => {
                const currentVal = createData.attribs[attr.id] || 0;
                
                const frame = document.createElement('div');
                frame.className = 'attrib-row';
                
                frame.innerHTML = `
                    <div class="attrib-info">
                        <span class="attrib-name">${attr.name}</span>
                        <span class="attrib-desc">${attr.desc}</span>
                    </div>
                    <div class="attrib-ctrl">
                        <button class="btn-small" onclick="modAttrib('${attr.id}', -1)">-</button>
                        <span class="attrib-val">${currentVal}</span>
                        <button class="btn-small" onclick="modAttrib('${attr.id}', 1)">+</button>
                    </div>
                `;
                
                list.appendChild(frame);
            });
        }
        
        function modAttrib(id, amount) {
            const current = createData.attribs[id] || 0;
            const newVal = current + amount;
            
            if(newVal < 0) return; // Cannot go below 0
            
            if(amount > 0) {
                if(usedAttribPoints >= maxAttribPoints) return; // Cap reached
                usedAttribPoints++;
            } else {
                usedAttribPoints--;
            }
            
            createData.attribs[id] = newVal;
            renderAttributes();
        }

        
        function renderTraits() {
            const tGrid = document.getElementById('trait-grid');
            const ptLabel = document.getElementById('trait-points');
            tGrid.innerHTML = '';
            
            ptLabel.innerText = maxTraitPoints - usedTraitPoints;
            
            traits.forEach(trait => {
                const el = document.createElement('div');
                el.className = 'grid-item';
                el.innerText = trait.name;
                
                // Styling active
                if(createData.traits[trait.uid]) {
                    el.classList.add('selected');
                }
                
                el.onclick = () => {
                    if(createData.traits[trait.uid]) {
                        // Deselect
                        delete createData.traits[trait.uid];
                        usedTraitPoints--;
                    } else {
                        // Select
                        if(usedTraitPoints < maxTraitPoints) {
                            createData.traits[trait.uid] = true;
                            usedTraitPoints++;
                        } else {
                            return; // Max points reached
                        }
                    }
                    renderTraits(); // Re-render to update UI
                    document.getElementById('trait-desc').innerText = trait.desc;
                };
                
                // Hover for desc
                 el.onmouseenter = () => {
                     document.getElementById('trait-desc').innerText = trait.desc;
                 };
                
                tGrid.appendChild(el);
            });
        }

        function cancelCreation() {
            document.getElementById('creation-view').style.display = 'none';
            document.getElementById('main-view').style.display = 'contents';
            if(window.gmod) gmod.webhook('exitedCreation'); 
        }

        function updateWizardUI() {
            // Steps
            [1,2,3,4,5].forEach(i => {
                const stepBtn = document.getElementById(`step-btn-${i}`);
                if(stepBtn) stepBtn.classList.toggle('active', i === currentStep);
                
                const stepDiv = document.getElementById(`step-${i}`);
                if(stepDiv) stepDiv.style.display = (i === currentStep) ? 'block' : 'none';
            });
            
            // Buttons
            document.getElementById('btn-prev').disabled = currentStep === 1;
            document.getElementById('btn-next').innerText = currentStep === 5 ? "INITIALIZE" : "NEXT";
        }

       function nextStep() {
            if(currentStep === 1) {
                if(!createData.factionIndex) return showModal("ERROR", "Please select a faction.", closeModal);
                
                // Load Models for Step 2
                const fac = factions.find(f => f.index === createData.factionIndex);
                const mGrid = document.getElementById('model-grid');
                mGrid.innerHTML = '';
                if(fac && fac.models) {
                    fac.models.forEach((mdl, index) => {
                        const el = document.createElement('div');
                        el.className = 'grid-item';
                        const mdlName = mdl.split('/').pop().replace('.mdl', '');
                        el.innerText = mdlName;
                        el.onclick = () => {
                            createData.model = mdl;
                            createData.modelIndex = index + 1; // Lua is 1-indexed
                            Array.from(mGrid.children).forEach(c => c.classList.remove('selected'));
                            el.classList.add('selected');
                            if(window.gmod) {
                                gmod.webhook('updateModel', { model: mdl });
                                updatePreviewBounds();
                            }
                        };
                        mGrid.appendChild(el);
                    });
                }
            }
            
            if(currentStep === 2) {
                if(!createData.model) return showModal("ERROR", "Please select a visual model.", closeModal);
                
                // Leaving Step 2 -> Step 3
                if(window.gmod) gmod.webhook('hideModel');
            }
            
            if(currentStep === 3) {
                 const name = document.getElementById('input-name').value;
                const desc = document.getElementById('input-desc').value;
                
                if(name.length < 3) return showModal("ERROR", "Name must be at least 3 characters.", closeModal);
                if(desc.length < 10) return showModal("ERROR", "Description is too short.", closeModal);
                
                createData.name = name;
                createData.desc = desc;
                
                renderAttributes(); // Prepared for Step 4
            }

            if (currentStep === 4) {
                renderTraits(); // Prepared for Step 5
            }
            
            if(currentStep === 5) {
                 const traitList = Object.keys(createData.traits);
                 createData.traitList = traitList;
                 
                 // ADDED: Attribute List
                 createData.attributeList = createData.attribs;

                if(window.gmod) gmod.webhook('submitCreate', createData);
                cancelCreation(); 
                return;
            }

            currentStep++;
            updateWizardUI();
            
            // Entering Step 2
            if(currentStep === 2) {
                 setTimeout(updatePreviewBounds, 100); // Slight delay for layout
            }
        }

        function prevStep() {
            if(currentStep > 1) {
                // Leaving Step 2 -> Step 1
                if(currentStep === 2 && window.gmod) gmod.webhook('hideModel');
                
                currentStep--;
                updateWizardUI();
                
                // Entering Step 2 (from 3)
                if(currentStep === 2) {
                    setTimeout(updatePreviewBounds, 100);
                     if(createData.model && window.gmod) gmod.webhook('updateModel', { model: createData.model });
                }
            }
        }
        
        function updatePreviewBounds() {
            const el = document.getElementById('model-preview-area');
            if(el && window.gmod) {
                const rect = el.getBoundingClientRect();
                gmod.webhook('updateModelBounds', {
                    x: rect.left,
                    y: rect.top,
                    w: rect.width,
                    h: rect.height
                });
            }
        }



        // --- MODAL LOGIC ---
        function showModal(title, text, onConfirm) {
            document.getElementById('modal-title').innerText = title;
            document.getElementById('modal-text').innerText = text;
            const confirmBtn = document.getElementById('modal-confirm-btn');
            
            const newBtn = confirmBtn.cloneNode(true);
            confirmBtn.parentNode.replaceChild(newBtn, confirmBtn);
            
            newBtn.onclick = onConfirm || closeModal;
            
            document.getElementById('modal-overlay').style.display = 'flex';
        }

        function closeModal() {
            document.getElementById('modal-overlay').style.display = 'none';
        }

        // Signal Ready
        window.onload = function() {
            if(window.gmod) gmod.webhook('js_ready');
        }

        function createGrowingVines() {
            const container = document.querySelector('.holo-container');
            if(!container) return;
            
            // Container for vine pixels
            const vineLayer = document.createElement('div');
            vineLayer.id = 'vine-layer';
            container.appendChild(vineLayer);
            
            // Define 'A' shape approximation (Rough paths)
            // Coordinates relative to center (0,0)
            // 'A' is roughly 250px tall. 
            // Left Leg: x: -70 -> 0, y: 100 -> -100
            // Right Leg: x: 70 -> 0, y: 100 -> -100
            // Bar: x: -35 -> 35, y: 0
            
            const paths = [
                { start: {x: -70, y: 110}, end: {x: -15, y: -90}, steps: 40 }, // Left leg up (Wider base, top slightly left)
                { start: {x: 70, y: 110}, end: {x: 15, y: -90}, steps: 40 },  // Right leg up (Wider base, top slightly right)
                { start: {x: -35, y: 15}, end: {x: 35, y: 15}, steps: 15 },   // Crossbar (Lowered slightly?)
            ];
            
            paths.forEach(path => {
                const dx = (path.end.x - path.start.x) / path.steps;
                const dy = (path.end.y - path.start.y) / path.steps;
                
                for(let i=0; i<path.steps; i++) {
                    // Base position
                    let bx = path.start.x + dx * i;
                    let by = path.start.y + dy * i;
                    
                    // Jitter for organic look
                    bx += (Math.random() - 0.5) * 15;
                    by += (Math.random() - 0.5) * 15;
                    
                    // Pixelate
                    const px = Math.floor(bx/4)*4;
                    const py = Math.floor(by/4)*4;
                    
                    createPixel(vineLayer, px, py, i * 100); // Delay based on step index
                    
                    // Leaves
                    if(Math.random() > 0.8) {
                         createPixel(vineLayer, px + 4, py, i * 100 + 50, '#2d2');
                         createPixel(vineLayer, px - 4, py + 4, i * 100 + 50, '#2d2');
                    }
                }
            });
        }
        
        function createPixel(parent, x, y, delay, color) {
            const p = document.createElement('div');
            p.className = 'vine-pixel';
            p.style.backgroundColor = color || '#4f4';
            p.style.left = `calc(50% + ${x}px)`;
            p.style.top = `calc(50% + ${y}px)`;
            p.style.animationDelay = `${delay}ms`;
            parent.appendChild(p);
        }
    </script>
</body>
</html>
]]