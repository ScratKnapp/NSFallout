local SOCIAL = CYR.Net.Social
function SOCIAL:BuildFreeEddies()
    local f = self.container:Add("DHTML")
    f:Dock(FILL)
    f:SetHTML([[
        <style>
            body {
                background-color: #000000;
                background-image: linear-gradient(45deg, #000 25%, #111 25%, #111 50%, #000 50%, #000 75%, #111 75%, #111 100%);
                background-size: 20px 20px;
                color: #00ff00;
                font-family: 'Comic Sans MS', 'Chalkboard SE', sans-serif;
                text-align: center;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                height: 100vh;
                margin: 0;
                overflow: hidden;
            }
            h1 {
                font-size: 60px;
                color: #ffff00;
                text-shadow: 2px 2px #ff0000;
                margin: 0;
                animation: flash 0.5s infinite alternate;
            }
            @keyframes flash { from { color: #ffff00; } to { color: #ff0000; } }
            .box {
                background: rgba(0, 0, 50, 0.9);
                border: 5px dashed #00ff00;
                padding: 30px;
                width: 600px;
            }
            input {
                display: block;
                width: 90%;
                margin: 10px auto;
                padding: 10px;
                font-size: 20px;
                border: 2px solid #ff00ff;
            }
            button {
                background: #ff0000;
                color: #ffffff;
                font-size: 30px;
                font-weight: bold;
                padding: 20px 50px;
                border: 5px outset #ff0000;
                cursor: pointer;
                margin-top: 20px;
            }
            button:active {
                border-style: inset;
            }
            .marquee {
                width: 100%;
                background: #0000ff;
                color: white;
                font-weight: bold;
                padding: 5px 0;
                margin-bottom: 20px;
            }
        </style>
        <div class="marquee">WARNING: OFFER EXPIRES IN 00:05:00!!! ACT NOW!!!</div>
        <div class="box">
            <h1>$$ FREE EDDIES $$</h1>
            <h2>GENERATOR 2077 (WORKING)</h2>
            <p>Enter your details below to receive 1,000,000 Eurodollars instantly!</p>
            
            <input type="text" placeholder="Credit Chip Number" />
            <input type="text" placeholder="Social Security / SIN" />
            <input type="password" placeholder="PIN Code" />
            
            <button onclick="/* nothing */">GENERATE NOW</button>
            
            <p style="font-size: 10px; color: #888;">By clicking generate you agree to transfer all assets to Nigerian Prince Corp.</p>
        </div>
    ]])
end