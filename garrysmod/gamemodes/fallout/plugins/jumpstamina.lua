local PLUGIN = PLUGIN
PLUGIN.name = "Jump Stamina Cost"
PLUGIN.author = ""
PLUGIN.desc = " "

PLUGIN.jumpCost = 10

--[[
local buffPLUGIN = nut.plugin.Get( "buffs" )
if not buffPLUGIN then
	print( 'Leg Break Buff will not work properly without "buffs" plugin!' )
end
--]]

if(SERVER) then
	function PLUGIN:SetupMove(ply, mvd, cmd)
		if(mvd:KeyPressed(IN_JUMP)) then
			if(ply:GetMoveType() == MOVETYPE_WALK) then
				local current = ply:getLocalVar("stm", 0)
				
				if(current < PLUGIN.jumpCost) then
					local newbuttons = bit.band(mvd:GetButtons(), bit.bnot(IN_JUMP))
					mvd:SetButtons(newbuttons)
				else
					ply:setLocalVar("stm", current-PLUGIN.jumpCost)
				end
			end
		end
	end
end