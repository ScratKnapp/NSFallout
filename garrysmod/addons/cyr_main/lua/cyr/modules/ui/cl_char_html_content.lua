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

        /* Curved CRT tube: rounded screen + edge darkening so the whole UI reads as bowed glass. */
        body::before {
            content: "";
            position: fixed;
            inset: 0;
            pointer-events: none;
            z-index: 999;
            border-radius: 26px / 38px;
            background: radial-gradient(ellipse 95% 95% at center, rgba(0,0,0,0) 52%, rgba(0,0,0,0.45) 82%, rgba(0,0,0,0.95) 100%);
            box-shadow: inset 0 0 120px 18px rgba(0,0,0,0.85);
        }
        /* Convex glass: a soft glare near the top and a faint overall bulge highlight. */
        body::after {
            content: "";
            position: fixed;
            inset: 0;
            pointer-events: none;
            z-index: 1002;
            border-radius: 26px / 38px;
            background:
                radial-gradient(ellipse 150% 95% at 50% -12%, rgba(120,255,160,0.07), rgba(0,0,0,0) 46%),
                radial-gradient(ellipse 120% 120% at center, rgba(120,255,160,0.05), rgba(0,0,0,0) 55%);
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
            background: rgba(51, 255, 102, 0.08);
            border: 1px solid var(--primary-color);
            color: var(--primary-color);
            padding: 10px;
            text-align: center;
            cursor: pointer;
            margin-top: 10px;
            text-transform: uppercase;
            font-weight: bold;
            text-shadow: 0 0 8px var(--primary-glow);
            /* Pulsing glow so it's obvious the button is there. */
            animation: createPulse 1.8s ease-in-out infinite;
        }
        .create-btn:hover {
            border-color: var(--primary-color);
            color: #001a05;
            background: var(--primary-color);
            box-shadow: 0 0 22px var(--primary-glow);
            text-shadow: none;
            animation: none; /* settle to a solid, clearly-clickable state on hover */
        }

        @keyframes createPulse {
            0%, 100% {
                box-shadow: 0 0 5px var(--primary-dim);
                border-color: var(--secondary-color);
            }
            50% {
                box-shadow: 0 0 20px var(--primary-glow);
                border-color: var(--primary-color);
            }
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
            cursor: default;
            opacity: 0.5;
        }
        .step-item.active {
            border-color: var(--primary-color);
            opacity: 1;
            font-weight: bold;
        }
        /* Completed steps are clickable to navigate back. */
        .step-item.done {
            cursor: pointer;
            opacity: 0.75;
        }
        .step-item.done:hover {
            border-color: var(--primary-color);
            opacity: 1;
            background: rgba(255,255,255,0.05);
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

        /* Terminal boot/typewriter intro shown when registering a new dweller.
           Occupies the same grid cell as the center panel so it lines up with it. */
        .terminal-intro {
            grid-column: 2 / 3;
            grid-row: 2 / 3;
            z-index: 200;
            display: none;
            opacity: 1;
            transition: opacity 0.85s ease;
            border: 1px solid var(--primary-dim);
            background: var(--bg-color);
            background-image:
                linear-gradient(var(--grid-color) 1px, transparent 1px),
                linear-gradient(90deg, var(--grid-color) 1px, transparent 1px);
            background-size: 40px 40px;
            padding: 24px;
            box-sizing: border-box;
            overflow: hidden;
            cursor: pointer;
        }
        .terminal-intro pre {
            margin: 0;
            height: 100%;
            overflow: hidden;
            white-space: pre-wrap;
            word-break: break-word;
            tab-size: 4;
            -moz-tab-size: 4;
            font-family: 'VCR OSD Mono', monospace;
            font-size: 0.82rem;
            line-height: 1.35;
            color: var(--primary-color);
            text-shadow: 0 0 6px var(--primary-glow);
        }
        /* Blinking block cursor at the end of the typed text. */
        .terminal-intro pre::after {
            content: "_";
            animation: termCursor 1s steps(1) infinite;
        }
        @keyframes termCursor {
            0%, 50% { opacity: 1; }
            50.01%, 100% { opacity: 0; }
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
                    <span class="detail-label">RACE</span>
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
                <div class="step-list" id="step-list"></div>

                <div class="step-content" id="step-faction">
                    <h3>SELECT RACE</h3>
                    <div class="grid-select" id="faction-grid"></div>
                    <p id="faction-desc" style="opacity:0.7; margin-top:20px;"></p>
                </div>

                <div class="step-content" id="step-visual" style="display:none; overflow: hidden;">
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

                <div class="step-content" id="step-data" style="display:none;">
                    <h3>IDENTITY DATA</h3>
                    <div class="input-group">
                        <span class="input-label">FULL NAME</span>
                        <input type="text" class="text-input" id="input-name" placeholder="John Doe" onclick="this.focus()">
                    </div>
                    <div class="input-group">
                        <span class="input-label">DESCRIPTION</span>
                        <textarea class="text-input" id="input-desc" rows="3" placeholder="Physical description..." onclick="this.focus()"></textarea>
                    </div>
                    <div class="input-group">
                        <span class="input-label">BACKGROUND (optional, max 1 &mdash; grants bonus skills and an attribute)</span>
                        <div class="grid-select" id="background-grid"></div>
                        <p id="background-desc" style="opacity:0.7; margin-top:10px; min-height: 30px; white-space: pre-line; font-size: 0.85rem;"></p>
                    </div>
                    <div class="input-group">
                        <span class="input-label">LANGUAGES (<span id="language-points">2</span> LEFT)</span>
                        <div class="grid-select" id="language-grid"></div>
                        <p id="language-desc" style="opacity:0.7; margin-top:10px; min-height: 30px; white-space: pre-line; font-size: 0.85rem;"></p>
                    </div>
                </div>

                <div class="step-content" id="step-stats" style="display:none; overflow: hidden;">
                    <div style="display: flex; flex-direction: row; gap: 20px; height: 100%;">
                        <div style="flex: 1; display: flex; flex-direction: column; height: 100%; overflow: hidden;">
                            <h3>S.P.E.C.I.A.L. (<span id="attrib-points">0</span> LEFT)</h3>
                            <div id="attrib-list" style="display:flex; flex-direction:column; overflow-y:auto; flex: 1; padding-right: 5px;"></div>
                        </div>
                        <div style="flex: 1; display: flex; flex-direction: column; height: 100%; overflow: hidden;">
                            <h3>SKILLS (<span id="skill-points">0</span> LEFT)</h3>
                            <div id="skill-list" style="display:flex; flex-direction:column; overflow-y:auto; flex: 1; padding-right: 5px;"></div>
                        </div>
                    </div>
                </div>

                <div class="step-content" id="step-traits" style="display:none;">
                    <h3>TRAITS (<span id="trait-points">2</span> POINTS REMAINING)</h3>
                    <div class="grid-select" id="trait-grid"></div>
                    <p id="trait-desc" style="opacity:0.7; margin-top:20px; min-height: 40px; white-space: pre-line;"></p>
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

        <!-- Terminal boot intro (typewriter), shown over the creation area then faded out -->
        <div class="terminal-intro" id="terminal-intro" onclick="finishTerminalIntro()"><pre id="terminal-text"></pre></div>
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
        let attributes = [];
        let skills = [];
        let backgrounds = [];
        let bgFactions = [];   // faction indices allowed to choose a background
        let languages = [];

        // --- POINT POOLS (filled by Lua) ---
        let totalAttribPoints = 0;
        let maxPerAttrib = 10;
        let totalSkillPoints = 0;
        let maxPerSkill = 100;
        let maxTraitPoints = 2;
        let maxLanguagePoints = 2;

        // --- STATE ---
        let selectedCharID = null;
        let createData = {};
        let currentStepIdx = 0;

        // --- WIZARD STEP DEFINITIONS (order matters) ---
        const STEPS = [
            { id: 'faction',    title: '1. AFFILIATION' },
            { id: 'visual',     title: '2. VISUAL' },
            { id: 'data',       title: '3. DATA' },
            { id: 'stats',      title: '4. SPECIAL & SKILLS' },
            { id: 'traits',     title: '5. TRAITS' }
        ];

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

        function setAttributes(data, total, perMax) {
            attributes = data || [];
            if(total) totalAttribPoints = total;
            if(perMax) maxPerAttrib = perMax;
        }

        function setSkills(data, total, perMax) {
            skills = data || [];
            if(total) totalSkillPoints = total;
            if(perMax) maxPerSkill = perMax;
        }

        function setBackgrounds(data, allowedFactions) {
            backgrounds = data || [];
            // Lua sends a JSON array of faction indices; normalize to guard against {}.
            bgFactions = Array.isArray(allowedFactions) ? allowedFactions : [];
        }

        function setLanguages(data, points) {
            languages = data || [];
            if(points) maxLanguagePoints = points;
        }

        window.setCharacters = setCharacters;
        window.setFactions = setFactions;
        window.setTraits = setTraits;
        window.setAttributes = setAttributes;
        window.setSkills = setSkills;
        window.setBackgrounds = setBackgrounds;
        window.setLanguages = setLanguages;

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
        // Source listing typed out during the terminal boot intro before creation.
        const TERMINAL_CODE =
`static int groups_to_user(gid_t __user *grouplist,
			  const struct group_info *group_info)
{
	struct user_namespace *user_ns = current_user_ns();
	int i;
	unsigned int count = group_info->ngroups;

	for (i = 0; i < count; i++) {
		gid_t gid;
		gid = from_kgid_munged(user_ns, group_info->gid[i]);
		if (put_user(gid, grouplist+i))
			return -EFAULT;
	}
	return 0;
}

/* fill a group_info from a user-space array - it must be allocated already */
static int groups_from_user(struct group_info *group_info,
    gid_t __user *grouplist)
{
	struct user_namespace *user_ns = current_user_ns();
	int i;
	unsigned int count = group_info->ngroups;

	for (i = 0; i < count; i++) {
		gid_t gid;
		kgid_t kgid;
		if (get_user(gid, grouplist+i))
			return -EFAULT;

		kgid = make_kgid(user_ns, gid);
		if (!gid_valid(kgid))
			return -EINVAL;

		group_info->gid[i] = kgid;
	}
	return 0;
}

static int gid_cmp(const void *_a, const void *_b)
{
	kgid_t a = *(kgid_t *)_a;
	kgid_t b = *(kgid_t *)_b;

	return gid_gt(a, b) - gid_lt(a, b);
}

void groups_sort(struct group_info *group_info)
{
	sort(group_info->gid, group_info->ngroups, sizeof(*group_info->gid),
	     gid_cmp, NULL);
}
EXPORT_SYMBOL(groups_sort);

/* a simple bsearch */
int groups_search(const struct group_info *group_info, kgid_t grp)
{
	unsigned int left, right;

	if (!group_info)
		return 0;

	left = 0;
	right = group_info->ngroups;
	while (left < right) {
		unsigned int mid = (left+right)/2;
		if (gid_gt(grp, group_info->gid[mid]))
			left = mid + 1;
		else if (gid_lt(grp, group_info->gid[mid]))
			right = mid;
		else
			return 1;
	}
	return 0;
}

void set_groups(struct cred *new, struct group_info *group_info)
{
	put_group_info(new->group_info);
	get_group_info(group_info);
	new->group_info = group_info;
}
EXPORT_SYMBOL(set_groups);

int set_current_groups(struct group_info *group_info)
{
	struct cred *new;
	const struct cred *old;
	int retval;

	new = prepare_creds();
	if (!new)
		return -ENOMEM;

	old = current_cred();

	set_groups(new, group_info);

	retval = security_task_fix_setgroups(new, old);
	if (retval < 0)
		goto error;

	return commit_creds(new);

error:
	abort_creds(new);
	return retval;
}`;

        let introDone = false;
        let typeTimer = null;

        // Register clicked: play the terminal boot intro, then fade into the wizard.
        function showCreation() {
            document.getElementById('main-view').style.display = 'none';
            startTerminalIntro();
        }

        function startTerminalIntro() {
            introDone = false;
            const intro = document.getElementById('terminal-intro');
            const pre = document.getElementById('terminal-text');
            pre.textContent = '';
            intro.style.display = 'block';
            intro.style.opacity = 1;

            if(window.gmod) gmod.webhook('playTypewriter');

            let i = 0;
            function tick() {
                if(introDone) return;
                const chunk = 48 + Math.floor(Math.random() * 42); // ~6x faster (48..89 chars per tick)
                pre.textContent += TERMINAL_CODE.substr(i, chunk);
                i += chunk;
                pre.scrollTop = pre.scrollHeight; // keep the newest line in view
                if(i < TERMINAL_CODE.length) {
                    typeTimer = setTimeout(tick, 14);
                } else {
                    typeTimer = setTimeout(finishTerminalIntro, 300); // brief hold, then fade
                }
            }
            tick();
        }

        // Crossfade from the terminal into the character creation wizard.
        function finishTerminalIntro() {
            if(introDone) return;
            introDone = true;
            if(typeTimer) { clearTimeout(typeTimer); typeTimer = null; }
            if(window.gmod) gmod.webhook('stopTypewriter');

            beginCreation(); // build & reveal the wizard underneath

            const intro = document.getElementById('terminal-intro');
            intro.style.opacity = 0;
            setTimeout(() => { intro.style.display = 'none'; }, 850);
        }

        // Builds and shows the actual creation wizard.
        function beginCreation() {
            document.getElementById('creation-view').style.display = 'flex';
            if(window.gmod) gmod.webhook('enteredCreation'); // Signal to show DModelPanel if needed

            // Reset state
            createData = {
                factionIndex: null,
                model: null,
                modelIndex: null,
                name: "",
                desc: "",
                background: null,
                attribs: {},
                skills: {},
                traits: {},
                languages: {}
            };
            // SPECIAL attributes start at 1.
            attributes.forEach(a => { createData.attribs[a.id] = 1; });

            currentStepIdx = 0;
            buildStepList();
            updateWizardUI();
            onEnterStep(STEPS[0].id);
        }

        function buildStepList() {
            const list = document.getElementById('step-list');
            if(!list) return;
            list.innerHTML = '';
            STEPS.forEach((step, idx) => {
                const el = document.createElement('div');
                el.className = 'step-item';
                el.id = 'step-btn-' + step.id;
                el.innerText = step.title;
                // Clicking a completed (earlier) step jumps back to it.
                el.onclick = () => { if(idx < currentStepIdx) goToStep(idx); };
                list.appendChild(el);
            });
        }

        function updateWizardUI() {
            STEPS.forEach((step, idx) => {
                const btn = document.getElementById('step-btn-' + step.id);
                if(btn) {
                    btn.classList.toggle('active', idx === currentStepIdx);
                    btn.classList.toggle('done', idx < currentStepIdx); // completed -> clickable
                }

                const content = document.getElementById('step-' + step.id);
                if(content) content.style.display = (idx === currentStepIdx) ? 'block' : 'none';
            });

            document.getElementById('btn-prev').disabled = currentStepIdx === 0;
            document.getElementById('btn-next').innerText = (currentStepIdx === STEPS.length - 1) ? "INITIALIZE" : "NEXT";
        }

        // Prepares a step's content when it becomes active.
        function onEnterStep(id) {
            // The model preview only shows on the visual step.
            if(id === 'visual') {
                buildModelGrid();
                setTimeout(updatePreviewBounds, 100);
                if(createData.model && window.gmod) gmod.webhook('updateModel', { model: createData.model });
            } else {
                if(window.gmod) gmod.webhook('hideModel');
            }

            if(id === 'faction') renderFactions();
            else if(id === 'data') {
                // Background + Languages live on the DATA step. Background eligibility
                // depends on the chosen race, so render them when this step opens.
                renderBackgrounds();
                renderLanguages();
            }
            else if(id === 'stats') {
                // SPECIAL and Skills share a page so the SPECIAL->skill bonus updates live.
                // Safety: ensure SPECIAL attributes were seeded to their minimum of 1.
                if(Object.keys(createData.attribs).length === 0) {
                    attributes.forEach(a => { createData.attribs[a.id] = 1; });
                }
                renderAttributes();
                renderSkills();
            }
            else if(id === 'traits') renderTraits();
        }

        function validateStep(id) {
            if(id === 'faction') {
                if(!createData.factionIndex) return "Please select a race.";
            } else if(id === 'visual') {
                if(!createData.model) return "Please select a visual model.";
            } else if(id === 'data') {
                const name = document.getElementById('input-name').value;
                const desc = document.getElementById('input-desc').value;
                if(name.length < 3) return "Name must be at least 3 characters.";
                if(desc.length < 10) return "Description is too short.";
                createData.name = name;
                createData.desc = desc;
            }
            // background / attributes / skills / traits / languages are optional.
            return null;
        }

        // Central navigation: switch to a step index and prepare its content.
        // onEnterStep() handles showing/hiding the model preview based on the destination.
        function goToStep(idx) {
            if(idx < 0 || idx >= STEPS.length) return;
            currentStepIdx = idx;
            updateWizardUI();
            onEnterStep(STEPS[idx].id);
        }

        function nextStep() {
            const step = STEPS[currentStepIdx];
            const err = validateStep(step.id);
            if(err) return showModal("ERROR", err, closeModal);

            // Submit on the final step.
            if(currentStepIdx === STEPS.length - 1) {
                submitCreation();
                return;
            }

            goToStep(currentStepIdx + 1);
        }

        function prevStep() {
            if(currentStepIdx > 0) goToStep(currentStepIdx - 1);
        }

        function submitCreation() {
            createData.traitList = Object.keys(createData.traits);
            createData.attributeList = createData.attribs;
            createData.skillList = createData.skills;
            createData.languageList = Object.keys(createData.languages);
            createData.backgroundUID = createData.background || "";

            if(window.gmod) gmod.webhook('submitCreate', createData);
            cancelCreation();
        }

        function cancelCreation() {
            document.getElementById('creation-view').style.display = 'none';
            document.getElementById('main-view').style.display = 'contents';
            if(window.gmod) gmod.webhook('exitedCreation');
        }

        // --- STEP RENDERERS ---
        function renderFactions() {
            const fGrid = document.getElementById('faction-grid');
            fGrid.innerHTML = '';
            factions.forEach(fac => {
                const el = document.createElement('div');
                el.className = 'grid-item';
                el.innerText = fac.name;
                if(fac.color) el.style.borderLeft = `3px solid rgb(${fac.color.r},${fac.color.g},${fac.color.b})`;
                if(createData.factionIndex === fac.index) {
                    el.classList.add('selected');
                    document.getElementById('faction-desc').innerText = fac.desc || '';
                }
                el.onclick = () => {
                    createData.factionIndex = fac.index;
                    createData.model = null; // Reset model on race change
                    createData.modelIndex = null;
                    createData.background = null; // Background eligibility depends on race
                    renderFactions();
                    document.getElementById('faction-desc').innerText = fac.desc || '';
                };
                fGrid.appendChild(el);
            });
        }

        function buildModelGrid() {
            const fac = factions.find(f => f.index === createData.factionIndex);
            const mGrid = document.getElementById('model-grid');
            mGrid.innerHTML = '';
            if(fac && fac.models) {
                fac.models.forEach((mdl, index) => {
                    const el = document.createElement('div');
                    el.className = 'grid-item';
                    const mdlName = mdl.split('/').pop().replace('.mdl', '');
                    el.innerText = mdlName;
                    if(createData.modelIndex === index + 1) el.classList.add('selected');
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

        function renderBackgrounds() {
            const grid = document.getElementById('background-grid');
            const descEl = document.getElementById('background-desc');
            grid.innerHTML = '';
            descEl.innerText = '';

            // Faction gating: only certain races can choose a background.
            const allowed = bgFactions.indexOf(createData.factionIndex) !== -1;
            if(!allowed) {
                createData.background = null;
                descEl.innerText = 'Your race cannot choose a background.';
                return;
            }

            backgrounds.forEach(bg => {
                const el = document.createElement('div');
                el.className = 'grid-item';
                el.innerText = bg.name;
                if(createData.background === bg.uid) {
                    el.classList.add('selected');
                    descEl.innerText = bg.desc || '';
                }
                el.onclick = () => {
                    createData.background = (createData.background === bg.uid) ? null : bg.uid;
                    renderBackgrounds();
                };
                el.onmouseenter = () => { descEl.innerText = bg.desc || ''; };
                grid.appendChild(el);
            });
        }

        function sumAttribs() {
            let s = 0;
            for(const k in createData.attribs) s += createData.attribs[k];
            return s;
        }

        function renderAttributes() {
            const list = document.getElementById('attrib-list');
            list.innerHTML = '';
            document.getElementById('attrib-points').innerText = totalAttribPoints - sumAttribs();

            attributes.forEach(attr => {
                const currentVal = createData.attribs[attr.id] || 1;

                const frame = document.createElement('div');
                frame.className = 'attrib-row';
                frame.innerHTML = `
                    <div class="attrib-info">
                        <span class="attrib-name">${attr.name}</span>
                        <span class="attrib-desc">${attr.desc || ''}</span>
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
            const current = createData.attribs[id] || 1;
            const newVal = current + amount;
            const attr = attributes.find(a => a.id === id);
            const cap = (attr && attr.maxValue) || maxPerAttrib;   // per-attribute cap (maxValue, e.g. 10)

            if(newVal < 1) return;                 // SPECIAL minimum is 1
            if(newVal > cap) return;               // per-attribute cap
            if(amount > 0 && (sumAttribs() + amount) > totalAttribPoints) return; // pool cap

            createData.attribs[id] = newVal;
            renderAttributes();
            renderSkills(); // SPECIAL feeds skill bonuses; refresh the adjacent skills column live.
        }

        function sumSkills() {
            let s = 0;
            for(const k in createData.skills) s += createData.skills[k];
            return s;
        }

        // Mirrors the server-side SPECIAL -> skill bonus preview.
        function specialSkillBonus(skill) {
            if(!skill.specialBonus) return 0;
            let bonus = 0;
            for(const attribID in skill.specialBonus) {
                const mult = skill.specialBonus[attribID];
                const attrib = attributes.find(a => a.id === attribID);
                if(!attrib || !attrib.skillBonus) continue;
                const selfMult = attrib.skillBonus[attribID];
                if(!selfMult) continue;
                const attribVal = createData.attribs[attribID] || 0;
                bonus += attribVal * mult * selfMult;
            }
            return Math.round(bonus);
        }

        function renderSkills() {
            const list = document.getElementById('skill-list');
            list.innerHTML = '';
            document.getElementById('skill-points').innerText = totalSkillPoints - sumSkills();

            skills.forEach(skill => {
                const currentVal = createData.skills[skill.id] || 0;
                const bonus = specialSkillBonus(skill);
                // Show the effective starting skill as one combined number (allocated points + SPECIAL bonus).
                const valTxt = `${currentVal + bonus}`;

                const frame = document.createElement('div');
                frame.className = 'attrib-row';
                frame.innerHTML = `
                    <div class="attrib-info">
                        <span class="attrib-name">${skill.name}</span>
                        <span class="attrib-desc">${skill.desc || ''}</span>
                    </div>
                    <div class="attrib-ctrl">
                        <button class="btn-small" onclick="modSkill('${skill.id}', -1)">-</button>
                        <span class="attrib-val" style="width:auto; min-width:52px;">${valTxt}</span>
                        <button class="btn-small" onclick="modSkill('${skill.id}', 1)">+</button>
                    </div>
                `;
                list.appendChild(frame);
            });
        }

        function modSkill(id, amount) {
            const current = createData.skills[id] || 0;
            const newVal = current + amount;
            const skill = skills.find(s => s.id === id);
            const cap = (skill && skill.maxValue) || maxPerSkill;  // per-skill cap (maxSkills, e.g. 100)

            if(newVal < 0) return;                 // skills minimum is 0
            if(newVal > cap) return;               // per-skill cap
            if(amount > 0 && (sumSkills() + amount) > totalSkillPoints) return; // pool cap

            createData.skills[id] = newVal;
            renderSkills();
        }

        function countTraits() {
            return Object.keys(createData.traits).length;
        }

        function renderTraits() {
            const tGrid = document.getElementById('trait-grid');
            const descEl = document.getElementById('trait-desc');
            tGrid.innerHTML = '';
            document.getElementById('trait-points').innerText = maxTraitPoints - countTraits();

            traits.forEach(trait => {
                const el = document.createElement('div');
                el.className = 'grid-item';
                el.innerText = trait.name;
                if(createData.traits[trait.uid]) el.classList.add('selected');

                el.onclick = () => {
                    if(createData.traits[trait.uid]) {
                        delete createData.traits[trait.uid];
                    } else {
                        if(countTraits() < maxTraitPoints) {
                            createData.traits[trait.uid] = true;
                        } else {
                            return; // Max points reached
                        }
                    }
                    renderTraits();
                    descEl.innerText = trait.desc || '';
                };
                el.onmouseenter = () => { descEl.innerText = trait.desc || ''; };
                tGrid.appendChild(el);
            });
        }

        function countLanguages() {
            return Object.keys(createData.languages).length;
        }

        function renderLanguages() {
            const grid = document.getElementById('language-grid');
            const descEl = document.getElementById('language-desc');
            grid.innerHTML = '';
            document.getElementById('language-points').innerText = maxLanguagePoints - countLanguages();

            languages.forEach(lang => {
                const el = document.createElement('div');
                el.className = 'grid-item';
                el.innerText = lang.name;
                if(createData.languages[lang.uid]) el.classList.add('selected');

                el.onclick = () => {
                    if(createData.languages[lang.uid]) {
                        delete createData.languages[lang.uid];
                    } else {
                        if(countLanguages() < maxLanguagePoints) {
                            createData.languages[lang.uid] = true;
                        } else {
                            return; // Max points reached
                        }
                    }
                    renderLanguages();
                    descEl.innerText = lang.desc || '';
                };
                el.onmouseenter = () => { descEl.innerText = lang.desc || ''; };
                grid.appendChild(el);
            });
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