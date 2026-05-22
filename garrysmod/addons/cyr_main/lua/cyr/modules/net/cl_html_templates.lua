CYR.Net = CYR.Net or {}
CYR.Net.HTML = {}
CYR.Net.HTML.CSS = [[
    <link href="https://fonts.cdnfonts.com/css/vcr-osd-mono" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #e6e6e6;
            --secondary-color: #a0a0a0;
            --tertiary-color: #ff5555;
            --primary-dim: rgba(230, 230, 230, 0.15);
            --bg-color: #050505;
            --grid-color: rgba(255, 255, 255, 0.05);
        }

        body {
            background-color: var(--bg-color);
            color: var(--primary-color);
            font-family: 'VCR OSD Mono', monospace;
            margin: 0;
            padding: 20px;
            overflow-y: auto;
            position: relative;
            
            /* Technical Grid Pattern */
            background-image: 
                linear-gradient(var(--grid-color) 1px, transparent 1px),
                linear-gradient(90deg, var(--grid-color) 1px, transparent 1px);
            background-size: 40px 40px;
        }

        /* CRT Effects */
        body::before {
            content: " ";
            display: block;
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;
            right: 0;
            background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.1) 50%);
            background-size: 100% 2px;
            z-index: 9998;
            pointer-events: none;
        }

        body::after {
            content: " ";
            display: block;
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;
            right: 0;
            background: rgba(255, 255, 255, 0.03);
            z-index: 9999;
            pointer-events: none;
            animation: scanline 8s linear infinite;
            opacity: 0.2;
            height: 5px;
        }

        @keyframes scanline {
            0% { top: -10%; }
            100% { top: 110%; }
        }

        ::-webkit-scrollbar {
            width: 8px;
        }
        
        ::-webkit-scrollbar-track {
            background: rgba(0, 0, 0, 0.3);
        }
        
        ::-webkit-scrollbar-thumb {
            background: var(--primary-dim); 
        }

        ::-webkit-scrollbar-thumb:hover { 
            background: var(--primary-color); 
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }

        .card {
            background: rgba(10, 10, 10, 0.9);
            border: 1px solid var(--primary-dim);
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.5);
        }

        h1, h2, h3 {
            text-transform: uppercase;
            margin-top: 0;
            color: #000;
            background: var(--primary-color);
            padding: 2px 10px;
            display: inline-block;
            clip-path: polygon(0 0, 100% 0, 95% 100%, 0% 100%);
            font-weight: bold;
            text-shadow: none;
        }

        input[type="text"], textarea, select {
            width: 100%;
            padding: 10px;
            background: rgba(0, 0, 0, 0.5);
            border: 1px solid var(--primary-dim);
            color: var(--primary-color);
            font-family: 'VCR OSD Mono', monospace;
            font-size: 16px;
            margin-bottom: 15px;
            box-sizing: border-box;
        }
        
        input[type="text"]:focus, textarea:focus, select:focus {
            outline: none;
            border-color: var(--primary-color);
            background: rgba(20, 20, 20, 0.8);
            box-shadow: 0 0 10px var(--primary-dim);
        }

        button {
            background: transparent;
            color: var(--primary-color);
            border: 1px solid var(--primary-color);
            padding: 10px 20px;
            font-family: 'VCR OSD Mono', monospace;
            font-weight: 700;
            font-size: 16px;
            cursor: pointer;
            text-transform: uppercase;
            transition: all 0.2s;
            width: 100%;
        }

        button:hover {
            background: var(--primary-color);
            color: #000;
            box-shadow: 0 0 15px var(--primary-dim);
        }

        .message-list {
            height: 400px;
            overflow-y: auto;
            margin-bottom: 20px;
            padding-right: 10px;
            display: flex;
            flex-direction: column;
        }

        .message-bubble {
            max-width: 80%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid var(--primary-dim);
            background: rgba(0, 0, 0, 0.5);
            color: var(--primary-color);
            align-self: flex-start;
            overflow-wrap: break-word;
            word-break: break-word;
        }

        .message-bubble.mine {
            align-self: flex-end;
            border-color: var(--primary-color);
            background: var(--primary-dim);
            color: #fff;
            text-align: right;
        }
        
        .message-sender {
            font-size: 0.8em;
            color: var(--secondary-color);
            margin-bottom: 4px;
        }

        .message-text {
            font-size: 1.1em;
            color: inherit;
        }
        
        a { color: var(--primary-color); text-decoration: none; }
        a:hover { text-decoration: underline; text-shadow: 0 0 5px var(--primary-color); }
    </style>
    <script>
        // Placeholder for emoji parsing - emoji map was missing
        function parseEmojis(content) {
            return content;
        }
    </script>
]]
function CYR.Net.HTML.GetBase()
    return [[
        <!DOCTYPE html>
        <html>
        <head>
            ]] .. CYR.Net.HTML.CSS .. [[
        </head>
        <body>
            <div id="app"></div>
            <script>
                function updateContent(html) {
                    document.getElementById('app').innerHTML = html;
                }
            </script>
        </body>
        </html>
    ]]
end