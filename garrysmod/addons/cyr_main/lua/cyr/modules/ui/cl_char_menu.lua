-- ConCommand to open/close
concommand.Add("nutCharacter", function()
    if IsValid(CYR_CHAR_MENU) then
        CYR_CHAR_MENU:Remove()
    else
        vgui.Create("nutCharacter")
    end
end)

local cvPacDebug = {
    GetBool = function() return true end
}

local PANEL = {}
function PANEL:Init()
    if IsValid(CYR_CHAR_MENU) then CYR_CHAR_MENU:Remove() end
    CYR_CHAR_MENU = self
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    -- Open Sound
    sound.Play("nl_ui_menu_next1.wav", LocalPlayer():GetPos(), 75, 100, 0.35)
    self.html = vgui.Create("DHTML", self)
    self.html:Dock(FILL)
    -- self.html:SetAllowLuaInput(false) -- Removed (Method does not exist)
    self.html:SetMouseInputEnabled(true)
    self.html:SetKeyboardInputEnabled(true)
    -- Prevent white flash
    self.html.Paint = function() end
    self.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0)
        surface.DrawRect(0, 0, w, h)
    end

    -- Add JS Callbacks
    self.html:AddFunction("gmod", "webhook", function(name, data)
        if name == "playSound" then
            if data.sound then surface.PlaySound(data.sound) end
        elseif name == "playTypewriter" then
            -- Looping typewriter SFX during the terminal boot intro.
            if IsValid(self.typeChannel) then self.typeChannel:Stop() end
            sound.PlayURL("https://www.myinstants.com/media/sounds/typewriter-sfx0281319.mp3", "noplay", function(channel)
                if not IsValid(channel) then return end
                if not IsValid(self) then channel:Stop() return end
       
                channel:SetVolume(0.6)
                channel:Play()
                self.typeChannel = channel
            end)
        elseif name == "stopTypewriter" then
            if IsValid(self.typeChannel) then
                self.typeChannel:Stop()
                self.typeChannel = nil
            end
        elseif name == "selectChar" then
            if data.id then self.selectedCharID = data.id end
            LocalPlayer():EmitSound("nl_ui_menu_focus.wav", 0, 100, 0.35)
        elseif name == "play" then
            LocalPlayer():EmitSound("nl_ui_menu_next1.wav", 0, 100, 0.35)
            if data.id then
                local currentID = LocalPlayer():getChar() and LocalPlayer():getChar():getID()
                if currentID == data.id then
                    self:Remove()
                    return
                end

                net.Start("nutCharChoose")
                net.WriteUInt(data.id, 32)
                net.SendToServer()
            end
        elseif name == "create" then
            -- Handled in JS
        elseif name == "updateModel" then
            if cvPacDebug:GetBool() then print("[PAC TRACKER] updateModel webhook received. ID: " .. tostring(data.id or self.selectedCharID)) end
            if data.model then self:UpdateModelView(data.model, data.pac, data.id or self.selectedCharID) end
        elseif name == "updateModelBounds" then
            if IsValid(self.model) then
                self.model:SetPos(data.x, data.y)
                self.model:SetSize(data.w, data.h)
            end
        elseif name == "hideModel" then
            if IsValid(self.model) then self.model:SetVisible(false) end
        elseif name == "enteredCreation" then
            if IsValid(self.model) then self.model:SetVisible(false) end
        elseif name == "exitedCreation" then
            if IsValid(self.model) then self.model:SetVisible(false) end
        elseif name == "submitCreate" then
            sound.Play("nl_ui_menu_next1.wav", LocalPlayer():GetPos(), 75, 100, 0.35)
            local traitData = {}
            if data.traitList then
                for _, uid in ipairs(data.traitList) do
                    traitData[uid] = 1
                end
            end

            local attribData = {}
            if data.attributeList then
                for k, v in pairs(data.attributeList) do
                    attribData[k] = v
                end
            end

            -- Skills are a registered char var ("skills"), stored as {skillID = points}.
            local skillData = {}
            if data.skillList then
                for k, v in pairs(data.skillList) do
                    skillData[k] = v
                end
            end

            -- Languages are persistence data, stored as {languageUID = 1}.
            local languageData = {}
            if data.languageList then
                for _, uid in ipairs(data.languageList) do
                    languageData[uid] = 1
                end
            end

            -- Background (history) is persistence data, a single {historyUID = 1}.
            local historyData = {}
            if data.backgroundUID and data.backgroundUID ~= "" then historyData[data.backgroundUID] = 1 end
            -- The 'data' variable holds persistence data (traits, languages, history in this schema).
            local persistData = {
                traits = traitData,
                languages = languageData
            }

            -- Only attach a background when one was chosen (keeps getHistory()'s "none" default intact).
            if next(historyData) then persistData.history = historyData end

            -- Perk points (ptPerk) are the leftover trait/perk pool. The stock NutScript trait
            -- step set this on creation; the CYR menu replaced that flow, so initialize it here
            -- (otherwise the F1 menu reads an uninitialized value and shows "Perk Points: -1").
            -- Spend = trait picks; leftover carries over as perk points to unlock more later.
            persistData.ptPerk = math.max(nut.config.get("maxTraits", 2) - table.Count(traitData), 0)

            -- Initialise as empty: creation perks are free baseline picks, not "purchased"
            -- ones. Only perks bought post-creation via perkAdd go into this table.
            -- An empty-table (not nil) is important so the respec code takes the new
            -- non-legacy path and does NOT strip creation traits.
            persistData.purchasedPerks = {}

            -- NutScript nutCharCreate expects a flat table where keys match registered variables.
            -- Attributes/Skills are variables, so they must be at the top level.
            -- Name/Desc/Model/Faction are also variables.
            local flatData = {
                faction = data.factionIndex,
                model = data.modelIndex or 1, -- Send INDEX, not path
                name = data.name,
                desc = data.desc,
                attribs = attribData,
                skills = skillData,
                data = persistData
            }

            -- Debug Print
            if cvPacDebug:GetBool() then
                print("[CHAR-CREATE] Submitting payload:")
                PrintTable(flatData)
            end

            net.Start("nutCharCreate")
            local count = 0
            for k, v in pairs(flatData) do
                count = count + 1
            end

            net.WriteUInt(count, 32)
            for k, v in pairs(flatData) do
                net.WriteString(k)
                net.WriteType(v)
            end

            net.SendToServer()
        elseif name == "delete" then
            if data.id then
                net.Start("nutCharDelete")
                net.WriteUInt(data.id, 32)
                net.SendToServer()
                sound.Play("nl_ui_menu_next1.wav", LocalPlayer():GetPos(), 75, 100, 0.35)
            end
        elseif name == "disconnect" then
            RunConsoleCommand("disconnect")
        elseif name == "js_ready" then
            self:RefreshCharacters()
        end
    end)

    self.html:SetHTML(CYR.UI.CharMenuHTML or "<h1>ERROR: HTML NOT FOUND</h1>")
end

function PANEL:OnRemove()
    if IsValid(self.typeChannel) then self.typeChannel:Stop() end
    LocalPlayer():EmitSound("nl_ui_menu_back" .. math.random(1, 3) .. ".wav", 0, 100, 0.35)
end

net.Receive("nutCharChoose", function()
    local fault = net.ReadString()
    if fault and #fault > 0 then return nut.util.notify(fault) end
    if IsValid(CYR_CHAR_MENU) then CYR_CHAR_MENU:Remove() end
    -- Also close if a hook exists
    hook.Run("OnCharSelectionClosed")
end)

net.Receive("nutCharCreate", function()
    local id = net.ReadUInt(32)
    local fault = net.ReadString()
    if id == 0 then return nut.util.notify(fault) end
    if IsValid(CYR_CHAR_MENU) then
        CYR_CHAR_MENU:RefreshCharacters()
        CYR_CHAR_MENU.html:Call("cancelCreation()") -- Return to character list
    end
end)

-- Refresh the open menu whenever the character list changes server-side (e.g. after a
-- character is deleted and the server re-syncs nutCharList), so stale entries are removed.
hook.Add("CharacterListUpdated", "cyrCharMenuRefresh", function()
    if IsValid(CYR_CHAR_MENU) then
        CYR_CHAR_MENU:RefreshCharacters()
    end
end)

function PANEL:RefreshCharacters()
    -- 1. Fetch Characters
    local chars = {}
    if nut.characters then
        for _, id in ipairs(nut.characters) do
            local char = nut.char.loaded and nut.char.loaded[id]
            if char then
                -- Safely get faction name
                local factionID = char:getFaction()
                local factionName = "Unknown"
                if nut.faction and nut.faction.indices and nut.faction.indices[factionID] then factionName = nut.faction.indices[factionID].name end
                table.insert(chars, {
                    id = char:getID(),
                    name = char:getName(),
                    faction = factionID,
                    factionName = factionName,
                    money = char:getMoney(),
                    desc = char:getDesc(),
                    model = char:getModel(),
                })
                -- if cvPacDebug:GetBool() then print("[PAC DEBUG] Char " .. char:getName() .. " lastPac type: " .. type(chars[#chars].lastPac)) end
            end
        end
    end

    -- 2. Fetch Factions for Creation
    local factions = {}
    if nut.faction and nut.faction.indices then
        for id, data in pairs(nut.faction.indices) do
            if nut.faction.hasWhitelist(id) then
                table.insert(factions, {
                    index = id,
                    name = data.name,
                    desc = data.desc,
                    color = data.color, -- Color table {r,g,b}
                    models = data.models -- List of models
                })
            end
        end
    end

    -- 3. Fetch Traits
    local traits = {}
    if TRAITS and TRAITS.traits then
        for uid, data in pairs(TRAITS.traits) do
            if not data.hidden then
                table.insert(traits, {
                    uid = uid,
                    name = data.name,
                    desc = data.desc,
                    category = data.category
                })
            end
        end

        -- Sort by name
        table.sort(traits, function(a, b) return a.name < b.name end)
    end

    -- 4. Fetch Attributes (SPECIAL)
    local attributes = {}
    if nut.attribs and nut.attribs.list then
        for k, v in pairs(nut.attribs.list) do
            local nm = tostring(v.name or "")
            if nm:lower() ~= "unknown" then
                table.insert(attributes, {
                    id = k,
                    name = v.name,
                    desc = v.desc,
                    maxValue = v.maxValue, -- per-attribute cap (mirrors charMeta:updateAttrib)
                    skillBonus = v.skillBonus -- used to preview SPECIAL->skill bonuses
                })
            end
        end

        table.sort(attributes, function(a, b) return a.name < b.name end)
    end

    -- 5. Fetch Skills
    local skills = {}
    if nut.skills and nut.skills.list then
        for k, v in pairs(nut.skills.list) do
            if not v.noStartBonus then
                table.insert(skills, {
                    id = k,
                    name = v.name,
                    desc = v.desc,
                    maxValue = v.maxValue, -- per-skill cap (mirrors charMeta:updateSkill)
                    specialBonus = v.specialBonus
                })
            end
        end

        table.sort(skills, function(a, b) return a.name < b.name end)
    end

    -- 6. Fetch Backgrounds (history plugin)
    local backgrounds = {}
    if HISTORIES and HISTORIES.histories then
        for uid, v in pairs(HISTORIES.histories) do
            if not v.ignore then
                table.insert(backgrounds, {
                    uid = uid,
                    name = v.name,
                    desc = v.desc,
                    category = v.category
                })
            end
        end

        table.sort(backgrounds, function(a, b) return a.name < b.name end)
    end

    -- Which factions are allowed to choose a background.
    local allowedBgFactions = {}
    local histPlugin = nut.plugin and nut.plugin.list and nut.plugin.list["history"]
    if histPlugin and histPlugin.factions then
        for facIdx in pairs(histPlugin.factions) do
            table.insert(allowedBgFactions, facIdx)
        end
    end

    -- 7. Fetch Languages
    local languages = {}
    if LANGUAGES and LANGUAGES.languages then
        for uid, v in pairs(LANGUAGES.languages) do
            if not v.ignore then
                table.insert(languages, {
                    uid = uid,
                    name = v.name,
                    desc = v.desc,
                    category = v.category
                })
            end
        end

        table.sort(languages, function(a, b) return a.name < b.name end)
    end

    -- Resolve point pools from config / hooks.
    local totalAttribPoints = hook.Run("GetStartAttribPoints", LocalPlayer()) or nut.config.get("startAttribs", 28)
    local maxPerAttrib = nut.config.get("maxAttribs", 10)
    local totalSkillPoints = hook.Run("GetStartSkillPoints", LocalPlayer()) or nut.config.get("charCreateSkills", 25)
    local maxPerSkill = nut.config.get("maxSkills", 100)
    local maxLanguagePoints = nut.config.get("maxLanguages", 2)
    -- Send to JS
    local jsonChars = util.TableToJSON(chars)
    local jsonFactions = util.TableToJSON(factions)
    local jsonTraits = util.TableToJSON(traits)
    local jsonAttribs = util.TableToJSON(attributes)
    local jsonSkills = util.TableToJSON(skills)
    local jsonBackgrounds = util.TableToJSON(backgrounds)
    local jsonBgFactions = util.TableToJSON(allowedBgFactions)
    local jsonLanguages = util.TableToJSON(languages)
    if IsValid(self) and IsValid(self.html) then
        self.html:Call("setCharacters(" .. jsonChars .. ")")
        self.html:Call("setFactions(" .. jsonFactions .. ")")
        self.html:Call("setTraits(" .. jsonTraits .. ", " .. nut.config.get("maxTraits", 2) .. ")")
        self.html:Call("setAttributes(" .. jsonAttribs .. ", " .. totalAttribPoints .. ", " .. maxPerAttrib .. ")")
        self.html:Call("setSkills(" .. jsonSkills .. ", " .. totalSkillPoints .. ", " .. maxPerSkill .. ")")
        self.html:Call("setBackgrounds(" .. jsonBackgrounds .. ", " .. jsonBgFactions .. ")")
        self.html:Call("setLanguages(" .. jsonLanguages .. ", " .. maxLanguagePoints .. ")")
    end
end

function PANEL:UpdateModelView(model, pacName, charID)
    if not IsValid(self.model) then
        self.model = vgui.Create("DModelPanel", self)
        self.model:SetSize(300, 400) -- Default, updated by JS
        self.model:SetModel(model)
        self.model:SetFOV(45)
        self.model:SetCamPos(Vector(60, 0, 36))
        self.model:SetLookAt(Vector(0, 0, 36))
    end

    self.model:SetModel(model)
    local ent = self.model:GetEntity()
    if IsValid(ent) then
        local mins, maxs = ent:GetModelBounds()
        self.model:SetCamPos(Vector(60, 0, 36))
        self.model:SetLookAt(Vector(0, 0, 36))
    end

    self.model:SetVisible(true)
    self.model:MoveToFront()
end

function PANEL:OncharacterListUpdated()
    self:RefreshCharacters()
end

vgui.Register("nutCharacter", PANEL, "EditablePanel")