local function ModifyForLowIntelligence(text)
    -- CYR Chat Modification Module
    -- Modifies player chat based on attributes (intelligence and charisma)
    -- Makes text appear like the speaker has low intelligence
    -- Simplified grammar, misspellings, random capitalization, etc.
    local words = string.Explode(" ", text)
    local result = {}
    local replacements = {
        ["the"] = {"da", "teh", "tha"},
        ["you"] = {"u", "yu", "yoo"},
        ["your"] = {"ur", "yor", "yur"},
        ["you're"] = {"ur", "yor", "yur"},
        ["are"] = {"r", "iz", "ar"},
        ["what"] = {"wat", "wut", "wot"},
        ["why"] = {"y", "wai", "wy"},
        ["because"] = {"cuz", "bcuz", "coz"},
        ["with"] = {"wit", "wif", "wiv"},
        ["this"] = {"dis", "thiz", "ths"},
        ["that"] = {"dat", "tht"},
        ["they"] = {"dey", "thay"},
        ["them"] = {"dem", "thm"},
        ["their"] = {"der", "thier"},
        ["there"] = {"der", "ther", "thur"},
        ["where"] = {"wher", "ware", "wur"},
        ["here"] = {"hur", "her"},
        ["have"] = {"hav", "hve", "haf"},
        ["has"] = {"haz", "hs"},
        ["was"] = {"wuz", "waz"},
        ["were"] = {"wer", "wur"},
        ["would"] = {"wud", "woud"},
        ["could"] = {"cud", "coud"},
        ["should"] = {"shud", "shoud"},
        ["going"] = {"goin", "gunna", "gonna"},
        ["want"] = {"wan", "wnt", "wanna"},
        ["know"] = {"no", "kno", "knw"},
        ["think"] = {"tink", "thik", "fink"},
        ["something"] = {"sumthin", "somethin", "sumfin"},
        ["nothing"] = {"nuthin", "nothin", "nufin"},
        ["anything"] = {"anythin", "anyfing"},
        ["everything"] = {"evrything", "everythin"},
        ["people"] = {"peeple", "peple", "ppl"},
        ["please"] = {"plz", "pls", "pleas"},
        ["thanks"] = {"thx", "thnks", "tanks"},
        ["thank"] = {"thk", "thnk", "tank"},
        ["hello"] = {"helo", "hullo", "hlo"},
        ["okay"] = {"ok", "okey", "k"},
        ["really"] = {"rly", "realy", "relly"},
        ["pretty"] = {"prety", "pritty"},
        ["probably"] = {"probly", "prolly"},
        ["definitely"] = {"definetly", "defnitly"},
        ["maybe"] = {"mayb", "mabey", "maibe"},
        ["never"] = {"nevr", "nver"},
        ["always"] = {"alwys", "allways"},
        ["before"] = {"befor", "b4"},
        ["after"] = {"aftr", "afta"},
        ["about"] = {"bout", "abut", "abowt"},
        ["around"] = {"arond", "arund"},
        ["through"] = {"thru", "trough"},
        ["though"] = {"tho", "thogh"},
        ["enough"] = {"enuf", "enugh"},
        ["though"] = {"tho", "doe"},
        ["friend"] = {"frend", "freind", "fren"},
        ["money"] = {"mony", "monee", "munny"},
        ["someone"] = {"sumone", "som1"},
        ["everyone"] = {"evryone", "every1"},
        ["anyone"] = {"any1", "anywun"},
        ["myself"] = {"myslef", "meself"},
        ["yourself"] = {"urself", "yorself"},
        ["understand"] = {"undrstnd", "undrstand"},
        ["remember"] = {"remembr", "rember", "rememba"},
        ["different"] = {"diferent", "diffrent"},
        ["important"] = {"importnt", "importent"},
        ["actually"] = {"actualy", "aktually"},
        ["beautiful"] = {"beautful", "butiful"},
        ["tomorrow"] = {"tomorro", "2morrow", "tomrow"},
        ["yesterday"] = {"yestrday", "ysterday"},
        ["together"] = {"togethr", "togther"},
        ["another"] = {"anoter", "anuther"},
        ["whatever"] = {"watevr", "watever", "wutever"},
        ["however"] = {"howevr", "howver"},
        ["which"] = {"wich", "whch"},
        ["could've"] = {"coulda", "cuda"},
        ["should've"] = {"shoulda", "shuda"},
        ["would've"] = {"woulda", "wuda"},
        ["isn't"] = {"isnt", "aint"},
        ["aren't"] = {"arent", "aint"},
        ["don't"] = {"dont", "dnt"},
        ["doesn't"] = {"doesnt", "dosnt"},
        ["didn't"] = {"didnt", "dint"},
        ["can't"] = {"cant", "carnt"},
        ["won't"] = {"wont", "wnt"},
        ["haven't"] = {"havent", "havnt"},
        ["hasn't"] = {"hasnt"},
        ["let's"] = {"lets", "les"},
        ["i'm"] = {"im", "am"},
        ["i've"] = {"ive", "iv"},
        ["i'll"] = {"ill", "il"},
        ["i'd"] = {"id"},
        ["it's"] = {"its", "itz"},
        ["he's"] = {"hes", "hez"},
        ["she's"] = {"shes", "shez"},
        ["we're"] = {"were", "wer"},
        ["they're"] = {"theyre", "ther"},
    }

    for i, word in ipairs(words) do
        local lowerWord = string.lower(word)
        local modified = word
        -- Check for replacements
        if replacements[lowerWord] then
            local choices = replacements[lowerWord]
            modified = choices[math.random(1, #choices)]
        else
            -- Random chance to add errors to longer words
            if #word > 4 and math.random(1, 100) <= 30 then
                local errorType = math.random(1, 4)
                if errorType == 1 then
                    -- Double a random letter
                    local pos = math.random(2, #word - 1)
                    modified = word:sub(1, pos) .. word:sub(pos, pos) .. word:sub(pos + 1)
                elseif errorType == 2 then
                    -- Remove a random vowel
                    local vowelPositions = {}
                    for j = 2, #word - 1 do
                        if word:sub(j, j):match("[aeiouAEIOU]") then table.insert(vowelPositions, j) end
                    end

                    if #vowelPositions > 0 then
                        local pos = vowelPositions[math.random(1, #vowelPositions)]
                        modified = word:sub(1, pos - 1) .. word:sub(pos + 1)
                    end
                elseif errorType == 3 then
                    -- Swap two adjacent letters
                    local pos = math.random(1, #word - 1)
                    modified = word:sub(1, pos - 1) .. word:sub(pos + 1, pos + 1) .. word:sub(pos, pos) .. word:sub(pos + 2)
                elseif errorType == 4 then
                    -- Random capitalization
                    local newWord = ""
                    for j = 1, #word do
                        local char = word:sub(j, j)
                        if math.random(1, 100) <= 25 then
                            char = char:upper()
                        else
                            char = char:lower()
                        end

                        newWord = newWord .. char
                    end

                    modified = newWord
                end
            end
        end

        -- Randomly add filler words
        if math.random(1, 100) <= 10 then
            local fillers = {"uhhh", "like", "uh", "hmm"}
            modified = fillers[math.random(1, #fillers)] .. " " .. modified
        end

        table.insert(result, modified)
    end
    return table.concat(result, " ")
end

local function ModifyForLowCharisma(text)
    -- Makes text appear stuttery and adds "uhm..." between words
    local words = string.Explode(" ", text)
    local result = {}
    for i, word in ipairs(words) do
        local modified = word
        -- Stutter effect - repeat first letter/syllable
        if #word > 1 and math.random(1, 100) <= 40 then
            local stutterLength = 1
            -- Try to stutter at syllable boundary for words starting with consonant clusters
            if #word > 2 and word:sub(1, 1):match("[^aeiouAEIOU]") and word:sub(2, 2):match("[^aeiouAEIOU]") then stutterLength = 2 end
            local stutterPart = word:sub(1, stutterLength)
            local repetitions = math.random(1, 3)
            local stutter = ""
            for j = 1, repetitions do
                stutter = stutter .. stutterPart .. "-"
            end

            modified = stutter .. word
        end

        -- Add "uhm..." or similar between words
        if math.random(1, 100) <= 35 and i < #words then
            local fillers = {"uhm...", "uh...", "um...", "err...", "ah...", "ehh..."}
            modified = modified .. " " .. fillers[math.random(1, #fillers)]
        end

        -- Occasionally trail off
        if math.random(1, 100) <= 15 then modified = modified .. "..." end
        table.insert(result, modified)
    end

    local finalText = table.concat(result, " ")
    -- Sometimes add nervous starters
    if math.random(1, 100) <= 50 then
        local starters = {"Uhm... ", "So, uh... ", "I-I mean... ", "Well, uhm... ", "Err... "}
        finalText = starters[math.random(1, #starters)] .. finalText
    end
    return finalText
end

-- Hook into the chat system to modify messages based on attributes
hook.Add("PlayerMessageSend", "CYR_ChatAttributeModify", function(client, chatType, message, anonymous)
    -- Only modify IC (in-character) chat types
    local icTypes = {
        ["ic"] = true,
        ["w"] = true,
        ["whisper"] = true,
        ["y"] = true,
        ["yell"] = true,
        ["me"] = false,
        ["it"] = true,
    }

    if not icTypes[chatType] then return end
    local character = client:getChar()
    if not character then return end
    local intelligence = character:getAttrib("int", 0)
    local charisma = character:getAttrib("cha", 0)
    local modifiedMessage = message
    if intelligence <= 1 then modifiedMessage = ModifyForLowIntelligence(modifiedMessage) end
    if charisma <= 1 then modifiedMessage = ModifyForLowCharisma(modifiedMessage) end
    -- Return modified message if changes were made
    if modifiedMessage ~= message then return modifiedMessage end
end)

print("[CYR] Chat attribute modification module loaded!")