if not CLIENT then return end
local CYR_UI_Y_OFFSET = CreateClientConVar("cyr_ui_y_offset", "15", true, false, "Chat & combat-log offset UP from the bottom of the screen, as a % of screen height.")
local BORDER = 32 -- matches the chatbox plugin's own bottom/left margin
hook.Add("Think", "CYR_ChatVerticalOffset", function()
    if not (nut and nut.gui) then return end
    local chat = nut.gui.chat
    if not IsValid(chat) then return end
    local _, h = chat:GetSize()
    local x = select(1, chat:GetPos())
    local targetY = ScrH() - h - BORDER - (ScrH() * (CYR_UI_Y_OFFSET:GetFloat() / 100))
    local _, curY = chat:GetPos()
    if math.abs(curY - targetY) > 0.5 then
        chat:SetPos(x, targetY)
        local chat2 = nut.gui.chat2
        if IsValid(chat2) then
            chat2:SetPos(x, targetY)
            chat2:MoveAbove(chat, 8)
        end
    end
end)