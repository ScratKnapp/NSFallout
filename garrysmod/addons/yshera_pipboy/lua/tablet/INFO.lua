
local newfunc = math.sin
local radioFreq = {}
function surface.OutlinedBox( x, y, w, h, thickness )
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end




local function DrawBox(x,y,perk)

	surface.OutlinedBox(x,y,60,60,2)
	surface.SetTextPos(x+64,y-11)
	surface.SetFont("Morton Medium@42")
	surface.DrawText(perk[1])
	surface.SetFont("Morton Medium@32") 
	surface.SetTextPos(x+64,y+16)
	surface.DrawText("RANK "..perk[3])

end

_HELIX_BUFFS = {
	{"Lightfooted" , "You Move Upto 5% faster based on your Current Health.",3},
	{"Placeholder" , "LOREUM ISPUMN BOOGLOOOFOFOG.",15},
	{"Placeholder" , "LOREUM ISPUMN BOOGLOOOFOFOG.",15},
	{"Placeholder" , "LOREUM ISPUMN BOOGLOOOFOFOG.",15},
	{"Placeholder" , "LOREUM ISPUMN BOOGLOOOFOFOG.",15},
	{"Placeholder" , "LOREUM ISPUMN BOOGLOOOFOFOG.",15},
	{"Placeholder" , "LOREUM ISPUMN BOOGLOOOFOFOG.",15},
	{"Placeholder" , "LOREUM ISPUMN BOOGLOOOFOFOG.",15},
	{"Placeholder" , "LOREUM ISPUMN BOOGLOOOFOFOG.",15}, 
	{"Placeholder" , "LOREUM ISPUMN BOOGLOOOFOFOG.",15},
}

tablet.pages["INFO"] = function(color_main) 


	surface.SetTextColor(color_main)
	draw.DrawText( "HELIX",  "Morton Medium@82",64,64)
	draw.DrawText( "RANK 1",  "Morton Medium@48",64,120)
	surface.SetDrawColor(color_main)

	local x,y = -420,-105
	for i = 0,9 do 
	DrawBox(x + ((i%2)*200) ,y + (80 * math.floor(i/2)),_HELIX_BUFFS[i+1])
	
	end
end


local function drawQuestFrame(focused,tracked,y,quest_name )
if focused then 
surface.SetDrawColor(pip_color)
	surface.DrawRect(60, 130+y, 400, 42)


	draw.SimpleText( quest_name,  "Morton Black@42",100, 151+y,color_black,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	else 
	draw.SimpleText( quest_name,  "Morton Black@42",100, 151+y,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	
	end
	if tracked then 
	surface.SetDrawColor(focused and color_black or pip_color)
	surface.DrawRect(72, 146+y, 14, 12)
	end
end


local function charWrap(text, remainingWidth, maxWidth)
    local totalWidth = 0

    text = text:gsub(".", function(char)
        totalWidth = totalWidth + surface.GetTextSize(char)

        -- Wrap around when the max width is reached
        if totalWidth >= remainingWidth then
            -- totalWidth needs to include the character width because it's inserted in a new line
            totalWidth = surface.GetTextSize(char)
            remainingWidth = maxWidth
            return "\n" .. char
        end

        return char
    end)

    return text, totalWidth
end

function textWrap(text, font, maxWidth)
    local totalWidth = 0

    surface.SetFont(font)

    local spaceWidth = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
            local char = string.sub(word, 1, 1)
            if char == "\n" or char == "\t" then
                totalWidth = 0
            end

            local wordlen = surface.GetTextSize(word)
            totalWidth = totalWidth + wordlen

            -- Wrap around when the max width is reached
            if wordlen >= maxWidth then -- Split the word if the word is too big
                local splitWord, splitPoint = charWrap(word, maxWidth - (totalWidth - wordlen), maxWidth)
                totalWidth = splitPoint
                return splitWord
            elseif totalWidth < maxWidth then
                return word
            end

            -- Split before the word
            if char == ' ' then
                totalWidth = wordlen - spaceWidth
                return '\n' .. string.sub(word, 2)
            end

            totalWidth = wordlen
            return '\n' .. word
        end)

    return text
end

-- concatenate a space to avoid the text being parsed as valve string
local function safeText(text)
    return string.match(text, "^#([a-zA-Z_]+)$") and text .. " " or text
end



function draw.DrawNonParsedText(text, font, x, y, color, xAlign)
    return draw.DrawText(safeText(text), font, x, y, color, xAlign)
end

function draw.DrawNonParsedSimpleText(text, font, x, y, color, xAlign, yAlign)
    return draw.SimpleText(safeText(text), font, x, y, color, xAlign, yAlign)
end

function draw.DrawNonParsedSimpleTextOutlined(text, font, x, y, color, xAlign, yAlign, outlineWidth, outlineColor)
    return draw.SimpleTextOutlined(safeText(text), font, x, y, color, xAlign, yAlign, outlineWidth, outlineColor)
end

function surface.DrawNonParsedText(text)
    return surface.DrawText(safeText(text))
end

function chat.AddNonParsedText(...)
    local tbl = {...}
    for i = 2, #tbl, 2 do
        tbl[i] = safeText(tbl[i])
    end
    return chat.AddText(unpack(tbl))
end

local questDesc = [[Robert and some members of the Calypso ordered me to do some bullshit dirty work in order to get my gear back. I need to find someone that goes by "The West" to learn more.]]
questDesc = textWrap(questDesc,"Morton Medium@24",300)

PIPBOY_FOCUSED_QUEST = PIPBOY_FOCUSED_QUEST or nil

tablet.pages["QUESTS"] = function(color_main)
	surface.SetDrawColor(pip_color)
	draw.DrawText("QUESTS", "Morton Black@42", 64, 64)
	surface.DrawRect(60, 106, 400, 8)

	local char = LocalPlayer():getChar()
	if not char then return end

	local active = char:getData("quests", {}) or {}
	local registered = (QUESTS and QUESTS.quests) or {}

	local list = {}
	for uid, _ in pairs(active) do
		local q = registered[uid]
		if q then list[#list + 1] = q end
	end

	if #list == 0 then
		draw.DrawText("No active quests.", "Morton Medium@32", 64, 140, color_white)
		return
	end

	if not PIPBOY_FOCUSED_QUEST or not active[PIPBOY_FOCUSED_QUEST] then
		PIPBOY_FOCUSED_QUEST = list[1].uid
	end

	for i, q in ipairs(list) do
		local y = (i - 1) * 48
		local focused = (q.uid == PIPBOY_FOCUSED_QUEST)
		local isIn, clicked = AddUIButton(60, 130 + y, 400, 42)
		if clicked then PIPBOY_FOCUSED_QUEST = q.uid end
		drawQuestFrame(focused, focused, y, (q.name or q.uid):upper())
	end

	local focusedQuest = registered[PIPBOY_FOCUSED_QUEST]
	if focusedQuest then
		surface.SetDrawColor(pip_color)
		draw.DrawText((focusedQuest.name or focusedQuest.uid):upper(), "Morton Black@42", 650, 120)
		surface.DrawRect(600, 125, 8, 400)
		local body = focusedQuest.reminder or focusedQuest.intro or ""
		draw.DrawNonParsedText(textWrap(body, "Morton Medium@24", 300), "Morton Medium@24", 650, 166, color_white, 0)
	end
end

hook.Add("Move", "keyLiwasten2", function()


end)