if SERVER then
    concommand.Add("cyr_admin_spawnitem", function(ply, cmd, args)
        if not IsValid(ply) or not ply:IsSuperAdmin() then return end
        local itemID = args[1]
        if not itemID then return end
        local pos = ply:GetEyeTraceNoCursor().HitPos
        pos = pos + Vector(0, 0, 10)
        -- verify item exists
        if not nut.item.list[itemID] then
            ply:ChatPrint("Invalid Item ID: " .. tostring(itemID))
            return
        end

        nut.item.spawn(itemID, pos)
        ply:ChatPrint("Spawned item: " .. itemID)
    end)
else
    -- Client
    hook.Add("PopulateCustomSpawnMenu", "CYR_NSItemsSpawnMenu", function(pnl, tree, node)
        -- Only create if superadmin (or check localplayer)
        -- Note: LocalPlayer():IsSuperAdmin() might not be ready immediately on join, but usually is for spawnmenu
        local treeNode = tree:AddNode("NS Items", "icon16/box.png")
        treeNode.DoClick = function(node)
            -- Clear panel
            pnl:Clear()
            -- Header / Search
            local header = vgui.Create("DPanel", pnl)
            header:Dock(TOP)
            header:SetHeight(30)
            header:SetBackgroundColor(Color(50, 50, 50))
            local search = vgui.Create("DTextEntry", header)
            search:Dock(FILL)
            search:DockMargin(5, 5, 5, 5)
            search:SetPlaceholderText("Search Items...")
            -- Content
            local scroll = vgui.Create("DScrollPanel", pnl)
            scroll:Dock(FILL)
            local grid = vgui.Create("DIconLayout", scroll)
            grid:Dock(FILL)
            grid:SetSpaceX(5)
            grid:SetSpaceY(5)
            grid:SetBorder(5)
            local function Populate(filter)
                grid:Clear()
                filter = filter and filter:lower() or ""
                local items = {}
                for uniqueID, data in pairs(nut.item.list) do
                    table.insert(items, {
                        id = uniqueID,
                        name = data.name,
                        model = data.model,
                        category = data.category
                    })
                end

                table.sort(items, function(a, b) return a.name < b.name end)
                for _, item in ipairs(items) do
                    if filter ~= "" then if not item.name:lower():find(filter) and not item.id:lower():find(filter) and not (item.category and item.category:lower():find(filter)) then continue end end
                    local icon = grid:Add("SpawnIcon")
                    icon:SetModel(item.model or "models/error.mdl")
                    icon:SetToolTip(item.name .. "\n[" .. item.id .. "]\n" .. (item.category or "No Category"))
                    icon.DoClick = function() RunConsoleCommand("cyr_admin_spawnitem", item.id) end
                end
            end

            Populate()
            search.OnValueChange = function(self, val) Populate(val) end
            -- Rebuild when clicking node
            pnl.Content = scroll
        end
        -- If superadmin, default to this? No, let standard behavior rule.
    end)

    -- Also try standard spawnmenu.AddCreationTab if PopulateCustomSpawnMenu is too hidden
    hook.Add("AddToolMenuTabs", "CYR_NSItemsToolTab", function()
        spawnmenu.AddCreationTab("NS Items", function()
            local pnl = vgui.Create("DPanel")
            pnl.Paint = function() end
            local ctrl = vgui.Create("DPanel", pnl)
            ctrl:Dock(TOP)
            ctrl:SetHeight(30)
            local search = vgui.Create("DTextEntry", ctrl)
            search:Dock(FILL)
            search:SetPlaceholderText("Search...")
            local scroll = vgui.Create("DScrollPanel", pnl)
            scroll:Dock(FILL)
            local grid = vgui.Create("DIconLayout", scroll)
            grid:Dock(FILL)
            grid:SetSpaceX(5)
            grid:SetSpaceY(5)
            grid:SetBorder(5)
            local function Populate(filter)
                grid:Clear()
                filter = filter and filter:lower() or ""
                local items = {}
                if nut and nut.item then
                    for uniqueID, data in pairs(nut.item.list) do
                        table.insert(items, {
                            id = uniqueID,
                            name = data.name,
                            model = data.model,
                            category = data.category
                        })
                    end

                    table.sort(items, function(a, b) return a.name < b.name end)
                end

                for _, item in ipairs(items) do
                    if filter ~= "" then if not item.name:lower():find(filter) and not item.id:lower():find(filter) then continue end end
                    local icon = grid:Add("SpawnIcon")
                    icon:SetModel(item.model or "models/error.mdl")
                    icon:SetToolTip(item.name .. "\n[" .. item.id .. "]")
                    icon.DoClick = function() RunConsoleCommand("cyr_admin_spawnitem", item.id) end
                end
            end

            Populate("")
            search.OnValueChange = function(s, v) Populate(v) end
            return pnl
        end, "icon16/box.png", 50, "Spawn NS Items")
    end)
end