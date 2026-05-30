-- CYR DHTML Chat - HTML Content
-- Retro-sci-fi VHS aesthetic matching F1/F4 menus and HUD
CYR = CYR or {}
CYR.UI = CYR.UI or {}
CYR.UI.ChatHTML = [==[
<!DOCTYPE html>
<html>
<head>
<link href="https://fonts.cdnfonts.com/css/vcr-osd-mono" rel="stylesheet">
<style>
    :root {
        --primary-color: #FF4400;
        --secondary-color: #E0E0E0;
        --tertiary-color: #FF0000;
        --primary-dim: rgba(255, 68, 0, 0.3);
        --bg-color: rgba(5, 5, 5, 0.85);
        --grid-color: rgba(255, 68, 0, 0.05);
    }

    html, body {
        height: 100%;
        width: 100%;
        margin: 0;
        padding: 0;
    }

    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
        background: transparent;
        color: var(--secondary-color);
        font-family: 'VCR OSD Mono', monospace;
        font-size: 13px;
        overflow: hidden;
        user-select: none;
        -webkit-user-select: none;
    }

    /* --- MAIN CONTAINER --- */
    #chat-container {
        position: absolute;
        top: 2px; left: 2px; right: 2px; bottom: 2px;
        display: flex;
        flex-direction: column;
        opacity: 0;
        transition: opacity 0.3s ease;
        pointer-events: none;
    }

    #chat-container.active {
        opacity: 1;
        pointer-events: auto;
    }

    #chat-container.has-messages {
        opacity: 1;
    }

    /* --- TAB BAR (always reserves space) --- */
    #tab-bar {
        display: flex;
        flex-shrink: 0;
        height: 28px;
        background: var(--bg-color);
        border: 1px solid var(--primary-color);
        border-bottom: none;
        overflow: hidden;
        align-items: center;
        visibility: hidden;
        opacity: 0;
        transition: opacity 0.2s ease;
    }

    #chat-container.active #tab-bar {
        visibility: visible;
        opacity: 1;
    }

    /* Panning diagonal lines in tab bar */
    #tab-bar::before {
        content: '';
        position: absolute;
        top: 0; left: -100%; right: -100%; bottom: 0;
        background: repeating-linear-gradient(
            -45deg,
            transparent,
            transparent 38px,
            var(--grid-color) 38px,
            var(--grid-color) 40px
        );
        animation: panLines 4s linear infinite;
        pointer-events: none;
        z-index: 0;
    }

    @keyframes panLines {
        0% { transform: translateX(0); }
        100% { transform: translateX(56px); }
    }

    .tab-btn {
        position: relative;
        z-index: 1;
        padding: 0 16px;
        height: 100%;
        border: none;
        background: transparent;
        color: var(--secondary-color);
        font-family: 'VCR OSD Mono', monospace;
        font-size: 11px;
        cursor: pointer;
        text-transform: uppercase;
        letter-spacing: 1px;
        transition: all 0.2s;
        border-right: 1px solid var(--primary-dim);
        opacity: 0.6;
        white-space: nowrap;
    }

    .tab-btn:hover { opacity: 0.9; }

    .tab-btn.active {
        opacity: 1;
        color: var(--primary-color);
        background: var(--primary-dim);
        text-shadow: 0 0 8px var(--primary-color);
    }

    /* Pop-out icon inside combat log tab */
    .pop-out-icon {
        display: inline-block;
        margin-left: 8px;
        font-size: 10px;
        opacity: 0.5;
        transition: all 0.2s;
        vertical-align: middle;
    }

    .tab-btn:hover .pop-out-icon,
    .tab-btn.active .pop-out-icon {
        opacity: 1;
    }

    .pop-out-icon:hover {
        color: var(--tertiary-color);
        text-shadow: 0 0 6px var(--tertiary-color);
    }

    /* --- FILTER BAR (always reserves space) --- */
    #filter-bar {
        display: flex;
        flex-shrink: 0;
        height: 24px;
        background: rgba(5, 5, 5, 0.9);
        border: 1px solid var(--primary-dim);
        border-top: none;
        overflow: hidden;
        align-items: center;
        padding: 0 4px;
        gap: 2px;
        visibility: hidden;
        opacity: 0;
        transition: opacity 0.2s ease;
    }

    #chat-container.active #filter-bar {
        visibility: visible;
        opacity: 1;
    }

    .filter-btn {
        position: relative;
        z-index: 1;
        padding: 2px 10px;
        height: 18px;
        border: 1px solid var(--primary-dim);
        background: transparent;
        color: var(--secondary-color);
        font-family: 'VCR OSD Mono', monospace;
        font-size: 9px;
        cursor: pointer;
        text-transform: uppercase;
        letter-spacing: 1px;
        transition: all 0.2s;
        opacity: 0.7;
    }

    .filter-btn:hover { opacity: 1; }

    .filter-btn.filtered {
        opacity: 0.3;
        text-decoration: line-through;
        color: var(--tertiary-color);
        border-color: rgba(255, 0, 0, 0.2);
    }

    /* --- MESSAGE AREA (fills remaining flex space) --- */
    #messages-wrap {
        flex: 1;
        position: relative;
        overflow: hidden;
    }

    #chat-container.active #messages-wrap {
        background: var(--bg-color);
        border: 1px solid var(--primary-dim);
        border-top: none;
    }

    .msg-panel {
        position: absolute;
        top: 0; left: 0; right: 0; bottom: 0;
        overflow-y: auto;
        padding: 6px 8px;
        display: none;
    }

    .msg-panel.visible { display: block; }

    /* Scrollbar */
    .msg-panel::-webkit-scrollbar { width: 4px; }
    .msg-panel::-webkit-scrollbar-track { background: transparent; }
    .msg-panel::-webkit-scrollbar-thumb { background: var(--primary-dim); }
    .msg-panel::-webkit-scrollbar-thumb:hover { background: var(--primary-color); }

    /* CRT scanlines (active only) */
    #chat-container.active #messages-wrap::after {
        content: '';
        position: absolute;
        top: 0; left: 0; right: 0; bottom: 0;
        background: linear-gradient(rgba(18,16,16,0) 50%, rgba(0,0,0,0.06) 50%);
        background-size: 100% 2px;
        pointer-events: none;
        z-index: 10;
    }

    /* --- CHAT MESSAGES --- */
    .chat-line {
        padding: 2px 0;
        line-height: 1.4;
        word-wrap: break-word;
        overflow-wrap: break-word;
        transition: opacity 1s ease;
    }

    .chat-line.fading { opacity: 0; }

    .chat-timestamp {
        color: var(--primary-dim);
        font-size: 10px;
        margin-right: 4px;
    }

    /* --- COMBAT LOG ENTRIES (inline in comms) --- */
    .combat-entry {
        padding: 3px 6px;
        margin: 2px 0;
        border-left: 2px solid var(--primary-dim);
        font-size: 12px;
        line-height: 1.3;
        transition: opacity 1s ease;
    }

    .combat-entry.fading { opacity: 0; }
    .combat-entry.damage-taken { border-left-color: #ff4444; color: #ff6666; }
    .combat-entry.damage-dealt { border-left-color: #ff8800; color: #ffaa44; }
    .combat-entry.heal { border-left-color: #44ff44; color: #66ff66; }
    .combat-entry.buff { border-left-color: #4488ff; color: #6699ff; }
    .combat-entry.system { border-left-color: var(--primary-color); color: var(--secondary-color); font-style: italic; }

    .combat-amount { font-weight: bold; font-size: 13px; }
    .combat-timestamp { color: rgba(255,255,255,0.2); font-size: 9px; float: right; }

    /* Hide combat entries in main chat when popped out */
    #chat-container.popped-out #panel-comms .combat-entry,
    #chat-container.popped-out #panel-comms .chat-line[data-filter="combat"] {
        display: none !important;
    }
</style>
</head>
<body>
<div id="chat-container">
    <div id="tab-bar">
        <button class="tab-btn active" id="tab-comms">COMMS</button>
        <button class="tab-btn" id="tab-combat" onclick="popOutCombatLog()">COMBAT LOG <span class="pop-out-icon">&#x2197;</span></button>
    </div>
    <div id="filter-bar"></div>
    <div id="messages-wrap">
        <div class="msg-panel visible" id="panel-comms"></div>
        <div class="msg-panel" id="panel-combat"></div>
    </div>
</div>

<script>
    // --- ES5 ONLY ---
    var root = document.documentElement;
    var chatContainer = document.getElementById('chat-container');
    var panelComms = document.getElementById('panel-comms');
    var panelCombat = document.getElementById('panel-combat');
    var filterBar = document.getElementById('filter-bar');
    var currentTab = 'comms';
    var isActive = false;
    var isPoppedOut = false;
    var fadeTimers = [];
    var MAX_MESSAGES = 200;
    var FADE_DELAY = 15000;
    var FADE_DURATION = 5000;
    var filteredCategories = {};

    // --- WEBHOOKS ---
    var Webhooks = {
        triggers: {},
        trigger: function(name, data) {
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

    // --- HELPERS ---
    function getTimestamp() {
        var d = new Date();
        var h = d.getHours();
        var m = d.getMinutes();
        return (h < 10 ? '0' : '') + h + ':' + (m < 10 ? '0' : '') + m;
    }

    function scrollToBottom(panel) {
        panel.scrollTop = panel.scrollHeight;
    }

    function trimMessages(panel) {
        while (panel.children.length > MAX_MESSAGES) {
            panel.removeChild(panel.firstChild);
        }
    }

    // --- TAB SWITCHING ---
    function switchTab(tab) {
        currentTab = tab;
        var tabs = document.querySelectorAll('.tab-btn');
        for (var i = 0; i < tabs.length; i++) {
            tabs[i].className = 'tab-btn';
        }

        var panels = document.querySelectorAll('.msg-panel');
        for (var i = 0; i < panels.length; i++) {
            panels[i].className = 'msg-panel';
        }

        if (tab === 'comms') {
            document.getElementById('tab-comms').className = 'tab-btn active';
            document.getElementById('panel-comms').className = 'msg-panel visible';
        } else {
            document.getElementById('tab-combat').className = 'tab-btn active';
            document.getElementById('panel-combat').className = 'msg-panel visible';
        }
    }

    // --- FILTER BUTTONS ---
    function initFilters(categories, activeFilters) {
        filterBar.innerHTML = '';
        for (var i = 0; i < categories.length; i++) {
            var cat = categories[i];
            var btn = document.createElement('button');
            btn.className = 'filter-btn';
            btn.textContent = cat.toUpperCase();
            btn.setAttribute('data-filter', cat);

            if (activeFilters && activeFilters.indexOf(cat) >= 0) {
                btn.className = 'filter-btn filtered';
                filteredCategories[cat] = true;
            }

            btn.onclick = (function(category, button) {
                return function() {
                    if (filteredCategories[category]) {
                        delete filteredCategories[category];
                        button.className = 'filter-btn';
                    } else {
                        filteredCategories[category] = true;
                        button.className = 'filter-btn filtered';
                    }
                    applyFilters();
                    var active = [];
                    for (var key in filteredCategories) {
                        if (filteredCategories.hasOwnProperty(key)) {
                            active.push(key);
                        }
                    }
                    Webhooks.callLua('filterChanged', { filters: active });
                };
            })(cat, btn);

            filterBar.appendChild(btn);
        }
    }

    function applyFilters() {
        var lines = panelComms.querySelectorAll('.chat-line');
        for (var i = 0; i < lines.length; i++) {
            var filter = lines[i].getAttribute('data-filter') || 'ic';
            if (filteredCategories[filter]) {
                lines[i].style.display = 'none';
            } else {
                lines[i].style.display = '';
            }
        }
    }

    // --- CHAT MESSAGES ---
    function addChatMessage(segments, filter) {
        var line = document.createElement('div');
        line.className = 'chat-line';
        line.setAttribute('data-filter', filter || 'ic');

        var ts = document.createElement('span');
        ts.className = 'chat-timestamp';
        ts.textContent = getTimestamp();
        line.appendChild(ts);

        for (var i = 0; i < segments.length; i++) {
            var seg = segments[i];
            var span = document.createElement('span');
            span.style.color = 'rgb(' + (seg.r || 255) + ',' + (seg.g || 255) + ',' + (seg.b || 255) + ')';
            span.textContent = seg.text || '';
            line.appendChild(span);
        }

        if (filteredCategories[filter || 'ic']) {
            line.style.display = 'none';
        }

        panelComms.appendChild(line);
        trimMessages(panelComms);
        scrollToBottom(panelComms);

        if (!isActive) {
            chatContainer.classList.add('has-messages');
            scheduleFade(line);
        }
    }

    function scheduleFade(element) {
        var timer1 = setTimeout(function() {
            element.classList.add('fading');
            var timer2 = setTimeout(function() {
                var lines = panelComms.querySelectorAll('.chat-line:not(.fading)');
                var combats = panelComms.querySelectorAll('.combat-entry:not(.fading)');
                if (lines.length === 0 && combats.length === 0 && !isActive) {
                    chatContainer.classList.remove('has-messages');
                }
            }, FADE_DURATION);
            fadeTimers.push(timer2);
        }, FADE_DELAY);
        fadeTimers.push(timer1);
    }

    // --- COMBAT LOG ---
    function addCombatEntry(data) {
        var entry = document.createElement('div');
        entry.className = 'combat-entry ' + (data.type || 'system');

        var ts = document.createElement('span');
        ts.className = 'combat-timestamp';
        ts.textContent = getTimestamp();
        entry.appendChild(ts);

        if (data.amount) {
            var amt = document.createElement('span');
            amt.className = 'combat-amount';
            amt.textContent = (data.type === 'heal' ? '+' : '-') + data.amount + ' ';
            entry.appendChild(amt);
        }

        var txt = document.createElement('span');
        txt.textContent = data.text || '';
        entry.appendChild(txt);

        // Always show in both dedicated combat panel AND inline in comms
        // CSS handles hiding from comms when popped out
        panelCombat.appendChild(entry.cloneNode(true));
        trimMessages(panelCombat);
        scrollToBottom(panelCombat);

        panelComms.appendChild(entry);
        trimMessages(panelComms);
        scrollToBottom(panelComms);

        if (!isActive) {
            chatContainer.classList.add('has-messages');
            scheduleFade(entry);
        }

        // Forward to pop-out if it exists
        Webhooks.callLua('combatLogEntry', data);
    }

    // Combat chat messages (from cMsg2) - chat-styled but routed to combat pipeline
    function addCombatChatMessage(segments) {
        // Build a chat-line element
        function buildLine() {
            var line = document.createElement('div');
            line.className = 'chat-line';
            line.setAttribute('data-filter', 'combat');

            var ts = document.createElement('span');
            ts.className = 'chat-timestamp';
            ts.textContent = getTimestamp();
            line.appendChild(ts);

            for (var i = 0; i < segments.length; i++) {
                var seg = segments[i];
                var span = document.createElement('span');
                span.style.color = 'rgb(' + (seg.r || 255) + ',' + (seg.g || 255) + ',' + (seg.b || 255) + ')';
                span.textContent = seg.text || '';
                line.appendChild(span);
            }
            return line;
        }

        // Always show in both dedicated combat panel AND inline in comms
        var combatLine = buildLine();
        panelCombat.appendChild(combatLine);
        trimMessages(panelCombat);
        scrollToBottom(panelCombat);

        var commsLine = buildLine();
        panelComms.appendChild(commsLine);
        trimMessages(panelComms);
        scrollToBottom(panelComms);

        if (!isActive) {
            chatContainer.classList.add('has-messages');
            scheduleFade(commsLine);
        }

        // Forward to pop-out
        Webhooks.callLua('combatChatEntry', { segments: segments });
    }

    // --- ACTIVE STATE ---
    function setActive(state) {
        isActive = state;
        if (state) {
            chatContainer.classList.add('active');
            chatContainer.classList.add('has-messages');
            var fading = document.querySelectorAll('.fading');
            for (var i = 0; i < fading.length; i++) {
                fading[i].classList.remove('fading');
            }
            for (var i = 0; i < fadeTimers.length; i++) {
                clearTimeout(fadeTimers[i]);
            }
            fadeTimers = [];
        } else {
            chatContainer.classList.remove('active');
            var lines = panelComms.querySelectorAll('.chat-line');
            for (var i = 0; i < lines.length; i++) {
                scheduleFade(lines[i]);
            }
            var combatLines = panelComms.querySelectorAll('.combat-entry');
            for (var i = 0; i < combatLines.length; i++) {
                scheduleFade(combatLines[i]);
            }
        }
    }

    // --- POP OUT ---
    function popOutCombatLog() {
        Webhooks.callLua('popOutCombatLog', {});
    }

    function setPoppedOut(state) {
        isPoppedOut = state;
        if (state) {
            chatContainer.classList.add('popped-out');
        } else {
            chatContainer.classList.remove('popped-out');
        }
    }

    // Transfer existing combat messages to the pop-out window
    function transferCombatToPopout() {
        // Collect all combat entries from panel-combat (has everything)
        var entries = panelCombat.querySelectorAll('.combat-entry, .chat-line');
        var htmlArr = [];
        for (var i = 0; i < entries.length; i++) {
            htmlArr.push(entries[i].outerHTML);
        }

        // Send to Lua for forwarding to pop-out DHTML
        if (htmlArr.length > 0) {
            Webhooks.callLua('transferCombatMessages', { html: htmlArr });
        }
    }

    // Receive transferred combat messages (in the pop-out instance)
    function insertCombatHTML(data) {
        var html = data.html || [];
        for (var i = 0; i < html.length; i++) {
            panelCombat.insertAdjacentHTML('beforeend', html[i]);
        }
        scrollToBottom(panelCombat);
    }

    // --- COLOR SETTINGS ---
    function updateColors(data) {
        if (data.primary) {
            root.style.setProperty('--primary-color', data.primary);
            var hex = data.primary.replace('#', '');
            var r = parseInt(hex.substring(0, 2), 16);
            var g = parseInt(hex.substring(2, 4), 16);
            var b = parseInt(hex.substring(4, 6), 16);
            root.style.setProperty('--primary-dim', 'rgba(' + r + ',' + g + ',' + b + ',0.3)');
            root.style.setProperty('--grid-color', 'rgba(' + r + ',' + g + ',' + b + ',0.05)');
        }
        if (data.secondary) {
            root.style.setProperty('--secondary-color', data.secondary);
        }
        if (data.tertiary) {
            root.style.setProperty('--tertiary-color', data.tertiary);
        }
    }

    // --- WEBHOOK REGISTRATIONS ---
    Webhooks.register('addChatMessage', function(data) {
        addChatMessage(data.segments || [], data.filter || 'ic');
    });

    Webhooks.register('addCombatEntry', function(data) {
        addCombatEntry(data);
    });

    Webhooks.register('addCombatChatMessage', function(data) {
        addCombatChatMessage(data.segments || []);
    });

    Webhooks.register('insertCombatHTML', function(data) {
        insertCombatHTML(data);
    });

    Webhooks.register('setActive', function(data) {
        setActive(data.active);
    });

    Webhooks.register('setPoppedOut', function(data) {
        setPoppedOut(data.state);
    });

    Webhooks.register('updateColors', function(data) {
        updateColors(data);
    });

    Webhooks.register('initFilters', function(data) {
        initFilters(data.categories || [], data.activeFilters || []);
    });

    Webhooks.register('setFilters', function(data) {
        var cats = data.filters || [];
        filteredCategories = {};
        for (var i = 0; i < cats.length; i++) {
            filteredCategories[cats[i]] = true;
        }
        var btns = filterBar.querySelectorAll('.filter-btn');
        for (var i = 0; i < btns.length; i++) {
            var cat = btns[i].getAttribute('data-filter');
            if (filteredCategories[cat]) {
                btns[i].className = 'filter-btn filtered';
            } else {
                btns[i].className = 'filter-btn';
            }
        }
        applyFilters();
    });
</script>
</body>
</html>
]==]