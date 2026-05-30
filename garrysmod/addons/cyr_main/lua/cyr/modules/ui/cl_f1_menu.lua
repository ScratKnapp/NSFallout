print("BUILDING f1 menu")
include("cl_tooltip.lua")
--------------------------------------------------------------------------------
-- CYR Menu Button (cl_menubutton.lua)
--------------------------------------------------------------------------------
local PANEL = {}
function PANEL:Init()
    self:SetFont("nutMenuButtonFont")
    self:SetExpensiveShadow(2, Color(0, 0, 0, 200))
    self:SetTextColor(color_white)
    self:SetPaintBackground(false)
    self.OldSetTextColor = self.SetTextColor
    self.SetTextColor = function(this, color)
        this:OldSetTextColor(color)
        this:SetFGColor(color)
    end
end

function PANEL:setText(text, noTranslation)
    surface.SetFont("nutMenuButtonFont")
    self:SetText(noTranslation and text:upper() or L(text):upper())
    if not noTranslation then self:SetTooltip(L(text .. "Tip")) end
    local w, h = surface.GetTextSize(self:GetText())
    self:SetSize(w + 64, h + 32)
end

function PANEL:OnCursorEntered()
    local color = self:GetTextColor()
    self:SetTextColor(Color(math.max(color.r - 25, 0), math.max(color.g - 25, 0), math.max(color.b - 25, 0)))
    LocalPlayer():EmitSound("nl_ui_menu_focus.wav", 0, 100, 0.35)
end

function PANEL:OnCursorExited()
    if self.color then
        self:SetTextColor(self.color)
    else
        self:SetTextColor(color_white)
    end
end

function PANEL:OnMousePressed(code)
    if self.color then
        self:SetTextColor(self.color)
    else
        self:SetTextColor(nut.config.get("color"))
    end

    if code == MOUSE_LEFT and self.DoClick then self:DoClick(self) end
    sound.Play("nl_ui_menu_next1.wav", LocalPlayer():GetPos(), 75, 100, 0.35)
end

function PANEL:OnMouseReleased(key)
    if self.color then
        self:SetTextColor(self.color)
    else
        self:SetTextColor(color_white)
    end
end

vgui.Register("cyrMenuButton", PANEL, "DButton")
--------------------------------------------------------------------------------
-- CYR Classes (cl_classes.lua)
--------------------------------------------------------------------------------
PANEL = {}
function PANEL:Init()
    self:SetTall(64)
    local function assignClick(panel)
        panel.OnMousePressed = function()
            self.pressing = -1
            self:onClick()
        end

        panel.OnMouseReleased = function()
            if self.pressing then
                self.pressing = nil
                --self:onClick()
            end
        end
    end

    self.icon = self:Add("SpawnIcon")
    self.icon:SetSize(128, 64)
    self.icon:InvalidateLayout(true)
    self.icon:Dock(LEFT)
    self.icon.PaintOver = function(this, w, h) end
    assignClick(self.icon)
    self.limit = self:Add("DLabel")
    self.limit:Dock(RIGHT)
    self.limit:SetMouseInputEnabled(true)
    self.limit:SetCursor("hand")
    self.limit:SetExpensiveShadow(1, Color(0, 0, 60))
    self.limit:SetContentAlignment(5)
    self.limit:SetFont("nutMediumFont")
    self.limit:SetWide(64)
    assignClick(self.limit)
    self.label = self:Add("DLabel")
    self.label:Dock(FILL)
    self.label:SetMouseInputEnabled(true)
    self.label:SetCursor("hand")
    self.label:SetExpensiveShadow(1, Color(0, 0, 60))
    self.label:SetContentAlignment(5)
    self.label:SetFont("nutMediumFont")
    assignClick(self.label)
end

function PANEL:onClick()
    nut.command.send("beclass", self.class)
end

function PANEL:setNumber(number)
    local limit = self.data.limit
    if limit > 0 then
        self.limit:SetText(Format("%s/%s", number, limit))
    else
        self.limit:SetText("∞")
    end
end

function PANEL:setClass(data)
    if data.model then
        local model = data.model
        if istable(model) then model = table.Random(model) end
        self.icon:SetModel(model)
    else
        local char = LocalPlayer():getChar()
        local model = LocalPlayer():GetModel()
        if char then model = char:getModel() end
        self.icon:SetModel(model)
    end

    self.label:SetText(L(data.name))
    self.data = data
    self.class = data.index
    self:setNumber(#nut.class.getPlayers(data.index))
end

vgui.Register("cyrClassPanel", PANEL, "DPanel")
PANEL = {}
function PANEL:Init()
    -- nut.gui.classes = self -- Avoid global conflict
    self:SetSize(self:GetParent():GetSize())
    self.list = vgui.Create("DPanelList", self)
    self.list:Dock(FILL)
    self.list:EnableVerticalScrollbar()
    self.list:SetSpacing(5)
    self.list:SetPadding(5)
    self.classPanels = {}
    self:loadClasses()
end

function PANEL:loadClasses()
    self.list:Clear()
    for k, v in ipairs(nut.class.list) do
        local no, why = nut.class.canBe(LocalPlayer(), k)
        local itsFull = "class is full" == why
        if no or itsFull then
            local panel = vgui.Create("cyrClassPanel", self.list)
            panel:setClass(v)
            table.insert(self.classPanels, panel)
            self.list:AddItem(panel)
        end
    end
end

vgui.Register("cyrClasses", PANEL, "EditablePanel")
--------------------------------------------------------------------------------
-- CYR Character Info (cl_information.lua)
--------------------------------------------------------------------------------
PANEL = {}
function PANEL:Init()
    -- Global ref handling
    if IsValid(CYR_CHAR_INFO_PANEL) then CYR_CHAR_INFO_PANEL:Remove() end
    CYR_CHAR_INFO_PANEL = self
    self:SetSize(ScrW() * 0.6, ScrH() * 0.7)
    self:Center()
    local suppress = hook.Run("CanCreateCharInfo", self)
    if not suppress or (suppress and not suppress.all) then
        if not suppress or not suppress.model then
            self.model = self:Add("nutModelPanel")
            self.model:SetWide(ScrW() * 0.25)
            self.model:Dock(LEFT)
            self.model:SetFOV(50)
            self.model.enableHook = true
            self.model.copyLocalSequence = true
        end

        if not suppress or not suppress.info then
            self.info = self:Add("DPanel")
            self.info:SetWide(ScrW() * 0.4)
            self.info:Dock(RIGHT)
            self.info:SetPaintBackground(false)
            self.info:DockMargin(150, ScrH() * 0.2, 0, 0)
        end

        if not suppress or not suppress.name then
            self.name = self.info:Add("DLabel")
            self.name:SetFont("nutHugeFont")
            self.name:SetTall(60)
            self.name:Dock(TOP)
            self.name:SetTextColor(color_white)
            self.name:SetExpensiveShadow(1, Color(0, 0, 0, 150))
        end

        if not suppress or not suppress.desc then
            self.desc = self.info:Add("DTextEntry")
            self.desc:Dock(TOP)
            self.desc:SetFont("nutMediumLightFont")
            self.desc:SetTall(28)
        end

        if not suppress or not suppress.time then
            self.time = self.info:Add("DLabel")
            self.time:SetFont("nutMediumFont")
            self.time:SetTall(28)
            self.time:Dock(TOP)
            self.time:SetTextColor(color_white)
            self.time:SetExpensiveShadow(1, Color(0, 0, 0, 150))
        end

        if not suppress or not suppress.money then
            self.money = self.info:Add("DLabel")
            self.money:Dock(TOP)
            self.money:SetFont("nutMediumFont")
            self.money:SetTextColor(color_white)
            self.money:SetExpensiveShadow(1, Color(0, 0, 0, 150))
            self.money:DockMargin(0, 10, 0, 0)
        end

        if not suppress or not suppress.faction then
            self.faction = self.info:Add("DLabel")
            self.faction:Dock(TOP)
            self.faction:SetFont("nutMediumFont")
            self.faction:SetTextColor(color_white)
            self.faction:SetExpensiveShadow(1, Color(0, 0, 0, 150))
            self.faction:DockMargin(0, 10, 0, 0)
        end

        if not suppress or not suppress.class then
            local class = nut.class.list[LocalPlayer():getChar():getClass()]
            if class then
                self.class = self.info:Add("DLabel")
                self.class:Dock(TOP)
                self.class:SetFont("nutMediumFont")
                self.class:SetTextColor(color_white)
                self.class:SetExpensiveShadow(1, Color(0, 0, 0, 150))
                self.class:DockMargin(0, 10, 0, 0)
            end
        end

        hook.Run("CreateCharInfoText", self, suppress)
    end

    hook.Run("CreateCharInfo", self)
end

function PANEL:setup()
    local char = LocalPlayer():getChar()
    if self.desc then
        self.desc:SetText(char:getDesc():gsub("#", "\226\128\139#"))
        self.desc.OnEnter = function(this, w, h) nut.command.send("chardesc", this:GetText():gsub("\226\128\139#", "#")) end
    end

    if self.name then
        self.name:SetText(LocalPlayer():Name():gsub("#", "\226\128\139#"))
        hook.Add("OnCharVarChanged", self, function(panel, character, key, oldValue, value)
            if char ~= character then return end
            if key ~= "name" then return end
            if IsValid(self) and IsValid(self.name) then self.name:SetText(value:gsub("#", "\226\128\139#")) end
        end)
    end

    if self.money then self.money:SetText(L("charMoney", nut.currency.get(char:getMoney()))) end
    if self.faction then self.faction:SetText(L("charFaction", L(team.GetName(LocalPlayer():Team())))) end
    if self.time then
        local format = "%A, %d %B " .. nut.config.get("year") .. nut.config.get("yearAppendix", "") .. " %T"
        self.time:SetText(L("curTime", nut.date.getFormatted(format)))
        self.time.Think = function(this)
            if (this.nextTime or 0) < CurTime() then
                this:SetText(L("curTime", nut.date.getFormatted(format)))
                this.nextTime = CurTime() + 0.5
            end
        end
    end

    if self.class then
        local class = nut.class.list[char:getClass()]
        if class then self.class:SetText(L("charClass", L(class.name))) end
    end

    if self.model then
        self.model:SetModel(LocalPlayer():GetModel())
        self.model.Entity:SetSkin(LocalPlayer():GetSkin())
        for k, v in ipairs(LocalPlayer():GetBodyGroups()) do
            self.model.Entity:SetBodygroup(v.id, LocalPlayer():GetBodygroup(v.id))
        end

        local ent = self.model.Entity
        if ent and IsValid(ent) then
            local mats = LocalPlayer():GetMaterials()
            for k, v in pairs(mats) do
                ent:SetSubMaterial(k - 1, LocalPlayer():GetSubMaterial(k - 1))
            end
        end
    end

    hook.Run("OnCharInfoSetup", self)
end

function PANEL:Paint(w, h)
end

vgui.Register("cyrCharInfo", PANEL, "EditablePanel")
-- Logic ported to HTML side
hook.Add("BuildHelpMenu", "nutBasicHelp", function(tabs)
    tabs["commands"] = function(node)
        local body = ""
        for k, v in SortedPairs(nut.command.list) do
            local allowed = false
            if v.adminOnly and not LocalPlayer():IsAdmin() or v.superAdminOnly and not LocalPlayer():IsSuperAdmin() then continue end
            if v.group then
                local groups = istable(v.group) and v.group or {v.group}
                for _, g in pairs(groups) do
                    if LocalPlayer():IsUserGroup(g) then
                        allowed = true
                        break
                    end
                end
            else
                allowed = true
            end

            if allowed then body = body .. "<h2>/" .. k .. "</h2><strong>Syntax:</strong> <em>" .. v.syntax .. "</em><br /><br />" end
        end
        return body
    end

    tabs["flags"] = function(node)
        local body = [[<table border="0" cellspacing="8px">]]
        for k, v in SortedPairs(nut.flag.list) do
            local icon
            if LocalPlayer():getChar():hasFlags(k) then
                icon = [[<img src="asset://garrysmod/materials/icon16/tick.png" />]]
            else
                icon = [[<img src="asset://garrysmod/materials/icon16/cross.png" />]]
            end

            body = body .. Format([[
                <tr>
                    <td>%s</td>
                    <td><b>%s</b></td>
                    <td>%s</td>
                </tr>
            ]], icon, k, v.desc)
        end
        return body .. "</table>"
    end

    tabs["plugins"] = function(node)
        local body = ""
        for _, v in SortedPairsByMemberValue(nut.plugin.list, "name") do
            body = (body .. [[
                <p>
                    <span style="font-size: 22;"><b>%s</b><br /></span>
                    <span style="font-size: smaller;">
                    <b>%s</b>: %s<br />
                    <b>%s</b>: %s
            ]]):format(v.name or "Unknown", L"desc", v.desc or L"noDesc", L"author", nut.plugin.namecache[v.author] or v.author)
            if v.version then body = body .. "<br /><b>" .. L"version" .. "</b>: " .. v.version end
            body = body .. "</span></p>"
        end
        return body
    end
end)

--------------------------------------------------------------------------------
-- MAIN MENU (cl_menu.lua Logic)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- MAIN MENU (Refactored for DHTML/VHS Aesthetic)
--------------------------------------------------------------------------------
F1_PLUGIN_STATES = F1_PLUGIN_STATES or {}
hook.Add("RetrievedPluginList", "cyrF1PluginList", function(plugins)
    F1_PLUGIN_STATES = plugins
    if IsValid(CYR_MENU) and CYR_MENU.lastHelpTab == "plugins" then CYR_MENU:ShowHelp() end
end)

hook.Add("PluginConfigDisabled", "cyrF1PluginToggle", function(name, disabled)
    F1_PLUGIN_STATES[name] = disabled
    if IsValid(CYR_MENU) and CYR_MENU.lastHelpTab == "plugins" then CYR_MENU:ShowHelp() end
end)

local F1_PANEL = {}
function F1_PANEL:Init()
    if IsValid(CYR_MENU) then CYR_MENU:Remove() end
    CYR_MENU = self
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self.nextClose = CurTime() + 0.5
    self.html = vgui.Create("DHTML", self)
    self.html:Dock(FILL)
    -- Play sound safely
    sound.Play("nl_ui_menu_next1.wav", LocalPlayer():GetPos(), 75, 100, 0.35)
    self.html:SetMouseInputEnabled(true)
    self.html:SetKeyboardInputEnabled(true)
    -- Prevent white flash
    self.html.Paint = function() end
    self.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0)
        surface.DrawRect(0, 0, w, h)
    end

    -- Sync color with F4 menu
    -- Cookies don't have callbacks, reliant on re-open or manual refresh
    -- Add JS Webhooks
    self.html:AddFunction("gmod", "webhook", function(func, data)
        if func == "js_ready" then
            self:OnJSReady()
        elseif func == "playSound" then
            if data.sound then surface.PlaySound(data.sound) end
        elseif func == "tabClicked" then
            if data.id then
                if data.id == "help_commands" then
                    self:ShowHelp("commands")
                elseif data.id == "help_flags" then
                    self:ShowHelp("flags")
                elseif data.id == "help_plugins" then
                    self:ShowHelp("plugins")
                elseif data.id == "help_config" then
                    self:ShowHelp("config")
                else
                    self:OnTabClicked(data.id)
                end
            end

            sound.Play("nl_ui_menu_focus.wav", LocalPlayer():GetPos(), 75, 100, 0.35)
        elseif func == "toggleAllocation" then
            if self.allocationMode ~= data.active then
                self.allocationMode = data.active
                self:ShowInformation() -- Refresh to show/hide buttons
            end

            sound.Play("nl_ui_menu_focus.wav", LocalPlayer():GetPos(), 75, 100, 0.35)
        elseif func == "openCharacters" then
            self:Remove()
            vgui.Create("cyr_char_menu")
        elseif func == "togglePlugin" then
            net.Start("cyrPluginList")
            net.WriteString(data.name)
            net.SendToServer()
        elseif func == "statIncrease" then
            netstream.Start("statIncrease", data.id, data.val)
            sound.Play("nl_ui_menu_focus.wav", LocalPlayer():GetPos(), 75, 100, 0.35)
        elseif func == "skillIncrease" then
            netstream.Start("skillIncrease", data.id, data.val)
            sound.Play("nl_ui_menu_focus.wav", LocalPlayer():GetPos(), 75, 100, 0.35)
        elseif func == "perkAdd" then
            netstream.Start("perkAdd", data.id)
            sound.Play("nl_ui_menu_focus.wav", LocalPlayer():GetPos(), 75, 100, 0.35)
        elseif func == "respec" then
            netstream.Start("nut_respec")
            sound.Play("nl_ui_menu_next1.wav", LocalPlayer():GetPos(), 75, 100, 0.35)
        elseif func == "generateIcon" then
            -- Dynamic Icon Generation
            local model = data.model
            if model then
                -- Create a hidden SpawnIcon to force generation
                local icon = vgui.Create("SpawnIcon")
                icon:SetModel(model)
                icon:SetSize(64, 64)
                icon:RebuildSpawnIcon()
                icon:Remove()
                -- Re-send the icon path to update JS (it should be valid now)
                -- We wait a frame to ensure the file is written
                timer.Simple(0.1, function()
                    if IsValid(self) and IsValid(self.html) then
                        local mdl = model:lower():gsub("%.mdl$", ".png")
                        local iconPath = "asset://garrysmod/materials/spawnicons/" .. mdl:gsub("\\", "/")
                        -- Safe call
                        local args = util.TableToJSON({data.id, iconPath})
                        self.html:Call("updateIcon(" .. args:sub(2, -2) .. ")")
                    end
                end)
            end
        elseif func == "bizBuy" then
            netstream.Start("bizBuy", data)
            sound.Play("nl_ui_menu_next1.wav", LocalPlayer():GetPos(), 75, 100, 0.35)
        elseif func == "updateConfig" then
            if LocalPlayer():IsSuperAdmin() then netstream.Start("cfgSet", data.key, data.val) end
        elseif func == "selectClass" then
            -- Handle class selection here
            nut.command.send("beclass", data.id)
            sound.Play("nl_ui_menu_next1.wav", LocalPlayer():GetPos(), 75, 100, 0.35)
            -- Refresh stats/ui after short delay
            timer.Simple(0.5, function()
                if IsValid(self) then
                    self:UpdateStats()
                    self:ShowClasses()
                end
            end)
        elseif func == "showTooltip" then
            if CYR.UI and CYR.UI.ShowTooltip then
                LocalPlayer():EmitSound("nl_ui_menu_focus.wav", 0, 100, 0.35)
                -- Inject color settings from cookies if needed, or rely on global theme
                -- For F1 menu we leverage the existing CYR.UI logic
                -- We ensure valid color objects are available
                data.colors = {
                    primary = cookie.GetString("cyr_f4_primary", "#00f0ff"),
                    secondary = cookie.GetString("cyr_f4_secondary", "#d600ff"),
                    tertiary = cookie.GetString("cyr_f4_tertiary", "#ccff00")
                }

                CYR.UI.ShowTooltip(data, gui.MouseX(), gui.MouseY())
            end
        elseif func == "hideTooltip" then
            if CYR.UI and CYR.UI.HideTooltip then CYR.UI.HideTooltip() end
        end
    end)

    self.html:SetHTML(CYR.UI.F1MenuHTML or "<h1>ERROR: HTML NOT FOUND</h1>")
end

function F1_PANEL:OnRemove()
    if CYR.UI and CYR.UI.HideTooltip then CYR.UI.HideTooltip() end
    sound.Play("nl_ui_menu_back" .. math.random(1, 3) .. ".wav", LocalPlayer():GetPos(), 75, 100, 0.35)
end

function F1_PANEL:ApplyTheme()
    -- Apply Theme from Cookie (Hex)
    local sColor = cookie.GetString("cyr_f4_primary", "#00f0ff")
    -- We need a Color object for ToCSS/dimming calculations
    -- Assuming HexToColor is available globally (from cl_paint_equipmentMenu.lua)
    local c = HexToColor(sColor) or Color(0, 240, 255)
    local function ToCSS(col, a)
        return string.format("rgba(%d, %d, %d, %f)", col.r, col.g, col.b, (a or col.a) / 255)
    end

    local theme = {
        primary = sColor, -- Pass Hex directly
        bg = "rgba(10, 10, 10, 0.95)", -- Darker, non-tinted background
        primaryDim = ToCSS(c, 50),
        grid = ToCSS(c, 30)
    }

    self.html:Call("setTheme(" .. util.TableToJSON(theme) .. ")")
end

function F1_PANEL:OnJSReady()
    self:ApplyTheme()
    -- Safe call for user name (handles quotes)
    local nameArgs = util.TableToJSON({LocalPlayer():Name()})
    self.html:Call("setHeaderUser(" .. nameArgs:sub(2, -2) .. ")")
    self:RefreshTabs()
    self:UpdateStats()
    -- Check for points to spend and default to allocation mode
    local char = LocalPlayer():getChar()
    if char then
        local ptAttrib = char:getData("ptAttrib", 0)
        local ptSkill = char:getData("ptSkill", 0)
        local ptPerk = char:getData("ptPerk", 0)
        if ptAttrib > 0 or ptSkill > 0 or ptPerk > 0 then
            self.allocationMode = true
            self.html:Call("setAllocationMode(true)")
        end
    end

    -- Default to Information tab
    self:OnTabClicked("information")
end

function F1_PANEL:RefreshTabs()
    local char = LocalPlayer():getChar()
    local ptAttrib = char:getData("ptAttrib", 0)
    local ptSkill = char:getData("ptSkill", 0)
    local ptPerk = char:getData("ptPerk", 0)
    local tabs = {
        {
            id = "information",
            name = "Information"
        },
        {
            id = "help",
            name = "Help"
        }
    }

    -- Show point counts in tab names if any available
    if ptAttrib > 0 or ptSkill > 0 or ptPerk > 0 then tabs[1].name = "Information (" .. (ptAttrib + ptSkill + ptPerk) .. ")" end
    -- Add Classes if available
    local cnt = table.Count(nut.class.list)
    if cnt > 1 then
        tabs[#tabs + 1] = {
            id = "classes",
            name = "Classes"
        }
    end

    tabs[#tabs + 1] = {
        id = "business",
        name = "Business"
    }

    tabs[#tabs + 1] = {
        id = "openCharacters",
        name = "Characters"
    }

    -- Allow other plugins to inject tabs
    hook.Run("CYR_PopulateF1Tabs", tabs)
    self.html:Call("setTabs(" .. util.TableToJSON(tabs) .. ")")
end

function F1_PANEL:UpdateStats()
    local char = LocalPlayer():getChar()
    if not char then return end
    local stats = {
        {
            label = "NAME",
            value = LocalPlayer():Name()
        },
        {
            label = "FACTION",
            value = team.GetName(LocalPlayer():Team())
        },
        {
            label = "MONEY",
            value = nut.currency.get(char:getMoney())
        },
        {
            label = "ID",
            value = "#" .. char:getID()
        },
        {
            label = "LAST OUTFIT",
            value = char.getPac and char:getPac("last_outfit") or "NONE"
        }
    }

    local class = nut.class.list[char:getClass()]
    if class then
        table.insert(stats, {
            label = "CLASS",
            value = L(class.name)
        })
    end

    -- Evasion & Accuracy
    table.insert(stats, {
        label = "EVASION",
        value = LocalPlayer():getEvasion()
    })

    -- Accuracy display (Dynamic per weapon)
    local equipment = nut.plugin.list["equipment"]:getEquippedItems(LocalPlayer(), true)
    local foundWeapon = false
    for _, item in pairs(equipment) do
        if item:getData("dmg", item.dmg) then
            foundWeapon = true
            table.insert(stats, {
                label = item:getName():upper() .. " ACC",
                value = LocalPlayer():getAccuracy(item)
            })
        end
    end

    -- If no weapons equipped, show base accuracy
    if not foundWeapon then
        table.insert(stats, {
            label = "ACCURACY",
            value = LocalPlayer():getAccuracy()
        })
    end

    -- Level & XP
    local level = LocalPlayer():getLevel()
    local xp = char:getData("xp", 0)
    local xpMax = nut.plugin.list["level"]:getLevelThresh(level)
    table.insert(stats, {
        label = "LEVEL",
        value = level
    })

    table.insert(stats, {
        label = "XP",
        value = xp,
        xpMax = xpMax -- used for progress bar
    })

    self.html:Call("setStats(" .. util.TableToJSON(stats) .. ")")
end

function F1_PANEL:OnTabClicked(id)
    if id:sub(1, 5) == "help_" then
        self.lastHelpTab = id:sub(6)
        return -- Don't call setActiveTab or clear content for internal help tabs
    end

    self.html:Call("setContent('')") -- Clear
    if id == "information" then
        -- Check for points to spend and enable allocation mode
        local char = LocalPlayer():getChar()
        if char then
            local ptAttrib = char:getData("ptAttrib", 0)
            local ptSkill = char:getData("ptSkill", 0)
            local ptPerk = char:getData("ptPerk", 0)
            if ptAttrib > 0 or ptSkill > 0 or ptPerk > 0 then
                self.allocationMode = true
                self.html:Call("setAllocationMode(true)")
            end
        end

        self:ShowInformation()
    elseif id == "help" then
        self:ShowHelp()
    elseif id == "classes" then
        self:ShowClasses()
    elseif id == "openCharacters" then
        self:Remove()
        vgui.Create("nutCharacter")
    elseif id == "business" then
        self:ShowBusiness()
    end

    self.html:Call("setActiveTab(" .. util.TableToJSON({id}):sub(2, -2) .. ")")
end

function F1_PANEL:ShowInformation()
    local char = LocalPlayer():getChar()
    local desc = char:getDesc()
    local boost = char:getBoosts()
    -- 1. Stats (Attributes)
    local ptAttrib = char:getData("ptAttrib", 0)
    local statsHtml = [[<div class="info-section"><div class="info-header"><span>SYSTEM STATS</span><div style="display:flex; align-items:center; gap:10px;"><span style="font-size:0.8rem; opacity:0.6;">ATTRIB POINTS: ]] .. ptAttrib .. [[</span><button class="allocation-toggle" onclick="toggleAllocation()">ALLOCATION MODE</button></div></div><div class="stats-grid">]]
    for k, v in SortedPairsByMemberValue(nut.attribs.list, "name") do
        local attribBoost = 0
        if boost[k] then
            for _, bValue in pairs(boost[k]) do
                attribBoost = attribBoost + bValue
            end
        end

        local val = char:getAttrib(k, 0)
        local baseVal = val - attribBoost
        local rawBase = char:getAttribs()[k] or 0
        local boostStr = attribBoost ~= 0 and [[<span class="stat-box-boost">]] .. (attribBoost > 0 and "+" or "") .. attribBoost .. [[</span>]] or ""
        local plusBtn = ""
        if self.allocationMode and ptAttrib > 0 then plusBtn = [[<button class="plus-btn" onclick="statIncrease(']] .. k .. [[', ]] .. (rawBase + 1) .. [[)">+</button>]] end
        statsHtml = statsHtml .. [[
            <div class="stat-box">
                <div class="stat-box-label">]] .. L(v.name):upper() .. [[</div>
                <div style="display:flex; align-items:center;">
                    <div class="stat-box-val">]] .. baseVal .. [[</div>
                    ]] .. plusBtn .. [[
                </div>
                ]] .. boostStr .. [[
            </div>
        ]]
    end

    statsHtml = statsHtml .. [[</div></div>]]
    -- 2. Skills
    local ptSkill = char:getData("ptSkill", 0)
    local skillsHtml = [[<div class="info-section"><div class="info-header"><span>SPECIALIZATIONS</span><span style="font-size:0.8rem; opacity:0.6;">SKILL POINTS: ]] .. ptSkill .. [[</span></div><div class="skills-container">]]
    for k, v in SortedPairsByMemberValue(nut.skills.list, "name") do
        local val = char:getSkill(k, 0)
        local rawBase = char:getSkills()[k] or 0
        local plusBtn = ""
        if self.allocationMode and ptSkill > 0 then plusBtn = [[<button class="plus-btn" onclick="skillIncrease(']] .. k .. [[', ]] .. (rawBase + 1) .. [[)">+</button>]] end
        skillsHtml = skillsHtml .. [[
            <div class="skill-row">
                <span class="skill-name">]] .. L(v.name) .. [[</span>
                <div style="display:flex; align-items:center;">
                    <span class="skill-val">]] .. val .. [[</span>
                    ]] .. plusBtn .. [[
                </div>
            </div>
        ]]
    end

    skillsHtml = skillsHtml .. [[</div></div>]]
    -- 3. Traits (Perks)
    -- Clamp at 0: perk points are never legitimately negative, so never display "-1".
    local ptPerk = math.max(char:getData("ptPerk", 0), 0)
    local traitsHtml = [[<div class="info-section"><div class="info-header"><span>IDENTITY TRAITS</span><span style="font-size:0.8rem; opacity:0.6;">PERK POINTS: ]] .. ptPerk .. [[</span></div>]]
    -- Current Traits
    traitsHtml = traitsHtml .. [[<div class="traits-list">]]
    local hasTraits = false
    local charTraits = char:getData("traits", {})
    for k, _ in pairs(charTraits) do
        local trait = TRAITS.traits[k]
        if trait then
            hasTraits = true
            traitsHtml = traitsHtml .. [[
                <div class="trait-entry"
                    onmouseenter="if(window.gmod) window.gmod.webhook('showTooltip', {name: ']] .. trait.name:gsub("'", "\\'"):gsub("\"", "\\\"") .. [[', desc: ']] .. trait.desc:gsub("'", "\\'"):gsub("\"", "\\\"") .. [[', stats: {CATEGORY: 'TRAIT'}})"
                    onmouseleave="if(window.gmod) window.gmod.webhook('hideTooltip')">
                    <div class="trait-entry-name">]] .. trait.name:upper() .. [[</div>
                    <div class="trait-entry-desc">]] .. trait.desc .. [[</div>
                </div>
            ]]
        end
    end

    if not hasTraits then traitsHtml = traitsHtml .. [[<div style="opacity:0.4; font-style:italic;">No traits active.</div>]] end
    traitsHtml = traitsHtml .. [[</div>]]
    -- Perk Selection (if in allocation mode and have points)
    if self.allocationMode and ptPerk > 0 then
        traitsHtml = traitsHtml .. [[<div style="margin-top:20px;"><div class="info-header">AVAILABLE PERKS</div><div class="perk-grid">]]
        for k, v in SortedPairsByMemberValue(TRAITS.traits, "name") do
            if not charTraits[k] then
                local safeName = v.name:gsub("'", "\\'"):gsub("\"", "\\\"")
                local safeDesc = v.desc:gsub("'", "\\'"):gsub("\"", "\\\"")
                traitsHtml = traitsHtml .. [[
                    <div class="perk-item" onclick="perkAdd(']] .. k .. [[')"
                        onmouseenter="if(window.gmod) window.gmod.webhook('showTooltip', {name: ']] .. safeName .. [[', desc: ']] .. safeDesc .. [[', stats: {CATEGORY: 'PERK'}})"
                        onmouseleave="if(window.gmod) window.gmod.webhook('hideTooltip')">
                        ]] .. v.name .. [[
                    </div>
                ]]
            end
        end

        traitsHtml = traitsHtml .. [[</div></div>]]
    end

    traitsHtml = traitsHtml .. [[</div>]]
    -- 4. Identity Record (Description)
    local recordHtml = [[
        <div class="info-section">
            <div class="info-header">IDENTITY RECORD</div>
            <div style="font-size: 0.9rem; line-height: 1.4; opacity: 0.9;">]] .. desc:gsub("\n", "<br>") .. [[</div>
        </div>
    ]]
    -- 5. Respec Button
    local respecHtml = [[
        <div style="display:flex; justify-content:center; margin-top:40px;">
            <button class="respec-btn" onclick="respec()">RESET STATS</button>
        </div>
    ]]
    local fullHtml = statsHtml .. skillsHtml .. traitsHtml .. recordHtml .. respecHtml
    -- Safe call
    self.html:Call("setContent(" .. util.TableToJSON({fullHtml}) .. ")")
end

function F1_PANEL:ShowHelp()
    local helpTabs = {}
    hook.Run("BuildHelpMenu", helpTabs)
    -- Request plugin list if Super Admin to ensure toggles are fresh
    if LocalPlayer():IsSuperAdmin() then
        net.Start("cyrPluginList")
        net.SendToServer()
    end

    local sortedKeys = {}
    for k, v in pairs(helpTabs) do
        table.insert(sortedKeys, k)
    end

    if LocalPlayer():IsSuperAdmin() then table.insert(sortedKeys, "configs") end
    table.sort(sortedKeys)
    -- Force flags, plugins, and configs to the front
    local finalKeys = {}
    if helpTabs["flags"] then table.insert(finalKeys, "flags") end
    if helpTabs["plugins"] then table.insert(finalKeys, "plugins") end
    if LocalPlayer():IsSuperAdmin() then table.insert(finalKeys, "configs") end
    for _, k in ipairs(sortedKeys) do
        if k ~= "flags" and k ~= "plugins" and k ~= "configs" then table.insert(finalKeys, k) end
    end

    local html = [[<div style='display:flex; flex-direction:column; gap: 20px;'>]]
    for _, category in ipairs(finalKeys) do
        local callback = helpTabs[category]
        if category == "flags" and not LocalPlayer():IsAdmin() then continue end
        local content = ""
        if category == "plugins" and LocalPlayer():IsSuperAdmin() then
            -- Custom interactive list for Super Admins
            content = "<div class='plugin-list'>"
            for name, disabled in SortedPairs(F1_PLUGIN_STATES) do
                local pluginData = nut.plugin.list[name]
                local pName = pluginData and pluginData.name or name
                local pDesc = (pluginData and pluginData.desc or "No description."):gsub("%]%]", "]] ")
                local statusClass = disabled and "disabled" or "enabled"
                local statusText = disabled and "OFF" or "ON"
                content = content .. [[
                    <div class="plugin-item">
                        <div class="plugin-info">
                            <div class="plugin-name">]] .. pName .. [[</div>
                            <div class="plugin-desc">]] .. pDesc .. [[</div>
                        </div>
                        <button class="status-toggle ]] .. statusClass .. [[" onclick="togglePlugin(']] .. name .. [[', ]] .. tostring(not disabled) .. [[)">]] .. statusText .. [[</button>
                    </div>
                ]]
            end

            content = content .. "</div>"
        elseif category == "configs" and LocalPlayer():IsSuperAdmin() then
            -- Config Editor for Super Admins
            local buffer = {}
            for k, v in pairs(nut.config.stored) do
                local cat = v.data and v.data.category or "misc"
                buffer[cat] = buffer[cat] or {}
                buffer[cat][k] = v
            end

            content = "<div class='config-editor'>"
            for cat, configs in SortedPairs(buffer) do
                content = content .. "<div class='config-category'><div class='config-category-title'>" .. L(cat):upper() .. "</div>"
                for k, v in SortedPairs(configs) do
                    local val = nut.config.get(k)
                    local inputHtml = ""
                    local valType = type(v.default)
                    -- Escape key for JS
                    local safeKey = k:gsub("'", "\\'")
                    if valType == "boolean" then
                        local checked = val and "checked" or ""
                        inputHtml = [[<input type="checkbox" ]] .. checked .. [[ onchange="updateConfig(']] .. safeKey .. [[', this.checked)">]]
                    elseif valType == "number" then
                        -- Handle nil/string values gracefully if config is messed up
                        local numVal = tonumber(val) or 0
                        inputHtml = [[<input type="number" value="]] .. numVal .. [[" onchange="updateConfig(']] .. safeKey .. [[', parseFloat(this.value))" style="width: 60px; background: rgba(0,0,0,0.5); border: 1px solid var(--primary-dim); color: #fff; font-family: inherit; padding: 2px 5px;">]]
                    elseif IsColor(v.default) then
                        inputHtml = string.format("R:%d G:%d B:%d (Read Only)", val.r, val.g, val.b)
                    else
                        local safeVal = tostring(val):gsub("\"", "&quot;")
                        inputHtml = [[<input type="text" value="]] .. safeVal .. [[" onchange="updateConfig(']] .. safeKey .. [[', this.value)" style="width: 120px; background: rgba(0,0,0,0.5); border: 1px solid var(--primary-dim); color: #fff; font-family: inherit; padding: 2px 5px;">]]
                    end

                    content = content .. [[
                        <div class="config-item">
                            <div class="config-label-wrap">
                                <div class="config-key">]] .. k .. [[</div>
                                <div class="config-desc">]] .. (v.desc or "") .. [[</div>
                            </div>
                            <div class="config-input">]] .. inputHtml .. [[</div>
                        </div>
                    ]]
                end

                content = content .. "</div>"
            end

            content = content .. "</div>"
        elseif isfunction(callback) then
            local success, res = pcall(callback)
            if success then
                content = tostring(res)
            else
                content = "Error loading category: " .. tostring(res)
            end
        else
            content = tostring(callback)
        end

        html = html .. [[
            <details style='border: 1px solid rgba(255,255,255,0.2); padding: 10px;'>
                <summary style='cursor:pointer; font-weight:bold; font-size: 1.3rem; margin-bottom: 10px;'>]] .. L(category):upper() .. [[</summary>
                <div style='padding: 10px; color: #ccc; font-size: 0.9rem;'>]] .. content .. [[</div>
            </details>
        ]]
    end

    html = html .. [[</div>]]
    self.html:Call("setContent(" .. util.TableToJSON({html}) .. ")")
end

function F1_PANEL:ShowBusiness()
    local html = [[
    <div class="biz-layout">
        <div class="biz-sidebar">
            <div class="panel-header">CATEGORIES</div>
            <button class="biz-cat-btn active" onclick="filterItems('all', this)">ALL ITEMS</button>
    ]]
    local categories = {}
    local itemsByCat = {}
    for uniqueID, itemTable in SortedPairsByMemberValue(nut.item.list, "name") do
        if not hook.Run("CanPlayerUseBusiness", LocalPlayer(), uniqueID) then continue end
        local cat = itemTable.category or "Misc"
        categories[cat] = true
        itemsByCat[cat] = itemsByCat[cat] or {}
        table.insert(itemsByCat[cat], {
            id = uniqueID,
            tbl = itemTable
        })
    end

    for cat, _ in SortedPairs(categories) do
        local safeCat = cat:gsub("'", "\\'")
        html = html .. [[<button class="biz-cat-btn" onclick="filterItems(']] .. safeCat .. [[', this)">]] .. cat:upper() .. [[</button>]]
    end

    html = html .. [[
        </div>
        <div class="biz-content">
            <div class="biz-header">
                <input type="text" class="biz-search-bar" placeholder="SEARCH REQUISITIONS..." onkeyup="searchItems(this.value)">
                <button class="view-cart-btn" onclick="openCheckout()">VIEW CART (<span id="cart-count">0</span>)</button>
            </div>
            <div id="biz-grid" class="business-grid">
    ]]
    -- Build item data list for JS
    local businessItems = {}
    for cat, items in SortedPairs(itemsByCat) do
        for _, data in ipairs(items) do
            local uniqueID = data.id
            local item = data.tbl
            local price = item:getPrice() or 0
            local priceStr = nut.currency.get(price)
            local name = L(item.name)
            -- Icon resolution
            local iconPath = "asset://garrysmod/materials/error.png"
            if item.icon then
                iconPath = "asset://garrysmod/materials/" .. item.icon
            elseif item.model then
                local mdl = item.model:lower():gsub("%.mdl$", ".png")
                iconPath = "asset://garrysmod/materials/spawnicons/" .. mdl:gsub("\\", "/")
            end

            table.insert(businessItems, {
                id = uniqueID,
                name = name,
                cat = cat,
                price = price,
                priceStr = priceStr,
                icon = iconPath,
                model = item.model -- Send model path for dynamic generation
            })
        end
    end

    html = html .. [[
            </div>
        </div>
    </div>
    
    <!-- Checkout Modal -->
    <div id="checkout-modal" class="modal">
        <div class="modal-content">
            <div class="modal-header">CONFIRM REQUISITION</div>
            <div id="modal-cart-items" class="modal-cart-items"></div>
            <div class="modal-footer">
                <div class="modal-total">TOTAL: <span id="modal-total">]] .. nut.currency.get(0) .. [[</span></div>
                <div class="modal-actions">
                    <button class="modal-btn cancel" onclick="closeCheckout()">CANCEL</button>
                    <button class="modal-btn confirm" onclick="confirmCheckout()">AUTHORIZE</button>
                </div>
            </div>
        </div>
    </div>
    ]]
    -- Send HTML structure first
    -- Manually serialize the HTML string to ensure it's passed correctly
    self.html:Call("setContent(" .. util.TableToJSON({html}) .. ")")
    -- Initialize JS cart and items
    local currencySymbol = nut.currency.symbol or "$"
    local jsInit = "initBusiness('" .. currencySymbol .. "');"
    self.html:Call(jsInit)
    -- Send items data in chunks
    self.html:Call("clearBusinessItems()")
    local chunkSize = 50
    local total = #businessItems
    for i = 1, total, chunkSize do
        local chunk = {}
        for j = i, math.min(i + chunkSize - 1, total) do
            table.insert(chunk, businessItems[j])
        end

        -- Send chunk
        local json = util.TableToJSON(chunk)
        self.html:Call("addBusinessItems(" .. json .. ")")
    end

    -- Final render
    self.html:Call("renderBuffer()")
end

function F1_PANEL:ShowClasses()
    local html = [[<div style='display:grid; grid-template-columns: repeat(auto-fill, minmax(120px, 1fr)); gap: 10px;'>]]
    for k, v in ipairs(nut.class.list) do
        local can = nut.class.canBe(LocalPlayer(), k)
        local players = #nut.class.getPlayers(k)
        local limit = v.limit or 0
        local limitText = limit > 0 and (players .. "/" .. limit) or (players .. "/∞")
        local style = can and "border: 1px solid #4f4; background: rgba(0,255,0,0.1);" or "border: 1px solid #f44; opacity: 0.5;"
        -- Safe usage of L(v.name) which might contain quotes
        html = html .. [[
            <div style='@STYLE@ padding: 10px; text-align:center; cursor:pointer;' onclick='window.gmod.webhook("selectClass", {id: ]] .. k .. [[})'>
                <div style='font-weight:bold;'>@NAME@</div>
                <div style='font-size: 0.8rem;'>]] .. limitText .. [[</div>
            </div>
        ]]
        html = html:gsub("@STYLE@", style):gsub("@NAME@", L(v.name):upper())
    end

    html = html .. [[</div>]]
    -- Safe call
    self.html:Call("setContent(" .. util.TableToJSON({html}) .. ")")
end

function F1_PANEL:OnKeyCodePressed(key)
    if key == KEY_F1 or key == KEY_ESCAPE then self:Remove() end
end

function F1_PANEL:Think()
    if (input.IsKeyDown(KEY_F1) or input.IsKeyDown(KEY_ESCAPE)) and (self.nextClose or 0) < CurTime() then self:Remove() end
end

vgui.Register("cyrMenu", F1_PANEL, "EditablePanel")
-- Update listeners
netstream.Hook("nut_stat_increase", function()
    timer.Simple(0.25, function()
        if IsValid(CYR_MENU) then
            CYR_MENU:UpdateStats()
            if CYR_MENU.ShowInformation then CYR_MENU:ShowInformation() end
        end
    end)
end)

netstream.Hook("nut_skill_increase", function()
    timer.Simple(0.25, function()
        if IsValid(CYR_MENU) then
            CYR_MENU:UpdateStats()
            if CYR_MENU.ShowInformation then CYR_MENU:ShowInformation() end
        end
    end)
end)

netstream.Hook("nut_UpdateTraits", function()
    timer.Simple(0.25, function()
        if IsValid(CYR_MENU) then
            CYR_MENU:UpdateStats()
            if CYR_MENU.ShowInformation then CYR_MENU:ShowInformation() end
        end
    end)
end)

net.Receive("cyrPluginList", function()
    local plugins = net.ReadTable()
    F1_PLUGIN_STATES = plugins
    if IsValid(CYR_MENU) and CYR_MENU.lastHelpTab == "plugins" then CYR_MENU:ShowHelp() end
end)

