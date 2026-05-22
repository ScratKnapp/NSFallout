local SOCIAL = CYR.Net.Social
function SOCIAL:BuildFreeTheFiles()
    local f = self.container:Add("DHTML")
    f:Dock(FILL)
    f:SetHTML([[
        <style>
            body { 
                background-color: #0a0a0a; 
                color: #ff3333; 
                font-family: 'Courier New', monospace; 
                padding: 40px; 
                text-align: center; 
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                box-sizing: border-box;
            }
            h1 { 
                font-size: 64px; 
                text-transform: uppercase; 
                border: 4px solid #ff3333; 
                padding: 20px; 
                margin-bottom: 40px;
                text-shadow: 0 0 10px #ff0000;
                background-color: rgba(255, 0, 0, 0.1);
            }
            p { 
                font-size: 32px; 
                margin: 20px 0; 
                text-shadow: 0 0 5px #ff0000;
            }
            .blink { animation: blinker 0.8s step-end infinite; }
            @keyframes blinker { 50% { opacity: 0; } }
            .glitch {
                position: relative;
            }
            .footer {
                margin-top: 50px;
                font-size: 18px;
                color: #888;
            }
        </style>
        <div>
            <h1>CLASSIFIED DATA LEAK</h1>
            <p>WE KNOW WHAT YOU DID.</p>
            <p>RELEASE THE <span class="blink" style="color: #fff; background: #f00; padding: 0 10px;">ADAM SMASHER</span> FILES.</p>
            <p>THE TRUTH CANNOT BE CONTAINED.</p>
            <p class="footer">net://free-the-files | #SmasherGate</p>
        </div>
    ]])
end