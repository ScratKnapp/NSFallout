local PANEL = {}
function PANEL:Init()
    if IsValid(nut.gui.actionL) then nut.gui.actionL:Remove() end
    nut.gui.actionL = self
    self:SetSize(ScrW() * 0.35, ScrH() * 0.65)
    self:Center()
    self:SetTitle("")
    self:MakePopup()
    self:ShowCloseButton(false)
    self.Paint = function(s, w, h) end -- Handle background transparently manually
    -- Create DHTML Panel
    self.html = vgui.Create("DHTML", self)
    self.html:Dock(FILL)
    self.html:SetHTML(CYR.UI.ActisCombatHTML)
    -- Interface Webhooks
    self.html:AddFunction("gmod", "webhook", function(name, data)
        data = util.JSONToTable(data or "{}")
        if name == "selectAction" then
            if self.swep then
                self.swep:selectAction(data)
                surface.PlaySound("buttons/blip1.wav")
                self:loadActions() -- Refresh active state
            end
        elseif name == "selectPart" then
            if self.swep then self.swep:selectPart(data) end
        elseif name == "closeMenu" then
            self:Close()
        end
    end)

    -- Inject Initial Data once loaded
    local timerName = "ACTIS_UI_RELOAD_" .. tostring(self)
    timer.Create(timerName, 0.1, 10, function()
        if not IsValid(self) or not IsValid(self.html) then return end
        -- Theme Colors
        local primary = cookie.GetString("cyr_f4_primary", "#00FF41")
        local secondary = cookie.GetString("cyr_f4_secondary", "#FFFFFF")
        local tertiary = cookie.GetString("cyr_f4_tertiary", "#FF0000")
        self.html:RunJavascript(string.format("setColors('%s', '%s', '%s')", primary, secondary, tertiary))
        -- Parts
        local combatPlugin = NUT_SWEP_COMBAT_PLUGIN or (nut and nut.plugin and nut.plugin.list and nut.plugin.list.combat)
        if combatPlugin then
            local parts = table.GetKeys(combatPlugin:getPartsModifiers())
            local current = (self.swep and self.swep.getNetVar and self.swep:getNetVar("part", "Body")) or "Body"
            self.html:RunJavascript(string.format("updateParts(%s, '%s')", util.TableToJSON(parts), current))
        end

        self:loadActions()
    end)
end

function PANEL:loadActions()
    if not IsValid(self.html) or not self.actions then return end
    local categories = {}
    -- Group actions by category
    for k, action in pairs(self.actions) do
        local actionData = (ACTS and ACTS.actions and action.uid and ACTS.actions[action.uid]) or {}
        local cat = action.category or actionData.category or "Default"
        categories[cat] = categories[cat] or {}
        local item = action.weapon and nut.item.instances[action.weapon]
        local desc = actionData.desc or action.desc or ""
        if item then desc = desc .. "\nITEM: " .. (item.getName and item:getName() or item.name or "Unknown") end
        if actionData.dmg then desc = desc .. "\nDMG: " .. actionData.dmg end
        if actionData.costAP then desc = desc .. "\nAP: " .. actionData.costAP end
        table.insert(categories[cat], {
            id = k,
            uid = action.uid,
            name = actionData.name or action.name or "Unknown",
            desc = desc,
            cost = actionData.costAP and (actionData.costAP .. " AP") or "",
            active = self.swep and self.swep:getNetVar("actCur") == k
        })
    end

    self.html:RunJavascript(string.format("updateActions(%s)", util.TableToJSON(categories)))
end

function PANEL:OnRemove()
    -- Cleanup logic if any
end

vgui.Register("nutActionList", PANEL, "DFrame")
print("[CYR] Combat UI (DHTML) Override Initialized")